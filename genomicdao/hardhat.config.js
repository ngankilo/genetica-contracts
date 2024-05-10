require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    solidity: "0.8.25",
    networks: {
        "optimism-sepolia": {
            url: "https://sepolia.optimism.io",
            chainId: 11155420,
            accounts: [process.env.PRIVATE_KEY],
        }
    }
}
