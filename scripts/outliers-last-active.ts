import { readFile, writeFile } from "node:fs/promises";
import { Configuration, AccountsApi } from "@stacks/blockchain-api-client";

const config = new Configuration({
  basePath: "http://localhost:3999",
});

const api = new AccountsApi(config);
const outliersList = (
  await readFile(new URL("../data/outliers.csv", import.meta.url), "ascii")
)
  .split("\n")
  .slice(0, 10);

for (let address of outliersList) {
  const { results } = await api.getAccountTransactions({
    limit: 1,
    principal: address,
  });

  console.log(
    `${address}`,
    (results[0] as any)?.block_height,
    (results[0] as any)?.nonce
  );
}
