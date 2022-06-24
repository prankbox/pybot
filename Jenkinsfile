pipeline{
    agent {label 'agent1'}

    stages{
        stage("Git"){
            steps{
                git 'https://github.com/prankbox/pybot'
                sh 'curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip'
                sh 'unzip awscliv2.zip'
                sh 'sudo ./aws/install'
            }
        }

        stage("Build"){
            steps{
                sh 'docker build -t bot:$BUILD_TAG .'
                sh 'docker images'
                sh 'aws --version'
            }
        }
    }
}