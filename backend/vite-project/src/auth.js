import { supabase } from './supabaseClient.js'

// SIGNUP (email + password)
export async function signUp(email, password) {
  const { data, error } = await supabase.auth.signUp({
    email,
    password,
  })

  if (error) {
    console.error("Signup error:", error.message)
    return { error }
  }

  return { data }
}

// LOGIN (email + password)
export async function login(email, password) {
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  })

  if (error) {
    console.error("Login error:", error.message)
    return { error }
  }

  return { data }
}

// GET CURRENT USER
export async function getCurrentUser() {
  const { data, error } = await supabase.auth.getUser()

  if (error) {
    console.error("Get user error:", error.message)
    return null
  }

  return data.user
}

// LOGOUT
export async function logout() {
  const { error } = await supabase.auth.signOut()
  if (error) console.error("Logout error:", error.message)
}
