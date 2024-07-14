// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract Create {
    using Counters for Counters.Counter;

    Counters.Counter public _voterId;
    Counters.Counter public _candidateId;

    address public votingOrganizer;

    struct Candidate {
        uint256 candidateId;
        string age;
        string name;
        string image;
        uint256 voteCount;
        address candidateAddress;
        string ipfs;
    }

    event CandidateCreate (
        uint256 indexed candidateId,
        string age,
        string name,
        string image,
        uint256 voteCount,
        address candidateAddress,
        string ipfs
    );

    address[] public candidateAddresses;

    mapping(address => Candidate) public candidates;
    // End of Candidate Data

    // Voter Data

    address[] public votedVoters;

    address[] public voterAddresses;
    mapping(address => Voter) public voters;

    struct Voter {
        uint256 voterId;
        string name;
        string image;
        address voterAddress;
        uint256 allowed;
        bool voted;
        uint256 vote;
        string ipfs;
    }

    event VoterCreated (
        uint256 indexed voterId,
        string name,
        string image,
        address voterAddress,
        uint256 allowed,
        bool voted,
        uint256 vote,
        string ipfs
    );
    // End of Voter Data

    constructor (){
        votingOrganizer = msg.sender;
    }

    function setCandidate(address _address, string memory _age, string memory _name, string memory _image, string memory _ipfs) public {
        require(votingOrganizer == msg.sender, "Only organizer can create the candidate");

        _candidateId.increment();

        uint256 idNumber = _candidateId.current();

        Candidate storage candidate = candidates[_address];
        
        candidate.age = _age;
        candidate.name = _name;
        candidate.candidateId = idNumber;
        candidate.image = _image;
        candidate.voteCount = 0;
        candidate.candidateAddress = _address;
        candidate.ipfs = _ipfs;

        candidateAddresses.push(_address);

        emit CandidateCreate(
            idNumber,
            _age,
            _name,
            _image,
            candidate.voteCount,
            _address,
            _ipfs
        );
            
    }

    function getCandidates() public view returns (address[] memory){
        return candidateAddresses;
    }

    function getCandidateLength() public view returns (uint256){
        return candidateAddresses.length;
    }

    function getCandidateData(address _address) public view returns(string memory, string memory, uint256, string memory, uint256, string memory, address){
        
        return(
            candidates[_address].age,
            candidates[_address].name,
            candidates[_address].candidateId,
            candidates[_address].image,
            candidates[_address].voteCount,
            candidates[_address].ipfs,
            candidates[_address].candidateAddress
        );
    }

    function voterRight(address _address, string memory _name, string memory _image, string memory _ipfs) public
    {
        require(votingOrganizer == msg.sender, "Only organizer can create voter");

        _voterId.increment();
        uint256 idNumber = _voterId.current();

        Voter storage voter = voters[_address];

        require(voter.allowed == 0);
        voter.allowed = 1;
        voter.name = _name;
        voter.image = _image;
        voter.voterAddress = _address;
        voter.voterId = idNumber;
        voter.vote = 1000;
        voter.voted = false;
        voter.ipfs = _ipfs;

        voterAddresses.push(_address);

        emit VoterCreated(
            idNumber,
            _name,
            _image,
            _address,
            voter.allowed,
            voter.voted,
            voter.vote,
            _ipfs
        );
        
    }

    function vote(address _candidateAddress, uint256 _candidateVoteId) external{
        Voter storage voter = voters[msg.sender];

        require(!voter.voted, "You have already voted");
        require(voter.allowed != 0, "You have no right to vote");

        voter.voted = true;
        voter.vote = _candidateVoteId;

        votedVoters.push(msg.sender);

        candidates[_candidateAddress].voteCount += voter.allowed;
    }

    function getVoterLength() public view returns (uint256){
        return voterAddresses.length;
    }

    function getVoterData (address _address) public view returns (uint256, string memory, string memory, address, string memory, uint256, bool)
    {
        return(
            voters[_address].voterId,
            voters[_address].name,
            voters[_address].image,
            voters[_address].voterAddress,
            voters[_address].ipfs,
            voters[_address].allowed,
            voters[_address].voted
        );
    }

    function getVotedVoterList() public view returns (address[] memory){
        return votedVoters;
    }

    function getVoterList () public view returns (address[] memory){
        return voterAddresses;
    }
}
