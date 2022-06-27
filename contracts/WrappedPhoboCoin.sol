// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";

contract WrappedPhoboCoin is ERC20PresetMinterPauser {
    string public constant Name = "WrappedPhoboCoin";
    string public constant Symbol = "wPHO";

    constructor() ERC20PresetMinterPauser(Name, Symbol) {
    }
}
