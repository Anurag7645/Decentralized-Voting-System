
const hre = require("hardhat");

async function main() {
    const Create = await hre.ethers.getContractFactory("Create");
    const create = await Create.deploy();

    await create.deployed();

    console.log("Lock with 1 ETH Deployed to:", create.address);
}

main().catch((errors) => {
    console.error(errors);
    process.exitCode = 1;
})