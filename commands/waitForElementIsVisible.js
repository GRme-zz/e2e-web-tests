exports.command = async function (selector, timeout) {
  await this.waitForElementVisible(selector, timeout);
  console.log("BLA")
  return await this;
};
