# Terraform Labs

These are some hands-on labs where I use Terraform to provision AWS infrastructure.

---

1. Setup AWS user. Add the following managed IAM Policies to the new IAM user :

- AmazonEC2FullAccess
- AmazonS3FullAccess
- AmazonDynamoDBFullAccess
- AmazonRDSFullAccess
- CloudWatchFullAccess
- IAMFullAccess

![](/images/policies.png)

2. Configure AWS credentials for the above IAM user.

```
aws configure --profile terraform-labs
```

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
<summary><b> Provision an EC2 Instance with a Data Source</b></summary><p>

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
