IAM_ECR_ROLE		:= arn:aws:iam::333594256635:role/SjeEcrPublish

.PHONY aws:assumerole
aws\:assumerole:
	ROLE_JSON		:= aws sts assume-role --role-arn $(IAM_ECR_ROLE) --role-session-name=test --output json
