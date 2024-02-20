import { ethers } from "hardhat";

async function main() {
  const multiSigFactory = await ethers.deployContract("MultiSigFactory");

  await multiSigFactory.waitForDeployment();

  console.log(
    `MultiSig Factory contract deployed to ${multiSigFactory.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
