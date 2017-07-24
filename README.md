# Preconditions

1. Install `NodeJS` with `NPM`
2. Install current `Chrome` and/or `Firefox`

# Start the tests

	//start the tests on Chrome with npm install
	npm run npm-test-chrome

	//start the tests on Firefox with npm install
	npm run npm-test-firefox

	//start the tests on Chrome without npm install
	npm run test-chrome

	//start the tests on Firefox with npm install
	npm run test-firefox

If starting the tests without implicit `npm install` you have to do first the following:

	npm install
	npm install -y nightwatch-cucumber@7.1.10
	npm install -y chromedriver@2.30.1
	npm install -y geckodriver@1.7.1
	npm install -y cucumber-html-reporter@2.0.3
	npm install -y multiple-cucumber-html-reporter@0.2.0
