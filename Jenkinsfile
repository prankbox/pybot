pipeline{
    agent {label 'agent1'}
    environment {
        AWS_ACCOUNT = "795939032463"
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
                    sh 'aws ecr get-login-password --region ${REGION}| docker login --username AWS --password-stdin $AWS_ACCOUNT.dkr.ecr.$REGION.amazonaws.com/bot'
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
            ]]) {
                sh 'aws iam create-role --role-name "$ROLE_NAME" --assume-role-policy-document file://policy.json'
                //sh 'aws iam create-role --role-name "$ROLE_NAME" --assume-role-policy-document \'{"Version": "2012-10-17","Statement": [{ "Effect": "Allow", "Principal": {"Service": "lambda.amazonaws.com"}, "Action": "sts:AssumeRole"}]}\''
                sh 'aws iam attach-role-policy --role-name "$ROLE_NAME" --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole'
                sh 'sleep 5'
                sh 'aws lambda create-function \
                    --region "$REGION" \
                    --role arn:aws:iam::"$AWS_ACCOUNT":role/"$ROLE_NAME" \
                    --function-name lambda-bot \
                    --package-type Image \
                    --environment "Variables={TELEGRAM_TOKEN=$TELEGRAM_BOT_KEY}" \
                    --code ImageUri="$AWS_ACCOUNT".dkr.ecr."$REGION".amazonaws.com/bot:"$BUILD_TAG"'
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