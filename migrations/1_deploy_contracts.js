const PropertyFactory = artifacts.require("PropertyFactory");
const Helper = artifacts.require("Helper");
const Marketplace = artifacts.require("Marketplace");

module.exports = function(deployer) {
  deployer.deploy(PropertyFactory);
  deployer.link(PropertyFactory, Helper, Marketplace);
  deployer.deploy(Helper);
  deployer.deploy(Marketplace);
};