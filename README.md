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
