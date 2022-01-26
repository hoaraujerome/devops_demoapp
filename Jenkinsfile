pipeline {
  agent any
 
  stages {
    stage('Prebuild') {
      steps {
        withAWS(credentials: 'devops_jenkins') {
          sh label: 'TerraformInit', script: 'terraform -chdir=./terraform/prebuild init' 
          sh label: 'TerraformApply', script: 'terraform -chdir=./terraform/prebuild apply --auto-approve' 
        }
      }
    }
    stage('Build') {
      steps {
        sh 'echo SUCCESS'
      }
    }
  }
}