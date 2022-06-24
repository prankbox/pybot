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
    }
}