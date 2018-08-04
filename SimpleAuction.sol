pragma solidity ^0.4.22;

contract SimpleAuction {
    
    // Parameters of the auction. Timers are either absolute unix timestamp or time peroid in seconds
    
    address public beneficiary;
    uint public auctionEnd;
    
    //Current state of the auction 
    address public highestBidder; 
    uint public highestBid; 
    
    //Allowed withdrawls of previous bids
    mapping (address => uint) pendingReturns;
    
    //Set to true at the end, disallows any change
    bool ended;
    
    //Events that will be fired on changes
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winnder, uint amount);
    
    ///Create a simple auction with _biddingTime, seconds bidding time on behalf of the beneficiary address _beneficicary
    constructor(
        uint _biddingTime, 
        address _beneficicary) public {
            beneficiary = _beneficicary;
            auctionEnd = now + _biddingTime;
        }
        
    
    function bid() public payable {
        require(now <=auctionEnd, "Auction already ended.");
        
        // if the bid is not higher, send the money back
        require(msg.value > highestBid, "There already is a higher bid");
        
        if(highestBid !=0) {
            //Sending back the money by simply using highest Bidder.send(highestBid) is security risk 
            //because it could execute an unstrusted contract. 
            pendingReturns[highestBidder] += highestBid;
        }
        
        highestBidder = msg.sender;
        highestBid = msg.value; 
        emit HighestBidIncreased(msg.sender, msg.value);
        
    }
    
    ///withdrawls a bid that was overbid 
    function withdraw() public returns (bools){
        uint amount = pendingReturns[msg.sender];
        if(amount >0){
            pendingReturns[msg.sender] =0;
            if(!msg.sender.send(amount)){
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }
    
    fucntion auctionEnd() public {
        
        //1. Check conditions
        require(now >=auctionEnd, "Auction not yet ended.");
        require(!end, "auctionEnd has already been called");
        
        //2.Effects
        ended = true;
        emit AuctionEnded(highestBidder, highestBid);
        
        //3. Interaction
        beneficiary.transfer(highestBid);
    }
    
    
}