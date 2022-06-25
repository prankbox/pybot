pipeline{
    agent {label 'agent1'}
    environment {
        AWS_ACCOUNT = "349685560242"
        REGION = "us-east-1"
    }

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
                    sh 'aws ecr get-login-password --region $REGION| docker login --username AWS --password-stdin $AWS_ACCOUNT.dkr.ecr.$REGION.amazonaws.com/bot'
                    sh 'docker tag bot:$BUILD_TAG $AWS_ACCOUNT.dkr.ecr.$REGION.amazonaws.com/bot:$BUILD_TAG'
                    sh 'docker push $AWS_ACCOUNT.dkr.ecr.$REGION.amazonaws.com/bot:$BUILD_TAG'
                }   

            }
        }

        stage("Lambda"){
            environment { 
                TELEGRAM_BOT_KEY = credentials('bot-token') 
            }

            steps{
                withCredentials([[
                $class: 'AmazonWebServicesCredentialsBinding',
                credentialsId: "aws-jenkins",
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
            ]] {
                sh 'aws lambda create-function \
                    --role arn:aws:iam::$AWS_ACCOUNT:role/fn_lambda_role \
                    --function-name lambda-bot \
                    --package-type Image \
                    --environment {TELEGRAM_TOKEN=$TELEGRAM_BOT_KEY}
                    --code ImageUri=$AWS_ACCOUNT.dkr.ecr.$REGION.amazonaws.com/bot:$BUILD_TAG'
                }
            }
        }
    }
}