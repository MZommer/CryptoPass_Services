// contracts/MyNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract Event is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;



    //  DB Vars //
    string Title;
    string Description;
    string Location;
    uint32 Date;  // UNIX Timestamp
    uint32 ReleaseDate; // ^^
    bool IsActive;
    bool IsPublic;
    uint32 TicketAmount;
    string[] TicketTypes;
    string[] Genres;
    string[] Tags;
    uint8 MinAge;


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