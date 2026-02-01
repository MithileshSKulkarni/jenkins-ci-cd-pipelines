📦 Jenkins CI/CD Pipelines — DevOps Reference
📌 Overview

This repository contains reference Jenkins CI/CD pipelines along with a Docker-based Jenkins setup, designed to demonstrate real-world DevOps CI/CD workflows.

It reflects how Jenkins is used in production environments where:

Application source code is developed by engineering teams

DevOps engineers own build automation, containerization, and deployment pipelines

⚠️ This repository focuses on CI/CD ownership and automation patterns, not application source code.

🧱 Repository Structure

```text
jenkins-ci-cd-pipelines/
├── docker-jenkins-setup/
│   └── Dockerfile
├── pipelines/
│   ├── java-maven.Jenkinsfile
│   ├── nest-js.Jenkinsfile
│   └── react-app.Jenkinsfile
└── README.md

🔧 Jenkins Setup (Dockerized)
📁 docker-jenkins-setup/

This directory contains a custom Dockerfile for Jenkins, used to run Jenkins in a containerized environment.

Key Highlights

Jenkins deployed using Docker

Suitable for self-hosted CI/CD servers

Supports execution of pipelines defined via Jenkinsfiles

Mirrors real deployments on:

On-prem Ubuntu servers

Cloud VMs (AWS / E2E Networks)

Example Usage
docker build -t custom-jenkins .
docker run -d -p 8080:8080 custom-jenkins

🔁 CI/CD Pipelines
📁 pipelines/

This folder contains realistic Jenkinsfile implementations for multiple application stacks.

Each pipeline demonstrates:

GitHub SCM checkout

Dependency installation

Build & packaging stages

Docker image creation

Container-based deployment for development environments

🟢 Java (Maven) Pipeline

📄 java-maven.Jenkinsfile

Demonstrates:

Maven build lifecycle (clean, package)

Artifact generation

Docker image build for Java backends

Environment-aware deployment logic

Typical Use Case:
Enterprise Java backend applications (Spring Boot / REST APIs)

🟢 NestJS / Node.js Pipeline

📄 nest-js.Jenkinsfile

Demonstrates:

Node.js dependency management

Build and test stages

Docker image creation

Containerized backend deployment flow

Typical Use Case:
Modern backend APIs built with NestJS / Node.js

🟢 React Frontend Pipeline

📄 react-app.Jenkinsfile

Demonstrates:

Frontend build automation

Static asset generation

Dockerized frontend deployment

Optimized multi-stage builds

Typical Use Case:
React / SPA applications deployed behind Nginx or reverse proxies

🧠 CI/CD Concepts Demonstrated

Declarative Jenkins pipelines

Multi-stage CI/CD workflows

GitHub integration for source control

Docker-based build and deployment

Environment separation (dev-focused pipelines)

Pipeline reusability across multiple tech stacks

🏗️ Real-World CI/CD Workflow
Developer Commit
      ↓
GitHub Repository
      ↓
Jenkins Pipeline Trigger
      ↓
Build & Package
      ↓
Docker Image Build
      ↓
Container Deployment (Dev)


This workflow closely reflects enterprise-grade DevOps CI/CD practices.