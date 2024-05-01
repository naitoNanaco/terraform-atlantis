# terraform atlantis

AWS上にGithubと連携するAtlantisをデプロイします。

## 作るもの

- @ AtlantisをデプロイするAWSアカウント (このコードではアカウントID`123456789012`)
  - `./atlantis`内のリソース
  - Atlantisが動くECSなど
- @ Terraformでインフラ管理するAWSアカウント (このコードではアカウントID`234567890123`)
  - `./terraform_backend`内のリソース
  - Terraform用のIAMロール

Terraform管理する各プロジェクトではデプロイするAWSアカウントのTerraform用IAMロールで`terraform`コマンドが実行されるように`assume_role`を設定しておく。

## 実行の流れ

Atlantisは各プロジェクト (`./service_example`) の`aws` provider内`assume_role`の記述に従いTerraform用IAMロールにスイッチしてapplyを実行する。

![flow](https://github.com/naitoNanaco/terraform-atlantis/assets/6639060/8c6ac4c5-761f-4f39-a3dc-d26e243a2215)
