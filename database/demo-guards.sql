CREATE TABLE private.demo_accounts (user_id uuid PRIMARY KEY REFERENCES auth.users(id), username text UNIQUE NOT NULL);
REVOKE ALL ON private.demo_accounts FROM PUBLIC, anon, authenticated;
GRANT ALL ON private.demo_accounts TO service_role;
CREATE OR REPLACE FUNCTION private.protect_demo_auth() RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path = '' AS $$
BEGIN
 IF EXISTS (SELECT 1 FROM private.demo_accounts WHERE user_id=OLD.id) THEN
  IF TG_OP='DELETE' THEN RAISE EXCEPTION 'Akun demo bersama tidak dapat dihapus'; END IF;
  IF NEW.email IS DISTINCT FROM OLD.email OR NEW.encrypted_password IS DISTINCT FROM OLD.encrypted_password
    OR NEW.phone IS DISTINCT FROM OLD.phone OR NEW.banned_until IS DISTINCT FROM OLD.banned_until
    OR NEW.deleted_at IS DISTINCT FROM OLD.deleted_at
    OR NEW.email_change IS DISTINCT FROM OLD.email_change
    OR NEW.phone_change IS DISTINCT FROM OLD.phone_change
    OR NEW.raw_app_meta_data IS DISTINCT FROM OLD.raw_app_meta_data THEN
   RAISE EXCEPTION 'Identitas dan password akun demo dikunci';
  END IF;
 END IF;
 IF TG_OP='DELETE' THEN RETURN OLD; END IF;
 RETURN NEW;
END $$;
CREATE TRIGGER protect_demo_auth BEFORE UPDATE OR DELETE ON auth.users FOR EACH ROW EXECUTE FUNCTION private.protect_demo_auth();
CREATE OR REPLACE FUNCTION private.protect_demo_profile() RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path = '' AS $$
BEGIN
 IF EXISTS (SELECT 1 FROM private.demo_accounts WHERE user_id=OLD.id) THEN
  IF TG_OP='DELETE' THEN RAISE EXCEPTION 'Akun demo tidak dapat dihapus'; END IF;
  IF NEW.id IS DISTINCT FROM OLD.id OR NEW.username IS DISTINCT FROM OLD.username OR NEW.nama IS DISTINCT FROM OLD.nama OR NEW.role IS DISTINCT FROM OLD.role OR NEW.status_aktif IS DISTINCT FROM OLD.status_aktif THEN
   RAISE EXCEPTION 'Profil akun demo dikunci';
  END IF;
 END IF;
 IF TG_OP='DELETE' THEN RETURN OLD; END IF;
 RETURN NEW;
END $$;
CREATE TRIGGER protect_demo_profile BEFORE UPDATE OR DELETE ON public.users FOR EACH ROW EXECUTE FUNCTION private.protect_demo_profile();
REVOKE ALL ON FUNCTION private.protect_demo_auth(), private.protect_demo_profile() FROM PUBLIC, anon, authenticated;
