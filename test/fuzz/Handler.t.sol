// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DSCEngine} from "../../src/DSCEngine.sol";
import {DecentralizedStableCoin} from "../../src/DecentralizedStableCoin.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/ERC20Mock.sol";
import {MockV3Aggregator} from "../mocks/MockV3Aggregator.sol";

contract Handler is Test {
    DSCEngine dsce;
    DecentralizedStableCoin dsc;

    ERC20Mock weth;
    ERC20Mock wbtc;

    uint256 public timesMintIsCalled;
    address[] public usersWithDepositedCollateral;
    MockV3Aggregator public ethUsdPriceFeed;

    uint256 MAX_DEPOSIT_SIZE = type(uint96).max;

    constructor(DSCEngine _dscEngine, DecentralizedStableCoin _dsc) {
        dsce = _dscEngine;
        dsc = _dsc;

        address[] memory collateralTokens = dsce.getCollateralTokens();
        weth = ERC20Mock(collateralTokens[0]);
        wbtc = ERC20Mock(collateralTokens[1]);

        // ✅ FIX: pass address(weth)
        ethUsdPriceFeed = MockV3Aggregator(dsce.getCollateralTokenPriceFeed(address(weth)));
    }

    function mintDsc(uint256 amount, address addressSeed) public {
        if (usersWithDepositedCollateral.length == 0) {
            return;
        }

        // ✅ FIX: modulo with uint256 index, not address
        uint256 index = uint256(uint160(addressSeed)) % usersWithDepositedCollateral.length;
        address sender = usersWithDepositedCollateral[index];

        (uint256 totalDscMinted, uint256 collateralValueInUsd) =
            dsce.getAccountInformation(sender);

        int256 maxDscToMint = (int256(collateralValueInUsd) / 2) - int256(totalDscMinted);
        if (maxDscToMint < 0) {
            return;
        }

        amount = bound(amount, 0, uint256(maxDscToMint));
        if (amount == 0) {
            return;
        }

        vm.startPrank(sender);
        dsce.mintDsc(amount);
        vm.stopPrank();
        timesMintIsCalled++;
    }

    function depositCollateral(uint256 collateralSeed, uint256 amountCollateral) public {
        ERC20Mock collateral = _getCollateralFromSeed(collateralSeed);

        vm.startPrank(msg.sender);
        collateral.mint(msg.sender, amountCollateral);
        collateral.approve(address(dsce), amountCollateral);

        amountCollateral = bound(amountCollateral, 0, MAX_DEPOSIT_SIZE);

        // ✅ FIX: pass address(collateral)
        dsce.depositCollateral(address(collateral), amountCollateral);

        vm.stopPrank();

        usersWithDepositedCollateral.push(msg.sender);
    }

    function redeeemCollateral(uint256 collateralSeed, uint256 amountCollateral) public {
        ERC20Mock collateral = _getCollateralFromSeed(collateralSeed);

        uint256 maxCollateralToRedeem =
            dsce.getCollateralBalanceOfUser(msg.sender, address(collateral));
        amountCollateral = bound(amountCollateral, 0, maxCollateralToRedeem);

        if (amountCollateral == 0) return;

        // ✅ FIX: pass address(collateral)
        dsce.redeemCollateral(address(collateral), amountCollateral);
    }

    function updateCollateralPrice(uint96 newPrice) public {
        int256 newPriceInt = int256(uint256(newPrice));
        ethUsdPriceFeed.updateAnswer(newPriceInt);
    }

    function _getCollateralFromSeed(uint256 collateralSeed) private view returns (ERC20Mock) {
        if (collateralSeed % 2 == 0) {
            return weth;
        }
        return wbtc;
    }
}
