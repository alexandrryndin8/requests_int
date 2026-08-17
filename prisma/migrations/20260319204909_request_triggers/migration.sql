-- Trigger functions and triggers for the "requests" table, recreated from
-- the live database (see 20260319204907_track_id_and_password_functions for
-- context). Must run after 20260319204908_try4ik, which creates the
-- "requests" table these triggers attach to.

CREATE OR REPLACE FUNCTION public.set_default_password()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    IF NEW.password IS NULL OR NEW.password = '' THEN
        NEW.password := generate_password(8);  -- длина пароля 8 символов
    END IF;
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.update_status_modified_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    IF NEW.status IS DISTINCT FROM OLD.status THEN
        NEW.status_modified_at := now();
    END IF;
    RETURN NEW;
END;
$function$;

CREATE TRIGGER trigger_set_password
    BEFORE INSERT ON public.requests
    FOR EACH ROW EXECUTE FUNCTION set_default_password();

CREATE TRIGGER trigger_update_status_modified_at
    BEFORE UPDATE ON public.requests
    FOR EACH ROW EXECUTE FUNCTION update_status_modified_at();
