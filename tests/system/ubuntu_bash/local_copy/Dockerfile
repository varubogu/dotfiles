FROM ubuntu:latest

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
