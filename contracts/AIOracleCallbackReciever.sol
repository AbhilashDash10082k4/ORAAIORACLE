//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "contracts/interface/IAIOracle.sol";
//a base contract for writing AIOracle app
//callbackreciever contract contains Oracle instance, a modifier and a callback function that will need to override
//also has a function that checks if the result is finalized onchain

abstract contract AIOracleCallbackReciever{

    //address at AIOracle contract
    IAIOracle public immutable aiOracle;

    //Invalid Callback source error
    error UnauthorizedCallBackSource(IAIOracle expected, IAIOracle found);

    // @notice Intialize the contract, binding it to specified AIOracle contract
    constructor (IAIOracle _aiOracle) {
        aiOracle = _aiOracle;
    }

    // @notice Verify this is a callback by the aiOracle contract
    modify onlyAIOracleCallback() {
        IAIOracle foundRelayAddress = IAIOracle(msg.sender);
        if(foundRelayAddress != aiOracle) {
            revert UnauthorizedCallbackSource(aiOracel, foundRelayAddress);
        }
    }

    /*
    * @dev the callback function in OAO should add the modifier onlyAIOracleCallback
    * @param request id for request in OAO(unique per request)
    * @param output AI model's output
    * @param callbackData user-defined data (The same as when the user call aiOracle.requestCallback)
    */
    function aiOracleCallback(uint256 requestId, bytes calldata output, bytes calldata callbackData) external virtual;

    function isFinalized(uint256 requestId) external view returns (bool) {
        return aiOracle.isFinalized(requestId);
    }

}