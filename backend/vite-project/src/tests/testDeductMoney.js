import { deductMoney } from "../wallet.js";

async function run() {
  const user_id = "70f93c5a-f1c5-410a-9a23-e249395aebe8"; // your real user ID

  const result = await deductMoney(user_id, 20);  // subtract ₹20
  console.log("DEDUCT MONEY RESULT:", result);
}

run();
