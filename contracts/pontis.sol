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
        address wrappedTokenAddress;
    }

    mapping(uint8 => mapping(address => address)) private nativeToWrappedTokenMap;
    mapping(address => TokenInfo) private wrappedToNativeTokenMap;
    address[] wrappedTokens;
    
    function getWrappedTokens() external view returns (TokenInfo[] memory) {
        TokenInfo[] memory tokens = new TokenInfo[](wrappedTokens.length);
        for (uint16 i = 0; i < wrappedTokens.length; i++) {
            tokens[i] = wrappedToNativeTokenMap[wrappedTokens[i]];
        }

        return tokens;
    } 

    function lock(uint8 _targetChain, address _nativeToken, uint256 _amount) external payable override {
        require(msg.value >= minFee, "Minimum fee is 100 wei.");
        
        ERC20(_nativeToken).transferFrom(msg.sender, address(this), _amount);

        // Currently the receiver address must be the same as the sender. 
        // TODO - should we allow different receiver addresses???
        emit Lock(_targetChain, _nativeToken, msg.sender, _amount, msg.value);
    }

    function mint(
        uint8 _nativeChain, 
        address _nativeToken, 
        string memory _tokenName, 
        string memory _tokenSymbol, 
        uint256 _amount, 
        address _receiver, 
        string memory transactionHash
    ) external override
    {
        //require(TODO);
        address wrappedTokenAddress = nativeToWrappedTokenMap[_nativeChain][_nativeToken];
        if(wrappedTokenAddress == address(0)) {
            // deploy a new instance of the wrapped token for each chain/token combination
            WrappedPhoboCoin wpc = new WrappedPhoboCoin(_tokenName,  _tokenSymbol);
            wrappedTokenAddress =  address(wpc);
            nativeToWrappedTokenMap[_nativeChain][_nativeToken] = wrappedTokenAddress;
            
            wrappedToNativeTokenMap[wrappedTokenAddress] = TokenInfo({
                chainId: _nativeChain, 
                tokenAddress: _nativeToken,
                wrappedTokenAddress: wrappedTokenAddress
            });
            
            wrappedTokens.push(wrappedTokenAddress);
        }
        
        WrappedPhoboCoin(wrappedTokenAddress).mint(_receiver, _amount);

        emit Mint(wrappedTokenAddress, _amount, _receiver, transactionHash);
    }

    function burn(address _wrappedToken, uint256 _amount, address _receiver, string memory transactionHash) external override {
        //require(TODO); - msg.sender == _reciever???

        WrappedPhoboCoin(_wrappedToken).burnFrom(msg.sender, _amount);

        emit Burn(_wrappedToken, _amount, _receiver, transactionHash);
    }

    function unlock(address _nativeToken, uint256 _amount, address _receiver, string memory transactionHash) external override {
        //require(TODO);

        ERC20(_nativeToken).transferFrom(address(this), msg.sender, _amount);

        emit Unlock(_nativeToken, _amount, _receiver, transactionHash);
    }
}