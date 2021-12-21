// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./mintable.sol";

contract TestToken is MintableToken {
    address echidna_caller = 0x00a329C0648769a73afAC7F9381e08fb43DBEA70;

    constructor() MintableToken(10000) {
        owner = echidna_caller;
    }

    // add the property
    function echidna_test_balance() public view returns (bool) {
        return balances[msg.sender] <= 10000;
    }
}
