// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


interface IInternationalAccount{

    ///@dev Function to generate a new Federal account
    ///@param _manager is the single manager of the federal account
    function addFederalAccount(address _manager) external;

    ///@dev Function to generate player transfer voting
    ///@param _vote is the transfer transaction ID
    ///@notice only a federal account can create
    function generatePlayerRequestInternational(bytes32 _vote) external;

    ///@dev Function to accept the transaction
    ///@param _vote is the transaction ID
    function acceptVoteInternacional(bytes32 _vote) external;

    ///@dev Function to change the single manager of the international account
    ///@param _manager is the new manager address
    //function changeManagerInternational(address _manager) external;
}