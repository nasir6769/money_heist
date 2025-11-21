import { processPayment } from "../payment.js";

async function run() {
  console.log("\n--- SUCCESSFUL PAYMENT TEST ---");

  const user_id = "70f93c5a-f1c5-410a-9a23-e249395aebe8";

  // first add money so we have enough balance
  const add = await import("../wallet.js");
  await add.addMoney(user_id, 500);

  const result = await processPayment(user_id, 200);

  console.log("RESULT:", result);
}

run();
