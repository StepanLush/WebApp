pipeline {
    agent any

    environment {
        ARM_CLIENT_ID = ''
        ARM_CLIENT_SECRET = ''
        ARM_TENANT_ID = ''
        ARM_SUBSCRIPTION_ID = ''
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

        stage('Azure Login') {
            steps {
                withCredentials([file(credentialsId: 'terraform-vars', variable: 'TFVARS_FILE')]) {
                    script {
                        // Читаем содержимое файла terraform.tfvars
                        def tfvarsContent = readFile("${TFVARS_FILE}")
                        
                        // Извлекаем значения переменных из файла tfvars с помощью регулярных выражений
                        def clientId = (tfvarsContent =~ /ARM_CLIENT_ID\s*=\s*"([^"]+)"/)[0][1]
                        def clientSecret = (tfvarsContent =~ /ARM_CLIENT_SECRET\s*=\s*"([^"]+)"/)[0][1]
                        def tenantId = (tfvarsContent =~ /ARM_TENANT_ID\s*=\s*"([^"]+)"/)[0][1]
                        def subscriptionId = (tfvarsContent =~ /ARM_SUBSCRIPTION_ID\s*=\s*"([^"]+)"/)[0][1]

                        // Устанавливаем переменные окружения для использования в Terraform
                        env.ARM_CLIENT_ID = clientId
                        env.ARM_CLIENT_SECRET = clientSecret
                        env.ARM_TENANT_ID = tenantId
                        env.ARM_SUBSCRIPTION_ID = subscriptionId

                        
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
