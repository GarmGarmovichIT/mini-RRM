param(
    [Parameter(Mandatory=$false)]
    [string]$ComputerName
)

if (-not $ComputerName) {
    $ComputerName = Read-Host "Введите имя удаленного ПК (например, tcsb-ws231)"
}

Write-Host "Подключение к $ComputerName и сбор данных..." -ForegroundColor Cyan

try {
    $RemotePrinters = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
        $AllPrinters = @()
        
        # Список слов-исключений (системные папки реестра, которые не являются принтерами)
        $ExcludeList = @('Forms', 'Monitors', 'Printers', 'Providers')

        # 1. Системные и локальные принтеры
        try {
            $LocalPrinters = Get-Printer -ErrorAction Stop | Select-Object Name, @{N='Type';E={'Local/System'}}, PrinterStatus
            $AllPrinters += $LocalPrinters
        } catch {}

        # 2. Системные сетевые принтеры (с фильтрацией)
        $CSRPP = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Providers\Client Side Rendering Print Provider\Servers"
        if (Test-Path $CSRPP) {
            Get-ChildItem $CSRPP -ErrorAction SilentlyContinue | ForEach-Object {
                $Srv = $_.PSChildName
                Get-ChildItem $_.PSPath -ErrorAction SilentlyContinue | ForEach-Object {
                    $Prn = $_.PSChildName
                    
                    # Пропускаем, если это системная папка
                    if ($ExcludeList -contains $Prn) { return }

                    $Unc = "\\$Srv\$Prn"
                    if ($AllPrinters.Name -notcontains $Unc) {
                        $AllPrinters += [PSCustomObject]@{ Name = $Unc; Type = "Network (System)"; PrinterStatus = "Unknown" }
                    }
                }
            }
        }

        # 3. Сетевые принтеры пользователей (через реестр)
        $HKU = reg.exe query HKU
        foreach ($line in $HKU) {
            if ($line -match 'HKEY_USERS\\(S-1-5-21-\d+-\d+-\d+-\d+)') {
                $Sid = $matches[1]
                $Conns = reg.exe query "HKU\$Sid\Printers\Connections" 2>$null
                foreach ($c in $Conns) {
                    if ($c -match 'HKEY_USERS\\.*\\Printers\\Connections\\(.*)') {
                        $ConnStr = $matches[1]
                        $Parts = $ConnStr -split ','
                        if ($Parts.Count -ge 4) {
                            $Unc = "\\$($Parts[2])\$($Parts[3])"
                            if ($AllPrinters.Name -notcontains $Unc) {
                                $AllPrinters += [PSCustomObject]@{ Name = $Unc; Type = "Network (User)"; PrinterStatus = "Unknown" }
                            }
                        }
                    }
                }
            }
        }
        return $AllPrinters
    } -ErrorAction Stop

    if (-not $RemotePrinters) {
        Write-Warning "Принтеры не найдены."
        return
    }

    # Выводим список вам локально
    $SelectedPrinters = $RemotePrinters | Sort-Object Type, Name | Out-GridView -Title "Принтеры на $ComputerName (отметьте галочками) и нажмите ОК" -OutputMode Multiple

    if (-not $SelectedPrinters) { return }

    # Спрашиваем действие
    $ActionChoice = @(
        [PSCustomObject]@{ Action = "Disable"; Description = "Отключить (только локальные)" },
        [PSCustomObject]@{ Action = "Enable";  Description = "Включить (только локальные)" },
        [PSCustomObject]@{ Action = "Remove";  Description = "Удалить принтер (работает для всех)" }
    ) | Out-GridView -Title "Что сделать с выбранными принтерами на $ComputerName?" -OutputMode Single

    if (-not $ActionChoice) { return }

    $Action = $ActionChoice.Action
    Write-Host "Выполняется действие '$($ActionChoice.Description)'..." -ForegroundColor Cyan

    $Results = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
        param($SelectedPrinters, $Action)
        $Output = @()

        foreach ($Printer in $SelectedPrinters) {
            $PName = $Printer.Name
            $IsNetwork = $PName.StartsWith("\\")
            
            try {
                if ($Action -eq "Remove") {
                    if ($IsNetwork) {
                        # Глобальное удаление сетевого принтера
                        $argList = "printui.dll,PrintUIEntry /gd /q /n `"$PName`""
                        Start-Process -FilePath "rundll32.exe" -ArgumentList $argList -Wait -NoNewWindow
                        $Output += "УДАЛЕН (Глобально): $PName"
                    } else {
                        Remove-Printer -Name $PName -ErrorAction Stop
                        $Output += "УДАЛЕН: $PName"
                    }
                } elseif ($Action -eq "Disable" -and -not $IsNetwork) {
                    Suspend-Printer -Name $PName -ErrorAction Stop
                    $Output += "ОТКЛЮЧЕН: $PName"
                } elseif ($Action -eq "Enable" -and -not $IsNetwork) {
                    Resume-Printer -Name $PName -ErrorAction Stop
                    $Output += "ВКЛЮЧЕН: $PName"
                } elseif ($IsNetwork) {
                    $Output += "ПРОПУЩЕН (сетевые можно только УДАЛИТЬ): $PName"
                }
            }
            catch {
                $Output += "ОШИБКА [$PName]: $($_.Exception.Message)"
            }
        }
        Restart-Service -Name Spooler -Force -ErrorAction SilentlyContinue
        return $Output
    } -ArgumentList (,$SelectedPrinters), $Action -ErrorAction Stop

    Write-Host "`nРезультаты:" -ForegroundColor Green
    $Results | ForEach-Object { Write-Host " $_" }

} catch {
    Write-Error "Ошибка подключения или выполнения: $($_.Exception.Message)"
}