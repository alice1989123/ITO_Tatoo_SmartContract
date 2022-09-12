// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";





contract Ticket  is ERC721 ,Ownable   { 

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping (uint => uint ) public sessionDuration ;
    mapping(uint256 => string) _tokenURI;


    uint public fee ;
    
    constructor() ERC721("Ticket", "TIC") {

    }

    function mint(  )  public payable {

        require(msg.value == fee || msg.sender == owner());
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current(); 
        _safeMint( msg.sender, newItemId);
   }

   function burn ( uint _id) public {

       
       require(msg.sender == owner() || _isApprovedOrOwner( msg.sender , _id), "not allowed to burn"); 
       _burn(_id);
   }

 function setFee( uint _fee) public onlyOwner {
     fee = _fee;

 }


      function _setURI(uint256 _id, string memory _uri) internal {
        _tokenURI[_id] = _uri;
    }

  function setSesionDetails(uint256 _id,  uint256 _duration , string memory _uri)
        public
        virtual
        onlyOwner
    {
        require(
            _exists(_id),
            "ERC721Metadata: URI is generated at minting"
        );
        _setURI(_id, _uri);
        sessionDuration[_id] = _duration;
    }

 


 function withdraw() external  onlyOwner{
    

        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success, "Transfer failed");
    }


}
