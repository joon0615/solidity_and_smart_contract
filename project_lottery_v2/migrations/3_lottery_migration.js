const Lottery = artifacts.require("./lottery.sol");

module.exports = function(deployer) {
    deployer.deploy(Lottery);
}