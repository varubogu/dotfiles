# 管理者権限の確認
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "管理者権限が必要です。スクリプトを管理者として実行してください。"

    Write-Host "続行するには何かキーを押してください..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

    exit
}


# PowerShell環境変数設定関数
function Set-SafeEnv {
    param(
        [string]$VarName,
        [string]$VarValue,
        [bool]$MakeDir = $true
    )

    # 変数が存在するかチェック
    $currentValue = [System.Environment]::GetEnvironmentVariable($VarName, "User")
    if ($currentValue -eq $null) {
        Write-Host "$VarName set. --> $VarValue"

        # ユーザー環境変数を設定
        [System.Environment]::SetEnvironmentVariable($VarName, $VarValue, "User")
        # セッション環境変数を設定
        Set-Item "env:$VarName" $VarValue

        # パスを分割してディレクトリを作成
        if ($MakeDir) {  # MakeDirがtrueの場合のみディレクトリを作成
            $VarValue -split ';' | ForEach-Object {
                if (-not [string]::IsNullOrEmpty($_) -and -not (Test-Path $_)) {
                    New-Item -ItemType Directory -Path $_ -Force | Out-Null
                    Write-Host "  Created directory: $_"
                }
            }
        }
    } else {
        Write-Host "$VarName is exist. -->$currentValue"  # メッセージを修正
    }
}

Set-SafeEnv -VarName "HOME" -VarValue "$env:USERPROFILE" -MakeDir $false

# XDG Base Directory 仕様
Set-SafeEnv -VarName "XDG_RUNTIME_DIR" -VarValue "$env:TEMP" -MakeDir $false
Set-SafeEnv -VarName "XDG_CONFIG_DIRS" -VarValue "$env:ProgramData" -MakeDir $false
Set-SafeEnv -VarName "XDG_DATA_DIRS" -VarValue "$env:ProgramData;$env:ProgramFiles" -MakeDir $false
Set-SafeEnv -VarName "XDG_CONFIG_HOME" -VarValue "$env:USERPROFILE\.config"
Set-SafeEnv -VarName "XDG_CACHE_HOME" -VarValue "$env:USERPROFILE\.cache"
Set-SafeEnv -VarName "XDG_DATA_HOME" -VarValue "$env:USERPROFILE\.local\share"
Set-SafeEnv -VarName "XDG_STATE_HOME" -VarValue "$env:USERPROFILE\.local\state"
Set-SafeEnv -VarName "XDG_AUTOSTART_DIR" -VarValue "$env:XDG_CONFIG_HOME\autostart"

# XDGユーザーディレクトリ
# OneDriveの存在確認
$oneDrivePath = "$env:USERPROFILE\OneDrive"
if (Test-Path $oneDrivePath) {
    # OneDriveが存在する場合はOneDriveのパスを使用
    Set-SafeEnv -VarName "XDG_DOCUMENTS_BASE" -VarValue "$oneDrivePath"
    Set-SafeEnv -VarName "XDG_DESKTOP_DIR" -VarValue "$env:XDG_DOCUMENTS_BASE\デスクトップ"
    Set-SafeEnv -VarName "XDG_DOCUMENTS_DIR" -VarValue "$env:XDG_DOCUMENTS_BASE\ドキュメント"
    Set-SafeEnv -VarName "XDG_PICTURES_DIR" -VarValue "$env:XDG_DOCUMENTS_BASE\画像"
    Set-SafeEnv -VarName "XDG_MUSIC_DIR" -VarValue "$env:XDG_DOCUMENTS_BASE\ミュージック"
    Set-SafeEnv -VarName "XDG_VIDEOS_DIR" -VarValue "$env:XDG_DOCUMENTS_BASE\動画"
} else {
    # OneDriveが存在しない場合はUSERPROFILEを使用
    Set-SafeEnv -VarName "XDG_DOCUMENTS_BASE" -VarValue "$env:USERPROFILE"
    Set-SafeEnv -VarName "XDG_DESKTOP_DIR" -VarValue "$env:XDG_DOCUMENTS_BASE\Desktop"
    Set-SafeEnv -VarName "XDG_DOCUMENTS_DIR" -VarValue "$env:XDG_DOCUMENTS_BASE\Documents"
    Set-SafeEnv -VarName "XDG_PICTURES_DIR" -VarValue "$env:XDG_DOCUMENTS_BASE\Pictures"
    Set-SafeEnv -VarName "XDG_MUSIC_DIR" -VarValue "$env:XDG_DOCUMENTS_BASE\Music"
    Set-SafeEnv -VarName "XDG_VIDEOS_DIR" -VarValue "$env:XDG_DOCUMENTS_BASE\Videos"
}

Set-SafeEnv -VarName "XDG_DOWNLOAD_DIR" -VarValue "$env:USERPROFILE\Downloads"
Set-SafeEnv -VarName "XDG_PUBLICSHARE_DIR" -VarValue "$env:USERPROFILE\Public"
Set-SafeEnv -VarName "XDG_TEMPLATES_DIR" -VarValue "$env:USERPROFILE\Templates"

Write-Host "XDG Base Directory 環境変数の設定が完了しました。"
# 設定完了後に一時停止
Write-Host "続行するには何かキーを押してください..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
