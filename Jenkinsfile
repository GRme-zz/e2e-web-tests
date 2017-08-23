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
        echo "------ stop all Docker containers ------"
        sh "(sudo ${params.docker} stop \$(sudo ${params.docker} ps -a -q) || echo \"------ all Docker containers are still stopped ------\")"
        echo "------ remove all Docker containers ------"
        sh "(sudo ${params.docker} rm \$(sudo ${params.docker} ps -a -q) || sudo echo \"------ all Docker containers are still removed ------\")"
        echo "------ pull Docker image from Docker Cloud ------"
        sh "sudo ${params.docker} pull \"${params.docker_image}\""
        echo "------ start Docker container from image ------"
        sh "sudo ${params.docker} run -d -t -i -v \$(pwd):/my_tests/ \"${params.docker_image}\" /bin/bash"
        echo "------ execute end2end tests on Docker container ------"
        sh "sudo ${params.docker} exec -i \$(sudo ${params.docker} ps --format \"{{.Names}}\") bash -c \"cd /my_tests && (xvfb-run --server-args=\'-screen 0 1600x1200x24\' npm run ${params.run_script_method} || true) && google-chrome --version && firefox --version && npm outdated\""
        echo "------ cleanup all temporary files ------"
        sh "sudo rm -Rf \$(pwd)/tmp-*"
        sh "sudo rm -Rf \$(pwd)/.com.google*"
        sh "sudo rm -Rf \$(pwd)/rust_mozprofile*"
        sh "sudo rm -Rf \$(pwd)/.org.chromium*"
        echo "------ stop all Docker containers again ------"
        sh "(sudo ${params.docker} stop \$(sudo ${params.docker} ps -a -q) || sudo echo \"------ all Docker containers are still stopped ------\")"
        echo "------ remove all Docker containers again ------"
        sh "(sudo ${params.docker} rm \$(sudo ${params.docker} ps -a -q) || sudo echo \"------ all Docker containers are still removed ------\")"
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
