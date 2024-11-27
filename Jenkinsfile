pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'docker.io/taeyoondev/jenkins-test'  // Docker Hub 리포지토리 이름
        DOCKER_HUB_CREDENTIALS = 'docker-hub-credentials'  // Jenkins에 설정한 Docker Hub 자격증명 이름
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Docker 이미지 빌드
                    sh "docker build -t $DOCKER_IMAGE ."
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    // Docker Hub에 로그인
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    // Docker 이미지를 Docker Hub에 푸시
                    sh "docker push $DOCKER_IMAGE"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Deployment, Service, Ingress 리소스 생성
                    sh '''
                    kubectl apply -f /k8s/deployment.yaml
                    kubectl apply -f /k8s/service.yaml
                    '''
                    
                    // 이미지 업데이트 (이미지가 이미 존재하는 경우)
                    sh '''
                    kubectl set image deployment/python-app python-app=$DOCKER_IMAGE --record
                    kubectl rollout status k8s/deployment/python-app
                    '''
                }
            }
        }
    }
}
