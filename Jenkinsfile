pipeline {
    
    environment {
        GIT_COMMIT = ''
        API_KEY = credentials('visual-crossing-api')
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

        // Here GIT_COMMIT var comes from the first job and is a trigger for this job
        stage("update configuration files") {
            steps {
                script {
                    sh """
                    yq -i '.image.tag = "'${params.BUILD}-${params.GIT_COMMIT}'"' weather-helm/eran-app2/values.yaml
                    """
                }
            }
        }
    stage('git push') {
        steps {
            withCredentials([
                sshUserPrivateKey(credentialsId: 'github-for-jobs', keyFileVariable: 'SSH_KEY', usernameVariable: 'GIT_USER')
            ]) {
                script {
                    // Ensure the repository directory is safe
                    sh 'git config --global --add safe.directory /home/ec2-user/workspace/project-cd'

                    // Configure Git user
                    sh '''
                    git config user.name "Jenkins Bot"
                    git config user.email "jenkins@example.com"

                    # Ensure the remote URL is set to SSH
                    git remote set-url origin git@github.com:eranzaksh/argocd.git

                    # Add GitHub's SSH key to known_hosts to prevent "Host key verification failed"
                    mkdir -p ~/.ssh
                    ssh-keyscan github.com >> ~/.ssh/known_hosts

                    # Add and commit changes
                    git add .
                    git commit -m "update values.yaml" || echo "No changes to commit"

                    # Push changes using SSH key
                    GIT_SSH_COMMAND="ssh -i $SSH_KEY" git push origin HEAD:main
                    '''
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
