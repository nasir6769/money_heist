import { getWallet } from "../wallet.js";

async function run() {
  const user_id = "70f93c5a-f1c5-410a-9a23-e249395aebe8";

  const wallet = await getWallet(user_id);
  console.log("WALLET:", wallet);
}

run();
