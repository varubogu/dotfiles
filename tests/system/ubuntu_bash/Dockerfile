FROM ubuntu:24.04

VOLUME /workspace/result

# 作業ディレクトリの設定
WORKDIR /workspace

RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# 実行用スクリプトのコピー
COPY tests/system/ubuntu_bash/exec.bash /workspace/exec.bash

# dotfilesのコピー
COPY . /workspace/dotfiles

# コンテナ起動時のコマンド
CMD ["/workspace/exec.bash"]

