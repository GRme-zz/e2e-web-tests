pipeline {
  agent any

  parameters {
    string(defaultValue: 'npm-test', description: '', name: 'run_script_method')
    string(defaultValue: 'chrome', description: '', name: 'browser')
    string(defaultValue: '--tag=run', description: '', name: 'tags')
  }

  stages {
    stage('Test') {
      steps {
        echo "------ start the end2end tests ------"
        sh "npm run ${params.run_script_method} -- ${params.browser} ${params.tags}"
        echo "------ end the end2end tests ------"
      }
    }
  }

  post {
    always {
      echo "------ cleanup all temporary files ------"
      sh "${params.sudo} rm -Rf \$(pwd)/tmp-*"
      sh "${params.sudo} rm -Rf \$(pwd)/.com.google*"
      sh "${params.sudo} rm -Rf \$(pwd)/rust_mozprofile*"
      sh "${params.sudo} rm -Rf \$(pwd)/.org.chromium*"
      echo "------ generate Cucumber report ------"
      cucumber "**/cucumber.json"
    }
  }
}
