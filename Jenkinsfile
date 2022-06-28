pipeline{
    agent {label 'agent1'}

    environment {
        TF_VAR_lambda_function_name = "lambda-bot"
        TF_VAR_token = credentials('bot-token')
        TELEGRAM_BOT_KEY = credentials('bot-token')
        AWS_ACCOUNT = "889527205817"
        REGION = "us-east-1"
        ROLE_NAME="lambda-ex"
        AWS_ACCESS_KEY_ID = credentials("aws-id")
        AWS_SECRET_ACCESS_KEY = credentials("aws-key")
        TF_VAR_region = "us-east-1"
    }

    stages{
        stage("Git"){
            steps{
                git 'https://github.com/prankbox/pybot'

            }
        }

        stage("Build"){
            steps{
                sh 'scripts/aws_build.sh'
            }
        }

        stage("Repo"){
            environment{
                TF_VAR_repo_name = "bot"
            }
            steps{
                 sh 'scripts/aws_create_repo.sh'
            }
        }

        stage("Push"){
            steps{
 
                sh 'scripts/aws_push_image.sh' 
            }
        }


        stage("CreateLambdaFunction"){
            environment{
                        TF_VAR_image_tag = "$BUILD_TAG"

                    }
            steps{

                sh 'scripts/aws_create_lambda_function.sh'
            }
        }

        stage("CreateAPIgateway"){
       
            steps{

                sh 'scripts/aws_create_api_gateway.sh'
            }
        }
        stage("Clean"){
            steps{
                sh 'scripts/clean.sh'
            }
        }
    }
}