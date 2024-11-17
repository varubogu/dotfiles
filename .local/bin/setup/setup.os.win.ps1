
# 1Password SSH Signer for WSL -> git config
wsl_gitconfig_path="$HOME/.config/git/win/local.gitconfig"
echo_log_info "Creating $wsl_gitconfig_path file..."
cat<< EOF > $wsl_gitconfig_path
[gpg "ssh"]
  program = "$WIN_HOME/AppData/Local/1Password/app/8/op-ssh-sign-wsl"
EOF
