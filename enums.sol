pragma solidity ^0.4.24;

contract enumsTest {
    
    enum ActionChoises {Left, Right, Straight, Sit}
    
    ActionChoises choice; 
    
    ActionChoises constant defaultChoice = ActionChoises.Straight;
    
    function setStraight() public {
        choice = ActionChoises.Straight;
    }
    
    function getChoice() public view returns (ActionChoises){
        return choice;
    }
    
    function getDefaultChoice() public pure returns(uint){
        return uint(defaultChoice);
    }
}