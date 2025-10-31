// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ProofAxis
 * @dev A blockchain-based proof registry that allows users to store and verify document hashes.
 * This contract provides a trustless way to validate data ownership and timestamp proof.
 */

contract ProofAxis {
    struct Proof {
        address owner;
        uint256 timestamp;
        string description;
    }

    mapping(bytes32 => Proof) private proofs;

    event ProofCreated(address indexed owner, bytes32 indexed hash, uint256 timestamp, string description);

    /**
     * @dev Creates a new proof record for a document hash.
     * @param documentHash The SHA256 hash of the document or data.
     * @param description A short description of the proof.
     */
    function createProof(bytes32 documentHash, string memory description) public {
        require(proofs[documentHash].timestamp == 0, "Proof already exists");
        proofs[documentHash] = Proof(msg.sender, block.timestamp, description);
        emit ProofCreated(msg.sender, documentHash, block.timestamp, description);
    }

    /**
     * @dev Verifies whether a proof exists for a given document hash.
     * @param documentHash The hash to check.
     * @return exists True if proof exists, otherwise false.
     */
    function verifyProof(bytes32 documentHash) public view returns (bool exists) {
        return proofs[documentHash].timestamp != 0;
    }

    /**
     * @dev Retrieves proof details for a given document hash.
     * @param documentHash The hash of the document.
     * @return owner Owner address, timestamp, and description of the proof.
     */
    function getProofDetails(bytes32 documentHash)
        public
        view
        returns (address owner, uint256 timestamp, string memory description)
    {
        require(proofs[documentHash].timestamp != 0, "Proof not found");
        Proof memory p = proofs[documentHash];
        return (p.owner, p.timestamp, p.description);
    }
}
