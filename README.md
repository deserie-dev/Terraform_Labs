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

2. Set AWS credentials for the above IAM user. To set these variables on Windows, use :

```
set AWS_ACCESS_KEY_ID=your_access_key_id
set AWS_SECRET_ACCESS_KEY=your_secret_access_key
```

3. Create a Packer template called packer.pkr.hcl that creates an Amazon Machine Image (AMI). See Packer folder.

4. Build AMI by running the following commands

```
packer validate packer.pkr.hcl
packer build packer.pkr.hcl
```

![](/images/validate.png)

![](/images/build.png)
