FROM ubuntu:24.04

# 結果を保存するディレクトリ
VOLUME /workspace/result

# 作業ディレクトリの設定
WORKDIR /workspace

# tzdataでdebconfのエラーが出るので非対話モードにする
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo

RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && apt-get update && apt-get install -y \
    curl \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# 実行用スクリプトのコピー
COPY tests/system/ubuntu_bash/exec.bash /workspace/exec.bash

# dotfilesのコピー
COPY . /workspace/dotfiles

# コンテナ起動時のコマンド
CMD ["/workspace/exec.bash"]

