//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface IBridge {
    event Lock(uint8 targetChain, address token, address receiver, uint256 amount, uint256 serviceFee);
    event Mint(address token, uint256 amount, address receiver);
    event Burn(address token, uint256 amount, address receiver);
    event Unlock(address token, uint256 amount, address receiver);
    
    // function initRouter(uint8 _chainId, address _token) external;
    // function nativeToWrappedToken(uint8 _chainId, bytes memory _nativeToken) external view returns (address);
    function lock(uint8 _targetChain, address _nativeToken, uint256 _amount) external payable;
    function mint(uint8 _nativeChain, address _nativeToken, uint256 _amount, address _receiver) external;
    function burn(address _wrappedToken, uint256 _amount, address _receiver) external;
    function unlock(address _nativeToken, uint256 _amount, address _receiver) external;
}