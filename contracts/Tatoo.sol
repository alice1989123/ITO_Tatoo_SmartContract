// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Tatoo is ERC721, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;

    mapping(uint256 => string) URIs;
    string public baseExtension = ".json";
    Counters.Counter private _tokenIds;

    mapping(address => bool) whitelistedAddresses;

    constructor() ERC721("Ito_Tatoo_Studio", "ITO") {}

    // internal
    function _URIs(uint256 _id) internal view virtual returns (string memory) {
        return URIs[_id];
    }

    //onlyOwner

    function setUser(address _addressToWhitelist, bool _update)
        public
        onlyOwner
    {
        whitelistedAddresses[_addressToWhitelist] = _update;
    }

    //public

    function totalSupply() public view returns (uint256) {
        uint256 totalSupply_ = _tokenIds.current();
        return totalSupply_;
    }

    function verifyUser(address _whitelistedAddress)
        public
        view
        returns (bool)
    {
        bool userIsWhitelisted = whitelistedAddresses[_whitelistedAddress];

        return userIsWhitelisted;
    }

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

        string memory currentBaseURI = _URIs(tokenId);
        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        tokenId.toString(),
                        baseExtension
                    )
                )
                : "";
    }

    function mint(address _to, string memory _URL) public {
        require(msg.sender == owner() || verifyUser(msg.sender) == true);
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        URIs[newItemId] = _URL;
        _safeMint(_to, newItemId);
    }
}
