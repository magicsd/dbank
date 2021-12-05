// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "./Token.sol";

contract dBank {
    Token private token;

    constructor(Token _token) public {
        token = _token;
    }
}
