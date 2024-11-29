
# 1Password SSH Signer for WSL -> git config
$wsl_gitconfig_path = "$HOME/.config/git/windows/local.gitconfig"
Write-Output "Creating $wsl_gitconfig_path file..."
# Start of Selection
$appdata = $env:APPDATA -replace '\\', '/'
# End of Selection
@"
[gpg "ssh"]
  program = "$appdata/Local/1Password/app/8/op-ssh-sign.exe"
"@ | Out-File -FilePath $wsl_gitconfig_path -Encoding utf8
