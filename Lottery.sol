// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery {
    address public  manager;
    address payable [] public participants;
    uint256 private nonce = 0;

     constructor() {
         manager=msg.sender;
     }
     receive() external  payable {
         require(msg.value==1 ether);
         participants.push(payable (msg.sender));
     }

     function getBalance() public view returns (uint){
         require(msg.sender==manager);
         return address(this).balance;
     }


    function generateRandomNumber() public returns (uint256) {
        nonce++;
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender, nonce)));
        return (randomNumber % participants.length) + 1; // Return a number between 1 and 100
    }
    function Winner () public {
        require(participants.length>=3);
        require(msg.sender==manager);
        address payable  winner_;
        winner_=participants[generateRandomNumber()];
        winner_.transfer(getBalance());

    }
    
}
