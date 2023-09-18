// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/PassportControler.sol";
import "../src/Utils/FactoryBeacon.sol";
//import "../src/shareholders/BaseAccount.sol";
// import "../src/shareholders/FederalAccount.sol";
// import "../src/shareholders/InternationalAccount.sol";
import "../test/Utils/MockERC20.sol";

contract Deploy is Script {

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

    // address[] managers;

    function setUp() public {
      //  managers.push(0x2271b1FBb0126F79b54b45f4787733286D035fe5);
        
    }

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

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


        vm.stopBroadcast();
    }
}
