pipeline{
    agent {label 'agent1'}

    stages{
        stage("Git"){
            step{
                git 'https://github.com/prankbox/pybot'
            }
        }

        stage("Check"){
            step{
                sh 'ls -lah'
            }
        }
    }
}