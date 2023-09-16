// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Interfaces/IPassportController.sol";
import "./Interfaces/IShareholderFactory.sol";

import "lib/ERC721A-Upgradeable/contracts/ERC721AUpgradeable.sol";


contract PassportController is IPassportController,ERC721AUpgradeable{

    uint256[49] private __gap;

    bool _restrict;
    address _factory;
    uint256 constant _24YEARS = 365 days * 24;
    mapping(address => bool) public transferApproved;
    mapping(address => bool) public managers;

    mapping(uint256 => PlayerInfo) public players;
    mapping(uint256 => TrainerInfo[]) public trainers;

    


    function initialize(string calldata  _name, string  calldata _symbol, address[] memory _managers) public initializerERC721A{
        _restrict = true;
        __ERC721A_init(_name,_symbol);

        uint256 _length = _managers.length;
        for(uint i; i < _length; ){
            managers[_managers[i]] = true;
            unchecked {
                ++i;
            }
        }
    }

    function createPlayerPassport(uint256 _birth, address _baseAccount, address _agent) external returns (uint256){
        _isManager();
        IShareholderFactory(_factory).baseAccountCheck(_baseAccount);

        players[_nextTokenId()]._birthTimestamp = _birth;
        players[_nextTokenId()]._currentBase = _baseAccount;
        players[_nextTokenId()]._creation = block.timestamp;
        players[_nextTokenId()]._playerController = _agent;
        
        
        players[_nextTokenId()] = PlayerInfo({
            _birthTimestamp : _birth,
            _creation : block.timestamp,
            _currentBase : _baseAccount,
            _playerController : _agent,
            _retired : false
        });

        trainers[_nextTokenId()].push(TrainerInfo(_baseAccount, 0, block.timestamp));

        
        


        _safeMint(_baseAccount, 1, "");

        return (_nextTokenId());
    }

    function transferPlayer(uint256 _playerID, address _to) external returns(bool){
        IShareholderFactory(_factory).baseAccountCheck(_to);
        
        PlayerInfo memory _auxPlayer = players[_playerID];
        TrainerInfo memory _auxTrainer = trainers[_playerID][trainers[_playerID].length-1];
        require(!_auxPlayer._retired, "Passport Controller : Player is retired");


        if(block.timestamp - _auxPlayer._birthTimestamp < _24YEARS){
            trainers[_playerID][trainers[_playerID].length-1]._duration = block.timestamp - _auxTrainer._timestamp;
            TrainerInfo memory _newTrainer = TrainerInfo({
                    _trainer : _to,
                    _duration : 0,
                    _timestamp : block.timestamp
            });
            trainers[_playerID].push(_newTrainer);

        }else if(_auxTrainer._duration == 0){
            uint256 _auxDuration = _auxPlayer._birthTimestamp + _24YEARS - _auxTrainer._timestamp;

            trainers[_playerID][trainers[_playerID].length-1]._duration = _auxDuration;

        }
        
        
        players[_playerID]._currentBase = _to;

        // _solidarityMechanism();
        transferFrom(msg.sender, _to, _playerID);

        return true;
    }

    function getPlayerInfo(uint256 _playerID) external view returns(PlayerInfo memory){
        return players[_playerID];
    }

    // function getTrainerInfo(uint256 _playerID) external view returns(TrainerInfo memory){
    //     return trainers[_playerID];
    // }

    /// @dev See {ERC721A-_beforeTokenTransfers}.
    // function _beforeTokenTransfers(
    //     address from,
    //     address to,
    //     uint256,
    //     uint256
    // ) internal virtual override {
    //     // If transfers are restricted on the contract, we still want to allow burning and minting.
    //     if (_restrict && from != address(0) && to != address(0)) {
    //         if (!transferApproved[from] && !transferApproved[to]) {
    //             revert("Passport controller : Not transfer approved");
    //         }
    //     }
    // }

    function setRetirement(uint256 _playerID) external {
        PlayerInfo memory _aux = players[_playerID];
        require(msg.sender == _aux._playerController, "Passport Controller : You are not the player's controller");

        _aux._currentBase = address(0);
        _aux._retired = true;

        players[_playerID] = _aux;
    }

    function setFactory(address __factory) external {
        _isManager();

        _factory = __factory;
    }

    function _solidarityMechanism(TrainerInfo[] memory _aux) external{
        for(uint256 i= _aux.length-1; i>0;){

            

            unchecked {
                --i;
            }
        }
    }

    function _isManager() internal view {
        if(!managers[tx.origin]) revert("Shareholder Factory : You're not a manager");
    }

    function getManager(address _manager) external view returns (bool){
        return managers[_manager];
    }
}