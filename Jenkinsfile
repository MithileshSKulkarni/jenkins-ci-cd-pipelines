pipeline {

    agent any

    environment {
        IMAGE_BASE       = 'api'
        CONTAINER_NAME   = 'api'
        GIT_CREDENTIALS_ID = 'Git_ID'
        TARGET_BRANCH    = 'dev'

        // Use Jenkins workspace paths
        APP_DIR          = "${WORKSPACE}"
        DOCKERFILE_PATH  = "${WORKSPACE}/Dockerfile"
        ENV_FILE         = "${WORKSPACE}/.env"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: "*/${TARGET_BRANCH}"]],
                    userRemoteConfigs: [[
                        url: 'https://github.com/your/repo.git',
                        credentialsId: GIT_CREDENTIALS_ID
                    ]]
                ])
            }
        }

        stage('Determine Version (Auto Increment)') {
            steps {
                script {
                    echo "Fetching existing backend image versions..."

                    def lastVersion = sh(
                        script: """
                            docker images --format "{{.Tag}}" ${IMAGE_BASE} \
                            | grep -E "^[0-9]+\\.[0-9]+" \
                            | sort -V | tail -1 || true
                        """,
                        returnStdout: true
                    ).trim()

                    if (!lastVersion) {
                        echo "No existing image → starting version from 1.0"
                        lastVersion = "1.0"
                    }

                    def (major, minor) = lastVersion.tokenize('.')
                    minor = minor.toInteger() + 1
                    env.NEW_VERSION = "${major}.${minor}"

                    echo "New Version = ${env.NEW_VERSION}"
                }
            }
        }

        stage('Clean Up Old Container') {
            steps {
                script {
                    echo "Cleaning old containers if any..."

                    def exists = sh(
                        script: "docker ps -a --format '{{.Names}}' | grep -w ${CONTAINER_NAME} || true",
                        returnStatus: true
                    )

                    if (exists == 0) {
                        echo "Stopping old container..."
                        sh "docker stop ${CONTAINER_NAME} || true"

                        echo "Removing old container..."
                        sh "docker rm ${CONTAINER_NAME} || true"
                    } else {
                        echo "No old container found (first deploy)"
                    }
                }
            }
        }

        stage('Build New Docker Image') {
            steps {
                script {
                    env.FULL_IMAGE_NAME = "${IMAGE_BASE}:${env.NEW_VERSION}"
                    echo "Building image → ${env.FULL_IMAGE_NAME}"

                    sh """
                        docker build --no-cache \
                        -t ${env.FULL_IMAGE_NAME} \
                        -f ${DOCKERFILE_PATH} \
                        ${APP_DIR}
                    """
                }
            }
        }

        stage('Run New Container') {
            steps {
                script {
                    echo "Running container → ${CONTAINER_NAME}"

                    sh """
                        docker run -d --name ${CONTAINER_NAME} \
                        --network ctrine \
                        -p 8042:8042 \
                        --env-file ${ENV_FILE} \
                        ${env.FULL_IMAGE_NAME}
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✔ Deployment successful → Version ${env.NEW_VERSION}"
        }
        failure {
            echo "❌ Deployment failed!"
        }
    }
}