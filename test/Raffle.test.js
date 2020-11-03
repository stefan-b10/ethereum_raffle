const Raffle = artifacts.require('Raffle');
const assert = require('assert');
const ganache = require('ganache-cli');

let raffle;
let accounts;

beforeEach ( async() => {
	raffle = await Raffle.new();
});

contract('Raffle', (accounts) => {

	it('Deploys contract' , async() => {
		let raffle = await Raffle.deployed();
		assert.ok(raffle.address);
	});

	it('allows accounts to enter', async() => {
		await raffle.enter({from: accounts[0], value: web3.utils.toWei('0.1', 'ether')});
		await raffle.enter({from: accounts[1], value: web3.utils.toWei('0.1', 'ether')});
		await raffle.enter({from: accounts[2], value: web3.utils.toWei('0.1', 'ether')});

		const players = await raffle.getPlayers.call();

		assert.equal(accounts[0], players[0]);
		assert.equal(accounts[1], players[1]);
		assert.equal(accounts[2], players[2]);
	});

	it('require exactly 0.1 ether to enter the raffle', async() => {
		try{
			await raffle.enter({from: accounts[0], value: web3utils.toWei('0.1', 'ether')});
			assert(false);
		} catch (err) {
			assert(err);
		}
	});

	it('sends ether to winner,manager, owner and resets players', async() => {
		
		await raffle.enter({from: accounts[0], value: web3.utils.toWei('0.1', 'ether')});
		await raffle.enter({from: accounts[1], value: web3.utils.toWei('0.1', 'ether')});
		await raffle.enter({from: accounts[2], value: web3.utils.toWei('0.1', 'ether')});
						
		await raffle.pickWinner({from: accounts[0]});
		const finalBalance = await web3.eth.getBalance(raffle.address);
		const players = await raffle.getPlayers.call();

		assert(finalBalance == 0);
		assert(players.length == 0);

	})

});