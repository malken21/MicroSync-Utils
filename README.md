# MicroSync-Utils

## 主要機能

- **GitHub Release 自動更新**: 起動時に GitHub から最新のリリースを自動的にチェックし、必要に応じてダウンロード・展開を行います。
- **ランチャー機能**:
    - **MicroBridge**: micro:bit と通信するためのブリッジアプリケーションの起動。
    - **MicroSync Client/Server**: 同期システムのクライアントおよびサーバーの起動。
- **アーキテクチャ対応**: 実行環境（x64 / ARM64）を自動判別し、適切なバイナリを取得します。

## スクリプト一覧

| ファイル名 | 説明 |
| :--- | :--- |
| `microbit.ps1` | MicroBridge の自動更新および起動を行います。起動時に micro:bit の 5 桁 ID 入力が求められます。 |
| `start_client.ps1` | 同期システムのクライアントアプリを最新版に更新し、起動します。 |
| `start_server.ps1` | 同期システムのサーバーアプリおよび Rust 製アセットサーバーを最新版に更新し、両方を起動します。 |
| `utils.ps1` | 各スクリプトで共通して使用される、更新・起動・初期化等の関数群を定義しています。 |

## 使用方法

### 準備
- PowerShell が実行可能な Windows 環境。
- インターネット接続（バイナリの自動更新に必要）。

### 起動手順
1. 使用目的に応じた `.bat` ファイル（`microbit.bat` 等）をダブルクリックします。
2. 初回起動時や更新がある場合は、自動的に関連ファイルがダウンロードされます。
3. 画面の指示に従い、情報の入力（microbit ID 等）を行ってください。

## 依存関係
- [MicroBridge](https://github.com/malken21/MicroBridge)
- [Unity-GLB-Vehicle-Sync](https://github.com/malken21/Unity-GLB-Vehicle-Sync)
- [Simple-Rust-Asset-Server](https://github.com/malken21/Simple-Rust-Asset-Server)
