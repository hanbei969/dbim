// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//@dev: use these openzeppelin libraries for deployment with a local framework
import "./@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "./@openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol";
import "./@openzeppelin/contracts/access/AccessControl.sol";
import "./@openzeppelin/contracts/security/Pausable.sol";
import "./@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";


//@dev: use these openzeppelin libraries for deployment with remix.ethereum.org

//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/token/ERC20/ERC20.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/token/ERC20/extensions/ERC20Burnable.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/token/ERC20/extensions/ERC20Snapshot.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/access/AccessControl.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/security/Pausable.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";


contract CollectiveDigitalFactory is ERC20, ERC20Burnable, ERC20Snapshot, AccessControl, Pausable, ERC20Permit {
    bytes32 public constant SNAPSHOT_ROLE = keccak256("SNAPSHOT_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor()
        ERC20("CollectiveDigitalFactory", "CDF")
        ERC20Permit("CollectiveDigitalFactory")
    {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(SNAPSHOT_ROLE, msg.sender);
        _setupRole(PAUSER_ROLE, msg.sender);
        _mint(msg.sender, 8888 * 10 ** decimals());
        _setupRole(MINTER_ROLE, msg.sender);
    }

    function snapshot() public {
        require(hasRole(SNAPSHOT_ROLE, msg.sender));
        _snapshot();
    }

    function pause() public {
        require(hasRole(PAUSER_ROLE, msg.sender));
        _pause();
    }

    function unpause() public {
        require(hasRole(PAUSER_ROLE, msg.sender));
        _unpause();
    }

    function mint(address to, uint256 amount) public {
        require(hasRole(MINTER_ROLE, msg.sender));
        _mint(to, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override(ERC20, ERC20Snapshot)
    {
        super._beforeTokenTransfer(from, to, amount);
    }
}
