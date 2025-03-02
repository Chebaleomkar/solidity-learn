
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
import "@openzeppelin/contracts/access/Ownable.sol";

interface IProfile {
    struct UserProfile{
        string displayName;
        string bio;
    }

    function getProfile(address _user) external  view returns(UserProfile memory);
    function setProfile(string memory _displayName , string memory _bio) external;
}

contract Twitter is Ownable {
    // define the address of the profile contract 
     IProfile public profileContract;

    constructor(address _profileContract) Ownable(msg.sender) {
        profileContract = IProfile(_profileContract);
    }

    bool public paused;
    mapping (address => uint) public balance;
    
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

    modifier notPaused(){
        require(!paused , "The contract is inActive!");
        _;
    }

    modifier  onlyRegistere(){
        IProfile.UserProfile memory userProfileTemp = profileContract.getProfile(msg.sender);
        require(bytes(userProfileTemp.displayName).length > 0 , "USER NOT REGISTERED !" );
        require(bytes(userProfileTemp.bio).length >0 , "USER BIO REQUIRED");
        _;
    }
    function getProfileContractAddress() public view returns (address) {
    return address(profileContract);
}


    function changeMaxTweetLenght(uint16 newTweetLenght) public onlyRegistere{
        MAX_TWEET_LENGTH = newTweetLenght;
    }

    function changeMinTweetLength(uint16 newTweetLength) public onlyRegistere {
        MIN_TWEET_LENGTH = newTweetLength;
    }

    function createUser(string memory _displayName , string memory _bio ) public {
        profileContract.setProfile(_displayName, _bio);
    }

    function createTweet(string memory  _tweets) public onlyRegistere {

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

    function likeTweet (address author , uint256 id) external onlyRegistere{
        require(tweets[author][id].id == id , "Tweet does not exist");
        tweets[author][id].likes++;
        emit TweetLike(msg.sender, author, id, tweets[author][id].likes );
    }

    function unLikeTweet(address author , uint256 id) external onlyRegistere{
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
    
    function getTotalLikes(address _author) public view returns (uint256){
        uint256 totalLikes;
        for(uint i =0 ;i< tweets[_author].length;i++ ){
            totalLikes += tweets[_author][i].likes;
        }
        return totalLikes;
    }

}