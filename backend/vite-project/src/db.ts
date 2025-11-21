// src/db.ts
import { supabase } from './supabaseClient'

/** === Profiles === **/
export async function getProfile(userId: string) {
  const { data, error } = await supabase
    .from('profiles')
    .select('id, full_name, email, phone, roles, is_verified, created_at')
    .eq('id', userId)
    .single()
  return { data, error }
}

export async function updateProfile(userId: string, payload: { full_name?: string; phone?: string }) {
  const { data, error } = await supabase
    .from('profiles')
    .update(payload)
    .eq('id', userId)
    .select()
  return { data, error }
}

/** === Wallet & Transactions === **/
export async function getWallet(userId: string) {
  const { data, error } = await supabase
    .from('wallet')
    .select('id, user_id, balance, updated_at')
    .eq('user_id', userId)
    .single()
  return { data, error }
}

export async function getTransactions(userId: string, limit = 50) {
  const { data, error } = await supabase
    .from('transactions')
    .select('id, amount, type, created_at')
    .eq('user_id', userId)
    .order('created_at', { ascending: false })
    .limit(limit)
  return { data, error }
}

/** === Create transaction (recommended: call server/RPC for atomicity) === **/

// Simple client-only version (not atomic) - good for quick testing
export async function createTransactionClient(userId: string, amount: number, type: 'credit' | 'debit') {
  // 1) insert transaction
  const { data: tx, error: txErr } = await supabase
    .from('transactions')
    .insert([{ user_id: userId, amount, type }])
    .select()
  if (txErr) return { data: null, error: txErr }

  // 2) update wallet (not atomic)
  const delta = type === 'credit' ? amount : -amount
  const { data: w, error: wErr } = await supabase
    .from('wallet')
    .update({ balance: supabase.rpc('add_numeric', { a: 'balance', b: delta }) }) // placeholder; see RPC below
    .eq('user_id', userId)
    .select()
  return { data: { tx, w }, error: wErr ?? null }
}

// Recommended: call a server-side RPC (atomic). See SQL below to create `record_transaction` function.
export async function createTransactionAtomic(userId: string, amount: number, type: 'credit' | 'debit') {
  const { data, error } = await supabase.rpc('record_transaction', {
    p_user_id: userId,
    p_amount: amount,
    p_type: type,
  })
  return { data, error }
}
