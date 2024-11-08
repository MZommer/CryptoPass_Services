// Credits TIMM.sol https://etherscan.io/address/0x674d37ac70e3a946b4a3eb85eeadf3a75407ee41#code
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "./SaleLib.sol";

struct EventInfo {
    string Title;
    string Description;
    string Location;
    uint32 Date;  // UNIX Timestamp
    uint32 ReleaseDate; // ^^
    bool   IsActive;
    bool   IsPublic;
    uint32 TicketAmount;
    uint8  MinAge;
}

contract Event is ERC721, ReentrancyGuard, Ownable {
    using Strings for uint256;
    using SaleLib for SaleLib.Sale;
    
    // Base URL for tokens metadata
    string public baseTokenURI;
    string _contractURI;
    uint256     MAX_SUPPLY;
    uint256 RESERVED_SUPPLY;
    // Reserved addreses
    mapping(address => uint256) public teamMinted;
    uint256 public mintedReserved = 0;
    uint256 public mintedPublic = 0;
    uint32  public mintedTickets = 0;
    // Keeps track of minted tokens
    uint256 internal _tokenCounter = 0;

    // Whatever this is?
    bytes32 public teamMerkleRoot = 0;

    SaleLib.Sale[] public sales;
    EventInfo public eventInfo;
    
    mapping(uint256 => bool) private _markedTokens;

    // make the mapping for the address -->
    mapping(string => mapping(uint256 => address)) private _tickets;

    constructor(string memory pTitle,
                string memory pDescription,
                string memory pLocation,
                uint32 pDate,
                uint32 pReleaseDate,
                bool   pIsActive,
                bool   pIsPublic,
                uint32 pTicketAmount,
                uint8  pMinAge) ERC721("Event", "EVT") {
        eventInfo = EventInfo(
            pTitle,
            pDescription,
            pLocation,
            pDate,
            pReleaseDate,
            pIsActive,
            pIsPublic,
            pTicketAmount,
            pMinAge
        );
        MAX_SUPPLY = pTicketAmount;
    }
    
    function mint(
        uint256 pSaleId,
        address pAccount,
        uint256 pMintAmount
    ) public payable nonReentrant {
        require(pSaleId < sales.length, "Invalid sale id");
        SaleLib.Sale storage sale = sales[pSaleId];
        require(sale.isActive(), "Sale is not active");
        /*
        // Check if its whitelisted, if whitelist stage has not finished.
        if (block.timestamp <= sale.whitelistEndTime) {
            require(
                MerkleProof.verify(
                    pProof,
                    sales[pSaleId].merkleRoot,
                    keccak256(abi.encodePacked(pAccount))
                ),
                "Account not whitelisted"
            );
        }
        */
        require(
            pMintAmount > 0 && pMintAmount <= sale.maxMintPerTx,
            "Invalid mint amount"
        );

        // Requested amount should be between 0 and maxMintPerTx
        require(
            balanceOf(pAccount) + pMintAmount <= sale.maxMintPerAccount,
            "Max minting exceeded"
        );

        // Sale not started
        require(block.timestamp >= sale.startTime, "Sale not started");

        // Sale not paused
        require(sale.isPaused == false, "Sale not active");

        require(sale.minted + pMintAmount <= sale.stock, "Not enough stock for mint stage");

        // Sent value should be at least the price * requested amount
        uint256 price = sale.getSalePrice();
        require(msg.value >= price * pMintAmount, "Not enough amount paid");

        // Total requested minted should not exceed for MAX SUPPLY - RESERVED SUPPLY
        require(
            mintedPublic + pMintAmount <= (MAX_SUPPLY - RESERVED_SUPPLY),
            "sold out"
        );

        // mint each requested token
        _mintMultipleUnsafe(pAccount, pMintAmount);
        // update minted public value
        mintedPublic += pMintAmount;
        // Update minted amount of sale
        sales[pSaleId].minted += pMintAmount;
    }

    function markTicket(uint256 tokenID) public{
        require(_markedTokens[tokenID], "Ticket already signed");
        require(msg.sender != this.ownerOf(tokenID), "You are not the owner of the nft");
        _markedTokens[tokenID] = true; 
    }
    function getAddressTokens(address addr) public view returns (uint256[] memory) {
        uint256[] memory tokens = new uint256[](balanceOf(addr));
        for (uint256 i = 1; i < _tokenCounter; i++){
            if (ownerOf(i) == addr){
                tokens[tokens.length-1] = i;
            }
        }
        return tokens;
    }
    function getTokens() public view returns (uint256[] memory) {
       return getAddressTokens(msg.sender);
    }

    function _mintMultipleUnsafe(address pAccount, uint256 pAmount) private {
        // Mint each token
        for (uint256 i = 1; i <= pAmount; i++) {
            _tokenCounter++;
            _mint(pAccount, _tokenCounter);
        }
    }


    function getActiveSaleId() public view returns (uint256) {
        for (uint256 i = 0; i < sales.length; i++) {
            if (sales[i].isActive()) {
                return i;
            }
        }

        revert("No active sale found");
    }

    function totalSupply() public view returns (uint256) {
        return _tokenCounter;
    }

    function publicAvailableSupply() public view returns (uint256) {
        return MAX_SUPPLY - RESERVED_SUPPLY - mintedPublic;
    }

    function reservedAvailableSupply() public view returns (uint256) {
        return RESERVED_SUPPLY - mintedReserved;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
                : "";
    }

    function contractURI() public view returns (string memory) {
        return _contractURI;
    }

    // Override so the openzeppelin tokenURI() method will use this method to create the full tokenURI instead
    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    function createSale(
        uint256 pStartTime,
        uint256 pWhitelistEndTime,
        uint256 pPrice,
        uint256 pEndPrice,
        uint256 pMaxMintPerTx,
        uint256 pMaxMintPerAccount,
        //bytes32 pSaleMerkleRoot,
        uint256 pStock
    ) public onlyOwner {
        SaleLib.Sale memory sale = SaleLib.createSale(
            pStartTime,
            pWhitelistEndTime,
            pPrice,
            pEndPrice,
            pMaxMintPerTx,
            pMaxMintPerAccount,
            false,
            //pSaleMerkleRoot,
            pStock
        );

        sales.push(sale);
    }

    function getSalePrice(uint256 pSaleId) public view returns (uint256) {
        return sales[pSaleId].getSalePrice();
    }

    function setSale(
        uint256 pSaleId,
        uint256 pStartTime,
        uint256 pWhitelistEndTime,
        uint256 pPrice,
        uint256 pEndPrice,
        uint256 pMaxMintPerTx,
        uint256 pMaxMintPerAccount,
        bool pIsPaused,
        //bytes32 pSaleMerkleRoot,
        uint256 pStock
    ) public onlyOwner {
        // Valid sale id
        require(pSaleId < sales.length, "Invalid sale id");
        sales[pSaleId] = sales[pSaleId].updateSale(
            pStartTime,
            pWhitelistEndTime,
            pPrice,
            pEndPrice,
            pMaxMintPerTx,
            pMaxMintPerAccount,
            pIsPaused,
            //pSaleMerkleRoot,
            pStock
        );
    }

    function pauseSale(uint256 pSaleId, bool value) public onlyOwner {
        require(sales[pSaleId].isPaused != value, "Invalid pause state");
        sales[pSaleId].isPaused = value;
    }

    // Update baseURI
    function setBaseTokenURI(string memory newbaseTokenURI) public onlyOwner {
        baseTokenURI = newbaseTokenURI;
    }

    function setContractURI(string memory pContractURI) public onlyOwner {
        _contractURI = pContractURI;
    }

    function setTeamMerkleRoot(bytes32 pTeamMerkleRoot) public onlyOwner {
        teamMerkleRoot = pTeamMerkleRoot;
    }
}