# PowerShell スクリプト

# エラー発生時に実行を停止
$ErrorActionPreference = "Stop"

if (Get-Command pwsh -ErrorAction SilentlyContinue) {
    Write-Host "pwsh がインストールされています。"
    $EXECSHELL = "pwsh"
    $is_pwsh = $true
} else {
    Write-Host "pwsh.exe が見つかりません。powershell.exeを使用します。"
    $EXECSHELL = "powershell.exe"
    $is_pwsh = $false
}


$REPO_OWNER = "varubogu"
$REPO_NAME = "dotfiles"
$REPO_URL = "https://github.com/$REPO_OWNER/$REPO_NAME.git"
$REPO_RAW = "https://raw.github.com/$REPO_OWNER/$REPO_NAME"
$BRANCH = "main"

function Setup-Winget {
    # https://learn.microsoft.com/ja-jp/windows/package-manager/winget/
    $progressPreference = 'silentlyContinue'
    Write-Host "Installing WinGet PowerShell module from PSGallery..."
    Install-PackageProvider -Name NuGet -Force | Out-Null
    Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery | Out-Null
    Write-Host "Using Repair-WinGetPackageManager cmdlet to bootstrap WinGet..."
    Repair-WinGetPackageManager -AllUsers -ErrorAction SilentlyContinue
    Write-Host "Done."
    Write-Host "winget version is..."
    winget --version
}

function Setup-Git {
    Write-Host "Checking git..."
    if (Get-Command -name git -ErrorAction SilentlyContinue) {
        Write-Host "git already installed"
    } else {
        Write-Host "git is not installed."
        Write-Host "Installing git from winget..."
        winget install git.git --source winget --accept-source-agreements

        # インストール直後のシェルセッションではパスがまだ通っていないため一時的に登録（シェルセッション後に消える）
        $GIT_COMMAND = "C:\Program Files\Git\cmd"
        $env:PATH = "$env:PATH;$GIT_COMMAND"
    }
}

function Setup-Yadm {
    Write-Host "Checking yadm..."
    $yadmScript = Get-installedScript -Name yadm -ErrorAction SilentlyContinue
    if ($yadmScript) {
        Write-Host "yadm already installed"
    } else {
        Write-Host "yadm is not installed."

        Write-Host "Search for yadm in PSGallery"
        Find-Script -Name yadm

        Write-Host "Installing yadm..."
        Install-Script -Name yadm -Scope CurrentUser -Force
        $yadmScript = Get-installedScript -Name yadm -ErrorAction SilentlyContinue
    }

    $yadmDir = $yadmScript.installedLocation
    $yadmPath = Join-Path -Path $yadmDir -ChildPath "yadm.ps1"

    Write-Host "Cloning dotfiles.to yadm..."
    if (Test-Path "$env:USERPROFILE/.local/share/yadm/repo.git") {
        Write-Host "yadm is already initialized"
        & "$yadmPath" pull origin $BRANCH
    }
    else {
        Write-Host "yadm is none repository. Cloning dotfiles..."
        & "$yadmPath" clone $REPO_URL

        # 不要なファイルを除外して再読み込みする
        & "$yadmPath" config core.sparseCheckout true

        Copy-Item -Path "$env:USERPROFILE\.config\yadm\sparse-checkout" -Destination "$env:USERPROFILE\.local\share\yadm\repo.git\info\sparse-checkout"
        & "$yadmPath" checkout main
    }
}

function Main {
    # ホームディレクトリに移動
    Set-Location "$env:USERPROFILE"

    # 実行ポリシーを変更（yadmコマンド実行に必要）
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

    # wingetインストール
    Setup-Winget

    # wingetでGitインストール
    Setup-Git

    # yadmをインストール & dotfilesをclone
    Setup-Yadm

    # 3秒待つ
    Start-Sleep -s 3

    $BIN_DIR = "$env:USERPROFILE\.local\bin"

    # XDG Base Directory Specificationを設定
    Start-Process $EXECSHELL -ArgumentList '-File `$BIN_DIR\xdg_base_dir\setEnv.ps1`' -Verb RunAs

    # アプリを一括インストール
    Write-Host "install apps"
    . "$BIN_DIR\install\install_windows.ps1"

    # シンボリックリンクを貼る
    Write-Host "symlink execution"
    . "$BIN_DIR\symlink\symlink.ps1"

    # 追加設定
    if (Test-Path "$env:USERPROFILE/.local/bin/setup/setup.os.win.ps1") {
        Write-Host "os specific setup"
        . "$env:USERPROFILE/.local/bin/setup/setup.os.win.ps1"
        Create-Local-Windows-Config
        Write-Host "os specific setup done"
    } else {
        Write-Host "No os specific setup found"
    }

    Write-Host "Installed dotfiles successfully!"
}

Main
