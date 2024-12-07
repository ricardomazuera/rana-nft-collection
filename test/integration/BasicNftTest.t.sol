// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {DeployBasicNft} from "script/DeployBasicNft.s.sol";
import {BasicNft} from "src/BasicNft.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;
    address public USER = makeAddr("USER");

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Rana";
        string memory actualName = basicNft.name();
        assertEq(actualName, expectedName);
    }

    function testSymbolIsCorrect() public view {
        string memory expectedSymbol = "RANA";
        string memory actualSymbol = basicNft.symbol();
        assertEq(actualSymbol, expectedSymbol);
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        string memory tokenUri = "ipfs://hash_uri";
        basicNft.mintNft(tokenUri);
        uint256 balance = basicNft.balanceOf(USER);
        assertEq(balance, 1);
        assertEq(basicNft.tokenURI(0), tokenUri);
    }
}
