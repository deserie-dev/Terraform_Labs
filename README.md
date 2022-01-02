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

2. Set AWS credentials for the above IAM user. I am on a Windows machine, and to set these variables on Windows, use :

```
set AWS_ACCESS_KEY_ID=your_access_key_id
set AWS_SECRET_ACCESS_KEY=your_secret_access_key
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

</p></details>
