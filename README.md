# Terraform Labs

These are some hands-on labs where I use Terraform to provision AWS infrastructure.

---

<details>
<summary><b>Create an AWS AMI Using Packer</b></summary><p>

1. Create a Packer template called packer.pkr.hcl that creates an Amazon Machine Image (AMI). See Packer folder.

2. Build AMI by running the following commands

```
packer validate packer.pkr.hcl
packer build packer.pkr.hcl
```

![](/images/validate.png)

![](/images/build.png)

![](/images/ami.png)

</p></details>

<details>
<summary><b>Provision an EC2 Instance</b></summary><p>

1. Configure a provider.

```
provider "aws" {
 profile = "terraform-labs"
 region = " us-east-1"
}
```

This tells Terraform that you are going to be using AWS as your provider and that you want to deploy your infrastructure into the us-east-1 region.

2. Create a resource. Use AMI ID of the image created using Packer.

```
resource "aws_instance" "example" {
 ami = "ami-0c55b159cbfafe1f0"
 instance_type = "t2.micro"
}
```

3. Add tags to the resource block

```
tags = {
 Name = "terraform-lab"
}
```

4. Run

```
terraform init
```

![](/images/init-1.png)

5. Run

```
terraform plan
```

6. To actually create the Instance, run the terraform apply command:

```
terraform apply
```

![](/images/apply-1.png)

## Verify instance has been created in the EC2 console.

![](/images/ec2-1.png)

## Destroy EC2 Instance

To destroy the EC2 instance run

```
terraform destroy
```

</p></details>

<details>
<summary><b>Provision an EC2 Instance with a Data Source</b></summary><p>

Provision an instance with a data source to dynamically look up the latest value of an Ubuntu AMI.

- data sources are elements that let you fetch data at runtime and perform computations.

We need to configure main.tf to read from the external data source, allowing us to query the most recent Ubuntu AMI published to AWS.

```
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "terraformlab" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  tags = {
    Name = "TerraformLab"
  }
}
```

---

```
data "aws_ami" "ubuntu"
```

- Declares an aws_ami data source with name “ubuntu”

```
filter
```

- Sets a filter to select all AMIs with name matching this regex expression

```
owners = ["099720109477"]
```

- Ubuntu AWS account id

```
resource "aws_instance" "helloworld" {
 ami = data.aws_ami.ubuntu.id
 instance_type = "t2.micro"
 tags = {
 Name = "HelloWorld"
 }
}
```

- Chains resources

Run _terraform apply_

![](/images/data-source.png)

</p></details>

<details>
<summary><b>Deploy a Single Web Server</b></summary><p>

Deploy a simple web server that can respond to HTTP requests.

By default, AWS does not allow any incoming or outgoing traffic from an EC2
Instance. To allow the EC2 Instance to receive traffic on port 8080, you
need to create a security group:

```
resource "aws_security_group" "instance" {
 name = "terraform-example-instance"
 ingress {
 from_port = 8080
 to_port = 8080
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
 }
}
```

This creates a new resource called _aws_security_group_ and specifies that this
group allows incoming TCP requests on port 8080 from the CIDR block 0.0.0.0/0.

You need to tell the EC2 Instance tO use it by passing the ID of the security group into the vpc_security_group_ids argument of the aws_instance resource.

```
vpc_security_group_ids = [aws_security_group.instance.id]
```

To get the IP address of your server, you can provide the IP address as an
output variable:

```
output "public_ip" {
 value = aws_instance.example.public_ip
 description = "The public IP address of the web server"
}
```

This references the public_ip attribute of the aws_instance resource. Output variables show up in the console after you run terraform apply, which users of your Terraform code might find useful (e.g., you now know what IP to test after the web server is deployed).

Run \_terraform

---

![](/images/ec2_lab_2.png)

---

![](/images/ec2_lab_2.2.png)

</p></details>

<details>
<summary><b>Deploying a Cluster of Web Servers</b></summary><p>

To create an Auto Scaling Group first create a launch template or launch configuration.

```
resource "aws_launch_template" "example"
```

Now you can create the ASG itself using the aws_autoscaling_group
resource:

```
resource "aws_autoscaling_group" "example" {
 launch_template = aws_launch_template.example.name
 min_size = 2
 max_size = 10
 tag {
 key = "Name"
 value = "terraform-asg-example"
 propagate_at_launch = true
 }
}
```

This ASG will run between 2 and 10 EC2 Instances (defaulting to 2 for the
initial launch), each tagged with the name terraform-asg-example.

</p></details>

<details>
<summary><b>Create an AWS Budget</b></summary><p>

1. Configure the AWS CLI from your terminal. Follow the prompts to input your AWS Access Key ID and Secret Access Key.

```
aws configure
```

2. Create a main.tf file.

3. Start by creating the provider block, which configures the specified provider, in this case AWS. A provider is a plugin that Terraform uses to create and manage your resources.

```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.5.0"
    }
  }
}
```

4. Tell the provider (AWS), what region to use.

```
provider "aws" {
  region = "af-south-1"
}
```

5. Create a resource block to define components of your infrastructure, in this lab, we're creating a budget.

```
resource "aws_budgets_budget" "terraform-budgets-lab" {
  name              = "monthly-budget"
  budget_type       = "COST"
  limit_amount      = "200"
  limit_unit        = "USD"
  time_unit         = "MONTHLY"
  time_period_start = "2022-01-24_00:01"
}
```

6. Initialize terraform

```
terraform init
```

![](/images/init-2.png)

7. Format your Terraform code

```
terraform fmt
```

8. To make sure your Terraform code is valid run

```
terraform validate
```

![](/images/fmt-1.png)

9. To see all the resources that Terraform will create run

```
terraform plan
```

10. To actually create create the resources run

```
terraform apply
```

![](/images/apply-2.png)

![](/images/apply-3.png)

</p></details>
