// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./token.sol";

contract TestToken is Token {
    address echidna_caller = 0x00a329C0648769a73afAC7F9381e08fb43DBEA70;

    constructor() {
        paused(); // pause the contract
        owner = address(0x0); // lose ownership
    }

    // add the property
    function echidna_no_transfer() public view returns (bool) {
        return is_paused == true;
    }
}
