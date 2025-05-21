# AWS CLI Commands

## Change Cognito Status & Password

```
aws cognito-idp admin-set-user-password --user-pool-id "us-east-1_<code>" --username "<generated_username>" --password "Testing123" --permanent
```

## Calculate the total size of all S3 buckets (in GB)
This can be run in the AWS CloudShell
```
aws s3api list-buckets --query 'Buckets[].Name' --output text | tr -s '[:space:]' '\n' | xargs -I {} aws s3api list-objects-v2 --bucket {} --query 'sum((Contents || `[]`)[].Size)' --output text | awk '{total+=$1} END {printf "%.2f GB\n", total/1024/1024/1024}'
```
