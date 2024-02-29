import { readFile, writeFile } from "node:fs/promises";

const airdropList = (
  await readFile(new URL("../data/list.csv", import.meta.url), "ascii")
).split("\n");

let boomList = (
  await readFile(new URL("../data/boom.csv", import.meta.url), "ascii")
).split("\n");

const airdropSet = new Set(airdropList);
const boomSet = new Set(boomList);
boomList = Array.from(boomSet);

let totalMatches = 0;

let outliers: string[] = [];

for (const boom of boomList) {
  if (airdropSet.has(boom)) {
    totalMatches++;
  } else {
    outliers = [...outliers, boom.trim()];
  }
}

writeFile(
  new URL("../data/outliers.csv", import.meta.url),
  outliers.join("\n")
);

console.log(`Total matches: ${totalMatches}`);
