## インストール済みのパッケージを書き出す

### 全パッケージ

```bash
dpkg --get-selections > ~/.config/apt/packages.list
```

### ユーザーが手動インストールしたパッケージのみ（依存関係によるインストールが除かれたもの）

```bash
apt-mark showmanual | echo > ~/.config/apt/manual-packages.txt
```

## パッケージをインストール

手動インストールのもののみ記載

```bash
sudo apt update
xargs sudo apt install -y < ~/.config/apt/manual-packages.txt
```


## 運用は`aptfile`で行う

### ファイル化

```bash
apt-mark showmanual > ~/.config/apt/aptfile
```


### インストール

```bash
sudo apt update
xargs sudo apt install -y < ~/.config/apt/aptfile
```