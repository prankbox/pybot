pipeline{
    agent {label 'agent1'}
    parameters {
        booleanParam(name: "CREATE", defaultValue: false)
        choice(name: "LAMBDA", choices: ["CREATE", "UPDATE"])
    }
    environment {
        TF_VAR_lambda_function_name = "lambda-bot"
        TF_VAR_token = credentials('bot-token')
        TELEGRAM_BOT_KEY = credentials('bot-token')
        AWS_ACCOUNT = "889527205817"
        REGION = "us-east-1"
        ROLE_NAME="lambda-ex"
        AWS_ACCESS_KEY_ID = credentials("aws-id")
        AWS_SECRET_ACCESS_KEY = credentials("aws-key")
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
            steps{
                 sh 'scripts/aws_create_repo.sh'
            }
        }

        stage("Push"){
            steps{
 
                sh 'scripts/aws_push_image.sh' 
            }
        }
        stage("CreateLambdaRole"){
            steps{

                sh 'scripts/aws_create_lambda_role.sh'
            }
        }

        stage("CreateLambdaFunction"){
            environment{
                        TF_VAR_image_tag = "$BUILD_TAG"
                        TF_VAR_region = "$REGION"
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