pragma solidity ^0.4.25;


import "./IERC20.sol";
import "./SafeMath.sol";

contract ERC20 is IERC20 {
	using SafeMath for uint256;
	mapping (address => uint256) private _balances;
	mapping (address => mapping (address => uint256)) private _allowed;
	mapping (address => uint256) private _levelOfPayment;
	
	mapping (address => bool) _whitelist;
	
	
	uint256 private _totalSupply;
	string private _ticker;
	uint256 private _decimal;
	address public _contractowner;
	
	constructor() public {  
		_ticker = "CAT";   
		_decimal = 5;  
		_totalSupply = 100000000000;  
  
		_contractowner = msg.sender;  
		_balances[msg.sender] = _totalSupply;  
  
		emit Transfer(0x0, msg.sender, _totalSupply);  
	}
	
	function AddWhitelist(address ad){
		_whitelist[ad]=true;
	}
	
	function SeeIfInWhitelist(address ad) public view returns (bool){
		return _whitelist[ad];
	}
	
	function DeleteWhitelist(address ad){
		_whitelist[ad]=false;
	}
	
	function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
	
	function ticker() public view returns (string) {
        return _ticker;
    }
	
	function decimal() public view returns (uint256) {
        return _decimal;
    }
	
	function balanceOf(address owner) public view returns (uint256) {

        return _balances[owner];
    }
	
	function allowance(address owner, address spender) public view returns (uint256) {

		return _allowed[owner][spender];
    }
	
	function transfer(address to, uint256 value) public returns (bool) {
		require(_whitelist[to]==true);
		_transfer(msg.sender, to, value);
        return true;
    }
	
	function approve(address spender, uint256 value) public returns (bool) {

        _approve(msg.sender, spender, value);
        return true;
    }
	
	function transferFrom(address from, address to, uint256 value) public returns (bool) {

        require(_whitelist[from]==true);
		require(_whitelist[to]==true);
		_transfer(from, to, value);
        _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
        return true;
    }
	
	function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {

        _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
        return true;
    }
	
	function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {

        _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
        return true;
    }
	
	function _transfer(address from, address to, uint256 value) internal {

        require(to != address(0));
        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(from, to, value);
    }
	
	
	function _mint(address account, uint256 value) internal {

        require(account != address(0));

        _totalSupply = _totalSupply.add(value);
        _balances[account] = _balances[account].add(value);
        emit Transfer(address(0), account, value);
    }
	
	
	function _burn(address account, uint256 value) internal {

        require(account != address(0));

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }
	
	function _approve(address owner, address spender, uint256 value) internal {

        require(spender != address(0));
        require(owner != address(0));

        _allowed[owner][spender] = value;
        emit Approval(owner, spender, value);

    }
	
	function _burnFrom(address account, uint256 value) internal {
        _burn(account, value);
        _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));

    }
	
	
}
	