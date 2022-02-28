
1: Create an NFT fractionalization contract
 
The fractionalization contract will have the following features:
-   Lock an NFT
-   Issue initial shares to various addresses as deﬁned by the contract owner.

 2: Fractionalize the NFT you have created 
For this task, we will fractionalize as follows:
 . Issue some shares to initial addresses, with a fair repartition that will not impact users
 . Shares are issued as ERC-20 tokens.

3: Staking
 Create a simple staking program (with no lockup) for the ERC-20 tokens. Rewards will come from Task 4.

4: Auction and shares rewards
 Everyday, new ERC-20 tokens will be minted. The number of tokens minted will be 1% of the initial total supply. 
 These newly minted ERC-20 tokens will be immediately auctioned off for ETH. 
 The earnings will be distributed to the stakers in proportion to their stakes from Task 3. 
 You can use the English auction mechanism. For the starting bid, you may assume 0.1 ETH.
 Devs should have a reward fee of 5% on the auction

Bonus : Implement a buyout mechanism, that only the main shareholder 
    can trigger, with the approval of the shareholders majority.