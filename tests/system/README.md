# システムテスト方針

## テスト環境

### ホストOS

- Windows 11
- WSL2
- Ubuntu 24.04
- macOS

上記の環境で構築し、テストを行う。

### テスト対象OS

- Windows 11（ホストはWindowsのみ）
  - Windowsの場合、Windowsサンドボックス（Windows Pro版のみ使用可能）にてテストする
- macOS（ホストはmacOSのみ）
- Ubuntu 24.04
- AlmaLinux 9
- Arch Linux

## 初期インストール

初回のインストールを行う。
対象パス

- Windowsの場合：`/.local/bin/setup/setup_windows.ps1`
- 上記以外の場合：`/.local/bin/setup/setup.sh`

## 2回目のインストール

2回目以降のインストールを行う。
対象パスは1回目と同じ。

## 変更テスト

構成に変更を加えた場合に、変更内容が反映され、yadmで管理できることを確認する。

### 変更内容

- ファイルの追加
- ファイルの削除
- ファイルの変更
- ディレクトリの追加
- ディレクトリの削除
- ディレクトリの変更
- シンボリックリンクの変更
- シンボリックリンクの削除
