//SPDX-License-Identifier: MIT


pragma solidity >=0.6.0 <0.9.0;

//import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol"; // if ^0.8.0 thi ko can

interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  // getRoundData and latestRoundData should both raise "No data present"
  // if they do not have data to report, instead of returning unset values
  // which could be misinterpreted as actual reported values.
  function getRoundData(uint80 _roundId)
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
}

contract FundMe{
    using SafeMathChainlink for uint256;

    mapping(address=> uint256) public addressToAmountFunded;
    address[] public funders;

    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function fund() public payable{

        uint256 minimumUsd= 50*10**18;
        require(getConversionRate(msg.value)>=minimumUsd, "Minimum 50USD!!");

        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
        // ETH => ???? USD
    }

    function getVersion() public view returns(uint256){
        // kovan eth/usd
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
        return priceFeed.version();
    }

    function getPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
        (,int256 answer,,,)=priceFeed.latestRoundData();
        return uint256(answer *10**10);// theo wei
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice*ethAmount) / (10**18);
        return ethAmountInUsd;
    }

    modifier onlyOwner{
        require(msg.sender == owner, "You are not the owner!!!");
        _;
    }



    function withdraw() payable onlyOwner public{
        require(msg.sender == owner, "You are not the owner!!!");
        msg.sender.transfer(address(this).balance);
        for(uint256 index=0; index<funders.length;index++){
            address funder = funders[index];
            addressToAmountFunded[funder]= 0;
        }
        funders = new address[](0);
    }


}