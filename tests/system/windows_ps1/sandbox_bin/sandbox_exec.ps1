# dotfilesスクリプトをダウンロード
$scriptUrl = 'https://raw.github.com/varubogu/dotfiles/master/.local/bin/setup/setup_win.ps1'
$scriptContent = Invoke-RestMethod -Uri $scriptUrl

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# dotfilesセットアップをスクリプト実行
if (Get-Command pwsh.exe -ErrorAction SilentlyContinue) {
    pwsh.exe  -Command $scriptContent -ExecutionPolicy RemoteSigned
} else {
    powershell.exe -Command $scriptContent -ExecutionPolicy RemoteSigned
}
