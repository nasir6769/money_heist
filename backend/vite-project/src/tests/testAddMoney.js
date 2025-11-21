import { addMoney } from "../wallet.js";

async function run() {
  const user_id = "70f93c5a-f1c5-410a-9a23-e249395aebe8";

  const result = await addMoney(user_id, 50);
  console.log("ADD MONEY RESULT:", result);
}

run();
