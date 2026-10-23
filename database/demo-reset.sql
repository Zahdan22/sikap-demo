CREATE OR REPLACE FUNCTION public.reset_demo_data() RETURNS void LANGUAGE plpgsql SECURITY INVOKER SET search_path = public, pg_temp AS $$
DECLARE mgr uuid; fin uuid; crew uuid; crew2 uuid; crew3 uuid; d date := (now() at time zone 'Asia/Jakarta')::date; sid integer;
BEGIN
 SELECT user_id INTO mgr FROM private.demo_accounts WHERE username='demo.manager';
 SELECT user_id INTO fin FROM private.demo_accounts WHERE username='demo.finance';
 SELECT user_id INTO crew FROM private.demo_accounts WHERE username='demo.crew';
 SELECT user_id INTO crew2 FROM private.demo_accounts WHERE username='demo.bima';
 SELECT user_id INTO crew3 FROM private.demo_accounts WHERE username='demo.citra';
 IF mgr IS NULL OR fin IS NULL OR crew IS NULL OR crew2 IS NULL OR crew3 IS NULL THEN RAISE EXCEPTION 'Create all demo accounts before seeding'; END IF;
 PERFORM pg_advisory_xact_lock(20261023);
 TRUNCATE public.attendance, public.attendance_correction_events, public.attendance_corrections, public.crew_payroll_counted_workdays, public.crew_payroll_status, public.crew_payroll_tier_history, public.crew_violations, public.jam_kerja_opsi, public.jam_kerja_preset, public.jobdesk, public.jobdesk_preset, public.jobdesk_preset_item, public.leave_request, public.office_location, public.overtime_requests, public.payroll_adjustments, public.payroll_items, public.payroll_periods, public.payroll_senior_plus_rates, public.payroll_tier_rates, public.periode_kerja, public.reverse_geocode_rate_limits, public.schedule, public.schedule_day_status, public.schedule_jobdesk, public.schedule_jobdesk_block, public.shift_swap_request;
 INSERT INTO payroll_tier_rates(tier,hourly_rate,work_days_to_next_tier) VALUES ('pra_training',5000,3),('training',6500,22),('junior',8000,24),('senior',10000,NULL);
 INSERT INTO payroll_senior_plus_rates(level,daily_bonus) SELECT n,n*5000 FROM generate_series(1,5) n;
 INSERT INTO crew_payroll_status(user_id,tier,effective_on) VALUES (crew,'junior',d-60),(crew2,'training',d-60),(crew3,'senior',d-60);
 INSERT INTO office_location(nama_lokasi,latitude,longitude,radius_meter) VALUES ('Kantor Simulasi',-7.98,112.63,100);
 INSERT INTO periode_kerja(nama,tanggal_mulai,tanggal_selesai,dibuat_oleh) VALUES ('Periode Demo Berjalan',d-14,d+14,mgr);
 INSERT INTO jobdesk(nama,singkatan,dibuat_oleh) VALUES ('Kasir','KSR',mgr),('Barista','BAR',mgr),('Pelayanan','PLY',mgr);
 INSERT INTO jam_kerja_opsi(label,jam_mulai,jam_selesai,durasi_jam,dibuat_oleh) VALUES ('Pagi','08:00','16:00',8,mgr),('Sore','14:00','22:00',8,mgr);
 INSERT INTO schedule(user_id,tanggal,jam_mulai,jam_selesai,durasi_jam,dibuat_oleh)
 SELECT u,day::date,'08:00','16:00',8,mgr FROM unnest(ARRAY[crew,crew2,crew3]) u CROSS JOIN generate_series(d-14,d+14,interval '1 day') day;
 INSERT INTO schedule_day_status(tanggal,updated_by) SELECT day::date,mgr FROM generate_series(d-14,d+14,interval '1 day') day;
 INSERT INTO schedule_jobdesk(schedule_id,jobdesk_id) SELECT s.id,j.id FROM schedule s JOIN jobdesk j ON j.singkatan=CASE WHEN s.user_id=crew THEN 'KSR' WHEN s.user_id=crew2 THEN 'BAR' ELSE 'PLY' END;
 INSERT INTO attendance(user_id,schedule_id,jam_masuk_aktual,jam_pulang_aktual,status_masuk,status_pulang,menit_telat)
 SELECT user_id,id,(tanggal+time '07:45') at time zone 'Asia/Jakarta',(tanggal+time '16:05') at time zone 'Asia/Jakarta','tepat_waktu','tepat_waktu',0 FROM schedule WHERE tanggal<d;
 INSERT INTO leave_request(user_id,jenis,tanggal_mulai,tanggal_selesai,alasan) VALUES (crew,'keperluan_pribadi',d+2,d+2,'Contoh pengajuan izin untuk mencoba persetujuan manager');
 INSERT INTO overtime_requests(user_id,tanggal,jam_mulai,jam_selesai,keterangan,status,reviewed_by,reviewed_at)
 VALUES (crew,d-2,'16:00','18:00','Contoh lembur penutupan toko','disetujui',mgr,now()),(crew2,d,'16:00','18:00','Contoh pengajuan lembur menunggu persetujuan','pending',NULL,NULL);
 INSERT INTO crew_violations(user_id,tanggal,kesalahan,poin,denda,created_by,reviewed_by,reviewed_at) VALUES (crew2,d-3,'Contoh simulasi: kelengkapan seragam',1,5000,mgr,mgr,now());
END $$;
REVOKE ALL ON FUNCTION public.reset_demo_data() FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.reset_demo_data() TO service_role;
