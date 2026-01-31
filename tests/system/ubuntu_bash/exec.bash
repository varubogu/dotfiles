#!/bin/bash


# 結果を保存するディレクトリの作成
mkdir -p /workspace/result

# dotfilesのインストール
echo "LOCAL_COPY: $LOCAL_COPY" | tee -a "$LOG_FILE"
echo "=== dotfilesのインストールを開始 ===" | tee -a "$LOG_FILE"
if [ $LOCAL_COPY ]; then
    bash /workspace/dotfiles/.local/bin/dotfiles/setup/setup.bash 2>&1 | tee -a "$LOG_FILE"
else
    bash -c "$(curl -fsSL https://raw.github.com/varubogu/dotfiles/master/.local/bin/dotfiles/setup/setup.bash)" 2>&1 | tee -a "$LOG_FILE"
fi

# environment structure test
~/.local/bin/dotfiles/doctor

# install result test
