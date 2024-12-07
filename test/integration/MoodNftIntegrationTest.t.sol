// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "src/MoodNft.sol";
import {DeployMoodNft} from "script/DeployMoodNft.s.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNftIntegrationTest is Test {
    MoodNft public moodNft;
    string public constant HAPPY_IMAGE_URI =
        "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz48IS0tIFVwbG9hZGVkIHRvOiBTVkcgUmVwbywgd3d3LnN2Z3JlcG8uY29tLCBHZW5lcmF0b3I6IFNWRyBSZXBvIE1peGVyIFRvb2xzIC0tPgo8c3ZnIGZpbGw9IiNmZmZmMDAiIHdpZHRoPSI4MDBweCIgaGVpZ2h0PSI4MDBweCIgdmlld0JveD0iMCAwIDM2IDM2IiB2ZXJzaW9uPSIxLjEiICBwcmVzZXJ2ZUFzcGVjdFJhdGlvPSJ4TWlkWU1pZCBtZWV0IiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIj4KICAgIDx0aXRsZT5oYXBweS1mYWNlLXNvbGlkPC90aXRsZT4KICAgIDxwYXRoIGQ9Ik0xOCwyQTE2LDE2LDAsMSwwLDM0LDE4LDE2LDE2LDAsMCwwLDE4LDJaTTguODksMTMuODlhMiwyLDAsMSwxLDIsMkEyLDIsMCwwLDEsOC44OSwxMy44OVptOS4yNCwxNC4zMmE4LjY3LDguNjcsMCwwLDEtOC4yNi02SDI2LjM4QTguNjcsOC42NywwLDAsMSwxOC4xMywyOC4yMVptNi45My0xMi4zMmEyLDIsMCwxLDEsMi0yQTIsMiwwLDAsMSwyNS4wNSwxNS44OVoiIGNsYXNzPSJjbHItaS1zb2xpZCBjbHItaS1zb2xpZC1wYXRoLTEiPjwvcGF0aD4KICAgIDxyZWN0IHg9IjAiIHk9IjAiIHdpZHRoPSIzNiIgaGVpZ2h0PSIzNiIgZmlsbC1vcGFjaXR5PSIwIi8+Cjwvc3ZnPg==";
    string public constant SAD_IMAGE_URI =
        "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz48IS0tIFVwbG9hZGVkIHRvOiBTVkcgUmVwbywgd3d3LnN2Z3JlcG8uY29tLCBHZW5lcmF0b3I6IFNWRyBSZXBvIE1peGVyIFRvb2xzIC0tPgo8c3ZnIGZpbGw9IiM5OTk5OTkiIHdpZHRoPSI4MDBweCIgaGVpZ2h0PSI4MDBweCIgdmlld0JveD0iMCAwIDM2IDM2IiB2ZXJzaW9uPSIxLjEiICBwcmVzZXJ2ZUFzcGVjdFJhdGlvPSJ4TWlkWU1pZCBtZWV0IiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIj4KICAgIDx0aXRsZT5zYWQtZmFjZS1zb2xpZDwvdGl0bGU+CiAgICA8cGF0aCBkPSJNMTgsMkExNiwxNiwwLDEsMCwzNCwxOCwxNiwxNiwwLDAsMCwxOCwyWm05LDEyLjI4YTEuOCwxLjgsMCwxLDEtMS44LTEuOEExLjgsMS44LDAsMCwxLDI3LDE0LjI4Wm0tMTUuNTUsMS44YTEuOCwxLjgsMCwxLDEsMS44LTEuOEExLjgsMS44LDAsMCwxLDExLjQxLDE2LjA4Wm0xNCw3LjUzYTEsMSwwLDAsMS0xLjYsMS4yLDcsNywwLDAsMC0xMS4zMS4xMywxLDEsMCwxLDEtMS42My0xLjE2LDksOSwwLDAsMSwxNC41NC0uMTdaIiBjbGFzcz0iY2xyLWktc29saWQgY2xyLWktc29saWQtcGF0aC0xIj48L3BhdGg+CiAgICA8cmVjdCB4PSIwIiB5PSIwIiB3aWR0aD0iMzYiIGhlaWdodD0iMzYiIGZpbGwtb3BhY2l0eT0iMCIvPgo8L3N2Zz4=";

    DeployMoodNft deployer;
    address USER = makeAddr("USER");

    function setUp() public {
        deployer = new DeployMoodNft();
        moodNft = deployer.run();
    }

    function testViewTokenURIIntegration() public {
        vm.prank(USER);
        moodNft.mintNft();
        string memory tokenUri = moodNft.tokenURI(0);
        console.log(tokenUri);
    }

    function testFlipTokenToSad() public {
        vm.prank(USER);
        moodNft.mintNft();

        vm.prank(USER);
        moodNft.flipMood(0);

        string memory sadTokenUri = string.concat(
            "data:application/json;base64,",
            Base64.encode(
                bytes( // bytes casting actually unnecessary as 'abi.encodePacked()' returns a bytes
                    abi.encodePacked(
                        '{"name":"',
                        moodNft.name(), // You can add whatever name here
                        '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                        '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                        SAD_IMAGE_URI,
                        '"}'
                    )
                )
            )
        );

        assertEq(moodNft.tokenURI(0), sadTokenUri);
    }
}
