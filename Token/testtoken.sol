// contracts/EchidnaTesting.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./token.sol";

contract TestToken is Token {
    // Echidna needs a constructor without argument. If your contract needs a specific initialization, you need to do it in the constructor.
    constructor() {}

    function echidna_balance_under_1000() public view returns (bool) {
        return balances[msg.sender] <= 1000;
    }
}
