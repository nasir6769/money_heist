import { createClient } from '@supabase/supabase-js'

const supabaseUrl = "https://pxhcheeetgfjkmrmjdqt.supabase.co"   // your URL
const supabaseAnonKey = "sb_publishable_xlJr2MYlcYdjdC8jUbw-IA_dQVjgj5v"             // your publishable key (anon)

export const supabase = createClient(supabaseUrl, supabaseAnonKey)
