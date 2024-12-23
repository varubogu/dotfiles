# PowerShell スクリプト

# エラー発生時に実行を停止
$ErrorActionPreference = "Stop"

$EXECSHELL = "pwsh.exe"

$REPO_OWNER = "varubogu"
$REPO_NAME = "dotfiles"
$REPO_URL = "https://github.com/$REPO_OWNER/$REPO_NAME.git"
$REPO_RAW = "https://raw.github.com/$REPO_OWNER/$REPO_NAME"
$BRANCH = "main"
$BIN_DIR = "$HOME\.local\bin"

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
    if (Test-Path "$HOME/.local/share/yadm/repo.git") {
        Write-Host "yadm is already initialized"
        yadm pull origin $BRANCH
    }
    else {
        Write-Host "yadm is none repository. Cloning dotfiles..."
        yadm clone $REPO_URL

        # 不要なファイルを除外して再読み込みする
        yadm config core.sparseCheckout true
        Copy-Item -Path "$HOME\.config\yadm\sparse-checkout" -Destination "$HOME\.local\share\yadm\repo.git\info\sparse-checkout"
        yadm checkout main
    }
}

function Main {
    # ホームディレクトリに移動
    Set-Location $HOME

    # yadmをインストール & dotfilesをclone
    Setup-Yadm

    # 3秒待つ
    Start-Sleep -s 3

    # XDG Base Directory Specificationを設定
    Start-Process $EXECSHELL -ArgumentList "-File `"$BIN_DIR\xdg_base_dir\setEnv.ps1`"" -Verb RunAs

    # アプリを一括インストール
    Write-Host "install apps"
    . "$BIN_DIR\install\install_windows.ps1"

    # シンボリックリンクを貼る
    Write-Host "symlink execution"
    . "$BIN_DIR\symlink\symlink.ps1"

    # 追加設定
    . "./setup_win.ps1"
    Create-Local-Windows-Config

    Write-Host "Installed dotfiles successfully!"
}

Main
