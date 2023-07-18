// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract lottery {
address public manager;
address payable[] public player;
// address public player;

mapping(address=>uint256) public players;


modifier onlymanger{
    require(msg.sender==manager,"only manager can pick the lotery ");
    _;
}
constructor (){
    manager=msg.sender;
}
function alreadyContributer() private returns(bool){
     for (uint256 i =0; i <= player.length ; i++) 
     {
           if  ((player[i]==msg.sender))
             return true;
             else 
             return false;
        }
}
function contribute() public payable
 {

    require(msg.value >=1 ether,"enter minimum one ether for contribution");
    require(manager!= msg.sender,"manager cant contribute ");
    if (player.length>0){
    require(alreadyContributer()==false,"you cant contribute again");
    }
    players[msg.sender]=msg.value;
    player.push(payable(msg.sender));
}
function pickWinner ()public onlymanger {
    uint index = random() % player.length;
        player[index].transfer(address(this).balance);  
         player = new address payable[](0);
      

}
  function random() private view returns(uint){
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, player)));
    }
}
