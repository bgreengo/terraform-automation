resource "aws_efs_file_system" "wordpress-efs" {
  creation_token = "wordpress-efs"

  tags {
    Name = "wordpress-efs"
  }
}