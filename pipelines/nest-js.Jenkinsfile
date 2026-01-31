pipeline {
    agent any

    environment {
        NODE_LABEL = 'your_node_label'
        IMAGE_NAME = 'backend_image'
        CONTAINER_NAME = 'backend_container'
    }

    stages {
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
            // Add actions to be executed on successful completion of pipeline
            echo 'Pipeline completed successfully'
        }
    }
}