#!/bin/bash

# ログファイルのパスを変数に設定
LOG_FILE="/workspace/result/test_result.log"

# 結果を保存するディレクトリの作成
mkdir -p /workspace/result

# dotfilesのインストール
echo "LOCAL_COPY: $LOCAL_COPY"
echo "=== dotfilesのインストールを開始 ===" | tee -a "$LOG_FILE"
if [ $LOCAL_COPY ]; then
    bash /workspace/dotfiles/.local/bin/setup/setup.bash 2>&1 | tee -a "$LOG_FILE"
else
    bash -c "$(curl -fsSL https://raw.github.com/varubogu/dotfiles/master/.local/bin/setup/setup.bash)" 2>&1 | tee -a "$LOG_FILE"
fi

# インストール結果のテスト
echo -e "\n=== インストール結果のテスト開始 ===" | tee -a "$LOG_FILE"

# テスト項目の実行
test_dotfiles() {
    # .vimrcの存在確認
    if [ -f ~/.vimrc ]; then
        echo "✓ .vimrcが正常にインストールされています" | tee -a "$LOG_FILE"
    else
        echo "✗ .vimrcが見つかりません" | tee -a "$LOG_FILE"
    fi

    # その他の設定ファイルの確認
    # 必要に応じてテスト項目を追加
}

test_dotfiles

echo -e "\n=== テスト完了 ===" | tee -a "$LOG_FILE"
