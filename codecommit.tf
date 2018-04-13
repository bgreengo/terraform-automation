resource "aws_codecommit_repository" "wordpress" {
  repository_name = "wordpress"
  description     = "This is the Wordpress repo"
}