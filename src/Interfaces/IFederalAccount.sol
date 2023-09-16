// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


interface IFederalAccount {
    ///@dev Function to generate new base accounts under this federal entity
    ///@param _manager is the manager of the base account
    //function generateBaseAccount(address _manager) external;

    ///@dev Function that generates a transfer request
    ///@param _vote is the voting to be approved
    ///@notice only a base account can create
    function generatePlayerRequest(bytes32 _vote) external;

    ///@dev Function to accept a transfer request
    ///@param _vote  is the transfer to be approved
    function acceptVoteFederal(bytes32 _vote) external;

    ///@dev Function to execute the transaction
    ///@param _transaction is the transaction ID
    ///@notice only international account can trigger that
    function executeTransactionBase(bytes32 _transaction) external;

    ///@dev Function to add a new base account under this entity accepted addresses of base accounts
    ///@param _baseAccount is the base account address to be added
    function addBaseAccount(address _baseAccount) external;

    ///@dev Function to remove a base account address from the accepted ones
    ///@param _baseAccount is the base account to be taken off
    function removeBaseAccount(address _baseAccount) external;

    ///@dev Function to change the single manager of the federal entity
    ///@param _manager is the new manager address
    //function changeManager(address _manager) external;
    
}