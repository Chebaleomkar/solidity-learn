
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Twitter {
    address public owner;
    bool public paused;
    mapping (address => uint) public balance;
    
    constructor(){
        owner = msg.sender;
        paused = false;
        balance[owner] = 1000;
    }

    // define struct
    struct Tweet{
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }
    
    uint16 constant MAX_TWEET_LENGTH = 200;
    uint16 constant MIN_TWEET_LENGTH = 10;
    mapping (address => Tweet[]) public tweets;

    // implement modifiers
    modifier  onlyOwner(){
        require(msg.sender == owner, "you are not the owner !");
        _;
    }
    modifier notPaused(){
        require(!paused , "The contract is inActive!");
        _;
    }

    function createTweet(string memory  _tweets) public notPaused onlyOwner {

        require(bytes(_tweets).length <= MAX_TWEET_LENGTH  , "Tweet is long !");
        require(bytes(_tweets).length >= MIN_TWEET_LENGTH , "Tweet is so small !"  );
        
        Tweet memory newTweet = Tweet ({
            author : msg.sender,
            content : _tweets,
            timestamp : block.timestamp,
            likes : 0
        });
        tweets[msg.sender].push(newTweet);
    }

    function getTweets(address _owner, uint _i) public view returns (Tweet memory)  {
        return tweets[_owner][_i];
    }

    function getAllTweets(address _owner) public view returns (Tweet[] memory){
        return  tweets[_owner];
    }
    
}