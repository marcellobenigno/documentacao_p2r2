-- Adicionar a coluna espacial na tabela areacontampassivoambiental
-- Através do comando AddGeometryColumn deu um erro falando que não é único
ALTER TABLE public.areacontampassivoambiental
  ADD COLUMN the_geom GEOMETRY;

ALTER TABLE public.areacontampassivoambiental
  ADD CONSTRAINT enforce_dims_the_geom CHECK (st_ndims(the_geom) = 2);

ALTER TABLE public.areacontampassivoambiental
  ADD CONSTRAINT enforce_geotype_the_geom CHECK (geometrytype(the_geom) = 'MULTIPOLYGON' :: TEXT OR the_geom IS NULL);

ALTER TABLE public.areacontampassivoambiental
  ADD CONSTRAINT enforce_srid_the_geom CHECK (st_srid(the_geom) = 4291);

CREATE INDEX areacontampassivoambiental_gix
  ON public.areacontampassivoambiental
  USING GIST
  (the_geom);

-- Adicionar coluna risco na tabela areacontampassivoambiental
ALTER TABLE public.areacontampassivoambiental
  ADD COLUMN risco CHARACTER VARYING(150);

-- Adicionar coluna idpassivo na tabela meioimpactado
ALTER TABLE public.meioimpactado
  ADD COLUMN idpassivo INTEGER;

-- Adicionar constraint da tabela meioimpactado com a tabela passivoambiental
ALTER TABLE public.meioimpactado
  ADD CONSTRAINT fk_meioimpactado_passivoambiental FOREIGN KEY (idpassivo)
REFERENCES public.passivoambiental (idpassivo) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Adicionar coluna idpassivo na tabela produtoquimareacontaminada
ALTER TABLE public.produtoquimareacontaminada
  ADD COLUMN idpassivo INTEGER;

-- Adicionar constraint da tabela produtoquimareacontaminada com a tabela passivoambiental
ALTER TABLE public.produtoquimareacontaminada
  ADD CONSTRAINT fk_produtoquimareacontaminada_passivoambiental FOREIGN KEY (idpassivo)
REFERENCES public.passivoambiental (idpassivo) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Adicionar coluna idpassivo na tabela residuoareacontampasamb
ALTER TABLE public.residuoareacontampasamb
  ADD COLUMN idpassivo INTEGER;

-- Adicionar constraint da tabela residuoareacontampasamb com a tabela passivoambiental
ALTER TABLE public.residuoareacontampasamb
  ADD CONSTRAINT fk_residuoareacontampasamb_passivoambiental FOREIGN KEY (idpassivo)
REFERENCES public.passivoambiental (idpassivo) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Adicionar coluna idpassivo na tabela estrutcontinstrgestambareacontam
ALTER TABLE public.estrutcontinstrgestambareacontam
  ADD COLUMN idpassivo INTEGER;

-- Adicionar constraint da tabela estrutcontinstrgestambareacontam com a tabela passivoambiental
ALTER TABLE public.estrutcontinstrgestambareacontam
  ADD CONSTRAINT fk_estrutcontinstrgestambareacontam_passivoambiental FOREIGN KEY (idpassivo)
REFERENCES public.passivoambiental (idpassivo) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION;