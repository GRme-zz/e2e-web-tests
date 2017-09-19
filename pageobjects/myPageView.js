const assert = require("assert");

//selectors
const validGoogleLogo = 'div[id="hplogo"]';
const validSearchField = 'input[id="lst-ib"]';
const validSearchButton = 'input[name="btnK"]';

//these 3 selectors can not be found on google
const invalidGoogleLogo = 'div[id="hplogo123"]';
const invalidSearchField = 'input[id="lst-ib123"]';
const invalidSearchButton = 'input[name="btnK123"]';

module.exports = {
  elements: {},
  commands: [
    {
      goToGoogleMainPage(client) {
        return client.url("http://www.google.com");
      },

      checkAllElementsAreVisible(client) {
        client.setValue(validSearchField, "mal ein test");
        return (
          client
            //selector 'invalidGoogleLogo' can not be found
            .waitForElementVisible(validGoogleLogo)
            //selector 'invalidSearchField' can not be found
            .waitForElementVisible(validSearchField)
            //selector 'invalidSearchButton' can not be found
            .waitForElementVisible(validSearchButton)
        );
      },

      testIsRunning() {
        return assert.equal(true, true);
      }
    }
  ]
};
