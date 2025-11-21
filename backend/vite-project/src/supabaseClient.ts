import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://pxhcheeetgfjkmrmjdqt.supabase.co'
const supabaseAnonKey = 'sb_publishable_xlJr2MYlcYdjdC8jUbw-IA_dQVjgj5v'

export const supabase = createClient(supabaseUrl, supabaseAnonKey)
