// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";



contract Tatoo is ERC721, Ownable  {
    using Counters for Counters.Counter;
    using Strings for uint256;


    mapping(uint256 => string) URIs;
    Counters.Counter private _tokenIds;


    constructor() ERC721("Ito_Tatoo_Studio_-_____", "ITO__") {}

    // internal
    function _URIs(uint256 _id) internal view virtual returns (string memory) {
        return URIs[_id];
    }


    //public

    function totalSupply() public view returns (uint256) {
        uint256 totalSupply_ = _tokenIds.current();
        return totalSupply_;
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

        string memory URI = _URIs(tokenId);
        return URI;
           
    }

    function mint(address _to, string memory _URL) public {
        require(msg.sender == owner());
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        URIs[newItemId] = _URL;
        _safeMint(_to, newItemId);
    }

    function burn(uint256 _tokenId) public virtual  {
        //solhint-disable-next-line max-line-length
        require(
            _isApprovedOrOwner(_msgSender(), _tokenId),
            "ERC721Burnable: caller is not owner nor approved"
        );
        _burn(_tokenId);
    }
}
