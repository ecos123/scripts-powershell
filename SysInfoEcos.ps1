# Coleta Informações do Sistema
$OS = (Get-ComputerInfo | Select-Object CsName, OsName, OsArchitecture, WindowsVersion)
$Processor = (Get-CimInstance Win32_Processor | Select-Object Name).Name
$RAM = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
$Storage = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
$FreeSpace = [math]::Round($Storage.FreeSpace / 1GB, 2)
$TotalSpace = [math]::Round($Storage.Size / 1GB, 2)

# Formata o resultado
$Output = @"
System Information:
-------------------
Computer Name: $($OS.CsName)
Operating System: $($OS.OsName) ($($OS.OsArchitecture))
Windows Version: $($OS.WindowsVersion)
Processor: $Processor
RAM: ${RAM}GB
Total Storage (C:): ${TotalSpace}GB
Free Storage (C:): ${FreeSpace}GB
"@

# Salva no arquivo de texto
$Output | Out-File -FilePath "SystemInfo.txt"

# Exibe o conteúdo no console
Write-Output $Output
