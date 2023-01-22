const { expect } = require("chai");


describe("Contract Version 1 test", function () {

    let token;
    let owner;
    let user1;
    let owner_balance;
    let stake_amount = 100;

    before(async function () {
        [owner, user1] = await ethers.getSigners();
        const Token = await ethers.getContractFactory("MyToken");
        token = await Token.deploy('TKN', 'T');
        await token.deployed();

        const StakingRewards = await ethers.getContractFactory("StakingRewards");
        stackingToken = await StakingRewards.deploy(token.address);//
        await stackingToken.deployed();

        await token.mint(owner.address, 1000);
    });
    it("Should staking 100 tokens", async () => {

        owner_balance = await token.balanceOf(owner.address);
        console.log(owner_balance);

        // await token.transfer(stackingToken.address, stake_amount);//?
        await token.approve(stackingToken.address, stake_amount);
        let tx = await stackingToken.stakeToken(stake_amount);

        console.log(await token.balanceOf(owner.address));
        console.log(await stackingToken.getTokenAmountStaked());
        
        await expect(() => tx).to.changeTokenBalance(
            token, owner.address, -stake_amount
          );
    });
    // assert.equal(error.reason, "DevToken: Cannot stake more than you own");
    it("Should getTokenAmountStaked", async () => {

        let tx = await stackingToken.getTokenAmountStaked();
        await expect(tx).to.equal(stake_amount);
    });
    it("Should be reverted with `You are not participated`", async () => {
        /* await token.approve(stackingToken.address, stake_amount);
        let tx = await stackingToken.connect(user1).getTokenAmountStaked();
        await expect(()=>tx).to.be.revertedWith(
            "You are not participated"
        );*/
    });
    it("Should be reverted with `You already participated`", async () => {

        // await token.approve(stackingToken.address, stake_amount);
        // let tx = await stackingToken.stakeToken(stake_amount);
        // await expect(()=>tx).to.be.revertedWith(
        //     "You already participated"
        // );
    });
    it("Should be reverted with `Stake Time is not over yet`", async () => {

        // let tx = await stackingToken.claimReward();
        // await expect(()=>tx).to.be.revertedWith(
        //     "Stake Time is not over yet"
        // );
    });
    it("Should be reverted with `Stake Time is not over yet`", async () => {

        // let tx = await setTimeout(await stackingToken.claimReward(), 10000);
        // await expect(()=>tx).to.be.revertedWith(
        //     "Stake Time is not over yet"
        // );
    });
    it("I want to connecting other user and staked from it, but it `You already participated`", async () => {

        // await token.mint(user1.address, 2000);
        // owner_balance = await token.balanceOf(user1.address);
        // console.log(owner_balance);

        // await token.connect(user1).approve(stackingToken.address, stake_amount);
        // let tx = await stackingToken.stakeToken(stake_amount);

        // console.log(await token.balanceOf(user1.address));
        // console.log(await stackingToken.getTokenAmountStaked());
        
        // await expect(() => tx).to.changeTokenBalance(
        //     token, user1.address, -stake_amount
        //   );

    });
});