Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName Microsoft.VisualBasic # Для InputBox (диалоговых окон ввода)

# --- Форма ---
$form               = New-Object System.Windows.Forms.Form
$form.Text          = "Мини-RMM"
$form.Size          = New-Object System.Drawing.Size(680, 650)
$form.MinimumSize   = New-Object System.Drawing.Size(620, 500)
$form.StartPosition = "CenterScreen"

# --- Имя компьютера ---
$labelComputer              = New-Object System.Windows.Forms.Label
$labelComputer.Text         = "Имя компьютера:"
$labelComputer.AutoSize     = $true
$labelComputer.Location     = New-Object System.Drawing.Point(10,15)
$labelComputer.Anchor       = 'Top, Left'

$textComputer               = New-Object System.Windows.Forms.TextBox
$textComputer.Location      = New-Object System.Drawing.Point(120,10)
$textComputer.Width         = 420
$textComputer.Anchor        = 'Top, Left, Right'

# --- Пользователь ---
$labelUser                  = New-Object System.Windows.Forms.Label
$labelUser.Text             = "Пользователь:"
$labelUser.AutoSize         = $true
$labelUser.Location         = New-Object System.Drawing.Point(10,45)
$labelUser.Anchor           = 'Top, Left'

$textUser                   = New-Object System.Windows.Forms.TextBox
$textUser.Location          = New-Object System.Drawing.Point(120,40)
$textUser.Width             = 420
$textUser.Anchor            = 'Top, Left, Right'

# --- MAC ---
$labelMac                   = New-Object System.Windows.Forms.Label
$labelMac.Text              = "MAC (для WOL):"
$labelMac.AutoSize          = $true
$labelMac.Location          = New-Object System.Drawing.Point(10,75)
$labelMac.Anchor            = 'Top, Left'

$textMac                    = New-Object System.Windows.Forms.TextBox
$textMac.Location           = New-Object System.Drawing.Point(120,70)
$textMac.Width              = 420
$textMac.Anchor             = 'Top, Left, Right'

# --- Сообщение ---
$labelMsg                   = New-Object System.Windows.Forms.Label
$labelMsg.Text              = "Сообщение:"
$labelMsg.AutoSize          = $true
$labelMsg.Location          = New-Object System.Drawing.Point(10,105)
$labelMsg.Anchor            = 'Top, Left'

$textMsg                    = New-Object System.Windows.Forms.TextBox
$textMsg.Location           = New-Object System.Drawing.Point(120,100)
$textMsg.Width              = 420
$textMsg.Height             = 40
$textMsg.Multiline          = $true
$textMsg.Anchor             = 'Top, Left, Right'

# --- Действие ---
$labelAction                = New-Object System.Windows.Forms.Label
$labelAction.Text           = "Действие:"
$labelAction.AutoSize       = $true
$labelAction.Location       = New-Object System.Drawing.Point(10,150)
$labelAction.Anchor         = 'Top, Left'

$comboAction                = New-Object System.Windows.Forms.ComboBox
$comboAction.Location       = New-Object System.Drawing.Point(120,145)
$comboAction.Width          = 420
$comboAction.DropDownStyle  = "DropDownList"
$comboAction.Anchor         = 'Top, Left, Right'

$comboAction.Items.Add("<выберите действие>")                                 | Out-Null
$comboAction.Items.Add("1  - reboot удаленный компьютер")                     | Out-Null
$comboAction.Items.Add("2  - Показать MAC-адрес(а) удаленного компьютера")    | Out-Null
$comboAction.Items.Add("3  - Включить компьютер по MAC (Wake-on-LAN)")        | Out-Null
$comboAction.Items.Add("4  - Разлогинить RDP-сессии на удаленном компьютере") | Out-Null
$comboAction.Items.Add("5  - Показать аптайм и последнюю перезагрузку")       | Out-Null
$comboAction.Items.Add("6  - Показать залогиненных пользователей")            | Out-Null
$comboAction.Items.Add("7  - о системе")                                      | Out-Null
$comboAction.Items.Add("8  - Показать сетевые параметры")                     | Out-Null
$comboAction.Items.Add("9  - Очистить печать и перезапустить Spooler")        | Out-Null
$comboAction.Items.Add("10 - Отправить сообщение пользователю")               | Out-Null
$comboAction.Items.Add("11 - Удалить профиль пользователя")                   | Out-Null
$comboAction.Items.Add("12 - Очистить ETL-логи")                              | Out-Null
$comboAction.Items.Add("13 - Быстрый health-check станции")                   | Out-Null
$comboAction.Items.Add("14 - Показать сетевые диски и их пути")               | Out-Null
$comboAction.Items.Add("15 - Заблокировать ПК (Scheduled Task)")              | Out-Null
$comboAction.Items.Add("16 - Заблокировать ПК (PsExec -i -s)")                | Out-Null
$comboAction.Items.Add("17 - Заблокировать ПК (rundll32 Session 0)")          | Out-Null
$comboAction.Items.Add("18 - Заблокировать ПК (tsdiscon - отключить)")        | Out-Null
$comboAction.Items.Add("19 - Принудительное обновление GPO (gpupdate)")       | Out-Null
$comboAction.Items.Add("20 - Убить процесс (диалог)")                         | Out-Null
$comboAction.Items.Add("21 - Очистить временные файлы (Temp)")                | Out-Null
$comboAction.Items.Add("22 - Перезапустить конкретную службу (диалог)")       | Out-Null
$comboAction.Items.Add("23 - Список установленного ПО (с поиском)")           | Out-Null
$comboAction.Items.Add("24 - Ping с удаленной машины")                        | Out-Null
$comboAction.SelectedIndex = 0

