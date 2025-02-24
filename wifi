# Definir o caminho correto da área de trabalho
$desktopPath = [System.Environment]::GetFolderPath("Desktop")
# Obter a data atual no formato YYYY-MM-DD
$date = Get-Date -Format "yyyy-MM-dd"
$outputFile = "$desktopPath\WiFi_List_$date.txt"

# Verificar se a pasta existe
if (!(Test-Path $desktopPath)) {
    New-Item -ItemType Directory -Path $desktopPath | Out-Null
}

# Executar o script para obter os perfis de Wi-Fi e senhas
try {
    $wifiProfiles = netsh wlan show profiles | Select-String "All User Profile\s*:\s*(.+)" | ForEach-Object {
        $name = $_.Matches.Groups[1].Value.Trim()
        $passwordResult = netsh wlan show profile name="$name" key=clear | Select-String "Key Content\s*:\s*(.+)"
        $password = if ($passwordResult) { $passwordResult.Matches.Groups[1].Value.Trim() } else { "N/A" }

        [PSCustomObject]@{
            PROFILE_NAME = $name
            PASSWORD     = $password
        }
    }

    # Salvar o resultado no arquivo
    $wifiProfiles | Format-Table -AutoSize | Out-File -Encoding UTF8 $outputFile
    Write-Host "Arquivo salvo em: $outputFile" -ForegroundColor Green

    # Abrir o arquivo gerado (utilizando o Bloco de Notas como exemplo)
    Start-Process notepad.exe $outputFile
} catch {
    Write-Host "Erro ao gerar lista de Wi-Fi: $_" -ForegroundColor Red
}
