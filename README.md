# Ethereum Raffle game smartcontract

Rules of the game are simple:
 - The owner/deployer of the contract is responsible to deposit LINK so the contract cand get a random number via Chainlink VRF
 - The owner can withdraw LINK from the contract at any time
 - The manager of the raffle can pick a winner at any time
 - At the deployment of the contract the owner/deployer of the contract is the manager
 - At least 3 players need to enter the raffle before the manager can pick a winner
 - When a winner is picked the following will occur:
      - the winner becomes the new owner
      - for the owner to be able to fund the contract with LINK he will receive 0.5% of the current raffle
      - to keep the manager incentivized to pick a winner at some point he will also receive 0.5% of the current raffle
      - after the owner and the manager are paid the winner will receive the remaining amount of ETH
  - Every player need to enter with a fixed amount of 0.1 ETH
  
  
Random generator is provided via Chainlink VRF (0.1 LINK for every randomgenerator called)

A instance of this contract has been created on Rinkeby Test network : https://rinkeby.etherscan.io/address/0xe14de395265085aea89e6bc49129980203c8885d
Feel free to give it a try. (Get ETH on Rinkeby Test Network https://faucet.rinkeby.io/ )
