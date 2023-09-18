// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


import "lib/ERC721A/contracts/ERC721A.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../Interfaces/IPassportController.sol";
import "../Interfaces/IFederalAccount.sol";
import "../Interfaces/IInternationalAccount.sol";
import "../Interfaces/IBaseAccount.sol";

contract PlayersBCsimple is ERC721A, 
IPassportController, 
IFederalAccount,
IInternationalAccount,
IBaseAccount{

event voteCreated(uint256 indexed _player, bytes32 indexed _voteId, address indexed _to, uint256 _price, address _creator);
    event voted(bytes32 _vote, address _manager);
    event transfered(uint256 indexed _player, address indexed _to, uint256 indexed _price, uint256 _timestamp);

    struct receipt {
        bool _voted;
        uint256 _timestamp;
    }

    struct playerTransfer{
        address _team;
        uint256 _playerId;
        uint256 _price;
        bool _bothAcept;
        bool _teamAccept;
        bool _stakeholderAccept;
    }

    struct voting {
        address _proponent;
        uint _vote;
        bool _executed;
    }


uint256 constant _24YEARS = 365 days * 24;
    mapping(address => bool) public transferApproved;
    mapping(address => bool) public managers;

    mapping(address => bool) public base;
    
    mapping(address => bool) public federal;

    mapping(address => bool) public international;

    mapping(address => bool)public passportController;  

    mapping(uint256 => PlayerInfo) public players;
    mapping(uint256 => TrainerInfo[]) public trainers;

    mapping(address => playerTransfer) public transfers;
    mapping(address => receipt) public vote;

    mapping(address => mapping(address => playerTransfer)) acceptTransfers;

    address public COIN;

    string public baseURI;
    mapping(uint256 => string) private _tokenURIs;
    event MetadataUpdate(uint256 _id);


constructor(address _coin)ERC721A("PlayersBC", "PLBC"){
COIN = _coin;
}

//passaport ----

function createPlayerPassport(uint256 _birth, 
address _baseAccount, 
address _agent) external returns(uint256){ //mint for base account
baseAccountCheck(_baseAccount);
players[_nextTokenId()-1]._birthTimestamp = _birth; //unistimestamp
players[_nextTokenId()-1]._currentBase = _baseAccount;
players[_nextTokenId()-1]._creation = block.timestamp;
players[_nextTokenId()-1]._playerController = _agent;
        

_safeMint(_baseAccount, 1, "");

return (_nextTokenId()-1);

}


function transferPlayer(uint256 _playerID, address _to) external returns(bool){
    baseAccountCheck(_to);
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



function _solidarityMechanism(uint _value, address _base, address _team) internal {
    uint256 fivePercentBase = _value*100/5; //5%
    uint amountTransfer = _value - fivePercentBase;
    
    IERC20(COIN).transfer(_base, fivePercentBase);
    IERC20(COIN).transfer(_team, amountTransfer);


}



//internationalccounts ----

function addFederalAccount(address _manager) external{
_isManager();
international[_manager]=true;
}
    function generatePlayerRequestInternational(bytes32 _vote) external{

    }

    function acceptVoteInternacional(bytes32 _vote) external{

    }

    function changeManagerInternational(address _manager) external{

    }


//federalaccounts ----


    function generatePlayerRequest(uint _playerID) external{

    }

    function acceptVoteFederal(uint _playerID, address _base) external{
        baseAccountCheck(_base);
        if(acceptTransfers[msg.sender][_base]._teamAccept == true){
        acceptTransfers[msg.sender][_base]._stakeholderAccept = true;
        } else {
            revert("team not Request transfer this player");
        }
    }

    
    function executeTransactionBase(uint _playerID, address _base) external{
        _isFederal();
        baseAccountCheck(_base);
        require(acceptTransfers[msg.sender][_base]._bothAcept = true, "not both accept transfer player");
        
    }

    
    function addBaseAccount(address _baseAccount) external{
        _isFederal();
        base[_baseAccount]=true;
    }

   
    function removeBaseAccount(address _baseAccount) external{
        
        _isFederal();
        base[_baseAccount]=false;
    }




//baseaccounts ----

function generatePlayerRequest(uint256 _playerID, address _transferTo, uint256 _price, address _stakeholder) external{
require(baseAccountCheck(_transferTo) && baseAccountCheck(msg.sender), "You are not base or address to transfer");
_exists(_playerID);

acceptTransfers[_stakeholder][msg.sender]._teamAccept = true;
playerTransfer({_team: _transferTo, _playerId: _playerID, _price: _price,
 _bothAcept: false, _teamAccept: true, _stakeholderAccept: false});

}

    function executeTransaction(uint _playersID, address _stakeholder) external{
    baseAccountCheck(msg.sender);
        require(acceptTransfers[_stakeholder][msg.sender]._bothAcept = true, "not both accept transfer player");
    }

    
    function changeManager(address _manager) external{

    }

    
    function approveOutsider(address _spender, uint256 _amount) external returns(bool){

    }

    
    function changePaymentToken(address _paymentToken) external returns(bool){

    }


    ///manager

     function managementCheck(address _address) external view{ 
        
        if(!managers[_address]) revert("You're not a manager");
    }

    function addManager(address _newManager) external {
        _isManager();

        managers[_newManager] = true;
    }
    
    function baseAccountCheck(address _address) internal view returns(bool){
        if(!base[_address]) revert("You're not a base account");
        return true;
    }

    function _isPassport() internal view {
        if(!passportController[msg.sender]) revert("You're not passport controller");
    }

    function _isManager() internal view {
        if(!managers[msg.sender]) revert("You're not a manager");
    }
    function _isFederal() internal view {
        if(!federal[msg.sender]) revert("You're not a federal shareholder");
    }
    function _isInternational() internal view {
        if(!international[msg.sender]) revert("You're not an international shareholder");
    }

    //image passaport
    function tokenURI(uint256 tokenId) public view virtual override(ERC721A) returns (string memory) {
        if (!_exists(tokenId)) revert URIQueryForNonexistentToken();

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory baset = _baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(baset).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(baset, _tokenURI));
        }
        return super.tokenURI(tokenId);

        // return
        //     bytes(baseURI).length > 0
        //         ? string(abi.encodePacked(ERC721URIStorage.tokenURI(tokenId), tokenId.toString()))
        //         : baseURI;
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;

        emit MetadataUpdate(tokenId);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function setCoin(address _newcoin)external{
        COIN = _newcoin;
    }


    //control trasnfer passaport

    // function safeTransferFrom(
    //     address from,
    //     address to,
    //     uint256 tokenId
    // ) public payable virtual override {
    //     _isPassport();
    //     safeTransferFrom(from, to, tokenId, '');
    // }


    function deposit(uint256 _amount) external returns(bool) {
        _isManager();
        require(IERC20(COIN).allowance(msg.sender, address(this)) >= _amount, "Base Account : Not enough allowance");

        return IERC20(COIN).transferFrom(msg.sender, address(this), _amount);
    }

    function withdraw(uint256 _amount) external returns(bool){
        _isManager();

        return IERC20(COIN).transfer(msg.sender, _amount);
    }

}