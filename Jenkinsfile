pipeline {
  agent any

  parameters {
    string(defaultValue: 'sudo', description: '', name: 'sudo')
    string(defaultValue: 'grme/nightwatch-chrome-firefox:0.0.5', description: '', name: 'docker_image')
    string(defaultValue: 'npm-test', description: '', name: 'run_script_method')
    string(defaultValue: 'chrome', description: '', name: 'browser')
    string(defaultValue: '--tag=run', description: '', name: 'tags')
    string(defaultValue: '/Applications/Docker.app/Contents/Resources/bin/docker', description: '', name: 'docker')
  }

  stages {
    stage('Test') {
      steps {
        sh "${params.sudo} chmod -R 777 \$(pwd)"
        echo "------ stop all Docker containers ------"
        sh "(${params.sudo} ${params.docker} stop \$(${params.sudo} ${params.docker} ps -a -q) || echo \"------ all Docker containers are still stopped ------\")"
        echo "------ remove all Docker containers ------"
        sh "(${params.sudo} ${params.docker} rm \$(${params.sudo} ${params.docker} ps -a -q) || ${params.sudo} echo \"------ all Docker containers are still removed ------\")"
        echo "------ pull Docker image from Docker Cloud ------"
        sh "${params.sudo} ${params.docker} pull \"${params.docker_image}\""
        echo "------ start Docker container from image ------"
        sh "${params.sudo} ${params.docker} run -d -t -i -v \$(pwd):/my_tests/ \"${params.docker_image}\" /bin/bash"
        echo "------ execute end2end tests on Docker container ------"
        sh "${params.sudo} ${params.docker} exec -i \$(${params.sudo} ${params.docker} ps --format \"{{.Names}}\") bash -c \"cd /my_tests && (xvfb-run --server-args=\'-screen 0 1600x1200x24\' npm run ${params.run_script_method} -- ${params.browser} ${params.tags} || true) && google-chrome --version && firefox --version\""
        echo "------ cleanup all temporary files ------"
        sh "${params.sudo} rm -Rf \$(pwd)/tmp-*"
        sh "${params.sudo} rm -Rf \$(pwd)/.com.google*"
        sh "${params.sudo} rm -Rf \$(pwd)/rust_mozprofile*"
        sh "${params.sudo} rm -Rf \$(pwd)/.org.chromium*"
        echo "------ stop all Docker containers again ------"
        sh "(${params.sudo} ${params.docker} stop \$(${params.sudo} ${params.docker} ps -a -q) || ${params.sudo} echo \"------ all Docker containers are still stopped ------\")"
        echo "------ remove all Docker containers again ------"
        sh "(${params.sudo} ${params.docker} rm \$(${params.sudo} ${params.docker} ps -a -q) || ${params.sudo} echo \"------ all Docker containers are still removed ------\")"
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
