Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- Форма ---
$form               = New-Object System.Windows.Forms.Form
$form.Text          = "Мини-RMM"
$form.Size          = New-Object System.Drawing.Size(520,460)
$form.StartPosition = "CenterScreen"

# --- Имя компьютера ---
$labelComputer              = New-Object System.Windows.Forms.Label
$labelComputer.Text         = "Имя компьютера:"
$labelComputer.AutoSize     = $true
$labelComputer.Location     = New-Object System.Drawing.Point(10,15)

$textComputer               = New-Object System.Windows.Forms.TextBox
$textComputer.Location      = New-Object System.Drawing.Point(120,10)
$textComputer.Width         = 150

# --- MAC ---
$labelMac                   = New-Object System.Windows.Forms.Label
$labelMac.Text              = "MAC (для WOL):"
$labelMac.AutoSize          = $true
$labelMac.Location          = New-Object System.Drawing.Point(10,45)

$textMac                    = New-Object System.Windows.Forms.TextBox
$textMac.Location           = New-Object System.Drawing.Point(120,40)
$textMac.Width              = 150

# --- Сообщение ---
$labelMsg                   = New-Object System.Windows.Forms.Label
$labelMsg.Text              = "Сообщение:"
$labelMsg.AutoSize          = $true
$labelMsg.Location          = New-Object System.Drawing.Point(10,75)

$textMsg                    = New-Object System.Windows.Forms.TextBox
$textMsg.Location           = New-Object System.Drawing.Point(120,70)
$textMsg.Width              = 300
$textMsg.Height             = 40
$textMsg.Multiline          = $true

# --- Действие ---
$labelAction                = New-Object System.Windows.Forms.Label
$labelAction.Text           = "Действие:"
$labelAction.AutoSize       = $true
$labelAction.Location       = New-Object System.Drawing.Point(10,120)

$comboAction                = New-Object System.Windows.Forms.ComboBox
$comboAction.Location       = New-Object System.Drawing.Point(120,115)
$comboAction.Width          = 300
$comboAction.DropDownStyle  = "DropDownList"

$comboAction.Items.Add("<выберите действие>")                                 | Out-Null
$comboAction.Items.Add("1  - reboot удаленный компьютер")                     | Out-Null
$comboAction.Items.Add("2  - Показать MAC-адрес(а) удаленного компьютера")    | Out-Null
$comboAction.Items.Add("3  - Включить компьютер по MAC (Wake-on-LAN)")        | Out-Null
$comboAction.Items.Add("4  - Разлогинить RDP-сессии на удаленном компьютере") | Out-Null
$comboAction.Items.Add("5  - Показать аптайм и последнюю перезагрузку")       | Out-Null
$comboAction.Items.Add("6  - Показать залогиненных пользователей")            | Out-Null
$comboAction.Items.Add("7  -  о системе")                                     | Out-Null
$comboAction.Items.Add("8  - Показать сетевые параметры")                     | Out-Null
$comboAction.Items.Add("9  - Очистить печать и перезапустить Spooler")        | Out-Null
$comboAction.Items.Add("10 - Отправить сообщение пользователю")               | Out-Null
$comboAction.Items.Add("11 - Удалить профиль пользователя")                   | Out-Null
$comboAction.Items.Add("12 - Очистить ETL-логи")                              | Out-Null
$comboAction.Items.Add("13 - Быстрый health-check станции")                   | Out-Null
$comboAction.SelectedIndex = 0

# --- Кнопка Выполнить ---
$buttonRun                  = New-Object System.Windows.Forms.Button
$buttonRun.Text             = "Выполнить"
$buttonRun.Location         = New-Object System.Drawing.Point(430,112)
$buttonRun.Width            = 75

$form.AcceptButton = $buttonRun

# --- Поле вывода ---
$textOutput                 = New-Object System.Windows.Forms.TextBox
$textOutput.Location        = New-Object System.Drawing.Point(10,160)
$textOutput.Size            = New-Object System.Drawing.Size(480,250)
$textOutput.Multiline       = $true
$textOutput.ScrollBars      = "Vertical"
$textOutput.ReadOnly        = $true

