terraform {
  backend "s3" {
    bucket = "terraform-up-and-runnning-state"
    key = "workspace-example/terraform.tfstate" # default のワークスペースは、ここで指定した場所を使う
    region = "us-east-2"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true  # S3バケット自体暗号化されてるので、これで二重に暗号化設定してることになる
  }
}

# 書籍に記述なかった
provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "example" {
  ami = "ami-0fb653ca2d3203ac1"
  instance_type = terraform.workspace == "default" ? "t2.mediim" : "t2.micro"
}
