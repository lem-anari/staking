// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./StakingRewards.sol"; 

contract MyToken is ERC20{

    constructor(string memory name, string memory symbol) ERC20(name, symbol){}

    function mint(address account, uint256 amount) public {
        _mint(account, amount);
    }
}
 