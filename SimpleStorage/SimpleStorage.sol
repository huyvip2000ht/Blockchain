//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

contract SimpleStorage {
    //giong class
    uint256 favoriteNumber;
    bool favoriteBool;
    bool favoriteBool2;

    // string string- "sdad";
    // int256 favInt=-5;
    // address fevAddress = 0x42FA1E8f5b259A1FCf003a18Ed105cba2ba8C8a3;
    // bytes32 favBytes="cat";
    struct People {
        uint256 favoriteNumber;
        string name;
    }

    //People public person = People({favoriteNumber:2,name:"asdasd"});
    People[] public people;

    mapping(string => uint256) public nameToFav;

    //storage,memory
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));
        nameToFav[_name] = _favoriteNumber;
    }

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }

    // view, pure
    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }
}
