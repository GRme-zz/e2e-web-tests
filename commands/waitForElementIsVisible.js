exports.command = async function(selector, timeout) {
  await this.waitForElementVisible(selector, timeout);
  return await this;
};
