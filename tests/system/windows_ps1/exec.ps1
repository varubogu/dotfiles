# powershellのバージョン確認

if (Get-Command pwsh -ErrorAction SilentlyContinue) {
    Write-Host "pwsh.exe がインストールされています。"
    $shell = "pwsh.exe"
    $is_pwsh = $true
} else {
    Write-Host "pwsh.exe が見つかりません。powershell.exeを使用します。"
    $shell = "powershell.exe"
    $is_pwsh = $false
}



# サンドボックス起動

$wsbPath = Join-Path $PSScriptRoot "virtual-env.wsb"

if (-not (Test-Path $wsbPath)) {
    Write-Error "WSBファイルが見つかりません: $wsbPath"
    exit 1
}

Start-Process -FilePath $wsbPath
