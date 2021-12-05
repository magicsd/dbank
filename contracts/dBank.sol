// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Token.sol";

contract dBank {
    Token private token;
    mapping (address => uint) public etherBalanceOf;
    mapping (address => uint) public depositStart;
    mapping (address => bool) public isDeposited;

    event Deposit(address indexed user, uint etherAmount, uint timeStart);

    constructor(Token _token) public {
        token = _token;
    }

    function deposit() payable public {
        require(isDeposited[msg.sender] == false, 'Error, deposit already active');
        require(msg.value >= 1e16, 'Error, deposit must be >= 0.01 ETH');

        etherBalanceOf[msg.sender] += msg.value;
        depositStart[msg.sender] += block.timestamp;
        isDeposited[msg.sender] = true;

        emit Deposit(msg.sender, msg.value, block.timestamp);
    }
}
