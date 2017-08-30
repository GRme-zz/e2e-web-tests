#run the end2end tests headless in docker container from local with remote repository
#parameter: $1 mandatory -  folder on local machine to copy in project sources (with cucumber reports after test execution)
#                           (IMPORTANT: You have to ensure that the given folder path is in the file sharing paths in Docker configuration!!!)
#           $2 mandatory - git url with credentials to GitLab repo (e.g. https://<username>:<password>@gitlab.com/hrsinnolab/e2e-web-tests.git)
#           $3 mandatory - defined the running browser (scipts in package.json)
#                          YOU HAVE TO USE 'npm-test-chrome' OR 'npm-test-firefox' TO DO 'npm install' FIRST
#           $4 optionally - browser for test execution (chrome, firefox, safari)
#                           when you don't use this parameter, then you have to choose a npm script
#                           for a specific browser (test-chrome, npm-test-chrome, test-firefox, npm-test-firefox)
#                           DON'T USE A GENERIC NPM SCRIPT, LIKE test or npm-test!!!
#           $5 optionally - tags to execute only tests tagged by the given tags (e.g. "--tag=run", "--tag=run,enabled")
#                           default is the tag @enabled
#           $6 optionally - branch to run the tests against (optionally / if empty then the 'master' is used for tests as default)
#
#examples:
#
# run the tests with chrome for default tag against the default 'master'
#sh ./runRemoteTestsHeadlessOnLocal.sh /Users/me/e2e-tests/reports/ https://me:mypassword@gitlab.com/hrsinnolab/e2e-web-tests.git npm-test chrome
#sh docker/runRemoteTestsHeadlessOnLocal.sh $(pwd) https://me:mypassword@gitlab.com/hrsinnolab/e2e-web-tests.git npm-test chrome
#
# run the tests with firefox for tag "@run" and "@enabled" against the default 'master'
#sh ./runRemoteTestsHeadlessOnLocal.sh /Users/me/e2e-tests/reports/ https://me:mypassword@gitlab.com/hrsinnolab/e2e-web-tests.git npm-test firefox --tag=run,enabled
#sh docker/runRemoteTestsHeadlessOnLocal.sh $(pwd) https://me:mypassword@gitlab.com/hrsinnolab/e2e-web-tests.git npm-test firefox --tag=run,enabled
#
# run the tests with chrome for tag "@run" against the branch 'NIKITA-1234'
#sh ./runRemoteTestsHeadlessOnLocal.sh /Users/me/e2e-tests/reports/ https://me:mypassword@gitlab.com/hrsinnolab/e2e-web-tests.git npm-test chrome --tag=run NIKITA-1234
#sh docker/runRemoteTestsHeadlessOnLocal.sh $(pwd) https://me:mypassword@gitlab.com/hrsinnolab/e2e-web-tests.git npm-test chrome --tag=run NIKITA-1234

docker_image=grme/nightwatch-chrome-firefox:0.0.4
echo "------ stop all Docker containers ------" \
&& (docker stop $(docker ps -a -q) || echo "------ all Docker containers are still stopped ------") \
&& echo "------ remove all Docker containers ------" \
&& (docker rm $(docker ps -a -q) || echo "------ all Docker containers are still removed ------") \
&& echo "------ pull Docker image '"$docker_image"' from Docker Cloud ------" \
&& docker pull "$docker_image" \
&& echo "------ start Docker container from image ------" \
&& docker run -d -t -i -v $1:/my_tests/ "$docker_image" /bin/bash \
&& echo "------ execute end2end tests on Docker container ------" \
&& docker exec -it $(docker ps --format "{{.Names}}") bash -c \
  "rm -Rf /my_tests/project \
  && git clone $2 /my_tests/project \
  && cd /my_tests/project \
  && git checkout $6 \
  && xvfb-run --server-args='-screen 0 1600x1200x24' npm run $3 -- $4 $5 || true \
  && google-chrome --version \
  && firefox --version" \
&& echo "------ cleanup all temporary files ------" \
&& rm -Rf $1/project/tmp-* \
&& rm -Rf $1/project/.com.google* \
&& rm -Rf $1/project/rust_mozprofile* \
&& rm -Rf $1/.org.chromium* \
&& echo "------ stop all Docker containers again ------" \
&& (docker stop $(docker ps -a -q) || echo "------ all Docker containers are still stopped ------") \
&& echo "------ remove all Docker containers again ------" \
&& (docker rm $(docker ps -a -q) || echo "------ all Docker containers are still removed ------")
