
#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58

### My Custom


# コマンドが存在するかチェック
function Is-Command-Found {
    param (
        [string]$command
    )
    return (Get-Command $command -ErrorAction SilentlyContinue)
}

# コマンド存在チェック＋存在しない場合にメッセージ
function Is-Command-Exists {
    param (
        [string]$command
    )
    if (Is-Command-Found $command) {
        return $true
    } else {
        Write-Host "'$command' is not installed." -ForegroundColor Red
        return $false
    }

}

if (Is-Command-Exists starship) {
    Invoke-Expression (&starship init powershell)
}

if (Is-Command-Found python) {
    Invoke-Expression (&pyenv init -PowerShell | Out-String)
} else {
    Write-Host "pyenv is not installed. Skipping initialization."
}
