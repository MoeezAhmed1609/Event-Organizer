// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract Event {

    struct Event_Details {
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticket_count;
        uint ticket_remain;
    }

    mapping (uint => Event_Details) public Event_Map;
    mapping (address => mapping (uint => uint)) Tickets;

    event Event_Details (address _oragnizer , string _name , uint _date , uint _price , uint _ticket_count , uint _ticket_remain);
    event Ticket_Details (uint _id , address _buyer , uint _quantity , uint _amount);
    emit Ticket_Transfer_Details (address _contract , uint _id , address _from , address _to , uint _quantity);

    uint event_id;

    function organize_event (
        string memory _name ,
        uint _date ,
        uint _price ,
        uint _ticket_count
        ) external returns (bool) {

            require (_date > block.timestamp , "Timestamp error, aborting!");
            require (_ticket_count > 0 , "Not enough amount of tickets provided, aborting!");

            Event_Map[event_id] = Event_Details(msg.sender , _name , _date , _price , _ticket_count , _ticket_count);
            event_id++;

            emit Event_Details (_oragnizer , _name , _date , _price , _ticket_count , _ticket_count);

    }

    function buy_tickets (address _buyer , uint _id , uint _quantity) external payable {
            require(Event_Map[_id].date != 0 && Event_Map[_id].date > block.timestamp , "Event does not exist, aborting!");
            
            Event_Details storage _event = Event_Map[_id];

            require(msg.value >= (_event.price * _quantity) , "Not enough Ethers provided, aborting!");
            require(_event.ticket_remain >= _quantity, "Not enough tickets remaining, aborting!");

            _event.ticket_remain -= _quantity;
            Tickets[_buyer][_id] += _quantity;

            emit Ticket_Details (_id , _buyer , _quantity , msg.value);

    }

    function transfer_tickets (uint _id , address _from , address _to , uint _quantity) public returns (bool) {

        require(Tickets[_from][_id] >= _quantity , "Not enough tickets, aborting!");
        require(Event_Map[_id].date != 0 && Event_Map[_id].date > block.timestamp , "Event does not exist, aborting!");

        Tickets[_from][_id] -= _quantity;
        Tickets[_to][_id] += _quantity;

        emit Ticket_Transfer_Details (address(this) , _id , _from , _to , _quantity);

        return true;

    }

}