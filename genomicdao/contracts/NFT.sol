// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GeneNFT is ERC721, ERC721Burnable, Ownable {

    uint private _tokenId;

    constructor() ERC721("GeneNFT", "GNFT") Ownable(msg.sender){}

    function safeMint(address to) public onlyOwner returns (uint256) {
        _mint(to, _tokenId);
        _tokenId += 1;
        return _tokenId;
    }
}