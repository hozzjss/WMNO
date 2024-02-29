import { describe, expect, it } from "vitest";

const accounts = simnet.getAccounts();
const address1 = accounts.get("wallet_1")!;
const address2 = accounts.get("wallet_2")!;

/*
  The test below is an example. To learn more, read the testing documentation here:
  https://docs.hiro.so/clarinet/feature-guides/test-contract-with-clarinet-sdk
*/

describe("example tests", () => {
  it("ensures simnet is well initalised", () => {
    expect(simnet.blockHeight).toBeDefined();

    let res;
    res = simnet.callPublicFn("fis-com-fis-sev", "claim", [], address1);
    // console.log(res.result);
    res = simnet.callPublicFn("fis-com-fis-sev", "claim", [], address1);
    // console.log(res.result);
    res = simnet.callPublicFn("fis-com-fis-sev", "claim", [], address2);
    // console.log(res.result);

    simnet.mineEmptyBlocks(144 * 7);
    // res = simnet.callPublicFn("fis-com-fis-sev", "claim", [], address1);
    // console.log(res.result);
    // res = simnet.callPublicFn("fis-com-fis-sev", "claim", [], address1);
    // console.log(res.result);
    res = simnet.callPublicFn("fis-com-fis-sev", "claim", [], address2);
    // console.log(res.result);

    // console.log(simnet.getAssetsMap());
  });

  // it("shows an example", () => {
  //   const { result } = simnet.callReadOnlyFn("counter", "get-counter", [], address1);
  //   expect(result).toBeUint(0);
  // });
});
