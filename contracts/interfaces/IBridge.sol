//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface IBridge {
    event Lock(uint8 targetChain, address token, address receiver, uint256 amount, uint256 serviceFee);
    event Mint(address token, uint256 amount, address receiver, string transactionHash);
    event Burn(address token, uint256 amount, address receiver, uint8 nativeChainId, address nativeToken, string transactionHash);
    event Unlock(address token, uint256 amount, address receiver, string transactionHash);
    
    // function initRouter(uint8 _chainId, address _token) external;
    function lock(uint8 _targetChain, address _nativeToken, uint256 _amount) external payable;
    function burn(address _wrappedToken, uint256 _amount, address _receiver, string memory transactionHash) external;
    function unlock(address _nativeToken, uint256 _amount, address _receiver, string memory transactionHash) external;
    
    function mint(
        uint8 _nativeChain, 
        address _nativeToken, 
        string memory _nativeTokenName, 
        string memory _nativeTokenSymbol, 
        uint256 _amount, 
        address _receiver, 
        string memory transactionHash) external;
}