# Running the project

## Preconditions

1. You have to install [Java SDK](http://www.oracle.com/technetwork/java/javase/downloads/index.html) on your OS (or [OpenJDK](http://openjdk.java.net) for Unix OS).
2. You have to install [NodeJS with the NPM](https://nodejs.org/en/).
3. You have to install the Node package `scripts` globally

		npm install -y -g scripty

4. For every test executions with `Docker container` you have to install [Docker](https://www.docker.com)
5. If you want to run `Shell script` on your local Windows machine you have to provide a Unix-like environment, like [Cygwin](https://www.cygwin.com)
6. You have to install `Chrome`, `Firefox` or any other wanted browser on the running machine.

And that's all :)

## Running tests locally with real browser for local repository

At first you have to do some preparations:

	cd <root_directory_of_e2e_web_tests>
	npm install

And after you can start the tests with a real browser:

	//run with chrome browser
	npm run test-chrome

	//run with firefox browser
	npm run test-firefox

Or you choose the more smart way ;)

	//install all dependencies with npm and run with chrome browser
	npm run npm-test-chrome

	//install all dependencies with npm and run with firefox browser
	npm run npm-test-firefox

Or you choose the most smartest way

	//install all dependencies with npm and run with chrome browser for tagged tests
	npm run npm-test -- chrome --tag=run

	//install all dependencies with npm and run with firefox browser for default tags
	npm run npm-test -- firefox

## Running tests locally with headless browser in Docker container

**This solution is the preferred one, because every OS configuration you get by the given Docker image.**

To make tests runnable in headless mode on various operating systems it's necessary to find a generic, robust and equal solution for the mostly operating systems.

The result is a `Shell script` to execute tests in a `Docker container`. You can find the script under **`/docker/runLocalTestsHeadlessOnLocal.sh`**.

**Examples to call this shell script are given in the shell script!**

**sequence of the script:**

1. Stop and delete all existing Docker containers
2. Pull the Docker image `grme/nightwatch-chrome-firefox:0.0.5`
3. Create a Docker container from image and run it with a given mapped existing folder on local machine
4. Execute the given automated tests from local repository in Docker container
5. Cleanup all temporary files
6. Stop and delete all existing Docker containers again

The usage with examples is explained as comments directly in the script:

```
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

docker_image=grme/nightwatch-chrome-firefox:0.0.5
echo "------ stop all Docker containers ------" \
&& (docker stop e2e-web-test-docker-container || echo "------ all Docker containers are still stopped ------") \
&& echo "------ remove all Docker containers ------" \
&& (docker rm e2e-web-test-docker-container || echo "------ all Docker containers are still removed ------") \
&& echo "------ pull Docker image '"$docker_image"' from Docker Cloud ------" \
&& docker pull "$docker_image" \
&& echo "------ start Docker container from image ------" \
&& docker run --name e2e-web-test-docker-container -d -t -i -v $1:/my_tests/ "$docker_image" /bin/bash \
&& echo "------ execute end2end tests on Docker container ------" \
&& docker exec -it e2e-web-test-docker-container bash -c \
  "cd /my_tests \
  && xvfb-run --server-args='-screen 0 1600x1200x24' npm run $2 -- $3 $4 \
  && npm run posttest \
  && google-chrome --version \
  && firefox --version" \
&& echo "------ cleanup all temporary files ------" \
&& rm -Rf $1/tmp-* \
&& rm -Rf $1/.com.google* \
&& rm -Rf $1/rust_mozprofile* \
&& rm -Rf $1/.org.chromium* \
&& echo "------ stop all Docker containers again ------" \
&& (docker stop e2e-web-test-docker-container || echo "------ all Docker containers are still stopped ------") \
&& echo "------ remove all Docker containers again ------" \
&& (docker rm e2e-web-test-docker-container || echo "------ all Docker containers are still removed ------")
```
