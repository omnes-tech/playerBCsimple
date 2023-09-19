// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/PassportControler.sol";
import "../src/simple/PlayersBCsimple.sol";
import "../test/Utils/MockERC20.sol";

contract CounterTest is Test {

    PassportController public passportImplementation;
    PlayersBCsimple public playersBCsimple;
    mockERC20 public payment;

    address owner;
    uint256 ownerPrivateKey;
    address user;
    uint256 userPrivateKey;
    address managerBase;
    uint256 manager1PrivateKey;
    address managerFederal;
    uint256 manager2PrivateKey;
    address manager;
    uint256 manager3PrivateKey;

     address[] managers;

    function setUp() public {

        (owner, ownerPrivateKey) = makeAddrAndKey("owner");
        (user, userPrivateKey) = makeAddrAndKey("user");
        (manager, manager1PrivateKey) = makeAddrAndKey("manager");
        (managerBase, manager2PrivateKey) = makeAddrAndKey("managerBase");
        (managerFederal, manager3PrivateKey) = makeAddrAndKey("managerFederal");

        managers.push(manager);
        managers.push(managerBase);
        managers.push(managerFederal);

        vm.startPrank(owner,owner);

        payment = new mockERC20("Payment", "P2P");
        playersBCsimple = new PlayersBCsimple(address(payment));
        
        vm.stopPrank();

        vm.prank(manager,manager);
    }

    function testMintPassport() public {

         vm.prank(owner,owner);
         //address[2] memory federals = [managerFederal, manager];
         playersBCsimple.addiInternational(managerFederal);
         vm.prank(managerFederal,managerFederal);
         playersBCsimple.addFederalAccount(managerFederal);
         vm.prank(managerFederal,managerFederal);
         playersBCsimple.addBaseAccount(user);  
        vm.prank(user,user);
        uint256 birth = 168783864;
        playersBCsimple.createPlayerPassport(birth, user, manager); 
        

        
    }
}
