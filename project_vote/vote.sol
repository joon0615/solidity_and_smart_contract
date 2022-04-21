pragma solidity >=0.4.0 <0.7.0;

contract Vote {

    // declare data structures for the contracts
    enum State {
        VoterRegistration,
        ProposalSubmissionStart,
        ProposalSubmissionEnd,
        VoteSubmissionStart,
        VoteSubmissionEnd,
        VoteEnd
    }

    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalID;
    }

    struct Proposal {
        string description;
        uint voteCount;
    }



    // declare state variables
    address public admin;
    State public currentState;
    mapping (address => Voter) public voters;
    Proposal[] public proposals;
    uint winningProposalID;
    string winningProposalDescription;
    



    constructor() public {
        admin = msg.sender;
        currentState = State.VoterRegistration;
    }



    // modifiers for access controls
    modifier onlyAdmin() {
        require(msg.sender == admin, "Called only by admin.");
        _;
    }

    modifier onlyRegisteredVoters() {
        require(voters[msg.sender].isRegistered, "Called only by registered voters");
        _;
    }



    // modifiers for functions related to states
    modifier duringVoterRegistration() {
        require(currentState == State.VoterRegistration, "Call only during voter registration.");
        _;
    }

    modifier duringProposalSubmission() {
        require(currentState == State.ProposalSubmissionStart, "Call only during proposal submission.");
        _;
    }

    modifier afterProposalSubmission() {
        require(currentState == State.ProposalSubmissionEnd, "Call only after proposal submission.");
        _;
    }

    modifier duringVoteSubmission() {
        require(currentState == State.VoteSubmissionStart, "Call only during vote submission.");
        _;
    }

    modifier afterVoteSubmission() {
        require(currentState == State.VoteSubmissionEnd, "Call only after vote submission.");
        _;
    }

    modifier afterVoteEnd() {
        require(currentState == State.VoteEnd, "Call only after vote.");
        _;
    }



    // State Transition Functions
    function startProposalSubmission() public onlyAdmin duringVoterRegistration {
        currentState = State.ProposalSubmissionStart;
    }

    function endProposalSubmission() public onlyAdmin duringProposalSubmission {
        currentState = State.ProposalSubmissionEnd;
    }
    
    function startVoteSubmission() public onlyAdmin afterProposalSubmission {
        currentState = State.VoteSubmissionStart;
    }
    
    function endVoteSubmission() public onlyAdmin duringVoteSubmission {
        currentState = State.VoteSubmissionEnd;
    }
    
    function endVote() public onlyAdmin afterVoteSubmission {
        currentState = State.VoteEnd;
    }
    


    // functions during the state
    function registerVoters(address voterAddress) public onlyAdmin duringVoterRegistration {
        require (!voters[voterAddress].isRegistered, "The voter is already registered.");

        // update voter info
        voters[voterAddress].isRegistered = true;
        voters[voterAddress].hasVoted = false;
        voters[voterAddress].votedProposalID = 0;
    }

    function registerProposals(string memory proposalDescription) public onlyRegisteredVoters duringProposalSubmission {
        proposals.push(
            Proposal({
                description: proposalDescription,
                voteCount: 0
            }));
    }

    function vote(uint proposalID) public onlyRegisteredVoters duringVoteSubmission {
        require(!voters[msg.sender].hasVoted, "Caller has already voted.");

        voters[msg.sender].hasVoted = true;
        voters[msg.sender].votedProposalID = proposalID;
        proposals[proposalID].voteCount += 1;
    }

    function countVote() public onlyAdmin afterVoteSubmission {
        uint _countToWin = 0;
        uint _winningIndex = 0;
        string memory _winningProposalDescription;

        for (uint i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > _countToWin) {
                _countToWin = proposals[i].voteCount;
                _winningIndex = i;
                _winningProposalDescription = proposals[i].description;
            }
        }

        winningProposalID = _winningIndex;
        winningProposalDescription = _winningProposalDescription;
        endVote();
    }
}