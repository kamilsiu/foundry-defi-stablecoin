# Foundry DeFi Stablecoin

A minimal, overcollateralized, USD-pegged decentralized stablecoin built with Solidity and Foundry.  
Inspired by MakerDAO DAI, this system only supports **WETH** and **WBTC** as collateral.

---

## Features

- **Mint & Burn Stablecoin (DSC)** – Users can mint DSC against deposited collateral and burn to redeem.  
- **Collateral Management** – Deposit and redeem WETH & WBTC.  
- **Health Factor Checks** – Ensure the system remains overcollateralized.  
- **Liquidation Mechanism** – Liquidators can seize collateral at a bonus if health factor drops.  
- **Oracle Integration** – Uses Chainlink price feeds for accurate collateral valuation.  
- **Fuzzing & Invariant Tests** – Ensures system safety and reliability.  

---

## Project Structure

