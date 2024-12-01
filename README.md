<h1>Weather Application Deployment</h1>

  
This repository contains the code for a simple weather application. The application is built with Flask and Python, and it retrieves current weather data from an external API. The application is containerized using Docker, and the deployment pipeline is managed with Skaffold and GitHub Actions to deploy the application to AWS ECS.


<h2>Table of Contents</h2>

Prerequisites

Setting Up AWS Resources
Local Development Setup
GitHub Actions Workflow
Deploying to AWS ECS
Cleaning Up AWS Resources

<h2>Prerequisites</h2>

Before deploying the application, ensure the following:

<ul>1. AWS Account: An AWS account with ECS, ECR, and IAM permissions to access ECS, ECR, and the necessary regions.</ul>
<ul>2. Docker: Installed and configured for local builds.</ul>
<ul>3. Skaffold: Installed on your local machine (for local development and testing).</ul>
<ul>4. GitHub Repository Secrets:
  
       AWS_ACCESS_KEY_ID: AWS Access Key ID for authentication.
       AWS_SECRET_ACCESS_KEY: AWS Secret Access Key for authentication.
</ul>

<h3>Setting Up AWS Resources</h3>

To deploy this application on AWS ECS, the following AWS resources need to be set up:

<ul>1. ECS Cluster and Service:
  
Create an ECS cluster (either with EC2 or Fargate launch type).
Define an ECS task definition that uses your container image.
Create an ECS service that runs the task.

</ul>
<ul>
2. ECR Repository:
Create an Amazon Elastic Container Registry (ECR) repository to store Docker images.
</ul>
<ul>
3. IAM Permissions:
Ensure that the IAM user or role used for GitHub Actions has permissions to interact with ECR, ECS, and other related services.
You can use Terraform to automate the creation of these resources. (Optional)
</ul>

<h2>Local Development Setup</h2>
Clone this repository:
<ul>
git clone https://github.com/ragnarlegacy/weather-app.git
cd weather-app
</ul>

<h4>Build the Docker image locally:</h4>
<ul>
docker build -t weather-app .
Run the Docker container locally:
</ul>
<ul>
docker run -d -p --name lytx 8000:8000 weather-app
</ul>

You can access the application at http://localhost:5000.

<h4>GitHub Actions Workflow</h4>

The deployment pipeline is automated using GitHub Actions. When you push changes to the release/v.1 branch, the following steps occur:

<ul>Checkout Code: GitHub Actions checks out the repository.</ul>
<ul>AWS Authentication: AWS credentials are configured using GitHub secrets (AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY).</ul>
<ul>
Install Dependencies:
Docker and Skaffold are installed on the GitHub Actions runner.
Build and Push Docker Image:
The Docker image is built and pushed to an Amazon ECR repository.
</ul>
<ul>
Deploy to ECS:
The application is deployed to an ECS cluster using the skaffold run command.
The GitHub Actions workflow file is located in .github/workflows/deploy-with-skaffold.yml.
</ul>
<ul>
Workflow Execution:
The deployment is triggered every time you push code to the main branch. The pipeline will:
</ul>
<ul>
Build the Docker image.
Push the image to ECR.
Deploy the image to AWS ECS.
Deploying to AWS ECS
</ul>
  
<h4>Follow these steps to deploy the application to AWS ECS:</h4>
<h6>Use terraform folder to create the below mentioned resources</h6>
<ul>* terraform init</ul>
<ul>* terraform plan</ul>
<ul>* terraform apply --auto-approve</ul>
<h5>Create AWS ECR Repository:</h5>
<ul>
Go to the AWS Management Console.
Create an ECR repository to store the Docker images.
Create ECS Cluster and Service:
</ul>

<h5>Create an ECS cluster and service.</h5>
<ul>
  
Ensure that the service uses the correct task definition for running the application in ECS.
Update GitHub Secrets:

Add your AWS credentials (AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY) as GitHub secrets in the repository settings.
Push Code to GitHub:

When you push changes to the release/v.1 branch, GitHub Actions will automatically trigger the workflow to deploy the application.
</ul>

<h5>Monitor Deployment:</h5>
<ul>
Go to the ECS Console and check the status of your application.
You can use the Load Balancer (if configured) or the ECS service URL to access your app.
</ul>
<h5>Cleaning Up AWS Resources</h5>
To avoid unnecessary charges, delete the AWS resources after testing:

<ul>terraform destroy</ul>
