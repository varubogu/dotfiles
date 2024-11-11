# PowerShell スクリプト

# エラー発生時に実行を停止
$ErrorActionPreference = "Stop"

$REPO_OWNER = "varubogu"
$REPO_NAME = "dotfiles"
$REPO_URL = "https://github.com/$REPO_OWNER/$REPO_NAME.git"
$REPO_RAW = "https://raw.github.com/$REPO_OWNER/$REPO_NAME"
$BRANCH = "main"
$DOT_BIN_DIR = ".local/bin"
$BIN_DIR = "$HOME/$REPO_NAME/$DOT_BIN_DIR"
$INIT_DIR = "$BIN_DIR/init"

function Test-CommandExists {
    param($Command)
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    try { if (Get-Command $Command) { return $true } }
    catch { return $false }
    finally { $ErrorActionPreference = $oldPreference }
}

function Test-IsMac {
    return ($PSVersionTable.Platform -eq "Unix" -and (uname) -eq "Darwin")
}

function Test-IsLinux {
    return ($PSVersionTable.Platform -eq "Unix" -and (uname) -eq "Linux")
}


function Setup-Git {
    Write-Host "Checking git..."
    if (Test-CommandExists "git") {
        Write-Host "git already installed"
    }
    else {
        Write-Host "git is not installed. Installing git..."
        if (Test-CommandExists "brew") {
            brew install git
        }
        elseif (Test-CommandExists "apt-get") {
            sudo apt-get update; sudo apt-get install -y git
        }
        else {
            Write-Host "Unable to install git. Please install it manually."
            exit 1
        }
    }
}

function Setup-Yadm {
    Write-Host "Checking yadm..."
    if (Test-CommandExists "yadm") {
        Write-Host "yadm already installed"
    }
    else {
        Write-Host "yadm is not installed. Installing yadm..."
        if (Test-CommandExists "brew") {
            brew install yadm
        }
        elseif (Test-CommandExists "apt-get") {
            sudo apt-get update; sudo apt-get install -y yadm
        }
        else {
            Write-Host "Unable to install yadm. Please install it manually."
            exit 1
        }
    }

    Write-Host "Cloning dotfiles..."
    if (Test-Path "$HOME/.local/share/yadm/repo.git") {
        Write-Host "yadm is already initialized"
        yadm pull origin $BRANCH
    }
    else {
        Write-Host "yadm is none repository. Cloning dotfiles..."
        yadm clone $REPO_URL
    }
}

function Clone-Dotfiles {
    if (Test-Path $REPO_NAME) {
        Write-Host "dotfiles already cloned"
        Push-Location $REPO_NAME
        git pull origin $BRANCH
        Pop-Location
    }
    else {
        Write-Host "Cloning dotfiles..."
        git clone $REPO_URL $REPO_NAME
    }
}

function Main {
    # ホームディレクトリに移動
    Set-Location ~

    # XDG Base Directory Specificationを設定
    Start-Process pwsh.exe -ArgumentList "-File `"~\dotfiles\.local\bin\xdg_base_dir\setEnv.ps1`"" -Verb RunAs

    # wingetでアプリを一括インストール
    winget import -i .\.config\winget\20241110_w2022.json

    Setup-Git
    Setup-Yadm
    Clone-Dotfiles

    # 各シェルに実行権限付与
    Write-Host "chmod +x"
    Get-ChildItem -Path "$HOME/dotfiles" -Recurse -Filter "*.sh" | ForEach-Object {
        if ($PSVersionTable.Platform -eq "Unix") {
            chmod +x $_.FullName
        }
    }

    # XDG Base Directory Specification
    Write-Host "XDG Base Directory Specification"
    . "$BIN_DIR/xdg_base_dir/xdg_base_dir.ps1"
    . "$BIN_DIR/xdg_base_dir/xdg_base_app.ps1"

    if (Test-IsMac) {
        Write-Host "mac install"
        . "$INIT_DIR/install_mac.ps1"
        Write-Host "Installed mac dotfiles successfully!"
    }

    if (Test-CommandExists "apt-get") {
        Write-Host "apt-get install"
        . "$INIT_DIR/install_apt-get.ps1"
        Write-Host "Installed apt dotfiles successfully!"
    }

    # シンボリックリンクを貼る
    Write-Host "symlink execution"
    . "$INIT_DIR/symlink.ps1"

    if (Test-CommandExists "zsh") {
        Write-Host "zshrc execution"
        . "$HOME/dotfiles/.config/zsh/.zshrc"
    }
    else {
        Write-Host "bashrc execution"
        . "$HOME/dotfiles/.config/bash/.bashrc"
    }

    Write-Host "Installed dotfiles successfully!"
}

Main
