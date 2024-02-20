// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../MultiSig.sol";

interface IMultiSigFactory {
    function createMultiSigWallet(address[] memory _validSigners, uint256 _quorum) external returns (MultiSig newMulSig_, uint256 length_);

    function getMultiSigClones() external view returns(MultiSig[] memory);
}