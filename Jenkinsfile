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
        sh "xvfb-run --server-args=\'-screen 0 1600x1200x24\' npm run ${params.run_script_method} -- ${params.browser} ${params.tags}"
        echo "------ end the end2end tests ------"
      }
    }
  }

  post {
    always {
      echo "------ cleanup all temporary files ------"
      sh "rm -Rf \$(pwd)/tmp-*"
      sh "rm -Rf \$(pwd)/.com.google*"
      sh "rm -Rf \$(pwd)/rust_mozprofile*"
      sh "rm -Rf \$(pwd)/.org.chromium*"
      echo "------ generate Cucumber report in project ------"
      sh "xvfb-run --server-args=\'-screen 0 1600x1200x24\' npm run posttest"
      echo "------ generate Cucumber report with plugin ------"
      cucumber "**/cucumber.json"
    }
  }
}