# --- Кнопка Выполнить ---
$buttonRun                  = New-Object System.Windows.Forms.Button
$buttonRun.Text             = "Выполнить"
$buttonRun.Location         = New-Object System.Drawing.Point(555, 143)
$buttonRun.Width            = 90
$buttonRun.Height           = 25
$buttonRun.Anchor           = 'Top, Right'

$form.AcceptButton = $buttonRun

# --- Кнопка «Кто залогинен?» ---
$buttonWho            = New-Object System.Windows.Forms.Button
$buttonWho.Text       = "Кто залогинен?"
$buttonWho.Location   = New-Object System.Drawing.Point(555, 175)
$buttonWho.Width      = 90
$buttonWho.Height     = 25
$buttonWho.Anchor     = 'Top, Right'

# --- Кнопка RDP ---
$buttonRDP            = New-Object System.Windows.Forms.Button
$buttonRDP.Text       = "RDP"
$buttonRDP.Location   = New-Object System.Drawing.Point(445, 175)
$buttonRDP.Width      = 90
$buttonRDP.Height     = 25
$buttonRDP.Anchor     = 'Top, Right'

# --- Кнопка «Очистить лог» ---
$buttonClear          = New-Object System.Windows.Forms.Button
$buttonClear.Text     = "Очистить лог"
$buttonClear.Location = New-Object System.Drawing.Point(10, 175)
$buttonClear.Width    = 100
$buttonClear.Height   = 25
$buttonClear.Anchor   = 'Top, Left'

# --- Кнопка «Сохранить лог» ---
$buttonSave           = New-Object System.Windows.Forms.Button
$buttonSave.Text      = "Сохранить лог"
$buttonSave.Location  = New-Object System.Drawing.Point(120, 175)
$buttonSave.Width     = 100
$buttonSave.Height    = 25
$buttonSave.Anchor    = 'Top, Left'

# --- Поле вывода ---
$textOutput                 = New-Object System.Windows.Forms.TextBox
$textOutput.Location        = New-Object System.Drawing.Point(10,210)
$textOutput.Size            = New-Object System.Drawing.Size(635,380)
$textOutput.Multiline       = $true
$textOutput.ScrollBars      = "Vertical"
$textOutput.ReadOnly        = $true
$textOutput.Font            = New-Object System.Drawing.Font("Consolas", 9)
$textOutput.Anchor          = 'Top, Bottom, Left, Right'

# --- Вспомогательная функция логирования ---
function Write-UIOutput {
    param([string]$msg)
    $textOutput.AppendText($msg + "`r`n")
    $textOutput.SelectionStart = $textOutput.Text.Length
    $textOutput.ScrollToCaret()
    [System.Windows.Forms.Application]::DoEvents()
}

