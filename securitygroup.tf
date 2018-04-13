resource "aws_security_group" "wordpress-prod" {
  vpc_id = "${aws_vpc.wordpress-vpc.id}"
  name = "wordpress - production"
  description = "security group for wordpress"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  } 


  tags {
    Name = "wordpress"
  }
}
resource "aws_security_group" "allow-mysqldb" {
  vpc_id = "${aws_vpc.wordpress-vpc.id}"
  name = "allow-mysqldb"
  description = "allow-mysqldb"
  ingress {
      from_port = 3306
      to_port = 3306
      protocol = "tcp"
      security_groups = ["${aws_security_group.wordpress-prod.id}"]           
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      self = true
  }
  tags {
    Name = "allow-mysqldb"
  }
}
