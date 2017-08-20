const {
  client
} = require('nightwatch-cucumber');
const {
  defineSupportCode
} = require('cucumber');

const myPage = client.page.myPageView();

defineSupportCode(({Given, When, Then}) => {

  When(/^go to google main page$/, async () => {
    await myPage.goToGoogleMainPage(client);
    return client;
  });

  Then(/^all necessary elements are visible without async$/, async () => {
    await myPage.checkAllElementsAreVisibleWithoutAsync(client);
    return client;
  });

  Then(/^all necessary elements are visible with async$/, async () => {
    await myPage.checkAllElementsAreVisibleWithAsync(client);
    return client;
  });
});
