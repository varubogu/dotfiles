
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

# PowerShellスクリプトを実行する関数
# スクリプト名を引数に取り、インストール済みのスクリプトから取得して実行します。
# スクリプトが存在する場所について環境変数PATHを通さずに実行することを目的としています。
# Parameters:
#    [string] $scriptName 呼び出したいスクリプトのファイル名（拡張子を除く）
function Invoke-PowerShellScript {
    param (
        [string]$scriptName
    )
    $script = Get-installedScript -name $scriptName
    if (-not $script) {
        Write-Host "$scriptName script is not installed. Please install it first." -ForegroundColor Red
        return
    }
    $scriptDir = $script.installedLocation
    $scriptPath = Join-Path -Path $scriptDir -ChildPath "$scriptName.ps1"
    if (Test-Path $scriptPath) {
        & $scriptPath @args
    } else {
        Write-Host "Script not found: $scriptPath" -ForegroundColor Red
    }
}

# yadmスクリプトの実行。
function yadm {
    Invoke-PowerShellScript -scriptName "yadm" @args
}

if (Is-Command-Exists starship) {
    Invoke-Expression (&starship init powershell)
}

if (Is-Command-Found python) {
    Invoke-Expression (&pyenv init -PowerShell | Out-String)
} else {
    Write-Host "pyenv is not installed. Skipping initialization."
}
