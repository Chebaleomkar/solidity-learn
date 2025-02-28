
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
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }
    
    uint16 public MAX_TWEET_LENGTH = 200;
    uint16 public MIN_TWEET_LENGTH = 10;
    mapping (address => Tweet[]) public tweets;

    //Events
    event NewTweetCreated(uint256 id , address author , string content ,uint256  timestamp);
    event TweetLike(address liker , address tweetAuthor , uint256 tweetId , uint256 newLikeCount);
    event TweetUnLike(address unLiker , address tweetAuthor , uint256 tweetId , uint256 likeCont);

    // implement modifiers
    modifier  onlyOwner(){
        require(msg.sender == owner, "you are not the owner !");
        _;
    }
    modifier notPaused(){
        require(!paused , "The contract is inActive!");
        _;
    }

    function changeMaxTweetLenght(uint16 newTweetLenght) public onlyOwner{
        MAX_TWEET_LENGTH = newTweetLenght;
    }

    function changeMinTweetLength(uint16 newTweetLength) public onlyOwner {
        MIN_TWEET_LENGTH = newTweetLength;
    }

    function createTweet(string memory  _tweets) public notPaused onlyOwner {

        require(bytes(_tweets).length <= MAX_TWEET_LENGTH  , "Tweet is long !");
        require(bytes(_tweets).length >= MIN_TWEET_LENGTH , "Tweet is so small !"  );
        
        Tweet memory newTweet = Tweet ({
            id : tweets[msg.sender].length,
            author : msg.sender,
            content : _tweets,
            timestamp : block.timestamp,
            likes : 0
        });
        tweets[msg.sender].push(newTweet);

        emit NewTweetCreated(newTweet.id, newTweet.author, newTweet.content, newTweet.timestamp);
    }

    function likeTweet (address author , uint256 id) external{
        require(tweets[author][id].id == id , "Tweet does not exist");
        tweets[author][id].likes++;
        emit TweetLike(msg.sender, author, id, tweets[author][id].likes );
    }

    function unLikeTweet(address author , uint256 id) external{
       require(tweets[author][id].id == id , "Tweet does not exist");
       require(tweets[author][id].likes > 0  , "Tweet like is empty");
       tweets[author][id].likes--;
       emit TweetUnLike(msg.sender, author, id, tweets[author][id].likes);
    }

    function getTweets(address _owner, uint _i) public view returns (Tweet memory)  {
        return tweets[_owner][_i];
    }

    function getAllTweets(address _owner) public view returns (Tweet[] memory){
        return  tweets[_owner];
    }
    
}