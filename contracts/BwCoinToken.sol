pragma solidity ^0.4.0;

import './SafeMath.sol';
contract BwCoinToken is SafeMath {

    address public founder;
    bool public locked;

    /* Actual balances of token holders */
    mapping(address => uint) balances;

    /* approve() allowances */
    mapping (address => mapping (address => uint)) allowed;

    string public constant name = "BwCoin Token";
    string public constant symbol = "BWC";
    uint8 public constant decimals = 4;
    uint256 public totalSupply = 25 * 1000000;

    modifier onlyFounder() {
        if (msg.sender != founder)
            revert();
        _;
    }

    modifier onlyUnlocked() {
        if (msg.sender != founder && locked)
            revert();
        _;
    }

    /**
    *  Events
    **/

    event Transfer(address indexed from, address indexed to, uint value);
    event Burned(address indexed owner, uint value);

    function BwCoinToken(address _founder) {
        founder = _founder;
        locked = true;
    }

    function unlock() onlyFounder {
        locked = false;
    }

    /**
   * Burn extra tokens from a balance.
   *
   */
    function burn(uint burnAmount) onlyFounder {
        address burner = msg.sender;
        balances[burner] = safeSub(balances[burner], burnAmount);
        totalSupply = safeSub(totalSupply, burnAmount);
        Burned(burner, burnAmount);
    }

    function transfer(address _to, uint _value) onlyUnlocked returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], _value);
        balances[_to] = safeAdd(balances[_to], _value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint _value) onlyUnlocked returns (bool success) {
        uint _allowance = allowed[_from][msg.sender];

        balances[_to] = safeAdd(balances[_to], _value);
        balances[_from] = safeSub(balances[_from], _value);
        allowed[_from][msg.sender] = safeSub(_allowance, _value);
        Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) constant returns (uint balance) {
        return balances[_owner];
    }
}
