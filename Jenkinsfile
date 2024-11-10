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
                        // helm upgrade --install ${helmName} ./weather-helm/*.tgz   \
                        //     --set secret.key=${API_KEY} \
                        //     --set image.tag=${params.BUILD}-${params.GIT_COMMIT}

        // Here GIT_COMMIT comes from the first job and is a trigger for this job
        stage("deploy to eks") {
            steps {
                script {
                    withAWS(credentials:'aws-access-and-secret') {
                        sh """
                        aws eks update-kubeconfig --region eu-north-1 --name tf-eks
                        yq -i '.image.tag = "'${params.BUILD}-${params.GIT_COMMIT}'"' weather-helm/eran-app2/values.yaml
                        """
                    }
                    
                }
            }
        }
stage('git push') {
    steps {
        withCredentials([
            sshUserPrivateKey(credentialsId: 'github-for-jobs', keyFileVariable: 'SSH_KEY', usernameVariable: 'GIT_USER')
        ]) {
            sh "git config --global --add safe.directory '*'"
            sh '''
                 git add .
                 git commit -m "update values.yaml"

                 # Push changes using SSH key
                 GIT_SSH_COMMAND="ssh -i $SSH_KEY" git push
            '''
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
