//SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract User {
    struct Player{
        address playerAddress;
        string username;
        uint256 score;
    }

    mapping (address => Player) public players;

    function createuser(address _userAddress , string memory username) external{
        require(players[_userAddress].playerAddress == address(0), "User already exists!");

        Player memory newPlayer = Player({
            playerAddress : _userAddress,
            username : username,
            score : 0
        });

        players[_userAddress] = newPlayer; // Add a semicolon here

    }


}