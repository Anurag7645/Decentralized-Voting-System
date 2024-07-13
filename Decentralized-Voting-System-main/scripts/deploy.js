const { errors } = require("ethers");
const hre = require("hardhat");

async function main() {
    const Lock = await hre.ethers.getContractFactory("Lock");
    const lock = await Lock.deploy();

    await lock.deployed();

    console.log("Lock with 1 ETH Deployed to:", lock.address);
}

main().catch((errors) => {
    console.error(errors);
    process.exitCode = 1;
})