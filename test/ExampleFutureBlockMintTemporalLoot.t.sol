// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ExampleFutureBlockMintTemporalLoot.sol"; 



contract ExampleFutureBlockMintTemporalLootTest is Test {
    ExampleFutureBlockMintTemporalLoot fbmloot;

    function setUp() public {
        fbmloot = new ExampleFutureBlockMintTemporalLoot();
        vm.roll(14957686);
    }

    function compareStrings(string memory a, string memory b) public pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }

    function testMint(
        address addr,
        uint256 tokenId
    ) public {
        vm.assume(addr != address(0));
        vm.assume(addr != 0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84);
        vm.prank(addr);
        vm.assume(tokenId > 8000 && tokenId < (block.number / 10) + 1);
        fbmloot.claim(tokenId);
        // TODO abstract mint set up
        address tokenOwner = fbmloot.ownerOf(tokenId);
        assertEq(tokenOwner, addr);
    }

    function testPreview(
        address addr,
        uint256 tokenId
    ) public {
        vm.assume(addr != address(0));
        vm.assume(addr != 0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84);
        vm.prank(addr);
        vm.assume(tokenId > 8000 && tokenId < (block.number / 10) + 1);
        fbmloot.claim(tokenId);
        string memory hand = fbmloot.getHand(tokenId);
        string memory handTest = 'art not available yet';
        assertEq(true, compareStrings(hand, handTest));
    }

    function testLiveView(
        address addr,
        uint256 tokenId
    ) public {
        vm.assume(addr != address(0));
        vm.assume(addr != 0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84);
        vm.prank(addr);
        vm.assume(tokenId > 8000 && tokenId < (block.number / 10) + 1);
        fbmloot.claim(tokenId);
        // skip chain forward more than 10 blocks
        vm.roll(14957686 + 360);
        string memory hand = fbmloot.getHand(tokenId);
        string memory handTest = 'art not available yet';
        assertEq(false, compareStrings(hand, handTest));
    }

}
