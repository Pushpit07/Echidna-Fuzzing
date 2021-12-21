// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import "./node_modules/@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "./node_modules/@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";

contract MintableToken is ERC20Upgradeable, PausableUpgradeable {
    mapping(address => bool) public blacklist;
    address public owner;
    address public minter;
    uint256 public cap;

    event ChangeBlacklist(address indexed user, bool indexed status);

    modifier onlyOwner() {
        require(msg.sender == owner, "EKTA: ONLY OWNER");
        _;
    }

    modifier onlyMinter() {
        require(msg.sender == minter, "EKTA: ONLY MINTER");
        _;
    }

    event OwnerChanged(address oldOwner, address newOwner);

    event MinterChanged(address oldMinter, address newMinter);

    constructor() public ERC20Upgradeable() {}

    function initialize(
        string memory _name,
        string memory _symbol,
        uint256 _capacity
    ) public initializer {
        __ERC20_init(_name, _symbol);
        cap = _capacity;
        owner = msg.sender;
        minter = msg.sender;
    }

    /**
     * @notice Pause contract
     */
    function pauseContract() public onlyOwner {
        _pause();
    }

    /**
     * @notice Unpause contract
     */
    function unpauseContract() public onlyOwner {
        _unpause();
    }

    function setCapacity(uint256 _cap) external onlyOwner {
        require(_cap >= totalSupply(), "EKTA: INVALID CAPACITY");
        cap = _cap;
    }

    function mint(address user, uint256 amount)
        public
        whenNotPaused
        onlyMinter
    {
        require(totalSupply() + amount < cap, "EKTA: FULL CAPACITY");
        _mint(user, amount);
    }

    function burn(address account, uint256 amount) public whenNotPaused {
        require(
            msg.sender == account,
            "MAT: SENDER ADDRESS IS NOT MATCH ACCOUNT ADDRESS"
        );
        _burn(account, amount);
    }

    function changeMinter(address newMinter) public whenNotPaused onlyMinter {
        emit MinterChanged(minter, newMinter);
        minter = newMinter;
    }

    function changeOwner(address newOwner) public onlyOwner {
        emit OwnerChanged(owner, newOwner);
        owner = newOwner;
    }

    function addBlackList(address[] memory listAddress) public onlyOwner {
        _changeStatus(listAddress, true);
    }

    function removeBlackList(address[] memory listAddress) public onlyOwner {
        _changeStatus(listAddress, false);
    }

    function _changeStatus(address[] memory _listAddress, bool _status)
        private
    {
        for (uint256 i = 0; i < _listAddress.length; i++) {
            blacklist[_listAddress[i]] = _status;
            emit ChangeBlacklist(_listAddress[i], _status);
        }
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override whenNotPaused {
        require(blacklist[from] == false, "BLACKLIST CANNOT TRANSFER");
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function getMinter() public view returns (address) {
        return minter;
    }

    function isBlacklisted(address user) public view returns (bool) {
        return blacklist[user] == true;
    }
}
