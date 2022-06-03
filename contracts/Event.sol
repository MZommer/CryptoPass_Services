// contracts/MyNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract Event is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    mapping(string => mapping(uint256 => address)) private _tickets;

    constructor() ERC721("Event", "EVT") {
    }
    
    function mint(address owner, string memory ticketType) public returns (uint256) {
        uint256 Id = _tokenIds.current();
        _mint(owner, Id);
        _tickets[ticketType][Id] = owner;
        _tokenIds.increment();
        return Id;
    }

}