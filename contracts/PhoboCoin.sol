// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";

contract PhoboCoin is ERC20PresetMinterPauser {
    string public constant Name = "PhoboCoin";
    string public constant Symbol = "PHO";

    constructor() ERC20PresetMinterPauser(Name, Symbol) {
        //_mint(msg.sender, 100 * 10**uint(decimals()));
    }
}