# --- Логика кнопки ---
$buttonRun.Add_Click({
    $ComputerName = $textComputer.Text.Trim()
    $MacAddress   = $textMac.Text.Trim()
    $choiceIndex  = $comboAction.SelectedIndex    # 0..13

    $textOutput.Clear()

    if ($choiceIndex -eq 0) {
        $textOutput.AppendText("Сначала выберите действие из списка.`r`n")
        return
    }

    $choice = $choiceIndex   # реальные пункты 1..13

    if ($choice -in 1,2,4,5,6,7,8,9,10,11,12,13 -and [string]::IsNullOrWhiteSpace($ComputerName)) {
        $textOutput.AppendText("Укажите имя компьютера.`r`n")
        return
    }

    # Общая проверка пинга
    if ($choice -in 1,2,4,5,6,7,8,9,10,11,12,13) {
        $textOutput.AppendText("Проверяю доступность $ComputerName...`r`n")
        if (-not (Test-Connection -ComputerName $ComputerName -Count 1 -Quiet -ErrorAction SilentlyContinue)) {
            $textOutput.AppendText("Хост $ComputerName недоступен (ping не проходит). Отмена.`r`n")
            return
        }
        $textOutput.AppendText("Хост доступен.`r`n")
    }

    switch ($choice) {

        1 {
            $textOutput.AppendText("Отправляю команду на перезагрузку...`r`n")
            Restart-Computer -ComputerName $ComputerName -Force -AsJob
            $textOutput.AppendText("Команда перезагрузки отправлена.`r`n")
        }

        2 {
            $textOutput.AppendText("Получаю MAC-адрес(а) с $ComputerName...`r`n")
            $adapters = Get-WmiObject -Class Win32_NetworkAdapterConfiguration `
                                      -ComputerName $ComputerName `
                                      -Filter "IPEnabled = True" |
                        Select-Object Description, MACAddress
            if (-not $adapters) {
                $textOutput.AppendText("Не найдено активных сетевых адаптеров.`r`n")
            } else {
                $adapters | ForEach-Object {
                    $textOutput.AppendText(("Описание: {0} | MAC: {1}" -f $_.Description,$_.MACAddress) + "`r`n")
                }
            }
        }

        3 {
            if ([string]::IsNullOrWhiteSpace($MacAddress)) {
                $textOutput.AppendText("Укажите MAC-адрес для WOL.`r`n")
                return
            }
            $Broadcast = "255.255.255.255"
            $Port = 9
            $textOutput.AppendText("Отправляю WOL на $MacAddress через ${Broadcast}:$Port...`r`n")

            $mac = $MacAddress -split '[:-]'
            $packet = [byte[]](,0xFF*6+(([byte]("0x$($mac[0])"),[byte]("0x$($mac[1])"),[byte]("0x$($mac[2])"),[byte]("0x$($mac[3])"),[byte]("0x$($mac[4])"),[byte]("0x$($mac[5])"))*16))
            $u = New-Object System.Net.Sockets.UdpClient
            $u.EnableBroadcast = $true
            $u.Connect($Broadcast,$Port)
            $u.Send($packet,$packet.Length) | Out-Null
            $u.Close()
            $textOutput.AppendText("WOL-пакет отправлен.`r`n")
        }

        4 {
            $textOutput.AppendText("Ищу RDP-сессии на $ComputerName и выполняю logoff...`r`n")
            Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                $sessions = quser | Select-Object -Skip 1
                foreach ($line in $sessions) {
                    if ($line -match 'rdp-tcp') {
                        $parts = $line -replace '^\s+','' -split '\s+'
                        $id = $parts[2]
                        Write-Output "Логаут сессии ID=$id (RDP)"
                        logoff $id
                    }
                }
            } | ForEach-Object {
                $textOutput.AppendText($_ + "`r`n")
            }
            $textOutput.AppendText("Команда logoff для RDP-сессий выполнена.`r`n")
        }

        5 {
            $textOutput.AppendText("Получаю аптайм и время последней перезагрузки...`r`n")
            $os = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $ComputerName
            $lastBoot = $os.LastBootUpTime
            $uptime   = (Get-Date) - $lastBoot

            $textOutput.AppendText(("Последняя перезагрузка: {0}" -f $lastBoot) + "`r`n")
            $textOutput.AppendText(("Аптайм: {0} дн {1} ч {2} мин" -f `
                [int]$uptime.Days, `
                [int]$uptime.Hours, `
                [int]$uptime.Minutes) + "`r`n")
        }

        6 {
            $textOutput.AppendText("Получаю список залогиненных пользователей (локально и по RDP)...`r`n")

            Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                quser 2>$null | Select-Object -Skip 1
            } | ForEach-Object {
                $line = $_.ToString().Trim()
                if ([string]::IsNullOrWhiteSpace($line)) { return }

                $parts = $line -replace '\s+',' ' -split ' '
                if ($parts.Count -lt 4) { return }

                $user    = $parts[0]
                $session = $parts[1]
                $id      = $parts[2]
                $state   = $parts[3]

                if ($session -eq '.') { $session = 'Консоль' }

                "{0} | Сессия: {1} | ID: {2} | Состояние: {3}" -f $user,$session,$id,$state
            } | ForEach-Object {
                $textOutput.AppendText($_ + "`r`n")
            }
        }

        7 {
            $textOutput.AppendText("Получаю информацию о системе...`r`n")

            $cs    = Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName $ComputerName
            $os    = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $ComputerName
            $bios  = Get-CimInstance -ClassName Win32_BIOS -ComputerName $ComputerName
            $cpu   = Get-CimInstance -ClassName Win32_Processor -ComputerName $ComputerName | Select-Object -First 1
            $diskC = Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $ComputerName -Filter "DeviceID='C:'"

            $model        = $cs.Model
            $vendor       = $cs.Manufacturer
            $serial       = $bios.SerialNumber
            $totalRam     = [math]::Round($cs.TotalPhysicalMemory / 1GB, 2)
            $osCaption    = $os.Caption
            $osBuild      = $os.BuildNumber
            $osArch       = $os.OSArchitecture
            $compName     = $cs.Name
            $domain       = $cs.Domain
            $workgroup    = $cs.Workgroup
            $cpuName      = $cpu.Name
            $cpuCores     = $cpu.NumberOfCores
            $cpuLogical   = $cpu.NumberOfLogicalProcessors
            $freeCGB      = if ($diskC) { [math]::Round($diskC.FreeSpace / 1GB, 2) } else { $null }
            $sizeCGB      = if ($diskC) { [math]::Round($diskC.Size / 1GB, 2) } else { $null }

            $textOutput.AppendText(("Компьютер:    {0}" -f $compName) + "`r`n")
            if ($domain) {
                $textOutput.AppendText(("Домен/группа: {0}" -f $domain) + "`r`n")
            } elseif ($workgroup) {
                $textOutput.AppendText(("Рабочая группа: {0}" -f $workgroup) + "`r`n")
            }

            $textOutput.AppendText(("Производитель: {0}" -f $vendor) + "`r`n")
            $textOutput.AppendText(("Модель:        {0}" -f $model) + "`r`n")
            $textOutput.AppendText(("Серийный №:    {0}" -f $serial) + "`r`n")
            $textOutput.AppendText(("ОС:            {0} (Build {1}, {2})" -f $osCaption,$osBuild,$osArch) + "`r`n")
            $textOutput.AppendText(("RAM:           {0} ГБ" -f $totalRam) + "`r`n")

            if ($cpuName) {
                $textOutput.AppendText(("CPU:           {0}" -f $cpuName) + "`r`n")
                $textOutput.AppendText(("Ядер/потоков:  {0} / {1}" -f $cpuCores,$cpuLogical) + "`r`n")
            }

            if ($diskC) {
                $textOutput.AppendText(("Диск C: всего {0} ГБ, свободно {1} ГБ" -f $sizeCGB,$freeCGB) + "`r`n")
            } else {
                $textOutput.AppendText("Диск C: не найден.`r`n")
            }
        }

        8 {
            $textOutput.AppendText("Получаю сетевые параметры...`r`n")

            $nets = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -ComputerName $ComputerName -Filter "IPEnabled = True"
            if (-not $nets) {
                $textOutput.AppendText("Нет активных сетевых интерфейсов.`r`n")
            } else {
                foreach ($n in $nets) {
                    $textOutput.AppendText(("Адаптер: {0}" -f $n.Description) + "`r`n")
                    if ($n.IPAddress) {
                        $ips = $n.IPAddress -join ", "
                        $textOutput.AppendText(("  IP:      {0}" -f $ips) + "`r`n")
                    }
                    if ($n.IPSubnet) {
                        $masks = $n.IPSubnet -join ", "
                        $textOutput.AppendText(("  Маска:   {0}" -f $masks) + "`r`n")
                    }
                    if ($n.DefaultIPGateway) {
                        $gws = $n.DefaultIPGateway -join ", "
                        $textOutput.AppendText(("  Шлюз:    {0}" -f $gws) + "`r`n")
                    }
                    if ($n.DNSServerSearchOrder) {
                        $dns = $n.DNSServerSearchOrder -join ", "
                        $textOutput.AppendText(("  DNS:     {0}" -f $dns) + "`r`n")
                    }
                    $textOutput.AppendText("`r`n")
                }
            }
        }

        9 {
            $textOutput.AppendText("Очищаю очередь печати и перезапускаю Spooler на $ComputerName...`r`n")

            Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                try {
                    Stop-Service -Name Spooler -Force -ErrorAction Stop

                    $spoolPath = "$env:windir\System32\spool\PRINTERS"
                    if (Test-Path $spoolPath) {
                        Get-ChildItem -Path $spoolPath -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
                    }

                    Start-Service -Name Spooler -ErrorAction Stop
                    "Очередь печати очищена, служба Spooler перезапущена."
                } catch {
                    "Ошибка при очистке/перезапуске Spooler: $_"
                }
            } | ForEach-Object {
                $textOutput.AppendText($_ + "`r`n")
            }
        }

        10 {
            $textOutput.AppendText("Отправка сообщения пользователю на $ComputerName...`r`n")

            $msg = $textMsg.Text.Trim()
            if ([string]::IsNullOrWhiteSpace($msg)) {
                $textOutput.AppendText("Сообщение не задано. Введите текст в поле 'Сообщение'.`r`n")
                return
            }

            try {
                Invoke-WmiMethod -Class Win32_Process -ComputerName $ComputerName -Name Create `
                    -ArgumentList "C:\Windows\System32\msg.exe * $msg" | Out-Null

                $textOutput.AppendText("Сообщение отправлено.`r`n")
            } catch {
                $textOutput.AppendText("Ошибка при отправке сообщения: $_`r`n")
            }
        }

        11 {
            # --- Удалить профиль пользователя ---
            $profiles = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                $userRoot = 'C:\Users'
                $systemProfiles = @('All Users','Default','Default User','Public','DefaultAppPool')
                Get-ChildItem -Path $userRoot -Directory -ErrorAction SilentlyContinue |
                    Where-Object { $_.Name -notin $systemProfiles -and $_.Name -notlike 'ADMINI~*' } |
                    Select-Object -ExpandProperty Name
            }

            if (-not $profiles) {
                $textOutput.AppendText("Не найдено пользовательских профилей в C:\Users на $ComputerName.`r`n")
                return
            }

            $selectForm               = New-Object System.Windows.Forms.Form
            $selectForm.Text          = "Удаление профиля ($ComputerName)"
            $selectForm.Size          = New-Object System.Drawing.Size(350,200)
            $selectForm.StartPosition = "CenterParent"

            $labelUser                = New-Object System.Windows.Forms.Label
            $labelUser.Text           = "Выберите профиль для УДАЛЕНИЯ:"
            $labelUser.AutoSize       = $true
            $labelUser.Location       = New-Object System.Drawing.Point(10,15)

            $comboUsers               = New-Object System.Windows.Forms.ComboBox
            $comboUsers.Location      = New-Object System.Drawing.Point(10,40)
            $comboUsers.Width         = 310
            $comboUsers.DropDownStyle = "DropDownList"
            foreach ($p in $profiles) { [void]$comboUsers.Items.Add($p) }
            if ($comboUsers.Items.Count -gt 0) { $comboUsers.SelectedIndex = 0 }

            $btnOk                    = New-Object System.Windows.Forms.Button
            $btnOk.Text               = "Удалить"
            $btnOk.Location           = New-Object System.Drawing.Point(60,100)
            $btnOk.Width              = 80

            $btnCancel                = New-Object System.Windows.Forms.Button
            $btnCancel.Text           = "Отмена"
            $btnCancel.Location       = New-Object System.Drawing.Point(180,100)
            $btnCancel.Width          = 80

            $btnOk.Add_Click({
                $selectForm.Tag = "OK"
                $selectForm.Close()
            })
            $btnCancel.Add_Click({
                $selectForm.Tag = "CANCEL"
                $selectForm.Close()
            })

            $selectForm.Controls.AddRange(@($labelUser,$comboUsers,$btnOk,$btnCancel))
            [void]$selectForm.ShowDialog()

            if ($selectForm.Tag -ne "OK") {
                $textOutput.AppendText("Удаление профиля отменено пользователем.`r`n")
                return
            }

            $userToDelete = $comboUsers.SelectedItem
            if (-not $userToDelete) {
                $textOutput.AppendText("Профиль не выбран. Отмена.`r`n")
                return
            }

            $textOutput.AppendText("Будет удалён профиль: $userToDelete на $ComputerName.`r`n")

            $result = Invoke-Command -ComputerName $ComputerName -ArgumentList $userToDelete -ScriptBlock {
                param($userName)
                $messages = @()

                $userRoot    = 'C:\Users'
                $profilePath = Join-Path $userRoot $userName

                try {
                    $who = quser 2>$null
                    if ($who -and ($who -match "^\s*$userName\s")) {
                        $messages += ("Профиль {0}: пользователь сейчас залогинен, удаление может не сработать." -f $userName)
                    }
                } catch { }

                if (-not (Test-Path $profilePath)) {
                    $messages += ("Профиль {0}: путь не найден ({1})" -f $userName, $profilePath)
                } else {
                    $messages += ("Профиль {0}: найден путь {1}" -f $userName, $profilePath)

                    try {
                        $sidProfile = Get-WmiObject -Class Win32_UserProfile -ErrorAction SilentlyContinue |
                                      Where-Object { $_.LocalPath -ieq $profilePath }

                        if ($sidProfile) {
                            try {
                                $res = $sidProfile.Delete()
                                $messages += ("Профиль {0}: Win32_UserProfile.Delete() код {1}" -f $userName, $res.ReturnValue)
                            } catch {
                                $messages += ("Профиль {0}: ошибка Win32_UserProfile.Delete(): {1}" -f $userName, $_)
                            }
                        } else {
                            $messages += ("Профиль {0}: Win32_UserProfile не найден, удаляю только папку." -f $userName)
                        }
                    } catch {
                        $messages += ("Профиль {0}: ошибка поиска Win32_UserProfile: {1}" -f $userName, $_)
                    }

                    try {
                        if (Test-Path $profilePath) {
                            Remove-Item -Path $profilePath -Recurse -Force -ErrorAction Stop
                            $messages += ("Профиль {0}: папка {1} удалена." -f $userName, $profilePath)
                        } else {
                            $messages += ("Профиль {0}: папка {1} уже отсутствует после Delete(), всё ок." -f $userName, $profilePath)
                        }
                    } catch {
                        $messages += ("Профиль {0}: ошибка при удалении папки: {1}" -f $userName, $_)
                    }
                }

                $messages
            }

            if ($result) { foreach ($line in $result) { $textOutput.AppendText($line + "`r`n") } }
            else { $textOutput.AppendText("Не удалось получить результаты удаления профиля.`r`n") }

            $textOutput.AppendText("Операция удаления профиля завершена.`r`n")
        }

        12 {
            # --- Только чистка ETL-логов ---
            $textOutput.AppendText("Очищаю ETL-логи на $ComputerName...`r`n")

            $result = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                $messages = @()
                $etlDirs = @(
                    "C:\ProgramData\Microsoft\Diagnosis\ETLLogs",
                    "C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger",
                    "C:\ProgramData\Microsoft\Windows\WER\ReportQueue",
                    "C:\ProgramData\Microsoft\Windows\WER\ReportArchive"
                )

                foreach ($dir in $etlDirs) {
                    if (-not (Test-Path $dir)) {
                        $messages += ("ETL: путь не найден: {0}" -f $dir)
                        continue
                    }

                    try {
                        $before = Get-ChildItem -Path $dir -Force -ErrorAction SilentlyContinue
                        $sizeBefore = ($before | Measure-Object Length -Sum).Sum

                        foreach ($item in $before) {
                            try { Remove-Item -Path $item.FullName -Recurse -Force -ErrorAction Stop } catch { }
                        }

                        $after = Get-ChildItem -Path $dir -Force -ErrorAction SilentlyContinue
                        $sizeAfter = ($after | Measure-Object Length -Sum).Sum
                        $freed = $sizeBefore - $sizeAfter
                        $freedMB = [math]::Round(($freed / 1MB),2)

                        $messages += ("ETL: {0} очищено ~{1} МБ" -f $dir, $freedMB)
                    } catch {
                        $messages += ("ETL: ошибка при очистке {0}: {1}" -f $dir, $_)
                    }
                }

                $messages
            }

            if ($result) { foreach ($line in $result) { $textOutput.AppendText($line + "`r`n") } }
            else { $textOutput.AppendText("Не удалось получить результаты очистки ETL-логов.`r`n") }

            $textOutput.AppendText("Очистка ETL-логов завершена.`r`n")
        }

        13 {
            # --- Быстрый health-check станции ---
            $textOutput.AppendText(("Health-check {0}: ошибки журнала и статус служб...`r`n" -f $ComputerName))

            $result = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                $messages = @()

                $since = (Get-Date).AddHours(-24)

                foreach ($log in @("System","Application")) {
                    try {
                        $events = Get-WinEvent -FilterHashtable @{
                            LogName   = $log
                            Level     = 2
                            StartTime = $since
                        } -MaxEvents 10 -ErrorAction SilentlyContinue

                        if ($events) {
                            $messages += ("Журнал {0}: последние ошибки (до 10 шт., с {1}):" -f $log, $since)
                            foreach ($e in $events) {
                                $firstLine = $e.Message.Split("`n")[0]
                                $messages += ("  [{0}] {1} (ID {2}) - {3}" -f `
                                    $e.TimeCreated, $e.ProviderName, $e.Id, $firstLine)
                            }
                        } else {
                            $messages += ("Журнал {0}: ошибок уровня Error за последние 24 ч не найдено." -f $log)
                        }
                    } catch {
                        $messages += ("Журнал {0}: ошибка чтения: {1}" -f $log, $_)
                    }
                }

                $svcNames = @(
                    "WinRM",
                    "TermService"
                )

                try {
                    $services = Get-Service -Name $svcNames -ErrorAction SilentlyContinue
                    if ($services) {
                        $messages += "Статус важных служб:"
                        foreach ($s in $services) {
                            $messages += ("  {0} ({1}) - {2}" -f $s.Name, $s.DisplayName, $s.Status)
                        }
                    } else {
                        $messages += "Не удалось получить статус служб (список пуст)."
                    }
                } catch {
                    $messages += ("Ошибка при получении статуса служб: {0}" -f $_)
                }

                $messages
            }

            if ($result) {
                foreach ($line in $result) { $textOutput.AppendText($line + "`r`n") }
            } else {
                $textOutput.AppendText("Не удалось выполнить health-check.`r`n")
            }

            $textOutput.AppendText("Health-check завершён.`r`n")
        }
    }
})

$form.Controls.AddRange(@(
    $labelComputer, $textComputer,
    $labelMac, $textMac,
    $labelMsg, $textMsg,
    $labelAction, $comboAction,
    $buttonRun,
    $textOutput
))

[void]$form.ShowDialog()