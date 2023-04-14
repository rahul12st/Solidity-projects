//SPDX-License-Identifier: Inlicense
pragma solidity >=0.5.0 <0.9.0;

contract EventOrganizer{
struct Event{
    address organizer;
    string name;
    uint date;
    uint price;
    uint ticketCount;
    uint ticketRemain;
}
 mapping(uint=>Event) public events;
 mapping(address=>mapping(uint=>uint)) public tickets;
 uint public nextId;
//for organizer code
 function createEvent(string memory name, uint date,uint price, uint ticketCount) external{
     require(date>block.timestamp,"You can organize event for future dates");
     require(ticketCount>0,"you need to give some tickets");

     events[nextId]=Event(msg.sender,name,date,price,ticketCount,ticketCount);
     nextId++;
 }
 //for attendee code
 function buyTicket(uint id,uint quantity) external payable  {
     require(events[id].date!=0,"Event doesnt exist");
     require(events[id].date>block.timestamp,"Event has already occured");
     Event storage _event = events[id];
     require(msg.value==(_event.price*quantity),"Ethers is not enough ");
     require(_event.ticketRemain>=quantity,"Not enough tickets");
     _event.ticketRemain-=quantity;
     tickets[msg.sender][id]+=quantity;
 }
    function transferTicket(uint id,uint quantity,address to) external {
     require(events[id].date!=0,"Event doesnt exist");
     require(events[id].date>block.timestamp,"Event has already occured");
     require(tickets[msg.sender][id]>=quantity,"You do not have enough tickets");
    tickets[msg.sender][id]-=quantity;
    tickets[to][id]+=quantity;
    }





}