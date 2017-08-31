const report = require("cucumber-html-report");
const reporter = require("cucumber-html-reporter");
const multipleReporter = require("multiple-cucumber-html-reporter");
var assertHtmlReports = require("./assertHtmlReports");
var path = require("path");
var fs = require("fs-extra");
var find = require("find");

var theme = {
  hierarchy: "hierarchy",
  bootstrap: "bootstrap",
  foundation: "foundation",
  simple: "simple"
};

var outputDirectory = "./reports/";
var jsonFile = "./reports/json_result/cucumber.json";
var jsonDir = "./reports/json_result/";

/**
 * remove existing reports
 * @return
 */
function removeReports() {
  var files = find.fileSync(/\.html/, outputDirectory);
  files.map(function(file) {
    fs.unlinkSync(file);
  });
}

/**
 * get the cucumber report options
 * @param theme
 * @return options
 */
function getOptions(theme) {
  return {
    theme: theme,
    output: path.join(outputDirectory, "cucumber_report_" + theme + ".html"),
    reportSuiteAsScenarios: true,
    launchReport: false,
    name: "NIKITA end2end tests",
    brandTitle: "NIKITA end2end tests",
    metadata: {
      "App Version": "0.0.4",
      "Test Environment": "AAT-000"
    }
  };
}

/**
 * get JSON dir options
 * @param theme
 * @return options
 */
function getJsonDirOptions(theme) {
  var options = getOptions(theme);
  options.jsonDir = jsonDir;
  return options;
}

/**
 * generate HTML reports from JSON dir with cucumber-html-reporter
 */
function generateReportsFromJsonDir() {
  //generate hierarchy theme report
  reporter.generate(getJsonDirOptions(theme.hierarchy));
  //generate bootstrap theme report
  reporter.generate(getJsonDirOptions(theme.bootstrap));
  //generate foundation theme report
  reporter.generate(getJsonDirOptions(theme.foundation));
  //generate simple theme report
  reporter.generate(getJsonDirOptions(theme.simple));
  //assert reports
  assertHtmlReports(outputDirectory);
}

/**
 * generate HTML reports from JSON file with cucumber-html-report
 */
function generateReportsFromJsonFile() {
  report.create({
    source: jsonFile,
    dest: outputDirectory + "cucumber-html-report/",
    name: "report.html",
    title: "NIKITA end2end tests"
  });
}

/**
 * generate multiple HTML reports with multiple-cucumber-html-reporter
 */
function generateMultipleReports() {
  multipleReporter.generate({
    jsonDir: jsonDir,
    reportPath: outputDirectory + "multiple-cucumber-html-reporter/",
    saveCollectedJSON: true
  });
}

try {
  //remove all reports
  removeReports();

  //generate reports with cucumber-html-reporter
  generateReportsFromJsonDir();

  //generate reports with cucumber-html-report
  generateReportsFromJsonFile();

  //generate reports with multiple-cucumber-html-reporter
  generateMultipleReports();
} catch (e) {
  console.log("Report generation is not possible with the following message:");
  console.log(e);
}
