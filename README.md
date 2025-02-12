# Converção de vídeo em MP3 ou MP4

## Instalação

Executar o terminal do powershell como administrador

```powershell
irm "https://raw.githubusercontent.com/ferronicardoso/yt-dlp-installer/refs/heads/main/install.ps1" | iex
```

Após instalação, reiniciar o terminal

## Conversão em MP4

```powershell
yt-dlp.exe -f mp4 "https://www.youtube.com/watch?v=TAqZb52sgpU" -o c:\temp\alice_in_chains_-_man_in_the_box.mp4
```
## Conversão em MP3

```powershell
yt-dlp.exe --extract-audio --audio-format mp3 "https://www.youtube.com/watch?v=TAqZb52sgpU" -o c:\temp\alice_in_chains_-_man_in_the_box.mp3
```
