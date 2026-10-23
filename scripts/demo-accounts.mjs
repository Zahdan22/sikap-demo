import { createClient } from '@supabase/supabase-js'

const url = process.env.NEXT_PUBLIC_SUPABASE_URL
if (url !== 'https://ovbvnqhoexmdjqrstquz.supabase.co') throw new Error('Refusing a non-demo project')
if (!process.env.SUPABASE_SECRET_KEY) throw new Error('Set SUPABASE_SECRET_KEY in .env.local first')
const admin = createClient(url, process.env.SUPABASE_SECRET_KEY, { auth: { persistSession: false, autoRefreshToken: false } })
const accounts = [
  ['demo.manager', 'Manager Jadwal Demo', 'manager'],
  ['demo.finance', 'Manager Keuangan Demo', 'finance'],
  ['demo.crew', 'Alya Demo', 'crew'],
  ['demo.bima', 'Bima Demo', 'crew'],
  ['demo.citra', 'Citra Demo', 'crew'],
]
for (const [username, nama, role] of accounts) {
  const { data: profile, error: readError } = await admin.from('users').select('id').eq('username', username).maybeSingle()
  if (readError) throw readError
  if (profile) { console.log(`${username}: already exists`); continue }
  const { data, error } = await admin.auth.admin.createUser({ email: `${username}@sikap.internal`, password: 'SikapDemo2026!', email_confirm: true })
  if (error) throw error
  const { error: insertError } = await admin.from('users').insert({ id: data.user.id, username, nama, role })
  if (insertError) {
    await admin.auth.admin.deleteUser(data.user.id)
    throw insertError
  }
  console.log(`${username}: created`)
}
console.log('Next: register accounts in private.demo_accounts, then run npm run demo:reset.')
