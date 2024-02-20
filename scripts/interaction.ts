import { ethers } from "hardhat";

async function main() {
  const validSigners = ["0x617cd3DB0CbF26F323D5b72975c5311343e09115", "0x9A062EF7892c4F8bA4Ae09F4AF507f37218e9775", "0xf8E1d24aD086738fF31D31040967507801377B64", "0x4d247D5b8c20c4Ead7903BE3b1bA2953A6335C93"];
  const quorum = 3;

  const multiSigFactoryContract = "0xF7Bb849857e48877f39007BabaC0E4DdC5fD1B5C";
  const MULTISIGFACTORY = await ethers.getContractAt("IMultiSigFactory", multiSigFactoryContract);

  const createWalletTx = await MULTISIGFACTORY.createMultiSigWallet(validSigners, quorum);
  await createWalletTx.wait();

  const clones = await MULTISIGFACTORY.getMultiSigClones();

  console.log(clones);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
