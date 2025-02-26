
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Twitter {

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

    function createTweet(string memory  _tweets) public {

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