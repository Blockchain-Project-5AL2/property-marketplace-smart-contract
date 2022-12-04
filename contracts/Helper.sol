pragma solidity >=0.4.25 <0.9.0;

import "./PropertyFactory.sol";

contract Helper is PropertyFactory {
	modifier onlyOwnerOf(uint _propertyId) {
		require(propertyToOwner[_propertyId] == msg.sender);
		_;
	}
}