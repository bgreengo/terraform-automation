# iam user
resource "aws_iam_user" "wordpress" {
  name = "wordpress"
  path = "/"
}

resource "aws_iam_access_key" "wordpress" {
  user = "${aws_iam_user.wordpress.name}"
}

resource "aws_iam_user_policy" "wordpress" {
  name = "wordpress"
  user = "${aws_iam_user.wordpress.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# iam roles
resource "aws_iam_role" "wordpress-ec2-role" {
    name = "wordpress-ec2-role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_instance_profile" "wordpress-ec2-role" {
    name = "wordpress-ec2-role"
    role = "${aws_iam_role.wordpress-ec2-role.name}"
}

# service
resource "aws_iam_role" "elasticbeanstalk-service-role" {
    name = "elasticbeanstalk-service-role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "elasticbeanstalk.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# policies
resource "aws_iam_policy_attachment" "wordpress-attach1" {
    name = "wordpress-attach1"
    roles = ["${aws_iam_role.wordpress-ec2-role.name}"]
    policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}
resource "aws_iam_policy_attachment" "wordpress-attach2" {
    name = "wordpress-attach2"
    roles = ["${aws_iam_role.wordpress-ec2-role.name}"]
    policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}
resource "aws_iam_policy_attachment" "wordpress-attach3" {
    name = "wordpress-attach3"
    roles = ["${aws_iam_role.wordpress-ec2-role.name}"]
    policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}
resource "aws_iam_policy_attachment" "wordpress-attach4" {
    name = "wordpress-attach4"
    roles = ["${aws_iam_role.elasticbeanstalk-service-role.name}"]
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}
