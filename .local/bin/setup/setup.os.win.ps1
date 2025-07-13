
# 1Password SSH Signer for WSL -> git config
function Create-Local-Windows-Config {
    $gitconfig_dir = "$HOME/.config/git"
    $destination_file = "$gitconfig_dir/local.windows.config"
    $source_file = "$destination_file.example"

    if (-Not (Test-Path -Path $gitconfig_dir)) {
        Write-Error "The directory $gitconfig_dir does not exist."
        exit 1
    }

    if (-Not (Test-Path -Path $source_file)) {
        Write-Error "The file $source_file does not exist."
        exit 1
    }

    $contents = Get-Content -Path $source_file -Raw

    $updated_content = $contents -replace 'XXXXXX', "$env:localappdata/1Password/app/8/op-ssh-sign.exe"

    $updated_content | Out-File -FilePath $destination_file -Encoding utf8
}
