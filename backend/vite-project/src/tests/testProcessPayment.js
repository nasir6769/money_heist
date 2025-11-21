import { processPayment } from "../payment.js";

async function run() {
  const user_id = "70f93c5a-f1c5-410a-9a23-e249395aebe8"; // your UID

  console.log("\n--- PROCESS PAYMENT TEST ---");
  const amount = 200; // test amount
  const result = await processPayment(user_id, amount);

  console.log("RESULT:", result);
}

run();
