// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";



contract Tatoo is ERC721, Ownable  {
    using Counters for Counters.Counter;
    using Strings for uint256;


    mapping(uint256 => string) _tokenURI;
    Counters.Counter private _tokenIds;
     // Mapping for whether a token URI is set permanently
    mapping(uint256 => bool) private _isPermanentURI;

    event URI(string value, uint256 indexed id);
    event PermanentURI(string value, uint256 indexed id);





    constructor() ERC721("Ito_Tatoo_Studio", "ITO") {}

       modifier onlyImpermanentURI(uint256 id) {
        require(
            !isPermanentURI(id),
            "AssetContract#onlyImpermanentURI: URI_CANNOT_BE_CHANGED"
        );
        _;
    }

    // internal
    function _URIs(uint256 _id) internal view virtual returns (string memory) {
        return _tokenURI[_id];

        
    }

    function _setPermanentURI(uint256 _id)
        internal
        virtual
    {
        string memory _uri = _URIs(_id);
        require(
            bytes(_uri).length > 0,
            "AssetContract#setPermanentURI: ONLY_VALID_URI"
        );
        _isPermanentURI[_id] = true;
        _setURI(_id, _uri);
        emit PermanentURI(_uri, _id);
    }






    //public

       function setPermanentURI(uint256 _id)
        public
        
        onlyImpermanentURI(_id)
    {
        _setPermanentURI(_id);
    }

    function totalSupply() public view returns (uint256) {
        uint256 totalSupply_ = _tokenIds.current();
        return totalSupply_;
    }

    

    function isPermanentURI(uint256 _id) public view returns (bool) {
        return _isPermanentURI[_id];

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

        string memory uri = _URIs(tokenId);
        return uri;
           
    }

    

      function _setURI(uint256 _id, string memory _uri) internal {
        _tokenURI[_id] = _uri;
        emit URI(_uri, _id);
    }


     function setURI(uint256 _id, string memory _uri)
        public
        virtual
        onlyOwner
        onlyImpermanentURI(_id)
    {
        require(
            _exists(_id),
            "ERC721Metadata: URI is generated at minting"
        );
        _setURI(_id, _uri);
    }



    function mint(address _to, string memory _URL) public {
        require(msg.sender == owner());
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(_to, newItemId);
        _setURI(newItemId ,  _URL);
    }

   
}
