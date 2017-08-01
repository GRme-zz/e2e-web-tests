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
  commands: [{

    goToGoogleMainPage(client) {
      return client.url('http://www.google.com');
    },

    checkAllElementsAreVisibleWithoutAsync(client) {
      return client
        //selector 'invalidGoogleLogo' can not be found
        .waitForElementVisible(invalidGoogleLogo, 5000)
        //selector 'invalidSearchField' can not be found
        .waitForElementVisible(invalidSearchField, 5000)
        //selector 'invalidSearchButton' can not be found
        .waitForElementVisible(invalidSearchButton, 5000);
    },

    async checkAllElementsAreVisibleWithAsync(client) {
      //selector 'invalidGoogleLogo' can not be found
      await client.waitForElementVisible(invalidGoogleLogo, 5000);
      //selector 'invalidSearchField' can not be found
      await client.waitForElementVisible(invalidSearchField, 5000);
      //selector 'invalidSearchButton' can not be found
      await client.waitForElementVisible(invalidSearchButton, 5000);
      return client;
    },
  }]
};
