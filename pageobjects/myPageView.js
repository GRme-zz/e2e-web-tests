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
      async goToGoogleMainPage(client) {
        return await client.url("http://www.google.com");
      },

      checkAllElementsAreVisibleWithoutAsync(client) {
        return (
          client
            //selector 'invalidGoogleLogo' can not be found
            .waitForElementIsVisible(validGoogleLogo)
            //selector 'invalidSearchField' can not be found
            .waitForElementIsVisible(validSearchField)
            //selector 'invalidSearchButton' can not be found
            .waitForElementIsVisible(validSearchButton)
        );
      },

      async checkAllElementsAreVisibleWithAsync(client) {
        //selector 'invalidGoogleLogo' can not be found
        await client.waitForElementVisible(validGoogleLogo);
        //selector 'invalidSearchField' can not be found
        await client.waitForElementVisible(validSearchField);
        //selector 'invalidSearchButton' can not be found
        await client.waitForElementVisible(validSearchButton);
        return client;
      },

      testIsRunning() {
        return assert.equal(true, true);
      }
    }
  ]
};
