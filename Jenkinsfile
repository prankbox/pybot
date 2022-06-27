pipeline{
    agent {label 'agent1'}
    parameters {
        booleanParam(name: "CREATE", defaultValue: false)
        choice(name: "LAMBDA", choices: ["CREATE", "UPDATE"])
    }
    environment {
        AWS_ACCOUNT = "526469428739"
        REGION = "us-east-1"
        ROLE_NAME="lambda-ex"
    }

    stages{
        stage("Git"){
            steps{
                git 'https://github.com/prankbox/pybot'

            }
        }

        stage("Build"){
            steps{
                sh './aws_build.sh'
            }
        }

        stage("Repo"){
            parallel{
                stage("Create"){
                    when { expression { params.CREATE } }
                    steps{
                        withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: "aws-jenkins",
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ]]) {
                            
                            sh './aws_create_repo.sh'
                        }
                    }
                }

                stage("Pass"){
                    when { expression { !params.CREATE } }
                    steps{
                        sh 'echo "The repo exists"'
                    }
                }
            }
            
        }

        stage("Push"){
            steps{
                withCredentials([[
                $class: 'AmazonWebServicesCredentialsBinding',
                credentialsId: "aws-jenkins",
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
            ]]) {
                    sh './aws_push_image.sh'
                }   

            }
        }
        stage("CreateLambdaRole"){
            steps{
                withCredentials([[
                $class: 'AmazonWebServicesCredentialsBinding',
                credentialsId: "aws-jenkins",
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
            ]]){
                sh './aws_create_lambda_role.sh'
            }
            }
        }

        stage("CreateLambdaFunction"){
            environment { 
                TELEGRAM_BOT_KEY = credentials('bot-token') 
            }

            steps{
                withCredentials([[
                $class: 'AmazonWebServicesCredentialsBinding',
                credentialsId: "aws-jenkins",
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
            ]]) {
                sh './aws_create_lambda_function.sh'
                }
            }
        }
        stage("Clean"){
            steps{
                sh 'terraform --version'
                sh 'docker image rm -f $(docker images -q) || echo true'
            }
        }
    }
}