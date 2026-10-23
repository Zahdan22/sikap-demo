import { assertDemoProject } from '@/lib/demo'
assertDemoProject()
import { createClient } from '@supabase/supabase-js'

// PERHATIAN: file ini hanya boleh di-import dari kode yang jalan di server
// (API route atau Server Action), TIDAK PERNAH dari 'use client' component.
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!
const supabaseSecretKey = process.env.SUPABASE_SECRET_KEY!

function makeAdminClient() {
  return createClient(supabaseUrl, supabaseSecretKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  })
}
let client: ReturnType<typeof makeAdminClient> | undefined
// Defer privileged credentials until a server operation actually needs them.
export const supabaseAdmin = new Proxy({} as ReturnType<typeof makeAdminClient>, {
  get(_target, property) {
    if (!supabaseSecretKey) throw new Error('SUPABASE_SECRET_KEY untuk proyek demo belum dikonfigurasi.')
    client ??= makeAdminClient()
    const value = Reflect.get(client, property)
    return typeof value === 'function' ? value.bind(client) : value
  },
})
