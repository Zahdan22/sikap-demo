INSERT INTO private.demo_accounts(user_id, username)
SELECT id, username FROM public.users
WHERE username IN ('demo.crew','demo.manager','demo.finance','demo.bima','demo.citra')
ON CONFLICT (user_id) DO NOTHING;
