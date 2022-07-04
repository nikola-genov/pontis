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

    struct TokenInfo {
        uint8 chainId;
        address tokenAddress;
    }

    mapping(uint8 => mapping(address => address)) private nativeToWrappedTokenMap;
    mapping(address => TokenInfo) private wrappedToNativeTokenMap;
    
    function lock(uint8 _targetChain, address _nativeToken, uint256 _amount) external payable override {
        require(msg.value >= minFee, "Minimum fee is 100 wei.");
        
        ERC20(_nativeToken).transferFrom(msg.sender, address(this), _amount);

        // Currently the receiver address must be the same as the sender. 
        // TODO - should we allow different receiver addresses???
        emit Lock(_targetChain, _nativeToken, msg.sender, _amount, msg.value);
    }

    function mint(uint8 _nativeChain, address _nativeToken, uint256 _amount, address _receiver) external override
    {
        //require(TODO);

        if(nativeToWrappedTokenMap[_nativeChain][_nativeToken] == address(0)) {
            // deploy a new instance of the wrapped token for each chain/token combination
            WrappedPhoboCoin wpc = new WrappedPhoboCoin();
            nativeToWrappedTokenMap[_nativeChain][_nativeToken] = address(wpc);
            wrappedToNativeTokenMap[address(wpc)].chainId = _nativeChain;
            wrappedToNativeTokenMap[address(wpc)].tokenAddress = _nativeToken;
        }
        
        WrappedPhoboCoin(nativeToWrappedTokenMap[_nativeChain][_nativeToken]).mint(_receiver, _amount);

        emit Mint(nativeToWrappedTokenMap[_nativeChain][_nativeToken], _amount, _receiver);
    }

    function burn(address _wrappedToken, uint256 _amount, address _receiver) external override {
        //require(TODO); - msg.sender == _reciever???

        WrappedPhoboCoin(_wrappedToken).burnFrom(msg.sender, _amount);

        emit Burn(_wrappedToken, _amount, _receiver);
    }

    function unlock(address _nativeToken, uint256 _amount, address _receiver) external override {
        //require(TODO);

        ERC20(_nativeToken).transferFrom(address(this), msg.sender, _amount);

        emit Unlock(_nativeToken, _amount, _receiver);
    }
}