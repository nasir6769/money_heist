import { supabase } from './supabaseClient'

// Sign up user with email + password
export async function signUp(email: string, password: string) {
  const { data, error } = await supabase.auth.signUp({
    email,
    password,
  })

  return { data, error }
}

// Login user with email + password
export async function login(email: string, password: string) {
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  })

  return { data, error }
}

// Get current authenticated user
export async function getCurrentUser() {
  const { data, error } = await supabase.auth.getUser()
  if (error) console.error("Get user error:", error.message)
  return data?.user
}

// Logout
export async function logout() {
  const { error } = await supabase.auth.signOut()
  if (error) console.error("Logout error:", error.message)
  else console.log("Logged out successfully")
}
