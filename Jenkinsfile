pipeline {
  agent any

  parameters {
    string(defaultValue: 'grme/nightwatch-chrome-firefox:0.0.3', description: '', name: 'docker_image')
    string(defaultValue: 'npm-test-chrome', description: '', name: 'run_script_method')
    string(defaultValue: '/Applications/Docker.app/Contents/Resources/bin/docker', description: '', name: 'docker')
  }

  stages {
    stage('Test') {
      steps {
        sh "sudo chmod -R 777 \$(pwd)"
      }
    }
  }

  post {
    always {
      echo "------ generate Cucumber report ------"
      cucumber "**/cucumber.json"
    }
  }
}
