// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

interface Ticket {
   function sessionDuration(uint ) external view returns(uint);
   function  burn ( uint _id) external;

} 



contract Tatoo is ERC721, Ownable , ReentrancyGuard  {
    using Counters for Counters.Counter;
    using Strings for uint256;

    struct Date{ uint day;
                 uint month;
                 uint year;
                 uint hour;
                 uint duration ;}
    uint public hourPrice;
    Ticket public ticket;

    mapping(uint256 => string) _tokenURI;
    Counters.Counter private _tokenIds;
     // Mapping for whether a token URI is set permanently
    mapping(uint256 => bool) private _isPermanentURI;

    event URI(string value, uint256 indexed id);
    event PermanentURI(string value, uint256 indexed id);

    mapping (uint256 =>  Date ) public schedule ;

    mapping (bytes32 => bool) scheduled;


    





    constructor() ERC721("Jaime_Ito", "JITO") {}

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

    function _isAvailable(  uint _day , uint _month, uint _year, uint _hour  ) public view returns (bool) {
        return ! scheduled[ keccak256( (abi.encode(  _day , _month, _year , _hour) ))];

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



    function mint         
 (address _to, string memory _URL , uint  _day , uint _month , uint _year, uint _hour , uint _ticketId) public payable  nonReentrant {
        uint duration = ticket.sessionDuration(_ticketId) ;
        require ( duration >0 , "duration must be positive");

        require(msg.value == duration*hourPrice || msg.sender == owner() , "not payed Price");
        ticket.burn(_ticketId);
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();

        for( uint i = 0; i< duration ; i++){ 

                    require( scheduled[  keccak256( (abi.encode(  _day , _month, _year , _hour +i  )))] == false );

         }
        _safeMint(_to, newItemId);
        scheduled[  keccak256( (abi.encode(  _day , _month, _year , _hour)))] =true; 

        for( uint i = 0; i< duration ; i++){

        scheduled[  keccak256( (abi.encode(  _day , _month, _year , _hour +i)))] =true; 



         }

        schedule [newItemId] = Date(  _day , _month, _year , _hour , duration);


        _setURI(newItemId ,  _URL);
    }
// only owner


function changeShedule( uint _id  ,  uint  _day , uint _month , uint _year, uint _hour , uint _duration )external {
require( ownerOf(_id) == msg.sender );
require( schedule[_id].duration == _duration, "not_same_duration" );
 for( uint i = 0; i< _duration ; i++){ 

                    require( scheduled[  keccak256( (abi.encode(  _day , _month, _year , _hour +i  )))] == false );

         
         }
  for( uint i = 0; i< _duration ; i++){ 

                     scheduled[  keccak256( (abi.encode(  _day , _month, _year , _hour +i  )))] == true ;

         
         }
                        schedule [_id] = Date(  _day , _month, _year , _hour , _duration);

}


function setTicket(address _ticket) external onlyOwner {
    ticket = Ticket( _ticket);
}

 function withdraw() external {
        require( owner() == msg.sender);
    

        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success, "Transfer failed");
    }

 function setHourPirce( uint _price) external {
     require( owner() == msg.sender);
     hourPrice = _price;


 }
  
}
