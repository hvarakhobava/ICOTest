pragma solidity ^0.4.0;

// A standard token that implements ERC20 interface.
// One can override this contract to implement concrete tokens

contract StandardToken is ERC20 {
    string public name;
    string public symbol;
    uint8 public decimals;

    uint private totalSupply;

    address public owner;

    mapping (address => uint) private balances;

    mapping (address => mapping (address => uint)) private allowed;

    function StandardToken(string _name, string _symbol, uint8 _decimals, uint _totalSupply) {
        owner = msg.sender;
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply;
        balances[owner] = totalSupply;
    }

    function totalSupply() public view returns (uint supply) {
        return totalSupply;
    }

    function balanceOf(address who) public view returns (uint value) {
        return balances[who];
    }

    function allowance(address owner, address spender) public view returns (uint _allowance) {
        return allowed[owner][spender];
    }

    function transfer(address to, uint value) public returns (bool ok) {
        transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint value) public returns (bool ok) {
        require(allowed[from][msg.sender] >= value);

        allowed[from][msg.sender] -= value;
        transfer(from, to, value);

        return true;
    }

    function transfer(address from, address to, uint value) internal {
        require(to != 0x0);
        require(balanceOf[to] + value > balanceOf[to]);
        require(balances[from] >= value);

        balances[from] -= value;
        balances[to] += value;

        Transfer(from, to, value);
    }

    function approve(address spender, uint value) public returns (bool ok) {
        allowed[msg.sender][spender] = value;
        Approval(msg.sender, spender, value);

        return true;
    }

    event Transfer(address indexed from, address indexed to, uint value);

    event Approval(address indexed owner, address indexed spender, uint value);
}
