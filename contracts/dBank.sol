// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Token.sol";

contract dBank {
    Token private token;
    mapping (address => uint) public etherBalanceOf;
    mapping (address => uint) public depositStart;
    mapping (address => bool) public isDeposited;

    event Deposit(address indexed user, uint etherAmount, uint timeStart);
    event Withdraw(address indexed user, uint etherAmount, uint depositTime, uint interest);

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

    function withdraw() public {
        require(isDeposited[msg.sender] == true, 'Error, no previous deposit');
        uint userBalance = etherBalanceOf[msg.sender]; // for event

        uint depositTime = block.timestamp - depositStart[msg.sender];
        uint interestPerSecond = 31668017 * (userBalance / 1e16);
        uint interest = interestPerSecond * depositTime;

        payable(msg.sender).transfer(userBalance);
        token.mint(msg.sender, interest);

        depositStart[msg.sender] = 0;
        etherBalanceOf[msg.sender] = 0;
        isDeposited[msg.sender] = false;

        emit Withdraw(msg.sender, userBalance, depositTime, interest);
    }
}
