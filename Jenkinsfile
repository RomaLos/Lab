pipeline {
    agent any
    
    environment {
        PACKAGE_NAME = 'count-files'
        VERSION = '1.0'
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
                    def image = docker.build("${PACKAGE_NAME}:${VERSION}")
                }
            }
        }
        
        stage('Test Script') {
            steps {
                sh 'bash count_files.sh'
            }
        }
        
        stage('Build Packages') {
            parallel {
                stage('Build RPM') {
                    steps {
                        sh '''
                            make clean
                            make rpm
                        '''
                        archiveArtifacts artifacts: 'build/rpm/RPMS/noarch/*.rpm', fingerprint: true
                    }
                }
                
                stage('Build DEB') {
                    steps {
                        sh '''
                            make clean
                            make deb
                        '''
                        archiveArtifacts artifacts: 'build/deb/*.deb', fingerprint: true
                    }
                }
            }
        }
        
        stage('Test Installation') {
            parallel {
                stage('Test RPM') {
                    steps {
                        script {
                            docker.image('fedora:latest').inside {
                                sh '''
                                    dnf install -y ./build/rpm/RPMS/noarch/*.rpm
                                    count-files
                                '''
                            }
                        }
                    }
                }
                
                stage('Test DEB') {
                    steps {
                        script {
                            docker.image('ubuntu:latest').inside {
                                sh '''
                                    apt-get update
                                    dpkg -i ./build/deb/*.deb || apt-get install -f -y
                                    count-files
                                '''
                            }
                        }
                    }
                }
            }
        }
        
        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                echo 'Deploying packages...'
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
