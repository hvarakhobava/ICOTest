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

    event TokensSold(address to, uint number);
    event Refund(address to, uint amount, uint tokens);

    function Crowdsale() {
        token = HVTestToken();
    }

    function() payable {
        processTransaction(msg.sender, msg.value);
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

        TokensSold(sender, nTokens);
    }

    function refund() {
        require(totalRaisedAmount < softCap && now > endDate);
        var to = msg.sender;
        require(amountRaised[to] > 0);

        var amt = amountRaised[to];
        var tokens =  tokenSold[to];
        amountRaised[to] = 0;
        tokenSold[to] = 0;
        totalRaisedAmount -= amt;
        require(to.transfer(amt));

        Refund(to, amt, tokens);
    }

    function transfer() {
        require(totalRaisedAmount >= softCap && (now > endDate || totalRaisedAmount >= hardCap));
        require(tokenSold[msg.sender] > 0);

        tokens = tokenSold[msg.sender];
        tokenSold[msg.sender] = 0;
        token.transfer(msg.sender, tokens);
    }

}
