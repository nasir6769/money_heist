import { addMoney, deductMoney, calculateInvestment } from "./wallet.js";
import { addTransaction } from "./transactions.js";

// PAYMENT + AUTO INVEST LOGIC
export async function processPayment(user_id, amount) {
  // 1. Deduct payment
  const debited = await deductMoney(user_id, amount);
  if (!debited) {
    console.error("Payment failed");
    return null;
  }

  // 2. Log debit transaction
  await addTransaction(user_id, amount, "debit");

  // 3. Calculate invest amount
  const investAmount = calculateInvestment(amount);

  // 4. Credit investment
  await addMoney(user_id, investAmount);

  // 5. Log investment transaction
  await addTransaction(user_id, investAmount, "investment");

  return {
    status: "success",
    invested: investAmount,
  };
}
