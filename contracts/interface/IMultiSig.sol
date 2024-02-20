// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IMultiSig {
    struct Transaction {
        uint256 id;
        uint256 amount;
        address receiver;
        uint256 signersCount;
        bool isExecuted;
        address txCreator;
    }
    
    function initiateTransaction(uint256 _amount, address _receiver) external;

    function getAllTransactions() external view returns (Transaction[] memory);
}