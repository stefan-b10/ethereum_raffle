pragma solidity 0.6.6;

import "https://raw.githubusercontent.com/smartcontractkit/chainlink/develop/evm-contracts/src/v0.6/VRFConsumerBase.sol";

contract Raffle is VRFConsumerBase {
	
	address payable public owner;
	address payable public manager;
	address payable[] public players;
	
	bytes32 internal keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
	uint internal fee;
	uint public randomResult;
	uint seed;
	

	constructor() 
	    VRFConsumerBase (
	        0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B,  //VRF Coordinator
	        0x01BE23585060835E02B77ef475b0Cc51aA1e0709   //LINK token
           ) public
	{
	    fee = 0.1 * 10 ** 18; // 0.1 LINK
		owner = msg.sender;
		manager = msg.sender;
	}

	modifier onlyManager() {
		require(msg.sender == manager);
		_;
	}

	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	
	function getRandomNumber(uint256 userProvidedSeed) internal returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) > fee, "Not enough LINK - fill contract with faucet");
        return requestRandomness(keyHash, fee, userProvidedSeed);
    }
    
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResult = randomness;
    }

	function enter() public payable {
		require(msg.value == 0.1 ether);
		players.push(msg.sender);
	}

	function getSeed() private view returns(uint) {
		return uint(keccak256(abi.encodePacked(block.difficulty, now, players)));
	}

	function pickWinner () public payable onlyManager {
		//require more than 2 players to pick a winner
		require(players.length > 2);
		
		uint random = uint(getRandomNumber(getSeed()));
		uint index = random %  players.length;
		
		//amount to be received by manager and owner
		uint amount = (address(this).balance)*5/100;
		
		manager.transfer(amount);
		owner.transfer(amount);
		
		//remaining balance to be sent to the raffle winner
		players[index].transfer(address(this).balance);
		
		//raffle winner becomes the new manager
		manager = players[index];
		players = new address payable[](0);
	}

    function getPlayers () public view returns(address payable[] memory) {
        return  players;
    }

    //owner can withdraw LINK token from contract
    function withdrawLink(uint value) external onlyOwner {
    	require(LINK.transfer(msg.sender, value), "Unable to transfer");
    }
	
}