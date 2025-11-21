import { supabase } from './supabaseClient'
import { addMoney, deductMoney } from './wallet'
import { calculateInvestment } from './wallet'

export async function addTransaction(user_id: string, amount: number, type: string) {

  // Insert into transactions table
  const { data, error } = await supabase
    .from('transactions')
    .insert({
      user_id,
      amount,
      type
    })
    .select()
    .single()

  if (error) {
    console.error("Error adding transaction:", error)
    return null
  }

  return data
}

export async function getTransactions(user_id: string) {
  const { data, error } = await supabase
    .from('transactions')
    .select('*')
    .eq('user_id', user_id)
    .order('created_at', { ascending: false })

  if (error) {
    console.error("Error fetching transactions:", error)
    return []
  }

  return data
}

export async function processPayment(user_id: string, amount: number) {
  // 1. Deduct from wallet
  const deducted = await deductMoney(user_id, amount)
  if (!deducted) {
    console.error("Payment failed (insufficient balance)")
    return null
  }

  // 2. Add transaction record
  await addTransaction(user_id, amount, "debit")

  // 3. Calculate investment amount
  const investAmount = calculateInvestment(amount)

  // 4. Credit investment amount to wallet
  await addMoney(user_id, investAmount)

  // 5. Log investment transaction
  await addTransaction(user_id, investAmount, "investment")

  return {
    status: "success",
    invested: investAmount
  }
}

