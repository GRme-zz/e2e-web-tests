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
        echo "------ stop e2e-web-tests Docker container ------"
        sh "(${params.sudo} ${params.docker} stop e2e-web-tests-docker-container || ${params.sudo} echo \"------ all e2e-web-tests Docker container are still stopped ------\")"
        echo "------ remove e2e-web-tests Docker container ------"
        sh "(${params.sudo} ${params.docker} rm e2e-web-tests-docker-container || ${params.sudo} echo \"------ all e2e-web-tests Docker container are still removed ------\")"
        echo "------ pull Docker image from Docker Cloud ------"
        sh "${params.sudo} ${params.docker} pull \"${params.docker_image}\""
        echo "------ start Docker container from image ------"
        sh "${params.sudo} ${params.docker} run --name e2e-web-tests-docker-container -d -t -i -v \$(pwd):/my_tests/ \"${params.docker_image}\" /bin/bash"
        echo "------ execute end2end tests on Docker container ------"
        sh "${params.sudo} ${params.docker} exec -i e2e-web-tests-docker-container bash -c \"cd / && pwd && ls -lsa && (xvfb-run --server-args=\'-screen 0 1600x1200x24\' npm run ${params.run_script_method} -- ${params.browser} ${params.tags} || true) && google-chrome --version && firefox --version\""
        echo "------ cleanup all temporary files ------"
        sh "${params.sudo} rm -Rf \$(pwd)/tmp-*"
        sh "${params.sudo} rm -Rf \$(pwd)/.com.google*"
        sh "${params.sudo} rm -Rf \$(pwd)/rust_mozprofile*"
        sh "${params.sudo} rm -Rf \$(pwd)/.org.chromium*"
        echo "------ stop e2e-web-tests Docker container again ------"
        sh "(${params.sudo} ${params.docker} stop e2e-web-tests-docker-container || ${params.sudo} echo \"------ all e2e-web-tests Docker container are still stopped ------\")"
        echo "------ remove e2e-web-tests Docker container again ------"
        sh "(${params.sudo} ${params.docker} rm e2e-web-tests-docker-container || ${params.sudo} echo \"------ all e2e-web-tests Docker container are still removed ------\")"
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
