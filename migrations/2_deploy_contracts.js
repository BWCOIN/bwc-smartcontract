var SafeMath = artifacts.require('./SafeMath.sol');
var Ownable = artifacts.require('./Ownable.sol');
var BwCoinToken = artifacts.require('./BwCoinToken.sol');

module.exports = function(deployer) {
    let founder = '0x00';

    deployer.deploy(SafeMath);
    deployer.deploy(Ownable);
    deployer.deploy(BwCoinToken, founder)
        .then(BwCoinToken.deployed);
};
