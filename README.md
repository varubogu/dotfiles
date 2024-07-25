# dotfiles


## Setup

```bash
bash -c "$( curl -fsSL https://raw.github.com/varubogu/dotfiles/master/setup.sh )"
```




dotfiles リポジトリルート
|-- .bashrc    .bashrcの実体（~/.bashrcはシンボリックリンク）
|-- .config    設定ファイルまとめ
|-- .github
|   `-- workflows
|       `-- test.yml    GitHubActionsを使ったCIワークフロー
|-- .gitignore          このリポジトリの.gitignore
|-- .gitignore_global   ユーザー全体に適用する.gitignore
|-- .gitignore_shared   他ユーザーと共有する場合の.gitignore
|-- .zshenv             zshの環境定義
|-- .zshrc              zshの初期化シェル
|-- .zshrc.lazy         zshの初期化シェル（遅延実行）
|-- LICENSE
|-- README.md
|-- bin
|   |-- init
|   |   |-- init_ubuntu_after.sh
|   |   |-- install.sh
|   |   |-- install_apt.sh
|   |   |-- install_mac.sh
|   |   `-- symlink.sh
|   `-- struct
|       `-- dout
|-- bin.local
`-- var
    |-- find.txt
    `-- tree.txt

9 directories, 19 files
