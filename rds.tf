resource "aws_db_subnet_group" "mysqldb-subnet" {
    name = "mysqldb-subnet-wp"
    description = "RDS subnet group"
    subnet_ids = ["${aws_subnet.wp-private-1.id}","${aws_subnet.wp-private-2.id}"]
}

resource "aws_db_parameter_group" "mysqldb-parameters" {
    name = "mysqldb-params-wp"
    family = "mysql5.6"
    description = "MySQLDB parameter group"

    parameter {
      name = "max_allowed_packet"
      value = "16777216"
   }

}


resource "aws_db_instance" "mysqldb" {
  allocated_storage    = 10    
  engine               = "mysql"
  engine_version       = "5.6.39"
  instance_class       = "db.t2.small"    
  identifier           = "mysql"
  name                 = "wordpressdb" # database name
  username             = "root"   # username
  password             = "${var.RDS_PASSWORD}" 
  db_subnet_group_name = "${aws_db_subnet_group.mysqldb-subnet.name}"
  parameter_group_name = "${aws_db_parameter_group.mysqldb-parameters.name}"
  multi_az             = "false"     # set to true to have high availability: 2 instances synchronized with each other
  vpc_security_group_ids = ["${aws_security_group.allow-mysqldb.id}"]
  storage_type         = "gp2"
  backup_retention_period = 30    # how long you’re going to keep your backups
  skip_final_snapshot = true
  availability_zone = "${aws_subnet.wp-private-1.availability_zone}"   # prefered AZ
  tags {
      Name = "mysqldb-instance"
  }
}
