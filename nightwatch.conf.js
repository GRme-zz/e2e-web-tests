const seleniumServer = require("selenium-server-standalone-jar");
const phantomjs = require("phantomjs-prebuilt");
const chromedriver = require("chromedriver");
const geckodriver = require("geckodriver");
const seleniumdriver = require("selenium-webdriver");

require("nightwatch-cucumber")({
  cucumberArgs: [
    "--tags",
    "@enabled",
    "--compiler",
    "js:babel-core/register",
    "--require",
    "timeout.js",
    "--require",
    "hooks.js",
    "--require",
    "features/step_definitions",
    "--format",
    "json:reports/json_result/cucumber.json",
    "features"
  ]
});

const config = {
  output_folder: "reports",
  custom_commands_path: "commands",
  // custom_assertions_path: 'assertions',
  live_output: false,
  page_objects_path: "pageobjects",
  disable_colors: false,
  selenium: {
    start_process: true,
    server_path: seleniumServer.path,
    log_path: "",
    host: "127.0.0.1",
    port: 4444
  },
  test_settings: {
    default: {
      globals: {
        waitForConditionTimeout: 30000,
        waitForConditionPollInterval: 500
      },
      screenshots: {
        enabled: true,
        on_failure: true,
        path: "screenshots"
      },
      launch_url: "http://localhost:8087",
      selenium_port: 4444,
      selenium_host: "127.0.0.1",
      desiredCapabilities: {
        browserName: "phantomjs",
        javascriptEnabled: true,
        acceptSslCerts: true,
        "phantomjs.binary.path": phantomjs.path
      }
    },
    chrome: {
      desiredCapabilities: {
        browserName: "chrome",
        javascriptEnabled: true,
        acceptSslCerts: true,
        chromeOptions: {
          args: ["--no-sandbox"]
          //"args" : ["--no-sandbox", "start-fullscreen"]
        }
      },
      selenium: {
        cli_args: {
          "webdriver.chrome.driver": chromedriver.path
        }
      }
    },
    firefox: {
      desiredCapabilities: {
        browserName: "firefox",
        javascriptEnabled: true,
        acceptSslCerts: true
      },
      selenium: {
        cli_args: {
          "webdriver.gecko.driver": geckodriver.path
        }
      }
    }
  }
};
module.exports = config;
