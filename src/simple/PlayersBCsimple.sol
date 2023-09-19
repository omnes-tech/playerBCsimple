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
managers[msg.sender] = true;
}

//passaport ----

function createPlayerPassport(uint256 _birth, 
address _baseAccount, 
address _agent) external returns(uint256){ //mint for base account
if(!baseAccountCheck(_baseAccount)) revert("not base account");
//unchecked{
players[_nextTokenId()] = PlayerInfo({
    _birthTimestamp:_birth,
    _creation: block.timestamp,
    _currentBase:_baseAccount,
    _playerController:_agent,
    _retired:false
});  // deu erro com -1 de underflow
// players[_nextTokenId()-1]._birthTimestamp = _birth; //unistimestamp
// players[_nextTokenId()-1]._currentBase = _baseAccount;
// players[_nextTokenId()-1]._creation = block.timestamp;
// players[_nextTokenId()-1]._playerController = _agent;
// }
_safeMint(_baseAccount, 1, "");

return (_nextTokenId()-1);

}


function transferPlayer(uint256 _playerID, address _to) public returns(bool){
    if(!baseAccountCheck(_to)) revert("not base address");
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
    unchecked {
        uint256 fivePercentBase = _value*5/100; //5%
    uint amountTransfer = _value - fivePercentBase;
    IERC20(COIN).transfer( _base, fivePercentBase);
    IERC20(COIN).transfer(_team, amountTransfer);
    }


}



//internationalccounts ----


    function addiInternational(address _international) public {
        _isManager();

        international[_international] = true;
    }

    function addFederalAccount(address _federal) external{
    require(international[msg.sender]|| managers[msg.sender], "your not stakeholder or manager");
    federal[_federal]=true;
    }
    function generatePlayerRequestInternational(uint _playerID, address _team) external{
    require(international[msg.sender]|| managers[msg.sender], "your not stakeholder or manager");
    if(!_exists(_playerID)) revert("not exist player");
    acceptTransfers[msg.sender][_team]._stakeholderAccept = true;
    playerTransfer({_team: _team, _playerId: _playerID, _price: 0,
     _bothAcept: false, _teamAccept: true, _stakeholderAccept: false});
    }

    function acceptVoteInternacional(uint _playerID, address _team) external{
        require(international[msg.sender]|| managers[msg.sender], "your not stakeholder or manager");
        if(!_exists(_playerID)) revert("not exist player");
        if(acceptTransfers[msg.sender][_team]._teamAccept == true){
        acceptTransfers[msg.sender][_team]._stakeholderAccept = true;
        } else {
            revert("team not Request transfer this player");
        }
    }

    function changeManagerInternational(address _newinternational) external{
    require(international[msg.sender]|| managers[msg.sender], "your not stakeholder or manager");
    addiInternational(_newinternational);
    }


//federalaccounts ----


    function generatePlayerRequestFederal(uint _playerID, address _base) external{
    require(federal[msg.sender]|| managers[msg.sender], "your not stakeholder or manager");
    if(!_exists(_playerID)) revert("not exist player");
    acceptTransfers[msg.sender][_base]._stakeholderAccept = true;
    playerTransfer({_team: _base, _playerId: _playerID, _price: 0,
     _bothAcept: false, _teamAccept: true, _stakeholderAccept: false});
    }

    function acceptVoteFederal(uint _playerID, address _base) external{
        if(!baseAccountCheck(_base)) revert("not base account");
        require(federal[msg.sender]|| managers[msg.sender], "your not stakeholder or manager");
        if(!_exists(_playerID)) revert("not exist player");
        if(acceptTransfers[msg.sender][_base]._teamAccept == true){
        acceptTransfers[msg.sender][_base]._stakeholderAccept = true;
        } else {
            revert("team not Request transfer this player");
        }
    }

    
    function executeTransactionFederal(uint _playerID, address _base) external{
        require(federal[msg.sender]|| managers[msg.sender], "your not stakeholder or manager");
        if(!baseAccountCheck(_base)) revert("not base account");
        if(!transferPlayer( _playerID, _base)) revert("transfer player not execute yeat");
        if(!acceptTransfers[msg.sender][_base]._bothAcept) revert("not both accept transfer player");
        uint price = transfers[msg.sender]._price;
        address teamTransferPLayerFromBase = transfers[msg.sender]._team; 
        if(!transferPlayer(_playerID, teamTransferPLayerFromBase)) revert("There was no transfer, the payment will not be executed");
        _solidarityMechanism(price, msg.sender, teamTransferPLayerFromBase);
        
    }

    
    function addBaseAccount(address _baseAccount) external{
        require(federal[msg.sender]|| managers[msg.sender], "your not stakeholder or manager");
        base[_baseAccount]=true;
    }

   
    function removeBaseAccount(address _baseAccount) external{
       require(federal[msg.sender]|| managers[msg.sender], "your not stakeholder or manager");
        base[_baseAccount]=false;
    }




//baseaccounts ----

function generatePlayerRequestBase(uint256 _playerID, address _transferTo, uint256 _price, address _stakeholder) external{
require(baseAccountCheck(_transferTo) && baseAccountCheck(msg.sender), "addresses not interested in base teams");
if(!_exists(_playerID)) revert("not exist player");

acceptTransfers[_stakeholder][msg.sender]._teamAccept = true;
transfers[msg.sender] = playerTransfer({_team: _transferTo, _playerId: _playerID, _price: _price,
 _bothAcept: false, _teamAccept: true, _stakeholderAccept: false});

}

    function executeTransactionBase(uint _playersID, address _stakeholder) external{
    if(!baseAccountCheck(msg.sender)) revert("not base account");
    if(!_exists(_playersID)) revert("not exist player");
        //require(acceptTransfers[_stakeholder][msg.sender]._bothAcept = true, "not both accept transfer player");
        //address trainer = trainers[_playersID]._trainer; // isso e p time ou treinador?
            uint256 price = transfers[msg.sender]._price;
            address teamTransferPLayerFromBase = transfers[msg.sender]._team;
        
            //if(!transferPlayer(_playersID, teamTransferPLayerFromBase)) revert("There was no transfer, the payment will not be executed");
           
            _solidarityMechanism(price, msg.sender, teamTransferPLayerFromBase);

    }

    
    function changeManager(address _manager) external{
        if(!managers[msg.sender]) revert("You're not a manager");
        managers[_manager]=true;

    }

    
    function transferOutsider(address _to, uint256 _amount) external returns(bool){
        if(!managers[msg.sender]) revert("You're not a manager");
        IERC20(COIN).transferFrom(address(this), _to, _amount);
        return true;
    }

    
    function changePaymentToken(address _paymentToken) external returns(bool){
        if(!managers[msg.sender]) revert("You're not a manager");
        COIN = _paymentToken;
        return true;
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