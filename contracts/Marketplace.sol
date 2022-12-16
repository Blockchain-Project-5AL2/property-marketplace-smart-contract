// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.9.0;

// import "./PropertyFactory.sol";
import "./Helper.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Marketplace is Helper, ERC721 {

	mapping (uint => address) public saleApprovals;
	Property[] public propertiesInSale;
	mapping (address => uint[]) public ownerPropertiesInSale;

	event SoldProperty(uint propertyId, address buyer, uint price);

	constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

	modifier isInSale(uint _propertyId) {
		require (isInArray(ownerPropertiesInSale[propertyToOwner[_propertyId]], _propertyId), "Property is not in sale");
		_;
	}

	function setPropertyUpForSale (uint _propertyId) public onlyOwnerOf(_propertyId) {
		require (!isInArray(ownerPropertiesInSale[propertyToOwner[_propertyId]], _propertyId), "Property is already in sale");
		propertiesInSale.push(properties[_propertyId]);
		ownerPropertiesInSale[msg.sender].push(_propertyId);
	}

	// this can be replaced by calling ownerPropertiesInSale[_ownerAddress]
	/* 
	function getPropertiesInSaleByOwner(address _owner) public view returns (Property[] memory) {
		Property[] memory result = new Property[](ownerPropertiesInSale[_owner].length);
		uint counter = 0;
		for (uint i = 0; i < propertiesInSale.length; i++) {
			if (propertyToOwner[i] == _owner) {
				result[counter] = propertiesInSale[i];
				counter++;
			}
		}
		return result;
	}
	*/

	function _removeFromSale(uint _propertyId) private {
		// remove from propertiesInSale
		for (uint i = 0; i < propertiesInSale.length; i++) {
			if (propertiesInSale[i].id == _propertyId) {
				delete propertiesInSale[i];
			}
		}
		// remove property from ownerPropertiesInSale
		for (uint i = 0; i < ownerPropertiesInSale[msg.sender].length; i++) {
			if (ownerPropertiesInSale[msg.sender][i] == _propertyId) {
				delete ownerPropertiesInSale[msg.sender][i];
			}
		}
	}

	function _setPropertyDownFromSale (uint _propertyId) internal onlyOwnerOf(_propertyId) isInSale(_propertyId) {
		_removeFromSale(_propertyId);
	}

	function _transferOwnership(uint _propertyId , address _to) internal {
		address ownerAddress = propertyToOwner[_propertyId];
		address owner = propertyToOwner[_propertyId];
		// transfer ownership
		propertyToOwner[_propertyId] = _to;
		ownerPropertyCount[owner]--;
		ownerPropertyCount[_to]++;
		_removeFromSale(_propertyId);
		super._transfer(ownerAddress, _to, _propertyId);
		// update property owner
		Property storage property = properties[_propertyId];
		property.ownerAddress = _to; // update property owner in properties array
	}

	function withdraw() public onlyOwner {
		address payable _owner = payable(msg.sender);
		_owner.transfer(address(this).balance);
	}

	function buyProperty(uint _propertyId) public payable enoughEtherToBuyProperty(_propertyId) isInSale(_propertyId) {
		address buyerAddress = msg.sender;
		_mint(buyerAddress, _propertyId);
		_transferOwnership(_propertyId, buyerAddress);
		emit SoldProperty(_propertyId, buyerAddress, properties[_propertyId].price);
	}

}