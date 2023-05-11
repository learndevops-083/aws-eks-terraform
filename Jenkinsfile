pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    stages {
        stage('prepare workspace') {
            steps {
                sh 'rm -rf *'
                git branch: 'master', url: 'https://github.com/learndevops-083/aws-eks-terraform.git'
                sh 'terraform init'
            }
        }
        stage('terraform apply') {
            steps {
                sh 'terraform apply -auto-approve'
                sh 'terraform output kubeconfig > ./kubeconfig.yaml'
                sh 'terraform output config_map_aws_auth > ./config_map_aws_auth.yaml'
                sh 'export KUBECONFIG=./kubeconfig.yaml'
            }
        }
        stage('add worker nodes') {
            steps {
                sh 'kubectl apply -f ./config_map_aws_auth.yaml '
                sh 'sleep 60'
            }
        }
        stage('deploy example application') {
            steps {    
                sh 'kubectl apply -f ./example/hello-kubernetes.yml --kubeconfig=./kubeconfig.yaml'
                sh 'kubectl get all --kubeconfig=./kubeconfig.yaml'
            }
        }
        stage('Run terraform destroy') {
            steps {
                input 'Run terraform destroy?'
            }
        }
        stage('terraform destroy') {
            steps {
                sh 'kubectl delete -f ./example/hello-kubernetes.yml --kubeconfig=./kubeconfig.yaml'
                sh 'sleep 60'
                sh 'terraform destroy -force'
            }
        }
    }
}