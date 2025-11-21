import { calculateInvestment } from "../wallet.js";

function run() {
  let amounts = [10, 50, 100, 150, 500, 2000];

  for (const amount of amounts) {
    const invest = calculateInvestment(amount);
    console.log(`Amount: ₹${amount} → Invest: ₹${invest}`);
  }
}

run();
