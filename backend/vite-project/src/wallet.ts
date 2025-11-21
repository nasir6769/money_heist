import { supabase } from './supabaseClient'

export async function getWallet(user_id: string) {
  const { data, error } = await supabase
    .from('wallet')
    .select('*')
    .eq('user_id', user_id)
    .single()

  if (error) {
    console.error("Error fetching wallet:", error)
    return null
  }

  return data
}

export async function createWallet(user_id: string) {
  const { data, error } = await supabase
    .from('wallet')
    .insert({
      user_id,
      balance: 0
    })
    .select()
    .single()

  if (error) {
    console.error("Error creating wallet:", error)
    return null
  }

  return data
}

export async function addMoney(user_id: string, amount: number) {
  const wallet = await getWallet(user_id)
  if (!wallet) return null

  const newBalance = wallet.balance + amount

  const { data, error } = await supabase
    .from('wallet')
    .update({ balance: newBalance })
    .eq('user_id', user_id)
    .select()
    .single()

  if (error) {
    console.error("Error adding money:", error)
    return null
  }

  return data
}

export async function deductMoney(user_id: string, amount: number) {
  const wallet = await getWallet(user_id)
  if (!wallet) return null

  if (wallet.balance < amount) {
    console.error("Insufficient balance")
    return null
  }

  const newBalance = wallet.balance - amount

  const { data, error } = await supabase
    .from('wallet')
    .update({ balance: newBalance })
    .eq('user_id', user_id)
    .select()
    .single()

  if (error) {
    console.error("Error deducting money:", error)
    return null
  }

  return data
}

export function calculateInvestment(amount: number) {
  let invest = 0

  // First ₹100 → 2% per ₹10 = 0.2% per ₹1
  const first100 = Math.min(amount, 100)
  invest += first100 * 0.002   // 0.2%

  // Above ₹100 → 1%
  if (amount > 100) {
    invest += (amount - 100) * 0.01
  }

  // Cap at 10%
  const maxCap = amount * 0.10
  if (invest > maxCap) {
    invest = maxCap
  }

  return Number(invest.toFixed(2))
}

