# cloud-infra-applications-terragrunt
Repository for applications to configure the cloud infrastructure using terragrunt

## Terragrunt execution commands
* Navigate to below location:
```
cd aws/workload-account-123456789/project-name-xyz
```

* Initialize the module:
```
terragrunt run-all init
```

* terragrunt Plan:
```
terragrunt run-all plan -auto-approve
```

* terragrunt apply:
```
terragrunt run-all apply -auto-approve
```

* Delete terragrunt files:
```
find . -name ".terraform.lock.hcl" -type f -delete -o -name ".terragrunt-cache" -type d -exec rm -rf {} +
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