var MonICO = artifacts.require("./Crowdsale.sol");
var MonChat = artifacts.require("./ERC20.sol");



module.exports = function(deployer, network, accounts) {


    const rate = new web3.BigNumber(1000);

    const wallet = accounts[1];



    return deployer

        .then(() => {

            return deployer.deploy(MonChat);

        })

        .then(() => {

            return deployer.deploy(

                MonICO,

                rate,

                wallet,

                MonChat.address

            );

        });

};