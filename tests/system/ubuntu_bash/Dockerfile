FROM ubuntu:latest

VOLUME /workspace/result

# 作業ディレクトリの設定
WORKDIR /workspace

RUN apt-get update && apt-get install -y \
    curl

# 実行用スクリプトのコピー
COPY tests/system/ubuntu_bash/exec.bash /workspace/exec.bash

# コンテナ起動時のコマンド
CMD ["/workspace/exec.bash"]

