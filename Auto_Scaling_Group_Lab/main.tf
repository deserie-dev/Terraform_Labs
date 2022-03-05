resource "aws_launch_template" "example" {
 image_id = "ami-0c55b159cbfafe1f0"
 instance_type = "t2.micro"
 security_group_names = [aws_security_group.instance.id]
 user_data = <<-EOF
 #!/bin/bash
 echo "Hello, World" > index.html
 nohup busybox httpd -f -p ${var.server_port} &
 EOF
 
 lifecycle {
 create_before_destroy = true
 }
}

resource "aws_autoscaling_group" "example" {
 launch_configuration = aws_launch_configuration.example.name
 vpc_zone_identifier = data.aws_subnet_ids.default.ids

 min_size = 2
 max_size = 10
 
 tag {
 key = "Name"
 value = "terraform-asg-example"
 propagate_at_launch = true
 }
}
