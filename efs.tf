resource "aws_efs_file_system" "wordpress-efs" {
  creation_token = "wordpress-efs"

  tags {
    Name = "wordpress-efs"
  }
}

resource "aws_efs_mount_target" "wordpress-efs-target" {
  file_system_id = "${aws_efs_file_system.wordpress-efs.id}"
  subnet_id      = "${aws_subnet.wp-public-1.id}"
  security_groups = ["${aws_security_group.wordpress-prod.id}"]
}