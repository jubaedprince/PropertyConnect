/**
 *Submitted for verification at Etherscan.io on 2022-03-23
*/

// SPDX-License-Identifier: GPL-3.0

 /* 
 
 --------------------------------------
 || Design Pattern Final Assignment ||
 --------------------------------------
 George Brown College 
 Blockchain Development, Winter 2022

 Team Members
 ------------
 Gulshan Jubaed Prince
 Shruti Chauhan
 Parth Govindbhai Ilasariya

  */

pragma solidity ^0.8.7;

contract PropertyConnect {
    struct Property {
        string name; 
        uint256 lockFee;
        address buyer;
        bool releasedByBuyer;
        bool releasedBySeller;
    }

    // buyer can sale one property at a time
    mapping (address => Property) public properties; 

    address[] public listing_addresses;
    uint public listingCount;
    uint public balance;

    function addProperty(string memory details) public payable {
        Property memory property  = Property({name: details, lockFee: msg.value, buyer: address(0), releasedByBuyer: false, releasedBySeller: false});
        properties[msg.sender] = property;
        listing_addresses.push(msg.sender);
        listingCount++;
    }

    fallback() external payable {
    }

    receive() external payable {
    }

    function updateBalance() public{
        balance = address(this).balance;
    }

    function lockProperty(address owner) public payable{
        Property memory property = properties[owner];
        require(msg.value >= property.lockFee, "Send the lock fee");
        properties[owner].name = "Locked";
        properties[owner].buyer = msg.sender;
    }

    function releasePropertyByBuyer(address owner) public{
        if(msg.sender == properties[owner].buyer){
            properties[owner].releasedByBuyer = true;
        }
    }

    function releasePropertyBySeller() public{
        properties[msg.sender].releasedBySeller = true;
    }

    function releaseFund(address release) public{
        if(properties[release].releasedBySeller == true && properties[release].releasedByBuyer == true){
            (bool sent, bytes memory data) = release.call{value: properties[release].lockFee}("");
            require(sent, "Failed to send Ether to owner");

            address buyer = properties[release].buyer;
            (bool sentBuyer, bytes memory dataBuyer) = buyer.call{value:properties[release].lockFee}("");

            require(sentBuyer, "Failed to send Ether to buyer");

            data;
            dataBuyer;
        }
    }

}
