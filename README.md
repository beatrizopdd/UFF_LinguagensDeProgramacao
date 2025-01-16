## Como testar

- Compila ```ghc -o main main.hs```
- Roda ```.\main.exe```

## Instalação
Não sei o que funcionou mas eu fiz literalmente tudo isso aqui.
- Atualiza o power shell com:
    - ```winget search Microsoft.PowerShell```
    - ```winget install --id Microsoft.PowerShell.Preview --source winget```
- Crie o diretório ```C:\ghcup\bin``` e coloque dentro o arquivo  ```x86_64-mingw64-ghcup.exe``.
- Execute o arquivo ```msys2-x86_64-latest.exe``` e instale em ```C:\msys64```.
- Atualize os paths:
    - Adiciona em Path -> C:\ghcup\bin
    - Cria GHCUP_MSYS2 -> C:\msys64
    - Cria GHCUP_INSTALL_BASE_PREFIX -> C:\
    - Cria CABAL_DIR -> C:\cabal
- Execute no powershell 7:
    - Teste a conexão: ```Test-NetConnection -ComputerName www.haskell.org -Port 443```, tomara que dê true.
    - ```[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12```
    - ``` Invoke-WebRequest -Uri "https://www.haskell.org/ghcup/sh/bootstrap-haskell" -OutFile "bootstrap-haskell.sh"```
    - ```curl -k https://www.haskell.org/ghcup/sh/bootstrap-haskell -o bootstrap-haskell.sh```
    - ```Set-ExecutionPolicy Bypass -Scope Process -Force;[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; try { & ([ScriptBlock]::Create((Invoke-WebRequest https://www.haskell.org/ghcup/sh/bootstrap-haskell.ps1 -UseBasicParsing))) -Interactive -DisableCurl } catch { Write-Error $_ }```
        - Enter
        - Enter
        - Enter
        - Y
        - Y
        - Enter
        - Enter