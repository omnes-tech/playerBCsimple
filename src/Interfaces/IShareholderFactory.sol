// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IShareholderFactory {
    function newBaseShareholder(address _manager) external returns(address);
    function newFederalShareholder(address _manager) external returns(address);
    function newInternationalShareholder(address _manager) external returns(address);
    function changeManager(address _newManager, address _account) external;
    function managementCheck(address _address) external;
    function baseAccountCheck(address _address) external;
}