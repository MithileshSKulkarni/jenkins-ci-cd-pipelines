def DEVELOPERS = ['*Developer name* and *Developer name*']
pipeline {
    agent any
    environment {
        JAVA_HOME = '/usr/lib/jvm/java-17-openjdk-amd64'
        MAVEN_HOME = '/opt/apache-maven-3.9.6'
        IMAGE_NAME = 'backend_image'
        CONTAINER_NAME = 'backend_container'
    }
    options {
        skipStagesAfterUnstable()
    }
    stages {
        stage('Notify Start') {
            steps {
                script {
                    // Send notification on pipeline start
                    slackSend(
                        color: '#FFFF00',
                        message: "Backend pipeline started for ${env.JOB_NAME} #${env.BUILD_NUMBER} by ${env.USER}. Please wait until it gets finished.",
                        channel: '#slack_channel', // Slack channel
                        teamDomain: 'Team_Domain', // Your Slack team domain
                        tokenCredentialId: 'your_ID' // Slack token credential ID
                    )
                }
            }
        }
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Prepare Maven Wrapper') {
            steps {
                script {
                    // Ensure mvnw has executable permissions
                    sh 'chmod +x mvnw'
                }
            }
        }
        stage('Determine Next Version') {
            steps {
                script {
                    // Get the current highest version of the Docker image
                    def currentVersion = sh(script: "docker images --format '{{.Tag}}' ${IMAGE_NAME} | sort -V | tail -n 1", returnStdout: true).trim()
                    echo "Current version: ${currentVersion}"
                    // Determine the next version
                    def nextVersion
                    if (currentVersion) {
                        def parts = currentVersion.tokenize('.')
                        parts[-1] = (parts[-1].toInteger() + 1).toString()
                        nextVersion = parts.join('.')
                    } else {
                        nextVersion = '1.0'
                    }
                    echo "Next version: ${nextVersion}"
                    env.VERSION = nextVersion
                }
            }
        }
        stage('Cleanup Docker') {
            steps {
                script {
                    // Stop and remove the existing container if it exists (running or stopped)
                    sh """
                    if [ \$(docker ps -aq -f name=${CONTAINER_NAME}) ]; then
                        docker stop ${CONTAINER_NAME} || true
                        docker rm ${CONTAINER_NAME}
                    fi
                    """
                    // Prune unused build cache
                    sh 'docker builder prune -f'
                    // Remove old Docker images (keep the latest two)
                    def oldImages = sh(script: "docker images --format '{{.Repository}}:{{.Tag}}' ${IMAGE_NAME} | sort -V | head -n -2", returnStdout: true).trim()
                    if (oldImages) {
                        oldImages.split('\\n').each { image ->
                            sh "docker rmi ${image}"
                        }
                    } else {
                        echo "No old images to remove."
                    }
                }
            }
        }
        stage('Build and Package') {
            steps {
                script {
                    // Build and package in one step
                    sh './mvnw clean package -DskipTests'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image with the new version
                    sh """
                    docker build -t ${IMAGE_NAME}:${VERSION} .
                    """
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    // Run the Docker container with the new version
                    sh """
                    docker run -d --name ${CONTAINER_NAME} -p host_port:container_port -e TZ=Asia/Kolkata -v image_data:/app/images --network your_network ${IMAGE_NAME}:${VERSION}
                    """
                }
            }
        }
    }
    post {
        success {
            echo 'Build and deploy succeeded!'
            // Archive the WAR file (or other artifacts)
            archiveArtifacts artifacts: 'target/*.war', allowEmptyArchive: true
            // Send notification on success
            slackSend(
                color: '#36A64F',
                message: "Backend pipeline successful for ${env.JOB_NAME} #${env.BUILD_NUMBER} by ${env.USER}, developed by ${DEVELOPERS.join(' and ')}\nPipeline URL: ${env.BUILD_URL}",
                channel: '#slack_channel', // Slack channel
                teamDomain: 'Team_Domain', // Your Slack team domain
                tokenCredentialId: 'your_ID' // Slack token credential ID
            )
        }
        failure {
            echo 'Build or deploy failed.'
            // Send notification on failure
            slackSend(
                color: '#FF0000',
                message: "Backend pipeline failed for ${env.JOB_NAME} #${env.BUILD_NUMBER} by ${env.USER}, developed by ${DEVELOPERS.join(' and ')}\nPipeline URL: ${env.BUILD_URL}",
                channel: '#slack_channel', // Slack channel
                teamDomain: 'Team_Domain', // Your Slack team domain
                tokenCredentialId: 'your_ID' // Slack token credential ID
            )
        }
        always {
            echo "Sending email notification." // Just an echo to indicate the email would have been sent
        }
    }
}