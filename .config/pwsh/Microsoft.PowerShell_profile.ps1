
#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58

### My Custom

# コマンドが存在するかチェック
function Is-Command-Found() {
    param (
        [string]$command
    )
    return (Get-Command $command -ErrorAction SilentlyContinue)
}

if (Is-Command-Found starship) {
    Invoke-Expression (&starship init powershell)
} else {
    Write-Host "starship is not installed. Skipping initialization."
}

if (Is-Command-Found python) {
    Invoke-Expression (&pyenv init -PowerShell | Out-String)
} else {
    Write-Host "pyenv is not installed. Skipping initialization."
}
