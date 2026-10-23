export const DEMO_PROJECT_URL = 'https://ovbvnqhoexmdjqrstquz.supabase.co'
export const DEMO_PASSWORD = 'SikapDemo2026!'
export const DEMO_ACCOUNTS = [
  { username: 'demo.crew', label: 'Crew', description: 'Jadwal, absensi, izin, dan pengajuan lembur' },
  { username: 'demo.manager', label: 'Manager Penjadwalan', description: 'Kelola jadwal dan persetujuan pengajuan' },
  { username: 'demo.finance', label: 'Manager Keuangan', description: 'Laporan, tier crew, dan perhitungan payroll' },
] as const

// This repository is exclusively a demo. Refuse every other database target.
export function assertDemoProject(url = process.env.NEXT_PUBLIC_SUPABASE_URL) {
  if (url !== DEMO_PROJECT_URL) throw new Error('SIKAP Demo hanya boleh terhubung ke proyek Supabase demo.')
}
