const {
  client
} = require('nightwatch-cucumber');
const {
  defineSupportCode
} = require('cucumber');

const myPage = client.page.myPageView();

defineSupportCode(({Given, When, Then}) => {

  When(/^go to google main page$/, () => {
    return myPage.goToGoogleMainPage(client);
  });

  Then(/^all necessary elements are visible without async$/, () => {
    return myPage.checkAllElementsAreVisibleWithoutAsync(client);
  });

  Then(/^all necessary elements are visible with async$/, () => {
    return myPage.checkAllElementsAreVisibleWithAsync(client);
  });
});