# --- Функция: показать залогиненных пользователей ---
function Show-LoggedInUsers {
    param([string]$ComputerName)

    if ([string]::IsNullOrWhiteSpace($ComputerName)) {
        Write-UIOutput "Укажите имя компьютера."
        return
    }

    Write-UIOutput "Получаю список залогиненных пользователей на $ComputerName..."
    Write-UIOutput ("=" * 70)

    try {
        $result = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
            $out = @()
            $quserRaw = $null
            try {
                $oldEncoding = [Console]::OutputEncoding
                [Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding(866)
                $quserRaw = quser 2>$null
                [Console]::OutputEncoding = $oldEncoding
            } catch { }

            if ($quserRaw) {
                $out += "СЕССИИ (quser):"
                foreach ($line in $quserRaw) {
                    $t = $line.ToString().TrimEnd()
                    if ($t) { $out += "  " + $t }
                }
            }

            try {
                $sessions = Get-CimInstance Win32_LogonSession -ErrorAction SilentlyContinue |
                            Where-Object { $_.LogonType -in 2, 10, 11 }

                if ($sessions) {
                    $cimOut = @()
                    foreach ($s in $sessions) {
                        $users = Get-CimInstance Win32_LoggedOnUser -ErrorAction SilentlyContinue |
                                 Where-Object { $_.Dependent.LogonId -eq $s.LogonId }

                        foreach ($u in $users) {
                            $dom = $u.Antecedent.Domain
                            $nm  = $u.Antecedent.Name

                            if ($dom -eq 'NT AUTHORITY' -or $nm -match '^(DWM-|UMFD-|SYSTEM)') { continue }

                            $type = switch ($s.LogonType) {
                                2  { "Interactive (консоль)" }
                                10 { "RemoteInteractive (RDP)" }
                                11 { "CachedInteractive" }
                                default { "Type $($s.LogonType)" }
                            }
                            $start = if ($s.StartTime) { $s.StartTime.ToString("yyyy-MM-dd HH:mm") } else { "?" }

                            $line = ("  {0}\{1}  |  {2}  |  вход: {3}" -f $dom, $nm, $type, $start)
                            if ($line -notin $cimOut) {
                                $cimOut += $line
                            }
                        }
                    }

                    if ($cimOut.Count -gt 0) {
                        $out += ""
                        $out += "ДЕТАЛИ (CIM: интерактивные и RDP):"
                        $out += $cimOut
                    }
                }
            } catch {
                $out += "CIM: $_"
            }

            if ($out.Count -eq 0) { $out = "Залогиненных пользователей не найдено." }
            $out
        }

        foreach ($line in $result) { Write-UIOutput $line }
    } catch {
        Write-UIOutput "Ошибка: $_"
    }

    Write-UIOutput ("=" * 70)
}

# --- Обработчики кнопок ---

$buttonClear.Add_Click({
    $textOutput.Clear()
})

$buttonSave.Add_Click({
    $saveDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveDialog.Filter = "Текстовые файлы (*.txt)|*.txt|Все файлы (*.*)|*.*"
    $saveDialog.FileName = "RMM_Log_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
    if ($saveDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        try {
            $textOutput.Text | Out-File -FilePath $saveDialog.FileName -Encoding UTF8
            [System.Windows.Forms.MessageBox]::Show("Лог успешно сохранен!", "Успех", "OK", "Information")
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Ошибка при сохранении: $_", "Ошибка", "OK", "Error")
        }
    }
})

$buttonRDP.Add_Click({
    $pc = $textComputer.Text.Trim()
    if ([string]::IsNullOrWhiteSpace($pc)) {
        [System.Windows.Forms.MessageBox]::Show("Укажите имя компьютера для подключения по RDP.", "Внимание", "OK", "Warning")
        return
    }
    try {
        Start-Process "mstsc.exe" -ArgumentList "/v:$pc"
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Не удалось запустить RDP: $_", "Ошибка", "OK", "Error")
    }
})

$buttonWho.Add_Click({
    $ComputerName = $textComputer.Text.Trim()
    
    $textOutput.AppendText("`r`n")
    Write-UIOutput ("=" * 80)
    Write-UIOutput ("[{0}] ДЕЙСТВИЕ: Кто залогинен? (ПК: {1})" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $ComputerName)
    Write-UIOutput ("=" * 80)

    if ([string]::IsNullOrWhiteSpace($ComputerName)) {
        Write-UIOutput "Укажите имя компьютера."
        return
    }

    Write-UIOutput "Проверяю доступность $ComputerName..."
    if (-not (Test-Connection -ComputerName $ComputerName -Count 1 -Quiet -ErrorAction SilentlyContinue)) {
        Write-UIOutput "Хост $ComputerName недоступен."
        return
    }

    Show-LoggedInUsers -ComputerName $ComputerName
})

