pragma solidity ^0.4.24; 

contract TestFunc{
    
    struct Req{
        bytes data; 
        function (bytes memory) external callback;
    }
    
    Req[] request; 
    
    event NewReq(uint);
    function query(bytes data, function(bytes memory) external callback) public {
        request.push(Req(data, callback));
        emit NewReq(request.length -1);
    }
    
    function reply(uint requestID, bytes response) public {
        request[requestID].callback(response);
    }
}

contract TestFuncUser {
    TestFunc constant test = TestFunc(0x1234567); 
    function buysmt(){
        test.query("USD", this.testResponse);
    }
    
    function testResponse(bytes response)  public {
        require(
            msg.sender == address(test), 
            "Only test can call this");
            
    }
    
    
}
