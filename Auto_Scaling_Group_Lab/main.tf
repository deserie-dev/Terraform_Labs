resource "aws_launch_template" "example" {
 image_id = "ami-0c55b159cbfafe1f0"
 instance_type = "t2.micro"
 security_group_names = [aws_security_group.instance.id]
 user_data = <<-EOF
 #!/bin/bash
 echo "Hello, World" > index.html
 nohup busybox httpd -f -p ${var.server_port} &
 EOF
 # Required when using a launch configuration with an auto scaling group.
 # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
 lifecycle {
 create_before_destroy = true
 }
}

resource "aws_autoscaling_group" "example" {
 launch_configuration = aws_launch_configuration.example.name
 min_size = 2
 max_size = 10
 tag {
 key = "Name"
 value = "terraform-asg-example"
 propagate_at_launch = true
 }
}
