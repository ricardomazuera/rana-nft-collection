// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {BasicNft} from "src/BasicNft.sol";

contract MintBasicNft is Script {
    string public constant RANA_URI =
        "ipfs://QmdnunvzgQN7gEJSnignqXzPpPMHuuACrFEh83X5SviSfL?filename=1.json";

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "BasicNft",
            block.chainid
        );
        mintNftOnContract(mostRecentlyDeployed);
    }

    function mintNftOnContract(address basicNftAddress) internal {
        vm.startBroadcast();
        BasicNft(basicNftAddress).mintNft(RANA_URI);
        vm.stopBroadcast();
    }
}
