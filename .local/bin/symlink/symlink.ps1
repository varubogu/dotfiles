# シンボリックリンクを作成する関数
#
# パラメータ:
#   $From - シンボリックリンクを貼る元のファイル・ディレクトリパス（リンク元）
#   $To - シンボリックリンクを貼る先のファイル・ディレクトリパス（リンク先）
#
# 動作:
# 1. リンク先に何も存在しない場合は、直接リンクを作成
# 2. リンク先が既にシンボリックリンクの場合は何もしない
# 3. リンク先にファイルが存在する場合は、バックアップを作成してからリンクを作成
# 4. リンク先が存在し、ファイル以外の場合はエラー
#
# 注意:
# - 既存のファイルはバックアップされます（ファイル名.bk.年月日時分秒の形式）
function New-Symlink-Safety {
    param(
        [Parameter(Mandatory=$true)]
        [string]$From,
        [Parameter(Mandatory=$true)]
        [string]$To
    )

    # リンク元ファイルの存在チェック
    if (-not (Test-Path $From)) {
        Throw "Error: From file '$From' does not exist."
    }

    # リンク先ファイルの存在チェック（なければそのまま続行）
    if (Test-Path $To) {

        $ToItem = Get-Item $To
        $symlinkType = $ToItem.LinkType

        if ($symlinkType -eq "SymbolicLink") {
            # シンボリックリンク作成済み
            Write-Host "$From is already a symbolic link."
            return

        } elseif (Test-Path $To -PathType Leaf) {
            # ファイルが存在する場合は日時付きバックアップを取ってからシンボリックリンクを作成
            $backupDate = Get-Date -Format "yyyyMMddHHmmss"
            $backupFile = "${From}.bk.${backupDate}"
            Write-Host "backup ${From} to ${backupFile}"

            # バックアップ先が存在する場合はエラー
            if (Test-Path $backupFile) {
                Throw "Error: already exists '${backupFile}' To be safe, the function is terminated."
            }
            Move-Item -Path $To -Destination $backupFile
        } else {
            # ファイルでもシンボリックリンクでもない場合は作れないとしてエラー
            # コピー先がディレクトリの場合は想定外の挙動になる恐れがある
            Throw "Error: $To is not a file or directory or symbolic link."
        }
    }

    # シンボリックリンクを作成
    Write-Host "Created symbolic link $From ---> $To"
    New-Item -ItemType SymbolicLink -Path $To -Target $From
}

# ファイル・ディレクトリをコピーする関数
#
# パラメータ:
#   $From - コピーする元のファイル・ディレクトリパス
#   $To - コピーする先のファイル・ディレクトリパス
#
# 動作:
# 1. コピー先に何も存在しない場合は、直接コピーを作成
# 2. コピー先が存在する場合は何もしない
#
function Copy-Item-Safety {
    param(
        [Parameter(Mandatory=$true)]
        [string]$From,
        [Parameter(Mandatory=$true)]
        [string]$To
    )

    # リンク元ファイルの存在チェック
    if (-not (Test-Path $From)) {
        Write-Error "Error: From file '$From' does not exist."
        return
    }

    if (Test-Path $To) {
        # ファイルが存在する場合はコピーしない
        Write-Host "$To is already exist."
    }
    else {
        # コピーを作成
        Write-Host "Created copy $From ---> $To"
        Copy-Item -Path $From -Destination $To -Recurse
    }
}


# 設定ファイルのシンボリックリンクを作成
New-Symlink-Safety -From "$HOME\.config\git\win.config" -To "$HOME\.config\git\local.config"
New-Symlink-Safety -From "$HOME\.config\editorconfig\config" -To "$HOME\.editorconfig"
New-Symlink-Safety -From "$HOME\.config\git\config" -To "$HOME\.gitconfig"
