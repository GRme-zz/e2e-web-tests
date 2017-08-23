pipeline {
  agent any

  parameters {
    text(defaultValue: 'grme/nightwatch-chrome-firefox:0.0.3', description: '', name: 'docker_image')
  }

  stages {
    stage('Test') {
      steps {
        echo '===START==='
        sh 'pwd'
        echo "${params.docker_image}"
        echo '===STOP==='
      }
    }
  }
}
