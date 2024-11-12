# 出力ディレクトリを作成
$OUTDIR = "$env:XDG_STATE_HOME\struct"
New-Item -ItemType Directory -Path $OUTDIR -Force | Out-Null

# excludeファイルを読み込む
if ($IsWindows) {
    $excludeFileName = "exclude##os.Windows"
} else {
    $excludeFileName = "exclude"
}
$exclude = Get-Content "$env:XDG_CONFIG_HOME\dotfiles\struct\$excludeFileName"

# excludeファイルからコメントと空行を除外
$excludePatterns = $exclude | Where-Object {
    $line = $_
    $isNotEmpty = -not [string]::IsNullOrWhiteSpace($line)
    $isNotComment = -not $line.StartsWith("#")
    return $isNotEmpty -and $isNotComment
}

# 全ファイルをホームからの相対パスとして列挙
$OUTFILE = Join-Path $OUTDIR "find.txt"
$result = Get-ChildItem -Path $HOME -Recurse -Force |
    Where-Object {
        # 相対パスを取得
        $pathSeparator = [IO.Path]::DirectorySeparatorChar
        $relativePath = $_.FullName.Replace("$HOME$pathSeparator", "")

        # 各パターンをチェック
        foreach ($pattern in $excludePatterns) {

            # パターンをワイルドカードに変換
            $wildcardPattern = $pattern.Replace("/", $pathSeparator)
            if ($relativePath -like "*\$wildcardPattern*") {
                return $false
            }
        }
        return $true
    } |
    ForEach-Object {
        $_.FullName.Replace("$HOME\", "")
    } |
    Sort-Object -Property FullName -Ascending

Set-Content $result $OUTFILE -Encoding UTF8

# 全ファイルをツリーとして列挙
$OUTFILE = Join-Path $OUTDIR "tree.txt"

if ($IsWindows) {
    $result | tree.com /a /f | Set-Content $OUTFILE -Encoding UTF8
} elseif (Get-Command "tree" -ErrorAction SilentlyContinue) {
    $result | tree --noreport -a | Set-Content $OUTFILE -Encoding UTF8
} else {
    Write-Warning "tree command not found. Skipping tree output."
    $result | Set-Content $OUTFILE -Encoding UTF8
}
