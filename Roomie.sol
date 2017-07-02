pragma solidity ^0.4.8;

contract Roomie{
	string public agreementStatus;
	uint32 public agreementDate;
    string public ipfsHash;
	address[] public roomieAddresses;
	address owner;
	bool public isSigned;
	mapping (address=> bool) signed;
	mapping (address => uint) public roomieId;

    // This is the constructor, called while creating the contract
	function Roomie(
	        string _agreementStatus, 
	        uint32 _agreementDate, 
	        string _ipfsHash, 
	        address[] _roomieAddresses){
		agreementStatus = _agreementStatus;
		agreementDate = _agreementDate;
		ipfsHash = _ipfsHash;
	    roomieAddresses = _roomieAddresses;
	    uint id;
		for(uint i=0;i<_roomieAddresses.length;i++){
		    id = i+1;
		    signed[_roomieAddresses[i]]=false;
		    roomieId[_roomieAddresses[i]]=id;
		}
		owner = msg.sender;
	}

    // This is a function called by all roommates to accept the terms of the document denoted by ipfsHash
	function accept(){
	    signed[msg.sender]=true;
	    bool allSignedTrue = true;
	    for(uint i=0;i<roomieAddresses.length;i++){
		    if(signed[roomieAddresses[i]]==false){
		        allSignedTrue = false;
		    }
		}
		if(allSignedTrue){
		    isSigned = true;
		}
	}
	
	function reject(){
	    signed[msg.sender]=false;
		isSigned = false;
	}
	
	modifier ifRoomie() { 
        if(roomieId[msg.sender]==0) throw;
         _;
    }
    
    modifier ifOwner() { 
        if (owner != msg.sender) throw;
         _;
    }
    
    // A function to change the status of the contract
    function changeStatus(string _status) ifRoomie{
        agreementStatus = _status;
    }
    
    // A function to change the hash of the document in case there is a change in the agreement
    function changeIPFSHash(string _hash) ifRoomie{
        ipfsHash = _hash;   
        isSigned = false;
    }
    
   function removeContract() ifOwner{
		selfdestruct(msg.sender);
		
	}

   function () { throw; }
}