// contracts/MyNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract Event is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;



    //  DB Vars //
    string   public Title;
    string   public Description;
    string   public Location;
    uint32   public Date;  // UNIX Timestamp
    uint32   public ReleaseDate; // ^^
    bool     public IsActive;
    bool     public IsPublic;
    uint32   public TicketAmount;
    string[] public TicketTypes;
    string[] public Genres;
    string[] public Tags;
    uint8    public MinAge;
    uint32   public mintedTickets;
    string   public baseTokenURI;


    uint256 internal _tokenCounter = 0;


    // ?? Research abt SaleLib --> TIMM.sol 

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