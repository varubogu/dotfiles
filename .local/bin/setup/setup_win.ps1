# PowerShell スクリプト

# エラー発生時に実行を停止
$ErrorActionPreference = "Stop"

$REPO_OWNER = "varubogu"
$REPO_NAME = "dotfiles"
$REPO_URL = "https://github.com/$REPO_OWNER/$REPO_NAME.git"
$REPO_RAW = "https://raw.github.com/$REPO_OWNER/$REPO_NAME"
$BRANCH = "main"
$BIN_DIR = "~\.local\bin"

function Setup-Yadm {
    Write-Host "Checking yadm..."
    if (Get-installedScript -name yadm) {
        Write-Host "yadm already installed"
    }
    else {
        Write-Host "yadm is not installed. Installing yadm..."
        Install-Script -Name yadm -Scope CurrentUser
    }

    Write-Host "Cloning dotfiles.to yadm..."
    if (Test-Path "~/.local/share/yadm/repo.git") {
        Write-Host "yadm is already initialized"
        yadm pull origin $BRANCH
    }
    else {
        Write-Host "yadm is none repository. Cloning dotfiles..."
        yadm clone $REPO_URL
    }
}

function Main {
    # ホームディレクトリに移動
    Set-Location ~

    # yadmをインストール & dotfilesをclone
    Setup-Yadm

    # XDG Base Directory Specificationを設定
    Start-Process pwsh.exe -ArgumentList "-File `"$BIN_DIR\xdg_base_dir\setEnv.ps1`"" -Verb RunAs

    # アプリを一括インストール
    Write-Host "install apps"
    . "$BIN_DIR\install\install_windows.ps1"

    # シンボリックリンクを貼る
    Write-Host "symlink execution"
    . "$BIN_DIR/symlink/symlink.ps1"

    Write-Host "Installed dotfiles successfully!"
}

Main
