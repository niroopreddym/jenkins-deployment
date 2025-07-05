pipeline {
    agent any

    environment {
        AZURE_FUNCTION_APP = 'testfunction'
        AZURE_RG = 'your-resource-group'
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