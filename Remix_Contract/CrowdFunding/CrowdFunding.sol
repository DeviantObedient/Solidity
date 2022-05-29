//SPDX-License-Identifier: No License

pragma solidity ^0.8.0;

contract CrowdFunding{

    mapping(address => uint) public contributors;
    address public admin;
    uint public numberOfContributors;
    uint public minimumContribution;
    uint public goalAmount;
    uint public deadline;//timestamp
    uint public raisedAmount;

    struct Request{
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint numberOfVoters;
        mapping(address => bool) voters;
    }

    mapping (uint => Request) public listOfRequests;
    uint public numRequests;

    modifier onlyAdmin(){
        require(msg.sender == admin,"Only Admin can call this function");
        _;
    }

    constructor(uint _goal, uint _deadline){
        goalAmount = _goal; //the goal amount in wei
        deadline = block.timestamp + _deadline; //deadline in seconds
        minimumContribution = 100;
        admin = msg.sender;
    }

    receive() external payable{
        contribute();
    }

    event ContributeEvent(address _sender, uint _value);
    event CreateRequestEvent(string _description, address _recipient, uint _value);
    event MakePaymentEvent(address _recipient, uint _value);

    function contribute() public payable{
        require(block.timestamp < deadline, "Deadline has passed!");
        require(msg.value >= minimumContribution, "Minimum contribution not met!");

        if(contributors[msg.sender] == 0){
            numberOfContributors++;
        }
        contributors[msg.sender] += msg.value;
        raisedAmount += msg.value;

        emit ContributeEvent(msg.sender, msg.value);
    }
    
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
    function getRefund() public {
        //refunds available only if the deadline has pased and the goal amount has not been raised
        require(block.timestamp > deadline && raisedAmount < goalAmount);
        require (contributors[msg.sender] > 0);//needs to be a contributor to be refunded
    
        address payable recipient = payable(msg.sender);
        uint value = contributors[msg.sender];

        contributors[msg.sender] = 0;//before sending money to avoid re-entrency
        recipient.transfer(value);

        //or simply : payable(msg.sender).transfer(contributors[msg.sender]);    
    }
    
    function createRequest(string memory _description, address payable _recipient, uint _value) public onlyAdmin {
        Request storage newRequest = listOfRequests[numRequests];
        numRequests++;

        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.numberOfVoters = 0;

        emit CreateRequestEvent(_description, _recipient, _value);
    }

    function voteRequest(uint _requestNo) public {
        require(contributors[msg.sender] > 0, "Only contributors can vote");
        Request storage thisRequest = listOfRequests[_requestNo];//storage value to work directly on the request structure in the mapping, and not a copy.
        //the contributor can vote only once for the request
        require(thisRequest.voters[msg.sender] == false,"You have already voted for this request");
        thisRequest.voters[msg.sender] = true;
        thisRequest.numberOfVoters ++;
    }

    function makePayment(uint _requestNo) public onlyAdmin{
        require(raisedAmount >= goalAmount);
        Request storage thisRequest = listOfRequests[_requestNo];
        require(thisRequest.completed == false, "This request has already been completed");
        require(thisRequest.numberOfVoters > (numberOfContributors / 2));//check that 50% of the voters have voted for this request

        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed = true;

        emit MakePaymentEvent(thisRequest.recipient, thisRequest.value);
    }
}
