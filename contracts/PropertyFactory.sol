pragma solidity >=0.4.25 <0.9.0;

/// @title Un contrat qui permet de créer des bien immobiliers
/// @author HDEV THE THUG🤪
/// @dev Conforme aux spécificités provisoires de l'implémentation ERC721 d'OpenZeppelin

import "./Helper.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PropertyFactory is Ownable {

	event NewProperty(uint propertyId);
	event PropertyUpdated(uint propertyId);

	// struct attributes ordered this way to optimize storage
	struct Property {
		string propertyType;
		string location;
		string description;
		string documentsHash; // string takes 256 bits => 32 bytes as uint256
		uint256 id;
		uint256 price; // because unlike bitcoin, ethereum has no limits on its total amount
		address ownerAddress; // size of address is 160 bits => 20 bytes as uint256
		uint32 surface; // 32 bits is enough for surface => 4 bytes as uint256
		uint32 rooms;
        uint32 _bedrooms;
	}

	Property[] public properties;

	mapping (uint => address) public propertyToOwner;
	// mapping (address => address[]) public ownerProperties;
	mapping (address => uint) public ownerPropertyCount;

	function createProperty(
		string memory _propertyType, 
		string memory _location, 
		uint _price, 
		uint32 _surface, 
		uint8 _rooms, 
		uint8 _bedrooms, 
		string memory _description, 
		string memory _documentsHash) public {

		properties.push(Property(_propertyType, _location, _description, _documentsHash, properties.length, _price * (1 ether), msg.sender, _surface, _rooms, _bedrooms));
		uint id = properties.length - 1;
		propertyToOwner[id] = msg.sender;
		ownerPropertyCount[msg.sender]++;
		emit NewProperty(id);
	}

	function getAllProperties() public view returns (Property[] memory) {
		return properties;
	}

	function getPropertiesByOwner(address _owner) public view returns (Property[] memory) {
		Property[] memory result = new Property[](ownerPropertyCount[_owner]);
		uint counter = 0;
		for (uint i = 0; i < properties.length; i++) {
			if (propertyToOwner[i] == _owner) {
				result[counter] = properties[i];
				counter++;
			}
		}
		return result;
	}

	// function that update given atributes of a property
	function updatePropertyAttributes(
			uint _propertyId, 
			string memory _propertyType, 
			string memory _location, 
			uint _price, 
			uint32 _surface, 
			uint8 _rooms, 
			uint8 _bedrooms, 
			string memory _description, 
			string memory _documentsHash
		) public {
		require(propertyToOwner[_propertyId] == msg.sender);
		Property storage property = properties[_propertyId];
		if (bytes(_propertyType).length > 0) {
			property.propertyType = _propertyType;
		}
		if (bytes(_location).length > 0) {
			property.location = _location;
		}
		if (_price > 0) {
			property.price = _price * (1 ether);
		}
		if (_surface > 0) {
			property.surface = _surface;
		}
		if (_rooms > 0) {
			property.rooms = _rooms;
		}
		if (_bedrooms > 0) {
			property._bedrooms = _bedrooms;
		}
		if (bytes(_description).length > 0) {
			property.description = _description;
		}
		if (bytes(_documentsHash).length > 0) {
			property.documentsHash = _documentsHash;
		}
		emit PropertyUpdated(_propertyId);
	}

	
}