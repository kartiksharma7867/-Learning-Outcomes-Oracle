// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LearningOutcomesOracle {
    address public owner;

    struct LearningOutcome {
        string studentId;
        string courseId;
        string outcome;
        uint256 timestamp;
    }

    mapping(bytes32 => LearningOutcome) public outcomes;

    event OutcomeVerified(
        string studentId,
        string courseId,
        string outcome,
        uint256 timestamp
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function verifyOutcome(
        string memory studentId,
        string memory courseId,
        string memory outcome
    ) public onlyOwner {
        bytes32 outcomeHash = keccak256(abi.encodePacked(studentId, courseId));
        outcomes[outcomeHash] = LearningOutcome({
            studentId: studentId,
            courseId: courseId,
            outcome: outcome,
            timestamp: block.timestamp
        });
        emit OutcomeVerified(studentId, courseId, outcome, block.timestamp);
    }

    function getOutcome(
        string memory studentId,
        string memory courseId
    ) public view returns (LearningOutcome memory) {
        bytes32 outcomeHash = keccak256(abi.encodePacked(studentId, courseId));
        return outcomes[outcomeHash];
    }
}
