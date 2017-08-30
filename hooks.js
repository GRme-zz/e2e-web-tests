const { client } = require("nightwatch-cucumber");
const { defineSupportCode } = require("cucumber");

defineSupportCode(function({ Before, After, AfterAll }) {
  Before(function(scenario, callback) {
    client.maximizeWindow();
    this.scenario = scenario;
    callback();
  });

  After(function(scenario, callback) {
    callback();
  });

  AfterAll(function(callback) {
    client.end();
    callback();
  });
});
