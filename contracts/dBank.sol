// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Token.sol";

contract dBank {
    Token private token;
    mapping (address => uint) public etherBalanceOf;

    constructor(Token _token) public {
        token = _token;
    }

    function deposit() payable public {
        etherBalanceOf[msg.sender] += msg.value;
    }
}
