// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    address public minter;

    event MinterChanged(address indexed from, address to);

    constructor() public payable ERC20("Decentralized Bank Currency", "DCB") {
        minter = msg.sender;
    }

    function passMinterRole(address newMinter) public returns (bool) {
        require(msg.sender == minter, "Error, msg.sender doesn't have minter role");
        minter = newMinter;
        emit MinterChanged(msg.sender, newMinter);
        return true;
    }

    function mint(address account, uint256 amount) public {
        require(msg.sender == minter, "Error, msg.sender doesn't have minter role");
        _mint(account, amount);
    }
}
