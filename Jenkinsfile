pipeline {
  agent any
 
  stages {
    stage('Prebuild') {
      steps {
        withAWS(credentials: 'devops_jenkins') {
          sh label: 'CreateECRRepository', script: './ci/prebuild/create_ecr_repository.sh'
        }
      }
    }
    stage('Build') {
      steps {
        withAWS(credentials: 'devops_jenkins', region: 'ca-central-1') {
          sh label: 'BuildAndPushDockerImage', script: './ci/build/build_push_docker_image.sh' 
        }
      }
    }
    stage('Destroy') {
      input{
        message "Do you want to destroy the application?"
      }
      steps {
        withAWS(credentials: 'devops_jenkins') {
          sh label: 'DeleteECRRepository', script: './ci/destroy/delete_ecr_repository.sh'
        }
      }
    }
  }
}