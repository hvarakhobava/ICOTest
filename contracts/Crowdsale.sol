pragma solidity ^0.4.0;


contract Crowdsale {
    uint startDate;
    uint endDate;
    uint tokenPrice;

    uint softCap;
    uint hardCap;

    uint minTrxAmount;

    HVTestToken token;

    uint totalRaisedAmount;

    mapping(address => uint) tokenSold;
    mapping(address => uint) amountRaised;

    function Crowdsale() {
        token = HVTestToken();
    }

    function() payable {
        processTransaction();
    }

    function processTransaction(address sender, uint amount) internal returns (bool) {
        uint _now = now;
        require(_now > startDate && _now < endDate);
        require(totalRaisedAmount < hardCap);
        require(amount > minTrxAmount);

        var nTokens = amount / tokenPrice;
        tokenSold[sender] += nTokens;
        amountRaised[sender] += amount;
        totalRaisedAmount += amount;
    }

    function refund(address to) {
        require(totalRaisedAmount < softCap && now > endDate);

        var amt = amountRaised[to];
        amountRaised[to] = 0;
        tokenSold[to] = 0;
        totalRaisedAmount -= amt;
        require(to.transfer(amt));
    }

}
