
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract User{

    struct Player {
        address playerAddress;
        string username;
        uint256 score;
    }

    mapping (address => Player) public players;

    function createUser(address _userAddress , string memory _username) external{
        require(players[_userAddress].playerAddress == address(0), "Player already exists!");

        Player memory newPlayer = Player ({
            playerAddress : _userAddress,
            username: _username,
            score  : 0
        });
     players[_userAddress] = newPlayer;
    }

}