const StoreValue = artifacts.require('./StoreValue.sol');

module.exports = function(deployer) {
  // Use deployer to state migration tasks.
  deployer.deploy(StoreValue);
};