$buttonRun.Add_Click({
    $ComputerName = $textComputer.Text.Trim()
    $UserAddress  = $textUser.Text.Trim()
    $MacAddress   = $textMac.Text.Trim()
    $choiceIndex  = $comboAction.SelectedIndex

    if ($choiceIndex -gt 0) {
        $textOutput.AppendText("`r`n")
        Write-UIOutput ("=" * 80)
        Write-UIOutput ("[{0}] ДЕЙСТВИЕ: {1} (ПК: {2})" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $comboAction.Text, $ComputerName)
        Write-UIOutput ("=" * 80)
    }

    if ($choiceIndex -eq 0) {
        Write-UIOutput "Сначала выберите действие из списка."
        return
    }

    $choice = $choiceIndex

    # Проверяем, нужно ли имя ПК (для 3-го пункта WOL оно не нужно)
    if ($choice -in 1,2,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24 -and [string]::IsNullOrWhiteSpace($ComputerName)) {
        Write-UIOutput "Укажите имя компьютера."
        return
    }

    if ($choice -in 1,2,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24) {
        Write-UIOutput "Проверяю доступность $ComputerName..."
        if (-not (Test-Connection -ComputerName $ComputerName -Count 1 -Quiet -ErrorAction SilentlyContinue)) {
            Write-UIOutput "Хост $ComputerName недоступен (ping не проходит). Отмена."
            return
        }
        Write-UIOutput "Хост доступен."
    }

    switch ($choice) {

        1 {
            Write-UIOutput "Отправляю команду на перезагрузку..."
            Restart-Computer -ComputerName $ComputerName -Force -AsJob
            Write-UIOutput "Команда перезагрузки отправлена."
        }

        2 {
            Write-UIOutput "Получаю MAC-адрес(а) с $ComputerName..."
            $adapters = Get-WmiObject -Class Win32_NetworkAdapterConfiguration `
                                      -ComputerName $ComputerName `
                                      -Filter "IPEnabled = True" |
                        Select-Object Description, MACAddress
            if (-not $adapters) {
                Write-UIOutput "Не найдено активных сетевых адаптеров."
            } else {
                $adapters | ForEach-Object {
                    Write-UIOutput ("Описание: {0} | MAC: {1}" -f $_.Description,$_.MACAddress)
                }
            }
        }

        3 {
            if ([string]::IsNullOrWhiteSpace($MacAddress)) {
                Write-UIOutput "Укажите MAC-адрес для WOL."
                return
            }
            $Broadcast = "255.255.255.255"
            $Port = 9
            Write-UIOutput "Отправляю WOL на $MacAddress через ${Broadcast}:$Port..."

            $mac = $MacAddress -split '[:-]'
            $packet = [byte[]](,0xFF*6+(([byte]("0x$($mac[0])"),[byte]("0x$($mac[1])"),[byte]("0x$($mac[2])"),[byte]("0x$($mac[3])"),[byte]("0x$($mac[4])"),[byte]("0x$($mac[5])"))*16))
            $u = New-Object System.Net.Sockets.UdpClient
            $u.EnableBroadcast = $true
            $u.Connect($Broadcast,$Port)
            $u.Send($packet,$packet.Length) | Out-Null
            $u.Close()
            Write-UIOutput "WOL-пакет отправлен."
        }

        4 {
            Write-UIOutput "Ищу RDP-сессии на $ComputerName и выполняю logoff..."
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
            } | ForEach-Object { Write-UIOutput $_ }
            Write-UIOutput "Команда logoff для RDP-сессий выполнена."
        }

        5 {
            Write-UIOutput "Получаю аптайм и время последней перезагрузки..."
            $os = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $ComputerName
            $lastBoot = $os.LastBootUpTime
            $uptime   = (Get-Date) - $lastBoot

            Write-UIOutput ("Последняя перезагрузка: {0}" -f $lastBoot)
            Write-UIOutput ("Аптайм: {0} дн {1} ч {2} мин" -f `
                [int]$uptime.Days, [int]$uptime.Hours, [int]$uptime.Minutes)
        }

        6 {
            Show-LoggedInUsers -ComputerName $ComputerName
        }

        7 {
            Write-UIOutput "Получаю информацию о системе..."

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

            Write-UIOutput ("Компьютер:    {0}" -f $compName)
            if ($domain) {
                Write-UIOutput ("Домен/группа: {0}" -f $domain)
            } elseif ($workgroup) {
                Write-UIOutput ("Рабочая группа: {0}" -f $workgroup)
            }

            Write-UIOutput ("Производитель: {0}" -f $vendor)
            Write-UIOutput ("Модель:        {0}" -f $model)
            Write-UIOutput ("Серийный №:    {0}" -f $serial)
            Write-UIOutput ("ОС:            {0} (Build {1}, {2})" -f $osCaption,$osBuild,$osArch)
            Write-UIOutput ("RAM:           {0} ГБ" -f $totalRam)

            if ($cpuName) {
                Write-UIOutput ("CPU:           {0}" -f $cpuName)
                Write-UIOutput ("Ядер/потоков:  {0} / {1}" -f $cpuCores,$cpuLogical)
            }

            if ($diskC) {
                Write-UIOutput ("Диск C: всего {0} ГБ, свободно {1} ГБ" -f $sizeCGB,$freeCGB)
            } else {
                Write-UIOutput "Диск C: не найден."
            }
        }

        8 {
            Write-UIOutput "Получаю сетевые параметры..."

            $nets = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -ComputerName $ComputerName -Filter "IPEnabled = True"
            if (-not $nets) {
                Write-UIOutput "Нет активных сетевых интерфейсов."
            } else {
                foreach ($n in $nets) {
                    Write-UIOutput ("Адаптер: {0}" -f $n.Description)
                    if ($n.IPAddress) {
                        Write-UIOutput ("  IP:      {0}" -f ($n.IPAddress -join ", "))
                    }
                    if ($n.IPSubnet) {
                        Write-UIOutput ("  Маска:   {0}" -f ($n.IPSubnet -join ", "))
                    }
                    if ($n.DefaultIPGateway) {
                        Write-UIOutput ("  Шлюз:    {0}" -f ($n.DefaultIPGateway -join ", "))
                    }
                    if ($n.DNSServerSearchOrder) {
                        Write-UIOutput ("  DNS:     {0}" -f ($n.DNSServerSearchOrder -join ", "))
                    }
                    Write-UIOutput ""
                }
            }
        }

        9 {
            Write-UIOutput "Очищаю очередь печати и перезапускаю Spooler на $ComputerName..."

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
            } | ForEach-Object { Write-UIOutput $_ }
        }

        10 {
            Write-UIOutput "Отправка сообщения пользователю на $ComputerName..."
            $msg = $textMsg.Text.Trim()
            if ([string]::IsNullOrWhiteSpace($msg)) {
                Write-UIOutput "Сообщение не задано. Введите текст в поле 'Сообщение'."
                return
            }

            try {
                Invoke-WmiMethod -Class Win32_Process -ComputerName $ComputerName -Name Create `
                    -ArgumentList "C:\Windows\System32\msg.exe * $msg" | Out-Null
                Write-UIOutput "Сообщение отправлено."
            } catch {
                Write-UIOutput "Ошибка при отправке сообщения: $_"
            }
        }

        11 {
            $profiles = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                $userRoot = 'C:\Users'
                $systemProfiles = @('All Users','Default','Default User','Public','DefaultAppPool')
                Get-ChildItem -Path $userRoot -Directory -ErrorAction SilentlyContinue |
                    Where-Object { $_.Name -notin $systemProfiles -and $_.Name -notlike 'ADMINI~*' } |
                    Select-Object -ExpandProperty Name
            }

            if (-not $profiles) {
                Write-UIOutput "Не найдено пользовательских профилей в C:\Users на $ComputerName."
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

            $btnOk.Add_Click({ $selectForm.Tag = "OK"; $selectForm.Close() })
            $btnCancel.Add_Click({ $selectForm.Tag = "CANCEL"; $selectForm.Close() })

            $selectForm.Controls.AddRange(@($labelUser,$comboUsers,$btnOk,$btnCancel))
            [void]$selectForm.ShowDialog()

            if ($selectForm.Tag -ne "OK") {
                Write-UIOutput "Удаление профиля отменено пользователем."
                return
            }

            $userToDelete = $comboUsers.SelectedItem
            Write-UIOutput "Будет удалён профиль: $userToDelete на $ComputerName."

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
                            $messages += ("Профиль {0}: папка {1} уже отсутствует." -f $userName, $profilePath)
                        }
                    } catch {
                        $messages += ("Профиль {0}: ошибка при удалении папки: {1}" -f $userName, $_)
                    }
                }
                $messages
            }
            foreach ($line in $result) { Write-UIOutput $line }
            Write-UIOutput "Операция удаления профиля завершена."
        }

        12 {
            Write-UIOutput "Очищаю ETL-логи на $ComputerName..."
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
            foreach ($line in $result) { Write-UIOutput $line }
            Write-UIOutput "Очистка ETL-логов завершена."
        }

        13 {
            Write-UIOutput ("Health-check {0}: ошибки журнала и статус служб..." -f $ComputerName)
            $result = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                $messages = @()
                $since = (Get-Date).AddHours(-24)
                foreach ($log in @("System","Application")) {
                    try {
                        $events = Get-WinEvent -FilterHashtable @{ LogName=$log; Level=2; StartTime=$since } -MaxEvents 10 -ErrorAction SilentlyContinue
                        if ($events) {
                            $messages += ("Журнал {0}: последние ошибки (до 10 шт., с {1}):" -f $log, $since)
                            foreach ($e in $events) {
                                $firstLine = $e.Message.Split("`n")[0]
                                $messages += ("  [{0}] {1} (ID {2}) - {3}" -f $e.TimeCreated, $e.ProviderName, $e.Id, $firstLine)
                            }
                        } else {
                            $messages += ("Журнал {0}: ошибок уровня Error за последние 24 ч не найдено." -f $log)
                        }
                    } catch {
                        $messages += ("Журнал {0}: ошибка чтения: {1}" -f $log, $_)
                    }
                }
                $svcNames = @("WinRM", "TermService")
                try {
                    $services = Get-Service -Name $svcNames -ErrorAction SilentlyContinue
                    if ($services) {
                        $messages += "Статус важных служб:"
                        foreach ($s in $services) { $messages += ("  {0} ({1}) - {2}" -f $s.Name, $s.DisplayName, $s.Status) }
                    } else {
                        $messages += "Не удалось получить статус служб (список пуст)."
                    }
                } catch {
                    $messages += ("Ошибка при получении статуса служб: {0}" -f $_)
                }
                $messages
            }
            foreach ($line in $result) { Write-UIOutput $line }
            Write-UIOutput "Health-check завершён."
        }

        14 {
            Write-UIOutput "Получаю список сетевых дисков и их путей на $ComputerName..."
            $result = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                $out = @()
                $usersKey = 'Registry::HKEY_USERS'
                Get-ChildItem $usersKey -ErrorAction SilentlyContinue | ForEach-Object {
                    $sid = $_.PSChildName
                    if ($sid -match '^S-1-5-21-\d+-\d+-\d+-\d+$' -or $sid -match '^S-1-12-1-') {
                        $netKey = Join-Path $usersKey "$sid\Network"
                        if (Test-Path $netKey) {
                            $userName = $null
                            $volKey = Join-Path $usersKey "$sid\Volatile Environment"
                            if (Test-Path $volKey) {
                                $userName = (Get-ItemProperty -Path $volKey -Name USERNAME -ErrorAction SilentlyContinue).USERNAME
                            }
                            if (-not $userName) {
                                try {
                                    $objSid  = New-Object System.Security.Principal.SecurityIdentifier($sid)
                                    $userName = $objSid.Translate([System.Security.Principal.NTAccount]).Value
                                } catch {
                                    $userName = $sid
                                }
                            }
                            Get-ChildItem $netKey -ErrorAction SilentlyContinue | ForEach-Object {
                                $drive  = $_.PSChildName
                                $remote = (Get-ItemProperty -Path $_.PSPath -Name RemotePath -ErrorAction SilentlyContinue).RemotePath
                                $provider = (Get-ItemProperty -Path $_.PSPath -Name ProviderName -ErrorAction SilentlyContinue).ProviderName
                                $out += ("Пользователь: {0,-20} | {1}: -> {2}  [{3}]" -f $userName, $drive, $remote, $provider)
                            }
                        }
                    }
                }
                try {
                    $smbMappings = Get-SmbMapping -ErrorAction SilentlyContinue
                    if ($smbMappings) {
                        $out += ""
                        $out += "--- Текущая сессия (Get-SmbMapping) ---"
                        foreach ($m in $smbMappings) { $out += ("  {0} -> {1}  (Статус: {2})" -f $m.LocalPath, $m.RemotePath, $m.Status) }
                    }
                } catch {
                    try {
                        $oldEncoding = [Console]::OutputEncoding
                        [Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding(866)
                        $netUse = net use 2>$null
                        [Console]::OutputEncoding = $oldEncoding
                        if ($netUse) {
                            $out += ""
                            $out += "--- Текущая сессия (net use) ---"
                            foreach ($line in $netUse) { $out += $line }
                        }
                    } catch { }
                }
                try {
                    $mapped = Get-CimInstance -ClassName Win32_MappedLogicalDisk -ErrorAction SilentlyContinue
                    if ($mapped) {
                        $out += ""
                        $out += "--- Win32_MappedLogicalDisk ---"
                        foreach ($m in $mapped) { $out += ("  {0} -> {1}" -f $m.DeviceID, $m.ProviderName) }
                    }
                } catch { }
                if ($out.Count -eq 0) { $out = "Сетевых дисков не найдено." }
                $out
            }
            foreach ($line in $result) { Write-UIOutput $line }
            Write-UIOutput "Готово."
        }

        15 {
            Write-UIOutput "Метод: Scheduled Task (в сессии пользователя)"
            if ([string]::IsNullOrWhiteSpace($UserAddress)) {
                Write-UIOutput "Укажите Домен\Пользователь в соответствующем поле!"
                return
            }
            try {
                $result = Invoke-Command -ComputerName $ComputerName -ErrorAction Stop -ScriptBlock {
                    param($u)
                    $Action = New-ScheduledTaskAction -Execute 'rundll32.exe' -Argument 'user32.dll,LockWorkStation'
                    $Principal = New-ScheduledTaskPrincipal -UserId $u -LogonType Interactive -RunLevel Limited
                    $Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
                    $Task = New-ScheduledTask -Action $Action -Principal $Principal -Settings $Settings

                    Register-ScheduledTask -TaskName "RemoteLockTask" -InputObject $Task -Force | Out-Null
                    Start-ScheduledTask -TaskName "RemoteLockTask"
                    Start-Sleep -Seconds 4

                    $info = Get-ScheduledTaskInfo -TaskName "RemoteLockTask"
                    $res = "LastResult=$($info.LastTaskResult); LastRun=$($info.LastRunTime)"
                    Unregister-ScheduledTask -TaskName "RemoteLockTask" -Confirm:$false
                    $res
                } -ArgumentList $UserAddress
                
                Write-UIOutput $result
                Write-UIOutput "LastTaskResult=0 означает успех."
            } catch {
                Write-UIOutput "ОШИБКА: $($_.Exception.Message)"
            }
        }

        16 {
            Write-UIOutput "Метод: PsExec -i -s (интерактивная сессия)"
            $psexec = Get-Command PsExec.exe -ErrorAction SilentlyContinue
            if (-not $psexec) {
                Write-UIOutput "PsExec.exe не найден в PATH."
                Write-UIOutput "Скачайте Sysinternals PsExec и положите в PATH или укажите полный путь."
                return
            }
            $psArgs = @("\\$ComputerName", "-accepteula", "-i", "1", "-s", "-d", "rundll32.exe", "user32.dll,LockWorkStation")
            Write-UIOutput "Запуск: PsExec $($psArgs -join ' ')"
            try {
                $out = & $psexec.Source @psArgs 2>&1
                foreach ($line in $out) { Write-UIOutput $line }
                Write-UIOutput "Если вернулось 'started with process ID' — команда отправлена."
            } catch {
                Write-UIOutput "ОШИБКА: $_"
            }
        }

        17 {
            Write-UIOutput "Метод: rundll32 напрямую (Session 0)"
            try {
                $result = Invoke-Command -ComputerName $ComputerName -ErrorAction Stop -ScriptBlock {
                    $p = Start-Process -FilePath "rundll32.exe" -ArgumentList "user32.dll,LockWorkStation" -PassThru -Wait
                    "ExitCode=$($p.ExitCode)"
                }
                Write-UIOutput $result
                Write-UIOutput "Часто не работает из-за Session 0. Если ExitCode=0, но экран не блокируется — используйте метод 15 или 16."
            } catch {
                Write-UIOutput "ОШИБКА: $($_.Exception.Message)"
            }
        }

        18 {
            Write-UIOutput "Метод: tsdiscon (отключить сессию)"
            try {
                Write-UIOutput "Запрос списка сессий на $ComputerName ..."
                $sessions = Invoke-Command -ComputerName $ComputerName -ErrorAction Stop -ScriptBlock {
                    $oldEncoding = [Console]::OutputEncoding
                    [Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding(866)
                    $q = quser 2>$null | Out-String
                    [Console]::OutputEncoding = $oldEncoding
                    $q
                }
                Write-UIOutput $sessions

                if ([string]::IsNullOrWhiteSpace($UserAddress)) {
                    Write-UIOutput "Укажите 'Пользователь' (Домен\Логин) для tsdiscon, либо используйте пункт 4 для RDP."
                    return
                }

                $targetUser = $UserAddress.Split('\')[-1]
                $line = ($sessions -split "`r?`n") | Where-Object { $_ -match [regex]::Escape($targetUser) } | Select-Object -First 1

                if (-not $line) {
                    Write-UIOutput "Сессия пользователя $targetUser не найдена."
                    return
                }
                $sid = ($line.Trim() -split '\s+')[2]
                Write-UIOutput "Найдена сессия ID=$sid. Отключаю..."
                
                Invoke-Command -ComputerName $ComputerName -ErrorAction Stop -ScriptBlock {
                    param($s)
                    tsdiscon $s
                } -ArgumentList $sid
                
                Write-UIOutput "Сессия $sid отключена."
            } catch {
                Write-UIOutput "ОШИБКА: $($_.Exception.Message)"
            }
        }

        19 {
            Write-UIOutput "Принудительное обновление групповых политик (gpupdate /force)..."
            try {
                $result = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                    $tempFile = [System.IO.Path]::GetTempFileName()
                    try {
                        $p = Start-Process -FilePath "gpupdate.exe" -ArgumentList "/force" -RedirectStandardOutput $tempFile -Wait -PassThru -NoNewWindow
                        $content = [System.IO.File]::ReadAllLines($tempFile, [System.Text.Encoding]::GetEncoding(866))
                        if ($p.ExitCode -ne 0) {
                            $content += "Код завершения: $($p.ExitCode)"
                        }
                        $content
                    } finally {
                        if (Test-Path $tempFile) { Remove-Item -Path $tempFile -Force -ErrorAction SilentlyContinue }
                    }
                } -ErrorAction Stop
                foreach ($line in $result) { Write-UIOutput $line }
                Write-UIOutput "Обновление GPO инициировано."
            } catch {
                Write-UIOutput "ОШИБКА при gpupdate: $($_.Exception.Message)"
            }
        }

        20 {
            $procName = [Microsoft.VisualBasic.Interaction]::InputBox("Введите имя процесса для завершения (например, excel.exe):", "Завершение процесса", "excel.exe")
            if ([string]::IsNullOrWhiteSpace($procName)) {
                Write-UIOutput "Ввод отменен."
                return
            }
            $pName = $procName -replace '\.exe$', ''
            Write-UIOutput "Завершаю процесс '$pName' на $ComputerName..."
            try {
                $result = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                    param($p)
                    try {
                        $proc = Get-Process -Name $p -ErrorAction SilentlyContinue
                        if ($proc) {
                            Stop-Process -Name $p -Force -ErrorAction Stop
                            "Процесс $p успешно завершен."
                        } else {
                            "Процесс $p не найден (или уже закрыт)."
                        }
                    } catch {
                        "Ошибка при завершении процесса $p : $_"
                    }
                } -ArgumentList $pName -ErrorAction Stop
                Write-UIOutput $result
            } catch {
                Write-UIOutput "ОШИБКА: $($_.Exception.Message)"
            }
        }

        21 {
            Write-UIOutput "Очистка временных файлов (C:\Windows\Temp и папки пользователей)..."
            try {
                $result = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                    $paths = @("$env:windir\Temp", "C:\Users\*\AppData\Local\Temp")
                    $count = 0
                    foreach ($path in $paths) {
                        if (Test-Path $path) {
                            Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
                                try { 
                                    Remove-Item -Path $_.FullName -Force -Recurse -ErrorAction SilentlyContinue
                                    $count++ 
                                } catch {}
                            }
                        }
                    }
                    "Удалено файлов и папок: $count"
                } -ErrorAction Stop
                Write-UIOutput $result
                Write-UIOutput "Очистка Temp завершена."
            } catch {
                Write-UIOutput "ОШИБКА: $($_.Exception.Message)"
            }
        }

        22 {
            $serviceName = [Microsoft.VisualBasic.Interaction]::InputBox("Введите имя службы для перезапуска (например, WinRM, LanmanServer):", "Перезапуск службы", "LanmanServer")
            if ([string]::IsNullOrWhiteSpace($serviceName)) {
                Write-UIOutput "Ввод отменен."
                return
            }
            Write-UIOutput "Перезапускаю службу '$serviceName' на $ComputerName..."
            try {
                $result = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                    param($s)
                    try {
                        Restart-Service -Name $s -Force -ErrorAction Stop
                        "Служба $s успешно перезапущена."
                    } catch {
                        "Ошибка при перезапуске службы $s : $_"
                    }
                } -ArgumentList $serviceName -ErrorAction Stop
                Write-UIOutput $result
            } catch {
                Write-UIOutput "ОШИБКА: $($_.Exception.Message)"
            }
        }

        23 {
            $searchTerm = [Microsoft.VisualBasic.Interaction]::InputBox("Введите часть названия программы (например, Word, 1C) или оставьте пустым для вывода всего списка:", "Поиск установленного ПО", "")
            if ($null -eq $searchTerm) {
                Write-UIOutput "Ввод отменен."
                return
            }
            
            Write-UIOutput "Получаю список установленного ПО на $ComputerName... (поиск: '$searchTerm')"
            try {
                $result = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                    param($search)
                    $paths = @(
                        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
                        "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
                    )
                    $apps = Get-ItemProperty -Path $paths -ErrorAction SilentlyContinue | 
                            Where-Object { $_.DisplayName -and -not [string]::IsNullOrWhiteSpace($_.DisplayName) } | 
                            Select-Object DisplayName, DisplayVersion | 
                            Sort-Object DisplayName -Unique
                    
                    if (-not [string]::IsNullOrWhiteSpace($search)) {
                        $apps = $apps | Where-Object { $_.DisplayName -match $search }
                    }
                    $apps
                } -ArgumentList $searchTerm -ErrorAction Stop
                
                if ($result) {
                    Write-UIOutput ("Найдено программ: {0}" -f $result.Count)
                    Write-UIOutput ("-" * 70)
                    foreach ($app in $result) {
                        Write-UIOutput ("{0,-55} v{1}" -f $app.DisplayName, $app.DisplayVersion)
                    }
                } else {
                    Write-UIOutput "Программы не найдены."
                }
            } catch {
                Write-UIOutput "ОШИБКА: $($_.Exception.Message)"
            }
        }

        24 {
            $target = [Microsoft.VisualBasic.Interaction]::InputBox("Введите IP или имя хоста, который нужно пропинговать с $ComputerName :", "Ping с удаленной машины", "8.8.8.8")
            if ([string]::IsNullOrWhiteSpace($target)) {
                Write-UIOutput "Ввод отменен."
                return
            }
            
            Write-UIOutput "Пингую $target с $ComputerName..."
            try {
                $result = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                    param($t)
                    $p = Test-Connection -ComputerName $t -Count 4 -ErrorAction SilentlyContinue
                    if ($p) {
                        $p | Select-Object Address, ResponseTime
                    } else {
                        "Хост $t недоступен с этой машины."
                    }
                } -ArgumentList $target -ErrorAction Stop
                
                if ($result -is [array]) {
                    foreach ($line in $result) {
                        Write-UIOutput ("Ответ от {0} (время: {1} мс)" -f $line.Address, $line.ResponseTime)
                    }
                } else {
                    Write-UIOutput $result
                }
            } catch {
                Write-UIOutput "ОШИБКА: $($_.Exception.Message)"
            }
        }
    }
})

$form.Controls.AddRange(@(
    $labelComputer, $textComputer,
    $labelUser, $textUser,
    $labelMac, $textMac,
    $labelMsg, $textMsg,
    $labelAction, $comboAction,
    $buttonRun, $buttonWho, $buttonRDP, $buttonClear, $buttonSave,
    $textOutput
))

[void]$form.ShowDialog()