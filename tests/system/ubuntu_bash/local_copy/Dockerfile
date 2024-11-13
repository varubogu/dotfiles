FROM ubuntu:latest

# タイムゾーンの設定と日本語環境のサポート
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apt-get update && apt-get install -y \
    curl \
    git \
    vim \
    wget \
    sudo \
    language-pack-ja-base \
    language-pack-ja \
    && locale-gen ja_JP.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリの設定
WORKDIR /workspace

# デフォルトのシェルをbashに設定
SHELL ["/bin/bash", "-c"]

ENV LANG=ja_JP.UTF-8
ENV LANGUAGE=ja_JP:ja
ENV LC_ALL=ja_JP.UTF-8

# 実行用スクリプトのコピー
COPY tests/system/ubuntu_bash/cloudsetup/exec.bash /workspace/exec.bash

# dotfilesのコピー
COPY . /workspace/dotfiles

# コンテナ起動時のコマンド
CMD ["/workspace/exec.bash"]

VOLUME /workspace/result
