const PropertyFactory = artifacts.require("PropertyFactory");
const Helper = artifacts.require("Helper");
const Marketplace = artifacts.require("Marketplace");

module.exports = function(deployer) {
  deployer.deploy(PropertyFactory);
  deployer.deploy(Helper);
  deployer.deploy(Marketplace, "Marketplace", "MKP");
}; 