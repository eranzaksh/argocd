Weather Web-App CD Pipeline

This repository contains the configuration and code for the Continuous Deployment (CD) pipeline of my Weather Web-App. It leverages Jenkins, Terraform, Helm, and ArgoCD to deploy the application on AWS EKS with high availability and automated version control.

Key Components

1. Helm Chart

Directory: weather-helm

The Helm chart packages the Weather Web-App for deployment.

Image Versioning: The Helm values file includes an image.tag, which is dynamically updated in the pipeline with the build number and commit hash.

2. Terraform Infrastructure

Directory: terraform

Terraform defines and provisions the AWS resources:

VPC: Custom Virtual Private Cloud setup.

EKS Cluster: Managed Kubernetes service for running the app.

Ingress Controller: Creates an AWS Load Balancer for external access.

ArgoCD: Deployed in the cluster for GitOps-style deployment.

ArgoCD includes an ingress rule with a custom hostname (via DuckDNS) to access the ArgoCD web UI.

3. Jenkins Pipeline

File: Jenkinsfile

This Jenkins pipeline automates the deployment process:

Receives a build number and commit hash from another CI pipeline.

Updates the image.tag value in the Helm chart.

Pushes changes to the repository, triggering ArgoCD to monitor and deploy the new version.

4. Prometheus and Grafana Monitoring

Directory: environment/grafana

Includes Grafana setup for monitoring the EKS cluster and the web app.

How to Use

Clone the repository:

git clone <repository-url>

Set up Terraform to provision infrastructure:

cd terraform
terraform init
terraform apply

Configure Jenkins with the provided Jenkinsfile.

Deploy the application using ArgoCD.

Repository Structure

.github/workflows/      # Placeholder for GitHub Actions
environment/grafana/    # Grafana setup for monitoring
terraform/              # Terraform configurations (VPC, EKS, ArgoCD, Ingress Controller)
weather-helm/           # Helm chart for the Weather Web-App
Jenkinsfile             # Jenkins pipeline for CD
README.md               # Project documentation

Future Enhancements

Add prometheus for traffic metrics (On the ingress)


Author: Eran Zaksh
Contact: eranzaksh@gmail.com

