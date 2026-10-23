INSERT INTO public.payroll_tier_rates(tier,hourly_rate,work_days_to_next_tier)
VALUES ('pra_training',5000,3),('training',6500,22),('junior',8000,24),('senior',10000,NULL)
ON CONFLICT (tier) DO NOTHING;
