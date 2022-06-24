pipeline{
    agent {label 'agent1'}

    stages{
        stage("Git"){
            steps{
                git 'https://github.com/prankbox/pybot'
            }
        }

        stage("Check"){
            steps{
                sh 'ls -lah'
            }
        }
    }
}