#!/bin/zsh

# 現在のディレクトリをスタックにプッシュし、新しいディレクトリに移動
pushd $HOME > /dev/null

OUTDIR=$XDG_STATE_HOME/struct
mkdir -p $OUTDIR

# 全ファイルを~/dotfilesからの相対パスとして列挙
OUTFILE=$OUTDIR/find.txt
echo "find > $OUTFILE"
find . -path './.git' -prune -o -print | sed 's|^\./||' > $OUTFILE

# 全ファイルをツリーとして列挙
OUTFILE=$OUTDIR/tree.txt
tree -a -I ".git" dotfiles > $OUTFILE
echo "tree > $OUTFILE"

# 元のディレクトリに戻る
popd > /dev/null
