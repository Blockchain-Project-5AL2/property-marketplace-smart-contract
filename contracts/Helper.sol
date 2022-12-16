// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.9.0;

import "./PropertyFactory.sol";

contract Helper is PropertyFactory {
	modifier onlyOwnerOf(uint _propertyId) {
		require(propertyToOwner[_propertyId] == msg.sender);
		_;
	}

	modifier enoughEtherToBuyProperty(uint _propertyId) {
		require(msg.value >= properties[_propertyId].price, "Your value is lower than property price");
		_;
	}

	// pure function that check if value is in array
	function isInArray(uint[] memory _array, uint _value) public pure returns (bool) {
		for (uint i = 0; i < _array.length; i++) {
			if (_array[i] == _value) {
				return true;
			}
		}
		return false;
	}

}