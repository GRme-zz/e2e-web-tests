#run the end2end tests headless in docker container from local with local repository
#parameter: $1 mandatory - folder on local machine where the test project is placed
#           $2 mandatory - defined the running browser (scipts in package.json)
#           $3 optionally - browser for test execution (chrome, firefox, safari)
#                           when you don't use this parameter, then you have to choose a npm script
#                           for a specific browser (test-chrome, npm-test-chrome, test-firefox, npm-test-firefox)
#                           DON'T USE A GENERIC NPM SCRIPT, LIKE test or npm-test!!!
#           $4 optionally - tags to execute only tests tagged by the given tags (e.g. "--tag=run", "--tag=run,enabled")
#                           default is the tag @enabled
#
#examples:
#
#without npm installs and without optional parameters
#sh ./runLocalTestsHeadlessOnLocal.sh /Users/me/e2e-web-tests test-chrome
#sh ./runLocalTestsHeadlessOnLocal.sh /Users/me/e2e-web-tests test-firefox
#
#without npm installs and with optional parameters
#sh ./runLocalTestsHeadlessOnLocal.sh /Users/me/e2e-web-tests test chrome --tag=run
#sh ./runLocalTestsHeadlessOnLocal.sh /Users/me/e2e-web-tests test chrome
#sh ./runLocalTestsHeadlessOnLocal.sh /Users/me/e2e-web-tests test firefox --tag=run,enabled
#sh docker/runLocalTestsHeadlessOnLocal.sh $(pwd) test chrome
#sh docker/runLocalTestsHeadlessOnLocal.sh $(pwd) test firefox --tag=run
#
#with npm installs and without optional parameters
#sh ./runLocalTestsHeadlessOnLocal.sh /Users/me/e2e-web-tests npm-test-chrome
#sh ./runLocalTestsHeadlessOnLocal.sh /Users/me/e2e-web-tests npm-test-firefox
#sh docker/runLocalTestsHeadlessOnLocal.sh $(pwd) npm-test-chrome
#sh docker/runLocalTestsHeadlessOnLocal.sh $(pwd) npm-test-firefox
#
#with npm installs and with optional parameters
#sh ./runLocalTestsHeadlessOnLocal.sh /Users/me/e2e-web-tests npm-test chrome --tag=run
#sh ./runLocalTestsHeadlessOnLocal.sh /Users/me/e2e-web-tests npm-test chrome
#sh ./runLocalTestsHeadlessOnLocal.sh /Users/me/e2e-web-tests npm-test firefox --tag=run,enabled
#sh docker/runLocalTestsHeadlessOnLocal.sh $(pwd) npm-test chrome
#sh docker/runLocalTestsHeadlessOnLocal.sh $(pwd) npm-test firefox --tag=run

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
  "cd /my_tests \
  && xvfb-run --server-args='-screen 0 1600x1200x24' npm run $2 -- $3 $4 \
  && google-chrome --version \
  && firefox --version" \
&& echo "------ cleanup all temporary files ------" \
&& rm -Rf $1/tmp-* \
&& rm -Rf $1/.com.google* \
&& rm -Rf $1/rust_mozprofile* \
&& rm -Rf $1/.org.chromium* \
&& echo "------ stop all Docker containers again ------" \
&& (docker stop $(docker ps -a -q) || echo "------ all Docker containers are still stopped ------") \
&& echo "------ remove all Docker containers again ------" \
&& (docker rm $(docker ps -a -q) || echo "------ all Docker containers are still removed ------")
