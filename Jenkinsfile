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
        echo "=========================================="
        sh "sudo ${params.docker} ps -a"
        sh "echo "*******blablabla*******""
        echo "=========================================="
      }
    }
  }

  post {
    always {
      cucumber '**/cucumber.json'
    }
  }
}
