output "eb" {
	value = "${aws_elastic_beanstalk_environment.wordpress-prod.cname}"
}
output "efs" {
	value = "${aws_efs_file_system.wordpress-efs.id}"
}