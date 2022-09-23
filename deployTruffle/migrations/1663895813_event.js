const Event = artifacts.require('./Event.sol');

module.exports = function(deployer) {
  // Use deployer to state migration tasks.
  deployer.deploy(Event);
};
