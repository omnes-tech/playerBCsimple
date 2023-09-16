// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract mockERC20 is ERC20 {

    uint256 public supply;
    constructor(string memory _name, string memory _symbol) ERC20(_name,_symbol){}

    function mint(uint256 _amount) external {
        _mint(msg.sender, _amount);
        supply += _amount;
    }
}