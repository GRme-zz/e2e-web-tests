pipeline {
  agent any

  parameters {
    text(defaultValue: 'grme/nightwatch-chrome-firefox:0.0.3', description: '', name: 'docker_image')
    text(defaultValue: 'npm-test-chrome', description: '', name: 'run_script_method')
    text(defaultValue: '/Applications/Docker.app/Contents/Resources/bin/docker', description: '', name: 'docker')
  }

  stages {
    stage('Test') {
      steps {
        echo "=================================="
        sh 'docker ps -a'
        echo "=================================="
      }
    }
  }
}
