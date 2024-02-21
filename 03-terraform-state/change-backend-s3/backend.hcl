# このファイルは、あらゆるモジュールで使える

bucket = "terraform-up-and-runnning-state"
region = "us-east-2"
encrypt = true  # S3バケット自体暗号化されてるので、これで二重に暗号化設定してることになる
dynamodb_table = "terraform-up-and-running-locks"
