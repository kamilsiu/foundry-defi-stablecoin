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
```
foundry-defi-stablecoin/
│── lib/ # Dependencies (forge-std, OpenZeppelin, Chainlink)
│── script/ # Deployment scripts
│ └── DeployDSC.s.sol
│── src/ # Main contracts
│ ├── DSCEngine.sol
│ ├── DecentralizedStableCoin.sol
│ └── libraries/
│ └── OracleLib.sol
│── test/ # Tests
│ ├── unit/
│ │ └── DSCEngine.t.sol
│ └── fuzz/
│ └── Invariants.t.sol
│── .github/
│ └── workflows/
│ └── test.yml # GitHub Actions CI
│── foundry.toml # Foundry config
│── README.md
```

---

## Installation

1. Clone the repo:

```
git clone https://github.com/kamilsiu/foundry-defi-stablecoin.git
cd foundry-defi-stablecoin
```
2. Install dependencies:
```
forge install
```
3. Build the project:
```
forge build
```
## Testing

Run all tests using Foundry:

```
forge test -vvv
```

Unit tests are in test/unit/.

 Fuzz & invariant tests are in test/fuzz/.

## Deployment

Deploy using Foundry scripts:
```
forge script script/DeployDSC.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```
## Tech Stack

1. Solidity ^0.8.19
2. Foundry (forge, cast, anvil)
3. OpenZeppelin Contracts
4. Chainlink Oracles

## License

MIT License © 2025 Kamil Nissar
