resource "aws_key_pair" "wordpress" {
  key_name = "wordpress"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
  lifecycle {
    ignore_changes = ["public_key"]
  }
}
