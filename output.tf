output "eb" {
	value = "${aws_elastic_beanstalk_environment.wordpress-prod.cname}"
}
