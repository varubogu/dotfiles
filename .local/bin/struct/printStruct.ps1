# 現在のディレクトリをスタックにプッシュし、新しいディレクトリに移動
Push-Location ~/dotfiles

$OUTDIR = "$env:XDG_STATE_HOME\struct"
New-Item -ItemType Directory -Path $OUTDIR -Force | Out-Null

# 全ファイルを~/dotfilesからの相対パスとして列挙
$OUTFILE = Join-Path $OUTDIR "find.txt"
Get-ChildItem -Path . -Recurse -Force |
    Where-Object { $_.FullName -notlike "*\.git\*" } |
    ForEach-Object { $_.FullName.Replace("$PWD\", "") } |
    Set-Content $OUTFILE

# 全ファイルをツリーとして列挙
$OUTFILE = Join-Path $OUTDIR "tree.txt"
Push-Location ~
tree.com /a /f dotfiles | Where-Object { $_ -notmatch "\.git" } | Set-Content $OUTFILE
Pop-Location

# 元のディレクトリに戻る
Pop-Location