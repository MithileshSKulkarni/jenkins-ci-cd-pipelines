# Use the official Jenkins LTS image with JDK 17
FROM jenkins/jenkins:lts-jdk17

# Switch to root user to install Docker
USER root

# Install Docker CLI only (VERY lightweight)
RUN apt-get update && \
    apt-get install -y docker.io && \
    rm -rf /var/lib/apt/lists/*

# Allow Jenkins user to run Docker
RUN usermod -aG docker jenkins

# Switch back to Jenkins user
USER jenkins