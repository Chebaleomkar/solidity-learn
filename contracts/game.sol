//SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

Interface IUser {
    function createuser(address _newuserAddress , string memory username )external;
}
contract Game{
    uint public gameCount;
    Iuser public userContract;

    constructor( address _userContractAddress){
        userContract = Iuser{_userContractAddress};

    }

    function startGame(string memory username) external{
        gameCount ++;

        userContract.createuser(msg.sender , username);
    }
}