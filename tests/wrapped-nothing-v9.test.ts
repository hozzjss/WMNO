import { ClarityValue, cvToString, principalCV } from "@stacks/transactions";
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

    result = simnet.callPublicFn(
      "wrapped-nothing-v9",
      "wrap-wmno8",
      [],
      address1
    ).result;
    console.log(cvToString(result));

    result = simnet.callPublicFn(
      "wrapped-nothing-v9",
      "wrap-wmno5",
      [],
      address1
    ).result;
    console.log(cvToString(result));

    result = simnet.callPublicFn(
      "wrapped-nothing-v9",
      "wrap-wmno6",
      [],
      address1
    ).result;
    console.log(cvToString(result));

    result = simnet.callReadOnlyFn(
      "wrapped-nothing-v8",
      "get-balance",
      [principalCV(address1)],
      address1
    ).result;
    console.log(cvToString(result));

    result = simnet.callReadOnlyFn(
      "wrapped-nothing-v9",
      "get-balance",
      [principalCV(address1)],
      address1
    ).result;
    console.log(cvToString(result));
    result = simnet.callPublicFn(
      "wrapped-nothing-v9",
      "unwrap-wmno8",
      [],
      address1
    ).result;
    console.log(cvToString(result));

    result = simnet.callReadOnlyFn(
      "wrapped-nothing-v9",
      "get-balance",
      [principalCV(address1)],
      address1
    ).result;
    console.log(cvToString(result));
    // expect(result).toBeOk()
  });
});
