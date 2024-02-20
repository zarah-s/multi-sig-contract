import { ethers } from "hardhat";

async function main() {
  const validSigners = ["0x617cd3DB0CbF26F323D5b72975c5311343e09115", "0x9A062EF7892c4F8bA4Ae09F4AF507f37218e9775", "0xf8E1d24aD086738fF31D31040967507801377B64", "0x4d247D5b8c20c4Ead7903BE3b1bA2953A6335C93"];
  const quorum = 3;

  const mulsigWallet = "0xBbfca0C74Dc7e30F3f477b277747406517CcD6a8";
  const MultiSigWallet = await ethers.getContractAt("IMultiSig", mulsigWallet);

  const amount = ethers.parseEther("1");
  const receiver = "0x4d247D5b8c20c4Ead7903BE3b1bA2953A6335C93";

  const initiateTransactionTx = await MultiSigWallet.initiateTransaction(amount, receiver);
  await initiateTransactionTx.wait();

  const allTxs = await MultiSigWallet.getAllTransactions();

    console.log(allTxs);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
