// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";

contract WrappedPhoboCoin is ERC20PresetMinterPauser {
    constructor(string memory _name, string memory _symbol) ERC20PresetMinterPauser(_name, _symbol) {
    }
}
