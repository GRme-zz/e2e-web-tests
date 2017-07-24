const {
  client
} = require('nightwatch-cucumber');
const {
  defineSupportCode
} = require('cucumber');

defineSupportCode(({Given, When, Then}) => {

  When(/^"([\d]+)" seconds waiting$/, (timeInSeconds) => {
    return client.waitForTime(timeInSeconds * 1000);
  });
});
