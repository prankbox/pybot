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