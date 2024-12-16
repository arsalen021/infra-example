# ArgoCD
## Overview
This directory contains ArgoCD application configurations for GitOps-based deployments. The setup is designed to manage multiple applications (e.g., Jenkins, Spring Boot + React) across environments.
## Structure
- **`jenkins.yaml`**: Configuration for Jenkins Application.
- **`spring-boot-react-example.yaml`**: Configuration for the Spring Boot + React Application.
- **`clusters/development/`**:
  - `jenkins/values.yaml`: Helm values for Jenkins deployment.
  - `spring-boot-react-example/values.yaml`: Helm values for the Spring Boot + React deployment.

## Prerequisites
- ArgoCD installed and configured on your Kubernetes cluster.
- Access to the Git repository containing the manifests.
## Helm Values
Override values in `clusters/development/<app>/values.yaml`. Example:
   ```yaml
   replicaCount: 3
   resources:
     limits:
       cpu: "500m"
       memory: "512Mi"
   ```
## Notes
- Ensure your ArgoCD cluster has access to the Helm repositories and container registries.
- Use separate clusters or namespaces for staging and production environments.