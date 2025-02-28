
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract MappingExample{

    mapping(address => uint) public balances;
    address[] public users;

    function setBalance(address _user , uint _amount)public{
        if(balances[_user] == 0){
            users.push(_user);
        }
        balances[_user] = _amount;
    }

    function getBalance(address _user) public view returns(uint){
        return balances[_user];

    }

    function TotoalBankBalance()public view returns (uint){
        uint totalBankAmount;

        for(uint i=0 ; i < users.length ;i++){
            totalBankAmount += balances[users[i]];
        }
        
        return totalBankAmount;
    }

}