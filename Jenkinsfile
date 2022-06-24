pipeline{
    agent {label 'agent1'}

    stages{
        stage("Git"){
            steps{
                git 'https://github.com/prankbox/pybot'

            }
        }

        stage("Build"){
            steps{
                sh 'docker build -t bot:$BUILD_TAG .'
                sh 'docker images'
                sh 'aws --version'
            }
        }

        stage("Push"){
            steps{
                withCredentials([<object of type com.cloudbees.jenkins.plugins.awscredentials.AmazonWebServicesCredentialsBinding>]) {
                sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 006104586502.dkr.ecr.us-east-1.amazonaws.com/bot'
            }
                

            }
        }
    }
}