pipeline {
    agent any
    tools {
    terraform 'terraform'
}

    stages {
        stage('Defaul Stage') {
            steps {
                echo 'Hello World..!!'
            }
        }
        
    stage('Git Checkout') {
            steps {
              git branch: 'master', credentialsId: 'nikhil-github', url: 'https://github.com/nikhilpatne/azure-useronboarding-terraform.git'
            }
        }
        
        
    stage('Terraform init') {
            when { expression { !params.is_destroy } }
            steps {
              sh 'terraform init'
            }
        }
        
        
    stage('Terraform Plan') {
            when { expression { !params.is_destroy } }
            steps {
                
                    withCredentials([azureServicePrincipal(
                    credentialsId: 'nikhil-azure-subscription',
                    subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',
                    clientIdVariable: 'ARM_CLIENT_ID',
                    clientSecretVariable: 'ARM_CLIENT_SECRET',
                    tenantIdVariable: 'ARM_TENANT_ID'
                )]) {

                        sh """
                        echo "Panning the infrastructure"
                        terraform plan -lock=false -var "user_principal_name=$user_principal_name" -var "display_name=$display_name" -var "user_profile=$user_profile" -var "company_name=$company_name" -var "job_title=$job_title" -var "mobile_number=$mobile_number" -var "project_name=$project_name" -var "virtual_machine_prefix=$virtual_machine_prefix" -var "vm_username=$vm_username" -var "vm_password=$vm_password"
                        """
                                }
                }
                
        }
        
        stage("Approval") {
            steps {
                input("Are you sure to perform terraform apply ? this will execute your plan and create infrastructure")
            }
        }
        
        stage('Terraform apply') {
            when { expression { !params.is_destroy } }

            steps {
                
                    withCredentials([azureServicePrincipal(
                    credentialsId: 'nikhil-azure-subscription',
                    subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',
                    clientIdVariable: 'ARM_CLIENT_ID',
                    clientSecretVariable: 'ARM_CLIENT_SECRET',
                    tenantIdVariable: 'ARM_TENANT_ID'
                )]) {

                        sh """
                        echo "Applying the plan"
                        terraform apply -auto-approve -lock=false -var "user_principal_name=$user_principal_name" -var "display_name=$display_name" -var "user_profile=$user_profile" -var "company_name=$company_name" -var "job_title=$job_title" -var "mobile_number=$mobile_number" -var "project_name=$project_name" -var "virtual_machine_prefix=$virtual_machine_prefix" -var "vm_username=$vm_username" -var "vm_password=$vm_password"
                        """
                                }
                }
                
        }
        
        stage('terraform output') {
            when { expression { !params.is_destroy } }
            steps {
                sh 'terraform output > azure_credentials.txt'
                sh 'terraform output'
            }
        }
        
        stage('Sending email') {
              when { expression { !params.is_destroy } }
            steps {
                sh 'python3 send_email.py $display_name $USER_EMAIL $mobile_number'
            }
        }
        
        stage("Terraform destroy") {
            when { expression { params.is_destroy } }
           steps {
                
                    withCredentials([azureServicePrincipal(
                    credentialsId: 'nikhil-azure-subscription',
                    subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',
                    clientIdVariable: 'ARM_CLIENT_ID',
                    clientSecretVariable: 'ARM_CLIENT_SECRET',
                    tenantIdVariable: 'ARM_TENANT_ID'
                )]) {

                        sh """
                        echo "Destroying the infrastructure"
                        terraform destroy -auto-approve -lock=false -var "user_principal_name=$user_principal_name" -var "display_name=$display_name" -var "user_profile=$user_profile" -var "company_name=$company_name" -var "job_title=$job_title" -var "mobile=$mobile"
                        """
                                }
                }
             
        }
    }
}
