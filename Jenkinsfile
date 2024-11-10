pipeline {
    
    environment {
        registry = "eranzaksh/infinity" 
        registryCredential = 'docker-hub' 
        GIT_COMMIT = ''
        API_KEY = credentials('visual-crossing-api')
        helmName = "eran-app2"
    }


    agent {
        docker {
            label 'eee'
            image "eranzaksh/jenkins-agent:python"
            args '-u 0:0 -v /var/run/docker.sock:/var/run/docker.sock'
            alwaysPull true
        }
    }

    stages {
        stage("Clone Git Repository") {
            steps {
                checkout scm 
            
            }
        }
        

        // Here GIT_COMMIT comes from the first job and is a trigger for this job
        stage("deploy to eks") {
            steps {
                script {
                    withAWS(credentials:'aws-access-and-secret') {
                        sh """
                        aws eks update-kubeconfig --region eu-north-1 --name tf-eks
                        kubectl get nodes
                        helm upgrade --install ${helmName} *.tgz   \
                            --set secret.key=${API_KEY} \
                            --set image.tag=${params.BUILD}-${params.GIT_COMMIT}
                        """
                    }
                    
                }
            }
        }
    
 
    }     
    post {
        always {
            cleanWs()   
        }

        success {
          slackSend channel: 'succeeded-build', color: 'good', message: "Build successful: Job '${env.JOB_NAME}-${env.BUILD_NUMBER} ${STAGE_NAME}'"
        }
    
        failure {
          slackSend channel: 'devops-alerts', color: 'danger', message: "Build failed: Job '${env.JOB_NAME}-${env.BUILD_NUMBER} ${STAGE_NAME}'"
        }

}
    
}
