#run the end2end tests headless in docker container from local with local repository
#parameter: $1 folder on local machine where the test project is placed
#           $2 defined the running browser (scipts in package.json)
#examples:
#without npm installs
#sh ./runLocalTestsHeadlessOnLocal.sh /Users/me/e2e-web-tests test-chrome
#sh ./runLocalTestsHeadlessOnLocal.sh /Users/me/e2e-web-tests test-firefox
#with npm installs
#sh ./runLocalTestsHeadlessOnLocal.sh /Users/me/e2e-web-tests npm-test-chrome
#sh ./runLocalTestsHeadlessOnLocal.sh /Users/me/e2e-web-tests npm-test-firefox
#sh docker/runLocalTestsHeadlessOnLocal.sh $(pwd) npm-test-chrome
#sh docker/runLocalTestsHeadlessOnLocal.sh $(pwd) npm-test-firefox
docker_image=grme/nightwatch-chrome-firefox:0.0.3
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
  && xvfb-run --server-args='-screen 0 1600x1200x24' npm run $2 || true \
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
