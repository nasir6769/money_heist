import { supabase } from "./supabaseClient.js";

export async function addTransaction(user_id, amount) {
  const { data, error } = await supabase
    .from("transactions")
    .insert([
      {
        user_id: user_id,   // 🔥 REQUIRED (otherwise RLS blocks it)
        amount: amount,
        type: "auto-invest",
      }
    ])
    .select()
    .single();

  if (error) {
    console.error("addTransaction error:", error);
    return null;
  }

  return data;
}


// GET ALL TRANSACTIONS
export async function getTransactions(user_id) {
  const { data, error } = await supabase
    .from("transactions")
    .select("*")
    .eq("user_id", user_id)
    .order("created_at", { ascending: false });

  if (error) {
    console.error("getTransactions error:", error.message);
    return [];
  }

  return data;
}

