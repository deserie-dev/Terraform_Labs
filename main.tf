provider "aws" {
 region = "us-east-1"
}

resource "aws_instance" "example" {
 ami = "ami-0cdce5f44e3e75ab2"
 instance_type = "t2.micro"

 tags = {
    Name = "terraform-lab"
 }
}
