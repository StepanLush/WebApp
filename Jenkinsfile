pipeline {
    agent any

    environment {
        ARM_CLIENT_ID = credentials('ARM_CLIENT_ID')
        ARM_CLIENT_SECRET = credentials('ARM_CLIENT_SECRET')
        ARM_TENANT_ID = credentials('ARM_TENANT_ID')
        ARM_SUBSCRIPTION_ID = credentials('ARM_SUBSCRIPTION_ID')
        WORK_DIR = "${WORKSPACE}/ansible"
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

        stage('Terraform Refresh') {
            steps {
                dir('terraform') {
                    sh 'terraform refresh'
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

        stage('Prepare Environment') {
            steps {
                script {
                    // Создаем директорию, если её нет
                    sh 'mkdir -p $WORK_DIR/playbooks/fetch/fetch_secrets/defaults/'
                }
                withCredentials([file(credentialsId: 'ANSIBLE_FETCH_MAIN_YML', variable: 'FETCH_MAIN_YML_CONTENT')]) {
                    sh """
                        cp ${FETCH_MAIN_YML_CONTENT} $WORK_DIR/playbooks/fetch/fetch_secrets/defaults/main.yml
                    """
                }
            }
        }

        stage('Fetch Secrets') {
            steps {
                script {
                    sh """
                        whoami
                        pwd
                        ls -la
                        sudo -S ls -la /home/stepan/ansible_azure_venv/bin/activate
                        sleep 10000
                        sudo -S . /home/stepan/ansible_azure_venv/bin/activate
                        sudo -S ansible-playbook ansible/playbooks/fetch/fetch_secrets.yml -vvv
                    """
                }
            }
        }

        stage('Setup and deploy with Ansible') {
            steps {
                script {
                    sh '''
                    ansible-playbook -i ansible/hosts ansible/playbooks/site.yml
                    '''
                }
            }
        }
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
