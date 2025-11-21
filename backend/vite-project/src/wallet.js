import { supabase } from "./supabaseClient.js";

// GET WALLET — returns null if no row yet
export async function getWallet(user_id) {
  const { data, error } = await supabase
    .from("wallet")
    .select("*")
    .eq("user_id", user_id)
    .maybeSingle(); // safer than single()

  if (error) {
    console.error("getWallet error:", error.message);
    return null;
  }

  return data;
}

// CREATE WALLET (used only if wallet doesn't exist)
export async function createWallet(user_id) {
  const { data, error } = await supabase
    .from("wallet")
    .insert({
      user_id,
      balance: 0
    })
    .select()
    .single();

  if (error) {
    console.error("createWallet error:", error.message);
    return null;
  }

  return data;
}

// ADD MONEY
export async function addMoney(user_id, amount) {
  const wallet = await getWallet(user_id);
  if (!wallet) {
    console.error("Wallet not found");
    return null;
  }

  const newBalance = Number(wallet.balance) + Number(amount);

  const { data, error } = await supabase
    .from("wallet")
    .update({
      balance: newBalance
    })
    .eq("user_id", user_id)
    .select()
    .single();

  if (error) {
    console.error("addMoney error:", error.message);
    return null;
  }

  return data;
}

// DEDUCT MONEY
export async function deductMoney(user_id, amount) {
  const wallet = await getWallet(user_id);
  if (!wallet) {
    console.error("Wallet not found");
    return null;
  }

  if (Number(wallet.balance) < Number(amount)) {
    console.error("Insufficient balance");
    return null;
  }

  const newBalance = Number(wallet.balance) - Number(amount);

  const { data, error } = await supabase
    .from("wallet")
    .update({
      balance: newBalance
    })
    .eq("user_id", user_id)
    .select()
    .single();

  if (error) {
    console.error("deductMoney error:", error.message);
    return null;
  }

  return data;
}

// AUTO INVEST RULE
export function calculateInvestment(amount) {
  if (amount <= 100) {
    // 2% rule below 100
    return Number((amount * 0.02).toFixed(2));
  }

  // Above 100 → 1%
  return Number((amount * 0.01).toFixed(2));
}

