# SIKAP Demo

Versi portofolio SIKAP dengan database terpisah dan data simulasi. Aplikasi ini hanya menerima URL proyek Supabase `ovbvnqhoexmdjqrstquz` dan menolak target lain.

## Menjalankan

1. `npm ci`
2. Salin `.env.example` menjadi `.env.local`. Isi `SUPABASE_SECRET_KEY` dari proyek **sikap-demo**. Jangan gunakan kunci operasional atau commit file tersebut.
3. `npm run dev`

## Akun bersama

| Peran | Username | Password |
| --- | --- | --- |
| Crew | demo.crew | SikapDemo2026! |
| Manager penjadwalan | demo.manager | SikapDemo2026! |
| Manager keuangan | demo.finance | SikapDemo2026! |

Password ini sengaja dipublikasikan dan hanya berlaku untuk data simulasi. Dua crew contoh tambahan: `demo.bima` dan `demo.citra`.

## Database dan data contoh

`database/schema.sql` adalah snapshot struktur PostgreSQL, tanpa data produksi. Proyek demo yang ditentukan sudah menerima struktur dan fungsi reset melalui migrasi Supabase.

Untuk instalasi database kosong: jalankan `database/schema.sql`, `database/demo-guards.sql`, `database/demo-reset.sql`, kemudian `database/demo-rates.sql`. Jangan jalankan ulang snapshot schema pada database yang sudah berisi tabel.

Setelah Secret API Key tersedia:

1. `npm run demo:accounts` membuat akun melalui Supabase Auth Admin API.
2. Jalankan `database/register-demo-accounts.sql` melalui SQL Editor proyek demo untuk melindungi akun bersama.
3. `npm run demo:reset` mengisi ulang data contoh relatif terhadap tanggal Asia/Jakarta: tiga crew, periode 29 hari, 87 jadwal, 42 absensi historis, jobdesk, izin, lembur, dan pelanggaran. Laporan payroll dihitung dari data tersebut; manager keuangan dapat menyimpan draf melalui aplikasi.

Reset mengganti data transaksi demo, termasuk arsip payroll, dan mempertahankan akun. Fungsi reset hanya dapat dijalankan menggunakan peran server, bukan pengunjung. Berkas unggahan di Storage tidak dihapus oleh reset; kelola retensinya sebelum membuka demo untuk penggunaan publik jangka panjang. Reset saat ini dijalankan manual, bukan terjadwal.

## Perilaku demo

- Pilihan akun mengisi formulir login; tekan Masuk untuk masuk.
- Banner data simulasi ditampilkan di semua halaman.
- Lokasi absensi menggunakan koordinat contoh. Foto kamera dan aturan waktu shift tetap berlaku.
- Pembuatan/penghapusan akun, perubahan profil, password, dan penonaktifan akun bersama dikunci. Trigger database melindungi identitas/password meskipun API dipanggil langsung.
- Data digunakan bersama; perubahan seorang pengunjung dapat terlihat oleh pengunjung lain.

## Deployment

Hubungkan repository `Zahdan22/sikap-demo` ke proyek Vercel baru `sikap-demo` pada tim `vandaz`. Isi tiga variabel dari `.env.local` di Vercel; Secret API Key hanya untuk server dan tidak memakai awalan `NEXT_PUBLIC_`. Sesuaikan Supabase Auth Site URL dengan alamat deployment setelah tersedia.

## Verifikasi

`npm run build`, `npx tsc --noEmit`, dan `node --test tests/*.test.mjs tests/*.test.cjs`.

Pengujian awal: build produksi dan 23 tes lulus. Seed/reset serta proteksi password/status akun diuji dalam transaksi database yang di-rollback. Login nyata, persetujuan, payroll end-to-end, dan deployment perlu diverifikasi setelah kredensial demo tersedia.

Supabase Advisor menampilkan peringatan untuk sepuluh RPC SECURITY DEFINER warisan aplikasi. RPC tersebut memiliki pemeriksaan pengguna/peran di tubuh fungsi; izin eksekusi dipertahankan untuk fitur aplikasi. Panduan: https://supabase.com/docs/guides/database/database-linter?lint=0029_authenticated_security_definer_function_executable
