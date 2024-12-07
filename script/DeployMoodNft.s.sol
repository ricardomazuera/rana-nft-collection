// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {MoodNft} from "src/MoodNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {console} from "forge-std/console.sol";

contract DeployMoodNft is Script {
    uint256 public DEFAULT_ANVIL_PRIVATE_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    function run() external returns (MoodNft) {
        string memory sadSvg = vm.readFile("./assets/img/mood/sad-face.svg");
        string memory happySvg = vm.readFile(
            "./assets/img/mood/happy-face.svg"
        );

        vm.startBroadcast();
        MoodNft moodNft = new MoodNft(
            svgToImageURI(happySvg),
            svgToImageURI(sadSvg)
        );
        vm.stopBroadcast();
        return moodNft;
    }

    /* 
        This functions converts an SVG string to a base64 encoded image URI string that can be used in an <img> tag

        @param svg: The SVG string to convert to an image URI
        @return: The base64 encoded image URI string
    */
    function svgToImageURI(
        string memory svg
    ) public pure returns (string memory) {
        string memory baseURI = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );
        return string.concat(baseURI, svgBase64Encoded);
    }
}
