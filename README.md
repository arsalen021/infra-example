# infra-example
## Overview
This repository consists of 2 projects:
- Terraform project to provision infrastructure and services that are required to host the app
- ArgoCD project for applications manifests and Helm values files required to install Jenkins and the app. 
 
The following diagram is an overview of the result after running both `terraform` and `argocd` projects:
![alt text](https://github.com/arsalen021/infra-example/blob/main/diagram.jpg?raw=true)


## Notes
- Please refer to the `README.md` in each directory for an in depth information for each project