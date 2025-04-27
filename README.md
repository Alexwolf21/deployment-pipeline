# Streamlinig Deployment Pipeline : Overcoming Inconsistencies in Deployment Environment

This repository contains a fully automated deployment pipeline project that demonstrates how to streamline software delivery using a combination of Terraform, Docker, Jenkins, Prometheus, and Grafana. The project automates infrastructure provisioning, CI/CD, and monitoring to eliminate the classic "it works on my machine" problem.

## Tools and Their Roles:
### 1. Terraform:
- Provisions infrastructure in a declarative manner. 
- Creates a Docker network (my_network) and deploys an Nginx container with custom configuration (from nginx.conf).

### 2. Docker:
- Containerizes the Node.js application and runs all services in isolated environments.
- Ensures consistency across different environments.

### 3. Jenkins:
- Automates the CI/CD pipeline.
- Uses the Jenkinsfile to check out code, build the Docker image, run tests, and deploy the sample app container on the Docker network.

### 4. Prometheus & Grafana:
- Prometheus: Collects application metrics (exposed at /metrics by the sample app).
- Grafana: Visualizes metrics from Prometheus using custom dashboards.
- Both are deployed via Docker Compose (see docker-compose.yml).

## How to Get Started
- **Provision Infrastructure with Terraform**
   - Navigate to the terraform directory:
      ```
      cd terraform
      ```
   - Initialise Terraform:
      ```
      terraform init
      ```
   - Plan and Apply:
      ```
      terraform plan
      terraform apply -auto-approve
      ```
This creates the Docker network my_network and deploys an Nginx container configured with nginx.conf

- **Set Up Jenkins**
   2.a. Run Jenkins in Docker (ensuring it has access to the Docker daemon):
   docker run -d -p 8080:8080 -p 50000:50000 --name jenkins \-v jenkins_home:/var/jenkins_home \-v /var/run/docker.sock:/var/run/docker.sock \jenkins/jenkins:lts
   
   Access Jenkins at http://localhost:8080 and complete the initial setup.
   
   2.b. Configure the Pipeline Job:
   Create a new Pipeline job (e.g., Sample-App-Pipeline) in Jenkins.
   Under Pipeline script from SCM, set the SCM type to Git and provide the repository URL.
   Set the Script Path to Jenkinsfile.
   Save and run the job.
   
   2.c. Pipeline Stages (Defined in Jenkinsfile):
   Checkout: Retrieves the latest code.
   Build: Uses the Dockerfile to build the Docker image for the Node.js app.
   Test: Runs tests (e.g., npm test).
   Deploy: Deploys the container onto my_network and maps port 3000.

- **Deploy Monitoring with Prometheus and Grafana**
   3.a. Configure Prometheus:
   Ensure your prometheus.yml is set to scrape metrics from the sample-app container
   
   3.b. Run Docker Compose:
   From the root of the repository (where docker-compose.yml is located), run:
   docker-compose up -d
   or pull the docker image of Grafana with the same name mentioned in docker-compose.yml
   Prometheus will be available at http://localhost:9090 and Grafana at http://localhost:3001.
   
   3.c. Configure Grafana:
   In Grafana, add Prometheus as a data source (URL: http://prometheus:9090 if on the same network, or http://127.0.0.1:9090).
   Create dashboards to visualize the metrics scraped from the sample-app’s /metrics endpoint.

## Additional Notes
### Environment Consistency:
Using Terraform for provisioning ensures that every deployment starts from an identical infrastructure state.

### CI/CD Automation:
Jenkins automates the entire build-test-deploy cycle, ensuring reliable deployments.

### Monitoring:
Prometheus and Grafana provide real-time visibility into the application’s performance, enabling quick troubleshooting and performance tuning.

### Integration:
All components work together seamlessly. Terraform sets up the environment, Jenkins automates application delivery, and Prometheus with Grafana offers continuous monitoring.

## Conclusion
This project demonstrates a complete, automated deployment pipeline using best-in-class tools for infrastructure provisioning, CI/CD, and monitoring. By integrating Terraform, Docker, Jenkins, Prometheus, and Grafana, we ensure that our deployments are consistent, reliable, and easily monitored—eliminating the common "it works on my machine" issue.
