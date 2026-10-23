import PageHeader from '@/components/PageHeader'

export default function DemoSettings() {
  return <div className="min-h-full bg-cream pb-10">
    <PageHeader title="Pengaturan Demo" backHref="/dashboard" />
    <div className="m-5 rounded-2xl border border-cream-dim bg-white p-5">
      <h1 className="font-semibold text-ink">Akun bersama</h1>
      <p className="mt-2 text-sm text-muted">Profil, password, dan status akun demo dikunci agar pengunjung berikutnya tetap bisa masuk. Silakan jelajahi fitur jadwal, absensi, pengajuan, dan payroll.</p>
    </div>
  </div>
}
