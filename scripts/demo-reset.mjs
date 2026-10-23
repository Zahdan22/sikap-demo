import { createClient } from '@supabase/supabase-js'
const url = process.env.NEXT_PUBLIC_SUPABASE_URL
if (url !== 'https://ovbvnqhoexmdjqrstquz.supabase.co') throw new Error('Refusing a non-demo project')
if (!process.env.SUPABASE_SECRET_KEY) throw new Error('Set SUPABASE_SECRET_KEY in .env.local first')
const admin = createClient(url, process.env.SUPABASE_SECRET_KEY, { auth: { persistSession: false, autoRefreshToken: false } })
const { error } = await admin.rpc('reset_demo_data')
if (error) throw error
console.log('Demo data reset with dates relative to today in Asia/Jakarta.')
