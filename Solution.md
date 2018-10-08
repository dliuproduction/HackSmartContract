## 1. SimpleToken

```
function sendToken(address _recipient, uint _amount) {
    require(balances[msg.sender]!=0); // You must have some tokens.
    
    balances[msg.sender]-=_amount;
    balances[_recipient]+=_amount;
}
```

Function `sendToken` only checks if the `msg.sender` has a non-zero balance. Thus we can exploit this check by calling sendToken from one account with 1 token, to send to another address that we own an arbitrarily large amount of tokens.

<img src="screenshots/1.1.jpg" alt="screenshot 1.1" width="600" align="middle"/>
<img src="screenshots/1.2.jpg" alt="screenshot 1.2" width="600" align="middle"/>
<img src="screenshots/1.3.jpg" alt="screenshot 1.3" width="600" align="middle"/>

After the exploit, both the sender and recipient addresses can be given a very large number of tokens. The recipient address will have its balance increase by the amount sent to it, while the sender address will have its balance uint underflow. As a result, its value will equal to 
```
  max value of uint256 - (_amount + balance[msg.sender])
``` 
which can also be manipulated to be however small or large. 

**Does this count as two vulnerabilities in the same contract?**

## 2. VoteTwoChoices

``` 
function vote(uint _nbVotes, bytes32 _proposition) {
    require(_nbVotes + votesCast[msg.sender]<=votingRights[msg.sender]); // Check you have enough voting rights.
    
    votesCast[msg.sender]+=_nbVotes;
    votesReceived[_proposition]+=_nbVotes;
}
```

With the same problem of not using SafeMath, the value `votesReceived[_proposition]` can also be underflown. In this case, we can get past the `require` check by first voting for one proposition, increasing the `votesCast[msg.sender]` by 1. 
<img src="screenshots/2.1.jpg" alt="screenshot 2.1" width="600" align="middle"/>

Then we can pass a equally negative `_nbVotes` of -1 to vote on another proposition. This would result in the second proposition's `votesReceived[_proposition]` to be underflown.

<img src="screenshots/2.2.jpg" alt="screenshot 2.2" width="600" align="middle"/>

