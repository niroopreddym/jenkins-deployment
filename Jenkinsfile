pipeline {
    agent any

    environment {
        AZURE_FUNCTION_APP = 'co2emissions'
        AZURE_RG = 'azure-functions-rg'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Azure Login') {
            steps {
                withCredentials([azureServicePrincipal('AZURE_CREDENTIALS')]) {
                    sh '''
                        az login --service-principal \
                          -u $AZURE_CLIENT_ID \
                          -p $AZURE_CLIENT_SECRET \
                          --tenant $AZURE_TENANT_ID
                        az account set --subscription $AZURE_SUBSCRIPTION_ID
                    '''
                }
            }
        }

        stage('Deploy Function App') {
            steps {
                dir('testfunction') {
                    sh 'func azure functionapp publish $AZURE_FUNCTION_APP'
                }
            }
        }
    }
}