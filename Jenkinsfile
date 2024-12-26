pipeline {
    agent any

    environment {
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/StepanLush/WebApp.git'
            }
        }

        stage('Load Terraform Variables') {
            steps {
                dir('terraform') {
                    withCredentials([file(credentialsId: 'terraform-vars', variable: 'TFVARS_FILE')]) {
                        sh """
                            cp ${TFVARS_FILE} terraform.tfvars
                        """
                    }
                }
            }
        }

        stage('Load Credentials') {
            steps {
                withCredentials([
                    string(credentialsId: 'ARM_CLIENT_ID', variable: 'ARM_CLIENT_ID'),
                    string(credentialsId: 'ARM_CLIENT_SECRET', variable: 'ARM_CLIENT_SECRET'),
                    string(credentialsId: 'ARM_TENANT_ID', variable: 'ARM_TENANT_ID'),
                    string(credentialsId: 'ARM_SUBSCRIPTION_ID', variable: 'ARM_SUBSCRIPTION_ID')
                ]) {
                    script {
                        echo "Using Azure credentials for authentication"
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init -var-file=terraform.tfvars'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('terraform') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan -out=tfplan -var-file=terraform.tfvars'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve -var-file=terraform.tfvars'
                }
            }
        }

    //     stage('Ansible - Retrieve Secrets') {
    //         steps {
    //             script {
    //                 // Запуск playbook для получения секретов из Key Vault
    //                 ansiblePlaybook(
    //                     playbook: 'ansible/retrieve_secrets.yml',
    //                     inventory: 'inventory/servers.ini'
    //                 )
    //             }
    //         }
    //     }

    //     stage('Ansible - Deploy') {
    //         steps {
    //             script {
    //                 // Запуск playbook для конфигурации и деплоя приложения
    //                 ansiblePlaybook(
    //                     playbook: 'ansible/deploy.yml',
    //                     inventory: 'inventory/servers.ini'
    //                 )
    //             }
    //         }
    //     }

    //     stage('Notify Success') {
    //         steps {
    //             script {
    //                 // Отправка уведомления об успешном деплое
    //                 echo "Deployment completed successfully!"
    //                 // Можно использовать Slack, Email или другие уведомления
    //             }
    //         }
    //     }
    }

    post {
        failure {
            script {
                // Отправка уведомлений в случае ошибки
                echo "Pipeline failed"
                // Здесь можно добавить отправку уведомлений о сбое (например, в Slack)
            }
        }
        success {
            script {
                // Отправка уведомлений об успехе
                echo "Pipeline succeeded"
                // Также можно отправить уведомление о успешном выполнении
            }
        }
    }
    
}
