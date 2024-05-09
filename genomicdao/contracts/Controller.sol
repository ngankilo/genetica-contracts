pragma solidity ^0.8.25;

import "./NFT.sol";
import "./Token.sol";

contract Controller {

    //
    // STATE VARIABLES
    //
    uint private _sessionId;
    GeneNFT public geneNFT;
    PostCovidStrokePrevention public pcspToken;

    struct UploadSession {
        uint256 id;
        address user;
        string proof;
        bool confirmed;
    }

    struct DataDoc {
        string id;
        string hashContent;
    }

    mapping(uint256 => UploadSession) sessions;
    mapping(string => DataDoc) docs;
    mapping(string => bool) docSubmits;
    mapping(uint256 => string) nftDocs;

    //
    // EVENTS
    //
    event UploadData(string docId, uint256 sessionId);

    constructor(address nftAddress, address pcspAddress) {
        geneNFT = GeneNFT(nftAddress);
        pcspToken = PostCovidStrokePrevention(pcspAddress);
    }

    function uploadData(string memory docId) public returns (uint256) {
        require(!docSubmits[docId], "Document already submitted");
        sessions[_sessionId] = UploadSession(_sessionId, msg.sender, "", false);
        docSubmits[docId] = true;
        emit UploadData(docId, _sessionId);
        _sessionId += 1;
        return _sessionId;
    }

    function confirm(
        string memory docId,
        string memory contentHash,
        string memory proof,
        uint256 sessionId,
        uint256 riskScore
    ) public {
        require(sessions[sessionId].user == msg.sender, "Invalid session owner");
        require(!sessions[sessionId].confirmed, "Session is ended");
        require(!docSubmits[docId], "Document already submitted");
        docs[docId] = DataDoc(docId, contentHash);
        geneNFT.safeMint(msg.sender);
        pcspToken.reward(msg.sender, riskScore);
        sessions[sessionId].confirmed = true;
        sessions[sessionId].proof = proof;
    }

    function getSession(uint256 sessionId) public view returns (UploadSession memory) {
        return sessions[sessionId];
    }

    function getDoc(string memory docId) public view returns (DataDoc memory) {
        return docs[docId];
    }
}
