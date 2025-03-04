# Coleta as informações do processador
$processor = Get-CimInstance Win32_Processor | Select-Object Name, Manufacturer, MaxClockSpeed, NumberOfCores, NumberOfLogicalProcessors

# Coleta as informações de memória física
$memory = Get-CimInstance Win32_PhysicalMemory | Select-Object Manufacturer, Capacity, Speed, PartNumber
$maxMemory = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory

# Coleta as informações do disco rígido
$disks = Get-CimInstance Win32_DiskDrive | Select-Object Model, MediaType, Size, SerialNumber

# Coleta as informações da placa de vídeo
$video = Get-CimInstance Win32_VideoController | Select-Object Caption, VideoProcessor, AdapterRAM

# Coleta as informações de rede (incluindo Wi-Fi)
$networkAdapters = Get-CimInstance Win32_NetworkAdapter | Where-Object {$_.NetEnabled -eq $true} | Select-Object Name, MACAddress, Speed

# Coleta informações do sistema operacional
$os = Get-CimInstance Win32_OperatingSystem | Select-Object Caption, Version, OSArchitecture

# Coleta informações sobre o sistema (marca, modelo)
$computerSystem = Get-CimInstance Win32_ComputerSystem | Select-Object Manufacturer, Model

# Cria um objeto para o inventário
$inventory = New-Object PSObject -property @{
    Processor = $processor
    Memory = $memory
    MaxMemory = [math]::round($maxMemory / 1GB, 2)
    Disks = $disks
    Video = $video
    NetworkAdapters = $networkAdapters
    OS = $os
    ComputerSystem = $computerSystem
}

# Identifica o caminho para o Desktop do usuário
$desktopPath = [System.IO.Path]::Combine($env:USERPROFILE, 'Desktop')

# Verifica se o diretório do desktop existe
if (-not (Test-Path $desktopPath)) {
    Write-Host "Erro: Diretório do Desktop não encontrado!"
    exit
}

# Cria o caminho completo para o arquivo XML
$xmlFilePath = [System.IO.Path]::Combine($desktopPath, 'InventarioComputador.xml')

# Converte o inventário para XML
$inventoryXml = $inventory | ConvertTo-Xml -As String -Depth 5

# Tenta salvar o arquivo XML
try {
    $inventoryXml | Out-File $xmlFilePath
    Write-Host "Inventário gerado com sucesso e salvo no Desktop!"
} catch {
    Write-Host "Erro ao salvar o arquivo: $_"
}
