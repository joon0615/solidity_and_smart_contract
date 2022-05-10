const Lottery = artifacts.require("./lottery.sol");

contract("Lottery", accounts => {
    it("should have address", async () => {
        // get contract instance by function deployed()
        const lottery = await Lottery.deployed();

        // test if the address is well generated
        assert.ok(lottery.address);
    });

    it("should have a manager address which equals to my account", async() => {
        const lottery = await Lottery.deployed();
        const manager = await lottery.manager.call();

        assert.equal(accounts[0], manager);
    });

    it("should allow an account to enter", async() => {
        const lottery = await Lottery.deployed();
        await lottery.enter({from: accounts[1], value: web3.utils.toWei("0.1", "ether")});
        const player = await lottery.players.call(0);

        assert.equal(accounts[1], player);
    });

    it("requires a minimum to enter", async() => {
        const lottery = await Lottery.deployed();
        try {
            await lottery.enter({from: accounts[1], value: 0});
            assert.fail();
        }
        catch (err) {
            assert.include(err.message, "revert");
        }
    });
});