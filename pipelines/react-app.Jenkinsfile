def DEVELOPERS = ['Developer_name', 'Developer_name', 'Developer_name'] // Names of the developers

pipeline {
    agent any
    environment {
        NODE_LABEL = 'your_node_label'
        IMAGE_NAME = 'frontend_image'
        CONTAINER_NAME = 'frontend_container'
    }
    stages {
        stage('Preparation') {
            steps {
                // Notify at the beginning of the build
                script {
                    slackSend(
                        color: '#FFFF00',
                        message: "Hi team,\nSla your pipeline build is started. Kindly wait for its completion. You will receive notifications here after it gets completed.",
                        channel: '#your_slack_channel', // Slack channel
                        teamDomain: 'your_domain', // Your Slack team domain
                        tokenCredentialId: 'your_id' // Slack token credential ID
                    )
                }
            }
        }
        stage('Clean Up') {
            steps {
                script {
                    def containerExists = sh(script: "docker ps -a --format '{{.Names}}' | grep -w ${CONTAINER_NAME}", returnStatus: true)
                    def containerIsRunning = sh(script: "docker inspect --format '{{.State.Running}}' ${CONTAINER_NAME}", returnStatus: true)
                    if (containerExists == 0) {
                        if (containerIsRunning == 0) {
                            echo "Stopping and removing the existing running container: $CONTAINER_NAME"
                            sh "docker stop $CONTAINER_NAME"
                        } else {
                            echo "Removing the stopped container: $CONTAINER_NAME"
                        }
                        sh "docker rm $CONTAINER_NAME"
                    } else {
                        echo "No existing container found with the name: $CONTAINER_NAME"
                    }
                }
            }
        }
        stage('Build Image') {
            steps {
                script {
                    // Build the Docker image
                    sh "docker build --no-cache -t $IMAGE_NAME ."
                }
            }
        }
        stage('Run Container') {
            steps {
                script {
                    // Run the Docker container
                    sh "docker run -d --name $CONTAINER_NAME -p host_port:container_port -e TZ=Asia/Kolkata --network your_network $IMAGE_NAME"
                }
            }
        }
    }
    post {
        success {
            // Send notification on success
            slackSend(
                color: '#36A64F',
                message: "your pipeline successful for ${env.JOB_NAME} #${env.BUILD_NUMBER} by ${env.USER}, developed by ${DEVELOPERS.join(' and ')}\nPipeline URL: ${env.BUILD_URL}",
                channel: '#your_slack_channel', // Slack channel
                teamDomain: 'your_domain', // Your Slack team domain
                tokenCredentialId: 'your_id' // Slack token credential ID
            )
        }
        failure {
            // Send notification on failure
            slackSend(
                color: '#FF0000',
                message: "your pipeline failed for ${env.JOB_NAME} #${env.BUILD_NUMBER} by ${env.USER}, developed by ${DEVELOPERS.join(' and ')}\nPipeline URL: ${env.BUILD_URL}",
                channel: '#your_slack_channel', // Slack channel
                teamDomain: 'your_domain', // Your Slack team domain
                tokenCredentialId: 'your_id' // Slack token credential ID
            )
        }
        always {
            echo "Sending email notification." // Just an echo to indicate the email would have been sent
        }
    }
}