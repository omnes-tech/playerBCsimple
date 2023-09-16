// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
// import "../src/PassportControler.sol";
// import "../src/ShareholderFactory.sol";
// import "../src/Utils/FactoryBeacon.sol";
// import "../src/shareholders/BaseAccount.sol";
// import "../src/shareholders/FederalAccount.sol";
// import "../src/shareholders/InternationalAccount.sol";
// import "../test/Utils/MockERC20.sol";

contract CounterTest is Test {

    // PassportController public passportImplementation;
    // PassportController public passport;
    // ShareholderFactory public factory;
    // BaseAccount public baseImplementation;
    // BaseAccountBeacon public baseBeacon;
    // FederalAccount public federalImplementation;
    // FederalAccountBeacon public federalBeacon;
    // InternationalAccount public internationalImplementation;
    // InternationalAccountBeacon public internationalBeacon;
    // mockERC20 public payment;

    // address owner;
    // uint256 ownerPrivateKey;
    // address user;
    // uint256 userPrivateKey;
    // address manager1;
    // uint256 manager1PrivateKey;
    // address manager2;
    // uint256 manager2PrivateKey;
    // address manager3;
    // uint256 manager3PrivateKey;

    // address[] managers;

    function setUp() public {

        // (owner, ownerPrivateKey) = makeAddrAndKey("owner");
        // (user, userPrivateKey) = makeAddrAndKey("user");
        // (manager1, manager1PrivateKey) = makeAddrAndKey("manager1");
        // (manager2, manager2PrivateKey) = makeAddrAndKey("manager2");
        // (manager3, manager3PrivateKey) = makeAddrAndKey("manager3");

        // managers.push(manager1);
        // managers.push(manager2);
        // managers.push(manager3);

        // vm.startPrank(owner,owner);

        // payment = new mockERC20("Payment", "P2P");
        // baseImplementation = new BaseAccount();
        // baseBeacon = new BaseAccountBeacon(address(baseImplementation));
        // federalImplementation = new FederalAccount();
        // federalBeacon = new FederalAccountBeacon(address(federalImplementation));
        // internationalImplementation = new InternationalAccount();
        // internationalBeacon = new InternationalAccountBeacon(address(internationalImplementation));
        
        // bytes memory construtor = abi.encodeWithSignature("initialize(string,string,address[])", "Passport", "PSP", managers);
        
        // passportImplementation = new PassportController();
        // passport = PassportController (address(new UUPSPassport(address(passportImplementation), construtor)));
        // factory = new ShareholderFactory(address(baseBeacon),address(federalBeacon),address(internationalBeacon),address(passport),address(payment),managers);
        
        // vm.stopPrank();

        // vm.prank(manager1,manager1);
        // passport.setFactory(address(factory));
    }

    function testMintPassport() public {

        // vm.prank(manager1,manager1);
        // address International = factory.newInternationalShareholder(manager3);
        // vm.prank(manager3,manager3);
        // address Federal = InternationalAccount(International).generateFederalAccount(manager2);
        // vm.prank(manager2,manager2);
        // address Base = FederalAccount(Federal).generateBaseAccount(manager1);
        // vm.prank(manager2,manager2);
        // address Base2 = FederalAccount(Federal).generateBaseAccount(manager1);

        // console.log("----------------------------------------------");
        // console.log("International Shareholder Created at: ", International);
        // console.log("Federal Shareholder Created at: ", Federal);
        // console.log("Base Shareholder Created at: ", Base);
        // console.log("Base2 Shareholder Created at: ", Base2);

        // vm.prank(manager1,manager1);
        // uint256 birth = 2016;
        // address agent = 0xAaa7cCF1627aFDeddcDc2093f078C3F173C46cA4;
        // uint256 playerID = passport.createPlayerPassport(birth, Base, agent) - 1;

        // console.log("Player ID created at : ", playerID);
        // console.log("Owner of playerID 0 : ", passport.ownerOf(0));
        

        // deal(address(payment), Base2, 20000);
        // vm.prank(manager1,manager1);
        // BaseAccount(Base2).approveOutsider(Base, 20000);

        // console.log("Balance of Base before : ", payment.balanceOf(Base));
        // console.log("Balance of Base 2 before : ", payment.balanceOf(Base2));

        // console.log("----------------------------------------------");
        // console.log("Creating a vote for playerID 0 at base account, transfer to Base2");

        // vm.prank(manager1,manager1);

        // bytes32 vote = BaseAccount(Base).generatePlayerRequest(0, Base2, 20000);
        // console.logBytes32(vote);


        // console.log("Approving on Federal Level...");

        // vm.prank(manager2,manager2);
        // FederalAccount(Federal).acceptVote(vote);
        
        
        // console.log("Approving on International Level...");

        // vm.prank(manager3,manager3);
        // InternationalAccount(International).acceptVote(vote);
        

        // console.log("Checking for PlayerID 0 owner : ", passport.ownerOf(0));

        // console.log("Balance of Base after : ", payment.balanceOf(Base));
        // console.log("Balance of Base 2 after : ", payment.balanceOf(Base2));
        

        
    }
}
