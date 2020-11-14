pragma solidity >=0.4.22 <0.7.0;
pragma experimental ABIEncoderV2;
/**
 * @title Ballot
 * @dev Implements voting process along with vote delegation
 */
contract SynElection {

    struct Voter {
        bool voted;  // if true, that person already voted
    }

    struct Proposal {
        // If you can limit the length to a certain number of bytes,
        // always use one of bytes1 to bytes32 because they are much cheaper
        bytes32 name;   // short name (up to 32 bytes)
        uint voteCount; // number of accumulated votes
    }

    address public owner;

    mapping(address => Voter) public voters;

    Proposal[] public proposals;

    bool stopVote;

    /**
     * @dev Create a new ballot to choose one of 'proposalNames'.
     * @param proposalNames names of proposals
     */
    constructor(bytes32[] memory proposalNames) public {
        owner = msg.sender;
        stopVote = false;

        for (uint i = 0; i < proposalNames.length; i++) {
            // 'Proposal({...})' creates a temporary
            // Proposal object and 'proposals.push(...)'
            // appends it to the end of 'proposals'.
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    function stopElection() public {
        require(
            msg.sender == owner,
            "Only owner can stop the election."
        );
        stopVote=true;
    }

    function debugRestartElection() public {
        require(
            msg.sender == owner,
            "Only owner can restart session."
        );
        stopVote=false;
    }

    /**
     * @dev Give your vote (including votes delegated to you) to proposal 'proposals[proposal].name'.
     * @param proposal index of proposal in the proposals array
     */
    function vote(uint proposal) public {
        require(!stopVote, "The election is closed");
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "Already voted.");
        sender.voted = true;

        // If 'proposal' is out of the range of the array,
        // this will throw automatically and revert all
        // changes.
        proposals[proposal].voteCount += 1;
    }
    
    function getResults() public view
        returns (Proposal[] memory results)
    {
        require(msg.sender==owner);
        results = proposals;
    }
    
    function getProposals() public view
            returns (bytes32[] memory allProposals)
    {
        bytes32[] memory allP;
        allP = new bytes32[](proposals.length);
        for (uint p = 0; p < proposals.length; p++) {
            allP[p] = proposals[p].name;
        }
        allProposals = allP;
    }
}
