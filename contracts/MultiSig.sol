// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract MultiSig {
    address owner;
    address[] signers;
    uint256 quorum;
    uint256 txCount;

    address nextOwner;

    struct Transaction {
        uint256 id;
        uint256 amount;
        address receiver;
        uint256 signersCount;
        bool isExecuted;
        address txCreator;
    }

    Transaction[] allTransactions;

    // mapping of transaction id to signer address returning bool:
    // this checks if a valid signer has signed a trasaction
    mapping (uint256 => mapping (address => bool)) hasSigned;

    // mapping of transaction id to transaction struct
    // used to track transactions given their ID;
    mapping(uint256 => Transaction) transactions;

    mapping(address => bool) isValidSigner;


    constructor(address[] memory _validSigners, uint256 _quorum) {
        owner = msg.sender;
        signers = _validSigners;
        quorum = _quorum;

        for(uint8 i = 0; i < _validSigners.length; i++) {
            require(_validSigners[i] != address(0), "get out");

            isValidSigner[_validSigners[i]] = true;
        }
    }

    function initiateTransaction(uint256 _amount, address _receiver) external {
        require(msg.sender != address(0), "zero address detected");
        require(_amount > 0, "no zero value allowed");

        onlyValidSigner();

        uint256 _txId = txCount + 1;

        Transaction storage tns = transactions[_txId];

        tns.id = _txId;
        tns.amount = _amount;
        tns.receiver = _receiver;
        tns.signersCount = tns.signersCount + 1;
        tns.txCreator = msg.sender;

        allTransactions.push(tns);

        hasSigned[_txId][msg.sender] = true;

        txCount = txCount + 1;
    }

    function approveTransaction(uint256 _txId) external {
        require(_txId <= txCount, "invalid transaction id");
        require(msg.sender != address(0), "zero address detected");

        onlyValidSigner();

        require(!hasSigned[_txId][msg.sender], "can't sign twice");

        Transaction storage tns = transactions[_txId];

        require(address(this).balance >= tns.amount, "insufficient contract balance");

        require(!tns.isExecuted, "transaction already executed");
        require(tns.signersCount < quorum, "quorum count reached");

        tns.signersCount = tns.signersCount + 1;

        hasSigned[_txId][msg.sender] = true;

        if(tns.signersCount == quorum) {
            tns.isExecuted = true;
            payable(tns.receiver).transfer(tns.amount);
        }

    }

    function transferOwnership(address _newOwner) external {
        onlyOwner();

        nextOwner = _newOwner;
    }

    function claimOwnership() external {
        require(msg.sender == nextOwner, "not next owner");

        owner = msg.sender;
        
        nextOwner = address(0);
    }

    function addValidSigner(address _newSigner) external {
        onlyOwner();

        require(!isValidSigner[_newSigner], "signer already exist");

        isValidSigner[_newSigner] = true;
        signers.push(_newSigner);
    }

    function getAllTransactions() external view returns (Transaction[] memory) {
        return allTransactions;
    }

    function onlyOwner() private view {
        require(msg.sender == owner, "not owner");
    }

    function onlyValidSigner() private view {
        require(isValidSigner[msg.sender], "not valid signer");
    }

    receive() external payable {}

    fallback() external payable {}
}

// "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4","0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2",
// "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db",
// "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB",
// "0x0000000000000000000000000000000000000000"

// 0x5c6B0f7Bf3E7ce046039Bd8FABdfD3f9F5021678