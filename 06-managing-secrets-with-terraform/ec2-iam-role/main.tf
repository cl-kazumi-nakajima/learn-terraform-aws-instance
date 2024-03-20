terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"

  # EC2インスタンスがそのインスタンスプロファイルを使うようにする
  iam_instance_profile = aws_iam_instance_profile.instance.name
}

# IAMロールを作るときに、ロールを引き受けるポリシーにJSONを渡せる
# デフォルトでは何の権限も持っていない
resource "aws_iam_role" "instance" {
  name_prefix        = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# IAMロールの引き受けを、EC2インスタンスに許可するためのポリシーを定義
# Allow the IAM role to be assumed by EC2 instances
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Create an IAM policy that grants EC2 admin permissions
data "aws_iam_policy_document" "ec2_admin_permissions" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:*"]
    resources = ["*"]
  }
}

# ポリシーをIAMロールにアタッチ
# Attach the EC2 admin permissions to the IAM role
resource "aws_iam_role_policy" "example" {
  role   = aws_iam_role.instance.id
  policy = data.aws_iam_policy_document.ec2_admin_permissions.json
}

# EC2インスタンスが自動的にIAMロールを引き受けられるようにする
# Create an instance profile with the IAM role attached
resource "aws_iam_instance_profile" "instance" {
  role = aws_iam_role.instance.name
}
