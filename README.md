# Todo Summary Assistant

A full-stack application to manage personal to-do items, summarize pending tasks using Cohere LLM, and send the summary to a Slack channel.

## Table of Contents

* [Features](#features)
* [Tech Stack](#tech-stack)
* [Setup Instructions](#setup-instructions)
    * [Prerequisites](#prerequisites)
    * [Backend Setup](#backend-setup)
    * [Frontend Setup](#frontend-setup)
* [LLM (Cohere) Setup](#llm-cohere-setup)
* [Slack Integration Setup](#slack-integration-setup)
* [Design/Architecture Decisions](#designarchitecture-decisions)


## Features

* **Create, Edit, Delete To-Do Items:** Full CRUD operations for personal to-do items.
* **View To-Do List:** Display current to-do items with their status.
* **Summarize Pending To-Dos:** Utilizes Cohere LLM to generate a concise summary of all pending to-do items.
* **Send Summary to Slack:** Automatically posts the generated summary to a configured Slack channel using Incoming Webhooks.
* **Notifications:** Provides success/failure messages for Slack operations.

## Tech Stack

* **Frontend:** HTML, CSS, Javascript, React, Axios(for API calls), 
* **Backend:** Spring Boot (Java 17+), Maven
* **Database:** MySQL (via Spring Data JPA and Hibernate)
* **LLM:** Cohere API
* **Messaging:** Slack Incoming Webhooks
* **HTTP Client:** OkHttp (for Cohere and Slack API calls in backend)

## Setup Instructions

### Prerequisites

* Java Development Kit (JDK) 17 or higher
* Node.js and npm (or yarn)
* MySQL Server running locally or accessible remotely
* A Cohere API Key
* A Slack Workspace and an Incoming Webhook URL

### Backend Setup

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/your-username/todo-summary-assistant.git](https://github.com/your-username/todo-summary-assistant.git)
    cd todo-summary-assistant/backend
    ```
2.  **Configure `application.properties`:**
    Open `src/main/resources/application.properties` and update the following:
    ```properties
    spring.datasource.url=jdbc:mysql://localhost:3306/todo_db?createDatabaseIfNotExist=true
    spring.datasource.username=root
    spring.datasource.password=your_mysql_password_here # <-- IMPORTANT: Replace with your MySQL root password
    cohere.api.key=YOUR_COHERE_API_KEY # <-- IMPORTANT: Replace with your Cohere API Key
    slack.webhook.url=YOUR_SLACK_WEBHOOK_URL # <-- IMPORTANT: Replace with your Slack Incoming Webhook URL
    ```
3.  **Build and Run:**
    ```bash
    mvn clean install
    mvn spring-boot:run
    ```
    The backend will start on `http://localhost:8080`.

### Frontend Setup

1.  **Navigate to the frontend directory:**
    ```bash
    cd ../frontend
    ```
2.  **Install dependencies:**
    ```bash
    npm install
    # or yarn install
    ```
3.  **Run the React application:**
    ```bash
    npm start
    # or yarn start
    ```
    The frontend will open in your browser at `http://localhost:3000`.

## LLM (Cohere) Setup

1.  **Create a Cohere Account:** Visit [Cohere.ai](https://cohere.ai/) and sign up for a free account.
2.  **Obtain API Key:** Once logged in, navigate to your dashboard or API keys section to find your API key.
3.  **Update `application.properties`:** Paste your Cohere API key into `cohere.api.key` in the backend's `application.properties` file.

## Slack Integration Setup

1.  **Create a Slack App:**
    * Go to [api.slack.com/apps](https://api.slack.com/apps).
    * Click "Create New App" and choose "From scratch".
    * Give your app a name (e.g., "Todo Summary Bot") and select your Slack workspace.
2.  **Activate Incoming Webhooks:**
    * From your app's settings page, navigate to "Features" -> "Incoming Webhooks".
    * Toggle the "Activate Incoming Webhooks" switch to "On".
    * Scroll down and click the "Add New Webhook to Workspace" button.
    * Select the specific channel where you want the to-do summaries to be posted (e.g., `#general`, `#todos`, or a new channel).
    * Click "Allow".
3.  **Copy Webhook URL:**
    * A unique Webhook URL will be generated. Copy this URL.
4.  **Update `application.properties`:** Paste this URL into `slack.webhook.url` in the backend's `application.properties` file.

## Design/Architecture Decisions

* **Separation of Concerns:** The project is cleanly separated into frontend (React) and backend (Spring Boot) directories, allowing independent development and deployment.
* **RESTful API:** The backend exposes standard RESTful endpoints for managing todos, ensuring clear and predictable communication with the frontend.
* **Spring Data JPA:** Leveraged for efficient and simplified database interactions with MySQL, reducing boilerplate code for data access.
* **Service Layer:** Business logic (CRUD operations, LLM calls, Slack calls) is encapsulated within dedicated service classes, promoting modularity and testability.
* **External API Integration:** `OkHttp` was chosen as a lightweight and efficient HTTP client for making external API calls to Cohere and Slack.
* **CORS Configuration:** Explicit CORS configuration in Spring Boot ensures that the React frontend can communicate with the backend.
* **Error Handling:** Basic error handling is implemented on both frontend and backend to provide user feedback and log issues.
* **LLM Prompt Engineering:** A simple prompt is used for Cohere to instruct it on summarizing the list of to-do items. This can be further refined for better results.
* **Notification System:** A simple notification component in React provides immediate feedback to the user about operations.

## Demo Images

![Screenshot (1146)](https://github.com/user-attachments/assets/53fe53e3-b527-4659-9ab6-b462ae034fbd)

![Screenshot (1144)](https://github.com/user-attachments/assets/474b1a46-36c8-4407-8bf9-a46ca911603b)

![Screenshot (1143)](https://github.com/user-attachments/assets/1e9f8783-d0df-42ce-a3f8-ec7ca5e7c078)
---

# DevOps Implementation Details

This section explains how the DevOps pipeline was implemented for this project.
The focus was on automation, deployment, and operations without modifying the existing application logic.

---

## AWS Infrastructure Setup

All DevOps components for this project are hosted on AWS.

An EC2 instance is used as the main DevOps server. This instance is responsible for running Jenkins, building Docker images, and interacting with the Kubernetes cluster.

AWS ECR is used to store Docker images, and AWS EKS is used to run the application using Kubernetes.

---

## DevOps Tools on EC2

The following tools were installed and configured on the EC2 instance:

- Git for source control access
- Java 17 and Maven for building the backend
- Docker for containerization
- Jenkins for Continuous Integration
- AWS CLI for AWS access
- kubectl and eksctl for Kubernetes and EKS management

---

## Source Code Management

GitHub is used to manage the source code.
Both application code and Kubernetes configuration files are stored in the same repository.
Git acts as the single source of truth for the deployment.

---

## Continuous Integration Using Jenkins

Jenkins is configured only for Continuous Integration.

Whenever code is pushed to GitHub, Jenkins automatically:
- Pulls the latest code
- Builds the backend using Maven
- Runs tests if available
- Builds a Docker image
- Pushes the Docker image to AWS ECR

All sensitive values such as AWS credentials are stored securely using Jenkins credentials.
No secrets are hardcoded in the repository.

Jenkins does not deploy the application to Kubernetes.

---

## Dockerization Approach

The backend application is packaged into a Docker image using a multi-stage Dockerfile.

The build stage compiles the application, and the runtime stage runs it using a lightweight Java image.
The container runs as a non-root user to follow security best practices.

---

## Kubernetes Deployment on EKS

The application is deployed to AWS EKS using Kubernetes YAML manifests.

The deployment includes:
- A Deployment to manage pods and replicas
- A Service to expose the application
- ConfigMaps for non-sensitive configuration
- Secrets for sensitive values

Resource requests, limits, and health checks are defined to ensure stable runtime behavior.

---

## GitOps Deployment with ArgoCD

GitOps is implemented using ArgoCD.

ArgoCD is installed inside the EKS cluster and continuously monitors the GitHub repository.
Only the `k8s/` directory is tracked for deployments.

Whenever a change is made to Kubernetes manifests in Git, ArgoCD automatically applies the change to the cluster.
This ensures that the cluster state always matches what is defined in Git.

---

## Rollback Strategy

Rollback is handled through Git.

If a faulty deployment occurs, the Git commit is reverted.
ArgoCD detects this change and automatically restores the previous stable version of the application.

This makes rollback simple, fast, and reliable.

---

## Failure Handling

Common failure scenarios are handled as follows:

- If the application crashes, Kubernetes restarts the pod automatically
- If Jenkins is unavailable, deployments are still managed through GitOps
- If a Kubernetes node fails, pods are rescheduled to healthy nodes
- If a secret is compromised, it is rotated and redeployed

---

## Monitoring and Operations

Monitoring is focused on infrastructure and application health.

Key aspects include:
- Pod CPU and memory usage
- Pod restart counts
- Node health status

Logs and Kubernetes events are used to detect and investigate issues early.
Only critical issues are configured to trigger alerts.

---

## Proof of Implementation

Screenshots demonstrating successful pipeline execution, Docker image availability, Kubernetes deployment, and ArgoCD synchronization are available in the `screenshots/` directory.

## Demo Screenshots
01-github-repository-structure

![01-github-repository-structure](https://github.com/user-attachments/assets/cce45496-be8e-4915-98b9-da58127aaf56)

02-jenkins-pipeline-success

![02-jenkins-pipeline-success](https://github.com/user-attachments/assets/7485ca52-eb36-4a99-8023-08bd7caaa48d)

03-aws-ecr-image

![03-aws-ecr-image](https://github.com/user-attachments/assets/04d0d832-f6a4-4e67-95ba-06bdfd51d5df)

04-kubernetes-pods

![04-kubernetes-pods](https://github.com/user-attachments/assets/2dcd46ca-a868-4727-b388-00e50343a6d2)

05-argocd-application

![05-argocd-application](https://github.com/user-attachments/assets/5059be8d-a601-4720-851a-e215132352f0)

06-argocd-synced

![06-argocd-synced](https://github.com/user-attachments/assets/ff398add-3d40-44c6-ae2d-529cc3205182)







