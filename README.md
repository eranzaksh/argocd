# Weather Web-App CD Pipeline

This repository contains the configuration and code for the Continuous Deployment (CD) pipeline of my **Weather Web-App**. It leverages **Jenkins**, **Terraform**, **Helm**, and **ArgoCD** to deploy the application on AWS EKS with high availability and automated version control.

## Key Components

### 1. **Helm Chart**
- **Directory**: `weather-helm`
- The Helm chart packages the Weather Web-App for deployment.
- **Image Versioning**: The Helm values file includes an `image.tag`, which is dynamically updated in the pipeline with the build number and commit hash.

### 2. **Terraform Infrastructure**
- **Directory**: `terraform`
- Terraform defines and provisions the AWS resources:
  - **VPC**: Custom Virtual Private Cloud setup.
  - **EKS Cluster**: Managed Kubernetes service for running the app.
  - **Ingress Controller**: Creates an AWS Load Balancer for external access.
  - **ArgoCD**: Deployed in the cluster for GitOps-style deployment.
- ArgoCD includes an ingress rule with a custom hostname (via [DuckDNS](https://www.duckdns.org/)) to access the ArgoCD web UI.

### 3. **Jenkins Pipeline**
- **File**: `Jenkinsfile`
- This Jenkins pipeline automates the deployment process:
  1. Receives a **build number** and **commit hash** from another CI pipeline.
  2. Updates the `image.tag` value in the Helm chart.
  3. Pushes changes to the repository, triggering ArgoCD to monitor and deploy the new version.

### 4. **Grafana Monitoring**
- **Directory**: `environment/grafana`
- Includes Grafana setup for monitoring the EKS cluster and the web app.

### 5. **GitHub Actions**
- **Directory**: `.github/workflows`
- Placeholder for any future GitHub Actions workflows.

## Workflow
1. **Build Pipeline**:
   - Another CI pipeline builds the Docker image for the Weather Web-App.
   - It outputs a **build number** and **commit hash**.
2. **Jenkins Pipeline**:
   - Updates the Helm `image.tag` with the new build information.
   - Pushes the changes to the Helm chart values.
3. **ArgoCD Monitoring**:
   - ArgoCD detects changes in the Helm chart values.
   - It automatically deploys the updated image to the EKS cluster.
4. **Ingress Controller**:
   - Exposes the web application via an AWS Load Balancer.
5. **ArgoCD UI**:
   - Accessible using the DuckDNS-hosted domain for deployment visibility.

## Accessing the ArgoCD Web UI
- Hostname: Configured using **DuckDNS**.
- Use the provided domain name to monitor deployments and application status.

## AWS Infrastructure Overview
- **VPC**: Networking layer for the EKS cluster.
- **EKS**: Managed Kubernetes environment.
- **Ingress Controller**: Handles external traffic, provisions an AWS Load Balancer.
- **ArgoCD**: Manages deployments via GitOps.

## Monitoring and Observability
- **Grafana**: Dashboards and metrics for the application and infrastructure.

## Prerequisites
- **Terraform**: For infrastructure provisioning.
- **Helm**: For packaging the application.
- **Jenkins**: For pipeline execution.
- **DuckDNS**: To access ArgoCD UI.
- **AWS Account**: For deploying resources.

## How to Use
1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```
2. Set up Terraform to provision infrastructure:
   ```bash
   cd terraform
   terraform init
   terraform apply
   ```
3. Configure Jenkins with the provided `Jenkinsfile`.
4. Deploy the application using ArgoCD.

## Repository Structure
```plaintext
.github/workflows/      # Placeholder for GitHub Actions
environment/grafana/    # Grafana setup for monitoring
terraform/              # Terraform configurations (VPC, EKS, ArgoCD, Ingress Controller)
weather-helm/           # Helm chart for the Weather Web-App
Jenkinsfile             # Jenkins pipeline for CD
README.md               # Project documentation
```

## Future Enhancements
- Add automated testing in the pipeline.
- Implement GitHub Actions for CI/CD.
- Enhance Grafana dashboards for better insights.

---

**Author**: Eran Zaksh  
**Contact**: eranzaksh@gmail.com

