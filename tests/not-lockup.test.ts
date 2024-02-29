import { ClarityValue, cvToString, uintCV } from "@stacks/transactions";
import { describe, expect, it } from "vitest";

const accounts = simnet.getAccounts();
const address1 = accounts.get("deployer")!;

/*
  The test below is an example. To learn more, read the testing documentation here:
  https://docs.hiro.so/clarinet/feature-guides/test-contract-with-clarinet-sdk
*/

describe("example tests", () => {
  it("ensures simnet is well initalised", () => {
    expect(simnet.blockHeight).toBeDefined();
  });

  it("shows an example", () => {
    let result: ClarityValue;
    const assetMap = simnet.getAssetsMap();
    const oldMNO = assetMap.get(".micro-nthng.micro-nothing")!.get(address1)!;
    result = simnet.callPublicFn(
      "wrapped-nothing-v8",
      "wrap-nthng",
      [uintCV(oldMNO)],
      address1
    ).result;
    console.log(cvToString(result));
    result = simnet.callPublicFn(
      "not-lockup",
      "lock-wmno",
      [],
      address1
    ).result;
    console.log(cvToString(result));
    result = simnet.callPublicFn(
      "not-lockup",
      "unlock-wmno",
      [],
      address1
    ).result;
    console.log(cvToString(result));
  });
});
