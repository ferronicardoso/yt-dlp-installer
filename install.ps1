# Elevar automaticamente para administrador se necessário
$CurrentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$Principal = New-Object Security.Principal.WindowsPrincipal($CurrentUser)
$Admin = [Security.Principal.WindowsBuiltInRole]::Administrator

if (-not $Principal.IsInRole($Admin)) {
    Write-Host "Reexecutando como Administrador..."
    Start-Process powershell -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"" + $PSCommandPath + "`"") -Verb RunAs
    exit
}

# Definição das URLs de download
$ytDlpUrl = "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"
$ffmpegUrl = "https://github.com/BtbN/FFmpeg-Builds/releases/download/autobuild-2025-02-11-15-16/ffmpeg-N-118460-g78ff3782af-win64-gpl.zip"

# Definição dos diretórios
$ytDlpDir = "C:\yt-dlp"
$ffmpegDir = "C:\ffmpeg"
$tempZip = "$env:TEMP\ffmpeg.zip"
$tempExtract = "$env:TEMP\ffmpeg_extract"

# Criar diretórios, se não existirem
if (!(Test-Path $ytDlpDir)) { New-Item -ItemType Directory -Path $ytDlpDir -Force }
if (!(Test-Path $ffmpegDir)) { New-Item -ItemType Directory -Path $ffmpegDir -Force }

# Baixar yt-dlp.exe
Write-Host "Baixando yt-dlp.exe..."
Invoke-WebRequest -Uri $ytDlpUrl -OutFile "$ytDlpDir\yt-dlp.exe"

# Baixar FFmpeg e salvar como zip
Write-Host "Baixando FFmpeg..."
Invoke-WebRequest -Uri $ffmpegUrl -OutFile $tempZip

# Extrair FFmpeg
Write-Host "Extraindo FFmpeg..."
Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

# Detectar a pasta FFmpeg correta dentro do ZIP
$extractedFolder = Get-ChildItem -Path $tempExtract -Directory | Select-Object -First 1
if ($extractedFolder) {
    $innerFolder = Get-ChildItem -Path $extractedFolder.FullName -Directory | Select-Object -First 1
    
    if ($innerFolder) {
        Write-Host "Movendo arquivos para C:\ffmpeg..."
        Move-Item -Path "$innerFolder\*" -Destination $ffmpegDir -Force
    } else {
        Write-Host "Movendo arquivos diretamente..."
        Move-Item -Path "$extractedFolder\*" -Destination $ffmpegDir -Force
    }
}

# Remover arquivos temporários
Write-Host "Limpando arquivos temporários..."
Remove-Item -Path $tempZip -Force
Remove-Item -Path $tempExtract -Recurse -Force

# Adicionar yt-dlp e ffmpeg ao PATH
Write-Host "Configurando variáveis de ambiente..."
$envPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
$newPaths = "$ytDlpDir;$ffmpegDir"

if ($envPath -notlike "*$newPaths*") {
    [System.Environment]::SetEnvironmentVariable("Path", "$envPath;$newPaths", "Machine")
    Write-Host "PATH atualizado! Reinicie o terminal para aplicar as mudanças."
} else {
    Write-Host "O PATH já está configurado corretamente."
}

Write-Host "Instalação concluída!"
