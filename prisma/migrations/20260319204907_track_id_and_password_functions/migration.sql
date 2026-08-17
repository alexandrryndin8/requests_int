-- These functions previously existed only on the original database, created
-- by hand outside of Prisma Migrate, and were never captured in migration
-- history. Recreated here from the live database so a fresh database (e.g.
-- a new Docker deployment) behaves the same way. Must run before migration
-- 20260319204908_try4ik, which uses generate_track_id() as a column default
-- when creating the "requests" table.

CREATE OR REPLACE FUNCTION public.generate_track_id()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
    base_chars TEXT := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    ts BIGINT := EXTRACT(EPOCH FROM clock_timestamp()) * 1000;
    result TEXT := '';
BEGIN
    WHILE ts > 0 LOOP
        result := substr(base_chars, (ts % 36)::int + 1, 1) || result;
        ts := ts / 36;
    END LOOP;

    result := lpad(result, 12, '0');
    RETURN result;
END;
$function$;

CREATE OR REPLACE FUNCTION public.generate_password(length integer DEFAULT 8)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
    chars TEXT := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    result TEXT := '';
    i INT;
BEGIN
    FOR i IN 1..length LOOP
        result := result || substr(chars, floor(random() * length(chars) + 1)::int, 1);
    END LOOP;
    RETURN result;
END;
$function$;
