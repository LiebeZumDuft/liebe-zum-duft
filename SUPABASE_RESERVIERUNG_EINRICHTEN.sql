-- Nur EINMAL im Supabase SQL Editor ausführen.
-- Ergänzt die bestehende Datenbank. Die vorhandenen Tabellen / Bestände bleiben erhalten.
CREATE TABLE IF NOT EXISTS public.stock_reservations (
  request_id uuid PRIMARY KEY,
  perfume_name text NOT NULL,
  size_ml integer NOT NULL CHECK (size_ml IN (30, 50, 100)),
  created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.stock_reservations ENABLE ROW LEVEL SECURITY;
-- Keine direkten Zugriffe auf die Reservierungstabelle vom Browser.
REVOKE ALL ON public.stock_reservations FROM anon, authenticated;

CREATE OR REPLACE FUNCTION public.reserve_perfume(
  p_request_id uuid,
  p_perfume_name text,
  p_size_ml integer
) RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  previous public.stock_reservations%ROWTYPE;
  qty integer;
BEGIN
  IF p_request_id IS NULL OR p_perfume_name IS NULL OR length(p_perfume_name) NOT BETWEEN 1 AND 200
     OR p_size_ml NOT IN (30, 50, 100) THEN
    RAISE EXCEPTION 'Ungueltige Reservierung';
  END IF;

  -- Wiederholtes Klicken / gleichzeitige Anfragen mit derselben Kennung nur einmal abrechnen.
  PERFORM pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(p_request_id::text, 0));
  SELECT * INTO previous FROM public.stock_reservations WHERE request_id = p_request_id;
  IF FOUND THEN
    IF previous.perfume_name <> p_perfume_name OR previous.size_ml <> p_size_ml THEN
      RAISE EXCEPTION 'Reservierungskennung bereits anders verwendet';
    END IF;
    RETURN 'reserved';
  END IF;

  -- Atomarer Abzug: bei Parallelzugriffen kann der Bestand nicht negativ werden.
  UPDATE public.perfume_stock
     SET quantity = quantity - 1
   WHERE perfume_name = p_perfume_name
     AND size_ml = p_size_ml
     AND quantity > 0
  RETURNING quantity INTO qty;

  IF FOUND THEN
    INSERT INTO public.stock_reservations(request_id, perfume_name, size_ml)
    VALUES (p_request_id, p_perfume_name, p_size_ml);
    RETURN 'reserved';
  END IF;

  IF EXISTS(SELECT 1 FROM public.perfume_stock
            WHERE perfume_name = p_perfume_name AND size_ml = p_size_ml AND quantity = 0) THEN
    RETURN 'orderable';
  END IF;
  RETURN 'not_registered';
END;
$$;
REVOKE ALL ON FUNCTION public.reserve_perfume(uuid, text, integer) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.reserve_perfume(uuid, text, integer) TO anon, authenticated;
