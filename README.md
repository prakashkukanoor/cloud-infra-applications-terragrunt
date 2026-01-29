# cloud-infra-applications-terragrunt
Repository for applications to configure the cloud infrastructure using terragrunt

## Terragrunt execution commands
1. Create Networking Resources by Navigate to below location:
```
cloud-infra-applications-terragrunt/aws/workload-account-dev-qa-123456789/us-east-1/shared/environment/dev/networking/
```
1.1. Initialize the module:
```
tginit
alias tginit="terragrunt run-all init"
```
1.2. terragrunt Plan:
```
tgplan
alias tgplan="terragrunt run-all plan"
```
1.3. terragrunt apply:
```
tgapprove
alias tgapprove="terragrunt run-all apply -auto-approve"
```
1.4. Delete terragrunt files:
```
find . -name ".terraform.lock.hcl" -type f -delete -o -name ".terragrunt-cache" -type d -exec rm -rf {} +
```

2. Create EKS Resources by Navigate to below location:
```
cloud-infra-applications-terragrunt/aws/workload-account-dev-qa-123456789/us-east-1/project-name-abc/dev/purchase/eks-v1-34
```


## Kubernetes Commands
* Add cluster to kube config: 
```
aws eks update-kubeconfig --region us-east-1 --name purchase-PROD-cluster
```

* Check for admin access to cluster: 
```
kubectl auth can-i "*" "*"
```