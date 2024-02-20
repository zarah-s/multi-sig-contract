// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./MultiSig.sol";

contract MultiSigFactory {
    MultiSig[] multiSigClones;

    function createMultiSigWallet(address[] memory _validSigners, uint256 _quorum) external returns (MultiSig newMulSig_, uint256 length_) {
        newMulSig_ = new MultiSig(_validSigners, _quorum);

        multiSigClones.push(newMulSig_);

        length_ = multiSigClones.length;
    }

    function getMultiSigClones() external view returns(MultiSig[] memory) {
        return multiSigClones;
    }
}