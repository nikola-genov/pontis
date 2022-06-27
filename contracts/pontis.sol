// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IBridge.sol";
import "./PhoboCoin.sol";
import "./WrappedPhoboCoin.sol";

contract Pontis is Ownable, IBridge {
    address private nativeToken;
    address private targetToken;

    uint256 constant minFee = 100; // minimum fee in wei

    mapping(uint8 => mapping(address => address)) private nativeToWrappedTokenMap;

    //function lock(address _nativeToken, uint256 _amount, address _receiver) external payable override {
    function lock(address _nativeToken, uint256 _amount) external payable override {
        require(msg.value >= minFee, "Minimum fee is 100 wei.");
        
        ERC20(_nativeToken).transferFrom(msg.sender, address(this), _amount);

        emit Lock(_nativeToken, _amount, msg.value);
    }

    function mint(uint8 _nativeChain, address _nativeToken, uint256 _amount, address _receiver) external override
    {
        //require(TODO);

        WrappedPhoboCoin(nativeToWrappedTokenMap[_nativeChain][_nativeToken]).mint(_receiver, _amount);

        emit Mint(nativeToWrappedTokenMap[_nativeChain][_nativeToken], _amount, _receiver);
    }

    function burn(address _wrappedToken, uint256 _amount, address _receiver) external override {
        //require(TODO);

        WrappedPhoboCoin(_wrappedToken).burnFrom(msg.sender, _amount);

        emit Burn(_wrappedToken, _amount, _receiver);
    }

    function unlock(address _nativeToken, uint256 _amount, address _receiver) external override {
        //require(TODO);

        ERC20(_nativeToken).transferFrom(address(this), msg.sender, _amount);

        emit Unlock(_nativeToken, _amount, _receiver);
    }
}