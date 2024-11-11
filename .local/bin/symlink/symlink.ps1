# シンボリックリンクを作成する関数
#
# パラメータ:
#   $Destination - シンボリックリンクを貼る元のファイルパス（リンク元）
#   $Source - シンボリックリンクを貼る先のファイルパス（リンク先）
#
# 動作:
# 1. リンク先が既にシンボリックリンクの場合は何もしない
# 2. リンク先にファイルが存在する場合は、バックアップを作成してからリンクを作成
# 3. リンク先にファイルが存在しない場合は、直接リンクを作成
#
# 注意:
# - 既存のファイルはバックアップされます（ファイル名.bk.年月日時分秒の形式）
function Safe-Symlink {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Destination,
        [Parameter(Mandatory=$true)]
        [string]$Source
    )

    # リンク元ファイルの存在チェック
    if (-not (Test-Path $Destination)) {
        Write-Error "Error: Source file '$Destination' does not exist."
        return
    }

    $canSymlink = $false

    if (Test-Path -PathType SymbolicLink $Source) {
        # シンボリックリンク作成済み
        Write-Host "$Source is already a symbolic link."
        return
    }
    elseif (Test-Path $Source) {
        # ファイルが存在する場合は日時付きバックアップを取ってからシンボリックリンクを作成
        $backupDate = Get-Date -Format "yyyyMMddHHmmss"
        $backupFile = "${Source}.bk.${backupDate}"
        Write-Host "backup ${Source} to ${backupFile}"

        # 移動先ファイルの存在チェック
        if (Test-Path $backupFile) {
            Write-Error "Error: already exists '${backupFile}'"
            Write-Error "To be safe, the function is terminated."
            return
        }
        Move-Item -Path $Source -Destination $backupFile
        $canSymlink = $true
    }
    else {
        # ファイルが存在しない場合はそのままシンボリックリンクを作成
        $canSymlink = $true
    }

    if ($canSymlink) {
        # シンボリックリンクを作成
        Write-Host "Created symbolic link $Destination ---> $Source"
        New-Item -ItemType SymbolicLink -Path $Source -Target $Destination
    }
}

# ファイルをコピーする関数
function Safe-Copy {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Destination,
        [Parameter(Mandatory=$true)]
        [string]$Source
    )

    # リンク元ファイルの存在チェック
    if (-not (Test-Path $Destination)) {
        Write-Error "Error: Source file '$Destination' does not exist."
        return
    }

    if (Test-Path $Source) {
        # ファイルが存在する場合はコピーしない
        Write-Host "$Source is already exist."
    }
    else {
        # コピーを作成
        Write-Host "Created copy $Destination ---> $Source"
        Copy-Item -Path $Destination -Destination $Source -Recurse
    }
}

$DOTCONFIG = "~\.config"


# 設定ファイルのシンボリックリンクを作成
Safe-Symlink -Destination "$DOTCONFIG\editorconfig\.editorconfig" -Source "~/.editorconfig"
Safe-Copy -Destination "$DOTCONFIG\git\config" -Source "~/.gitconfig"
