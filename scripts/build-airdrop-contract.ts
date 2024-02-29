import { readFile, writeFile } from "node:fs/promises";

const airdropList = (
  await readFile(new URL("../data/highroller.csv", import.meta.url), "ascii")
).split("\n");

// const amountPerAddress = Math.floor(90e12 / airdropList.length);
const amountPerAddress = 21_000_000;
// const amountPerAddress = 1;

let contractCode = `(define-private (trans (address principal))
    (contract-call? 'SP32AEEF6WW5Y0NMJ1S8SBSZDAY8R5J32NBZFPKKZ.wrapped-nothing-v8 transfer u${amountPerAddress} tx-sender address none))
`;
const buildTransfer = (address: string) => `(trans '${address})`;
const page = 1;
const template = airdropList
  .map(buildTransfer)
  .slice(1500 * (page - 1), 1500 * page)
  .join("\n");
writeFile(
  new URL("../nthng-airdrop/contracts/airdrop.clar", import.meta.url),
  contractCode + template
);
// console.log(contractCode + template);
