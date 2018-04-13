resource "aws_s3_bucket" "wordpress" {
  bucket = "terraform-automation-wordpress-bucket"
  acl    = "private"
}

resource "aws_iam_role" "wordpress-pipeline" {
  name = "wordpress-pipeline"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = "${aws_iam_role.wordpress-pipeline.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning"
      ],
      "Resource": [
        "${aws_s3_bucket.wordpress.arn}",
        "${aws_s3_bucket.wordpress.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_codepipeline" "wordpress-pipeline" {
  name     = "wordpress-pipeline"
  role_arn = "${aws_iam_role.wordpress-pipeline.arn}"

  artifact_store {
    location = "${aws_s3_bucket.wordpress.bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["test"]

      configuration {
        RepositoryName      = "wordpress"
        BranchName     = "master"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ElasticBeanstalk"
      version         = "1"

      configuration {
        ApplicationName = "wordpress"
        EnvironmentName = "wordpress-prod"
      }
    }
  }
}