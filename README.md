# cloud-infra-applications-terragrunt
Repository for applications to configure the cloud infrastructure using terragrunt

## Commands
* Add cluster to kube config: 
```aws eks update-kubeconfig --region us-east-1 --name purchase-PROD-cluster```

* Check for admin access to cluster: 
```kubectl auth can-i "*" "*"```