-- RENOMEAR TABELAS
ALTER TABLE public.areacontam
  RENAME TO xxx_areacontam;
ALTER TABLE public.aterro_sanitario
  RENAME TO xxx_aterro_sanitario;
ALTER TABLE public.caractativpotimpactantesisttransp
  RENAME TO xxx_caractativpotimpactantesisttransp;
ALTER TABLE public.caractprodutoquimmaisfrequente
  RENAME TO xxx_caractprodutoquimmaisfrequente;
ALTER TABLE public.carcinicultura
  RENAME TO xxx_carcinicultura;
ALTER TABLE public.cips
  RENAME TO xxx_cips;
ALTER TABLE public.eixoviaprincipal
  RENAME TO xxx_eixoviaprincipal;
ALTER TABLE public.equipamento
  RENAME TO xxx_equipamento;
ALTER TABLE public.estrada
  RENAME TO xxx_estrada;
ALTER TABLE public.estrutcontinstrgestambsisttransp
  RENAME TO xxx_estrutcontinstrgestambsisttransp;
ALTER TABLE public.ficharesiduo
  RENAME TO xxx_ficharesiduo;
ALTER TABLE public.h_hidrografia
  RENAME TO xxx_h_hidrografia;
ALTER TABLE public.h_mancha_urbana
  RENAME TO xxx_h_mancha_urbana;
ALTER TABLE public.h_vegetacao_natural
  RENAME TO xxx_h_vegetacao_natural;
ALTER TABLE public.hidrografia
  RENAME TO xxx_hidrografia;
ALTER TABLE public.leito
  RENAME TO xxx_leito;
ALTER TABLE public.meioimpactado_passamb
  RENAME TO xxx_meioimpactado_passamb;
ALTER TABLE public.outrasareas
  RENAME TO xxx_outrasareas;
ALTER TABLE public.outrospontos
  RENAME TO xxx_outrospontos;
ALTER TABLE public.pessoal
  RENAME TO xxx_pessoal;
ALTER TABLE public.planimetria
  RENAME TO xxx_planimetria;
ALTER TABLE public.pointcloud_formats
  RENAME TO xxx_pointcloud_formats;
ALTER TABLE public.porto_suape
  RENAME TO xxx_porto_suape;
ALTER TABLE public.regiaometropolitanarecife
  RENAME TO xxx_regiaometropolitanarecife;
ALTER TABLE public.relato
  RENAME TO xxx_relato;
ALTER TABLE public.residuopasamb
  RENAME TO xxx_residuopasamb;
ALTER TABLE public.residuosolidoempresa
  RENAME TO xxx_residuosolidoempresa;
ALTER TABLE public.residuosolidoemptransp
  RENAME TO xxx_residuosolidoemptransp;
ALTER TABLE public.residuosolidosisttransp
  RENAME TO xxx_residuosolidosisttransp;
ALTER TABLE public.rodovia
  RENAME TO xxx_rodovia;
ALTER TABLE public.setorcensitario
  RENAME TO xxx_setorcensitario;
ALTER TABLE public.siliasubtipologia_classe
  RENAME TO xxx_siliasubtipologia_classe;
ALTER TABLE public.siliasubtipologia_divisao
  RENAME TO xxx_siliasubtipologia_divisao;
ALTER TABLE public.sistematransporte
  RENAME TO xxx_sistematransporte;
ALTER TABLE public.t_hidrografia
  RENAME TO xxx_t_hidrografia;
ALTER TABLE public.t_rodovia
  RENAME TO xxx_t_rodovia;
ALTER TABLE public.veiculo
  RENAME TO xxx_veiculo;

-- CRIAR NOVOS CAMPOS
ALTER TABLE public.areacontampassivoambiental
  ADD COLUMN municipio_id SMALLINT;

ALTER TABLE public.caractprodresquimenvolvido
  ADD COLUMN refprodutoperigoso_id INTEGER;
COMMENT ON COLUMN public.caractprodresquimenvolvido.refprodutoperigoso_id IS 'numonu';

ALTER TABLE public.caractprodresquimenvolvido
  ADD COLUMN refresiduo_id INTEGER;
COMMENT ON COLUMN public.caractprodresquimenvolvido.refresiduo_id IS 'codresiduo';

ALTER TABLE public.caractprodutoquimico
  ADD COLUMN refprodutoperigoso_id INTEGER;
COMMENT ON COLUMN public.caractprodutoquimico.refprodutoperigoso_id IS 'numonu';

ALTER TABLE public.caractprodutoquimtransportado
  ADD COLUMN refprodutoperigoso_id INTEGER;
COMMENT ON COLUMN public.caractprodutoquimtransportado.refprodutoperigoso_id IS 'numonu';

ALTER TABLE public.empresa
  ADD COLUMN municipio_id SMALLINT;

ALTER TABLE public.empresatransporte
  ADD COLUMN municipio_id SMALLINT;

ALTER TABLE public.historicoocoracidente
  ADD COLUMN municipio_id SMALLINT;

ALTER TABLE public.municipio2007ibge1000k
  ADD COLUMN uf_id SMALLINT;

ALTER TABLE public.passivoambiental
  ADD COLUMN municipio_id SMALLINT;

ALTER TABLE public.produtoquimareacontaminada
  ADD COLUMN refprodutoperigoso_id INTEGER;
COMMENT ON COLUMN public.produtoquimareacontaminada.refprodutoperigoso_id IS 'numonu';

ALTER TABLE public.residuoareacontampasamb
  ADD COLUMN refresiduo_id INTEGER;
COMMENT ON COLUMN public.residuoareacontampasamb.refresiduo_id IS 'codresiduo';

ALTER TABLE public.sitiofragilvulneravel
  ADD COLUMN municipio_id SMALLINT;

ALTER TABLE public.unidaderespacidente
  ADD COLUMN municipio_id SMALLINT;

-- APAGAR CONSTRAINTS
ALTER TABLE public.areacontampassivoambiental
  DROP CONSTRAINT fk_areacontampassivoambiental_municipio2007ibge1000k;

ALTER TABLE public.areacontampassivoambiental
  DROP CONSTRAINT fk_areacontampassivoambiental_unidadefederativa;

ALTER TABLE public.caractprodresquimenvolvido
  DROP CONSTRAINT fk_codresiduocarprodresquimrefresiduo;

ALTER TABLE public.caractprodresquimenvolvido
  DROP CONSTRAINT fk_numonucarprodresquimrefprodutoperigoso;

ALTER TABLE public.caractprodutoquimico
  DROP CONSTRAINT fk_numonucarprodquim_refprodutoperigoso;

ALTER TABLE public.caractprodutoquimtransportado
  DROP CONSTRAINT fk_caractprodutoquimtransportado_refprodutoperigoso;

ALTER TABLE public.empresa
  DROP CONSTRAINT fk_empresa_municipio2007ibge1000k;

ALTER TABLE public.empresa
  DROP CONSTRAINT fk_empresa_unidadefederativa;

ALTER TABLE public.empresatransporte
  DROP CONSTRAINT fk_empresatransporte_unidadefederativa;

ALTER TABLE public.historicoocoracidente
  DROP CONSTRAINT fk_historicoocoracidente_municipio2007ibge1000k;

ALTER TABLE public.historicoocoracidente
  DROP CONSTRAINT fk_historicoocoracidente_unidadefederativa;

ALTER TABLE public.passivoambiental
  DROP CONSTRAINT fk_passivoambiental_municipio2007ibge1000k;

ALTER TABLE public.passivoambiental
  DROP CONSTRAINT fk_passivoambiental_unidadefederativa;

ALTER TABLE public.produtoquimareacontaminada
  DROP CONSTRAINT fk_numonuprodquimareacont_refprodutoperigoso;

ALTER TABLE public.residuoareacontampasamb
  DROP CONSTRAINT fk_codresiduorefresiduo;

ALTER TABLE public.sitiofragilvulneravel
  DROP CONSTRAINT fk_sitiofragilvulneravel_unidadefederativa;

ALTER TABLE public.unidaderespacidente
  DROP CONSTRAINT fk_unidaderespacidente_municipio2007ibge1000k;

ALTER TABLE public.unidaderespacidente
  DROP CONSTRAINT fk_unidaderespacidente_unidadefederativa;

-- CRIAR NOVAS CONSTRAINTS
ALTER TABLE public.areacontampassivoambiental
  ADD CONSTRAINT fk_areacontampassivoambiental_municipio2007ibge1000k FOREIGN KEY (municipio_id)
REFERENCES public.municipio2007ibge1000k (idmunicipio) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE public.assentamentohumano
  ADD CONSTRAINT fk_assentamentohumano_sitiofragilvulner FOREIGN KEY (idsitio)
REFERENCES public.sitiofragilvulneravel (idsitio) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE public.caractprodresquimenvolvido
  ADD CONSTRAINT fk_caractprodresquimenvolvido_refprodutoperigoso FOREIGN KEY (refprodutoperigoso_id)
REFERENCES public.refprodutoperigoso (idrefprodperigoso) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE public.caractprodresquimenvolvido
  ADD CONSTRAINT fk_caractprodresquimenvolvido_refresiduo FOREIGN KEY (refresiduo_id)
REFERENCES public.refresiduo (idrefresiduo) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE public.caractprodutoquimico
  ADD CONSTRAINT fk_caractprodutoquimico_refprodutoperigoso FOREIGN KEY (refprodutoperigoso_id)
REFERENCES public.refprodutoperigoso (idrefprodperigoso) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE public.caractprodutoquimtransportado
  ADD CONSTRAINT fk_caractprodutoquimtransportado_refprodutoperigoso FOREIGN KEY (refprodutoperigoso_id)
REFERENCES public.refprodutoperigoso (idrefprodperigoso) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE public.empresa
  ADD CONSTRAINT fk_empresa_municipio2007ibge1000k FOREIGN KEY (municipio_id)
REFERENCES public.municipio2007ibge1000k (idmunicipio) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE public.empresatransporte
  ADD CONSTRAINT fk_empresatransporte_municipio2007ibge1000k FOREIGN KEY (municipio_id)
REFERENCES public.municipio2007ibge1000k (idmunicipio) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE public.estrutcontinstrgestambareacontam
  ADD CONSTRAINT fk_estrutcontinstrgestambareacontam_areacontampassivoambiental FOREIGN KEY (idareacont)
REFERENCES public.areacontampassivoambiental (idareacont) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE public.historicoocoracidente
  ADD CONSTRAINT fk_historicoocoracidente_municipio2007ibge1000k FOREIGN KEY (municipio_id)
REFERENCES public.municipio2007ibge1000k (idmunicipio) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Apagar linhas inconsistentes:
DELETE FROM public.meioimpactado
WHERE idareacont NOT IN (SELECT idareacont
                         FROM areacontampassivoambiental);
ALTER TABLE public.meioimpactado
  ADD CONSTRAINT fk_meioimpactado_areacontampassivoambiental FOREIGN KEY (idareacont)
REFERENCES public.areacontampassivoambiental (idareacont) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE public.municipio2007ibge1000k
  ADD CONSTRAINT fk_municipio_uf FOREIGN KEY (uf_id)
REFERENCES public.unidadefederativa (iduf) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE public.passivoambiental
  ADD CONSTRAINT fk_passivoambiental_municipio2007ibge1000k FOREIGN KEY (municipio_id)
REFERENCES public.municipio2007ibge1000k (idmunicipio) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Apagar linhas inconsistentes:
DELETE FROM public.produtoquimareacontaminada
WHERE idareacont NOT IN (SELECT idareacont
                         FROM areacontampassivoambiental);
ALTER TABLE public.produtoquimareacontaminada
  ADD CONSTRAINT fk_produtoquimareacontaminada_areacontampassivoambiental FOREIGN KEY (idareacont)
REFERENCES public.areacontampassivoambiental (idareacont) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE public.produtoquimareacontaminada
  ADD CONSTRAINT fk_produtoquimareacontaminada_refprodutoperigoso FOREIGN KEY (refprodutoperigoso_id)
REFERENCES public.refprodutoperigoso (idrefprodperigoso) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Apagar linhas inconsistentes:
DELETE FROM public.residuoareacontampasamb
WHERE idareacont NOT IN (SELECT idareacont
                         FROM areacontampassivoambiental);
ALTER TABLE public.residuoareacontampasamb
  ADD CONSTRAINT fk_residuoareacontampasamb_areacontampassivoambiental FOREIGN KEY (idareacont)
REFERENCES public.areacontampassivoambiental (idareacont) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE public.residuoareacontampasamb
  ADD CONSTRAINT fk_residuoareacontampasamb_refresiduo FOREIGN KEY (refresiduo_id)
REFERENCES public.refresiduo (idrefresiduo) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE public.sitiofragilvulneravel
  ADD CONSTRAINT fk_sitiofragilvulneravel_municipio2007ibge1000k FOREIGN KEY (municipio_id)
REFERENCES public.municipio2007ibge1000k (idmunicipio) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE public.unidaderespacidente
  ADD CONSTRAINT fk_unidaderespacidente_municipio2007ibge1000k FOREIGN KEY (municipio_id)
REFERENCES public.municipio2007ibge1000k (idmunicipio) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION;

-- POPULAR NOVAS COLUNAS DE ACORDO COM OS VALORES EXISTENTES NAS COLUNAS QUE SERÃO REMOVIDAS
UPDATE public.areacontampassivoambiental
SET municipio_id = (SELECT idmunicipio
                    FROM municipio2007ibge1000k
                    WHERE municipio2007ibge1000k.nm_nng = areacontampassivoambiental.municipio);

UPDATE caractprodresquimenvolvido
SET refprodutoperigoso_id = (SELECT idrefprodperigoso
                             FROM refprodutoperigoso
                             WHERE caractprodresquimenvolvido.numonu = refprodutoperigoso.numonu);

UPDATE caractprodresquimenvolvido
SET refresiduo_id = (SELECT idrefresiduo
                     FROM refresiduo
                     WHERE caractprodresquimenvolvido.codresiduo = refresiduo.codresiduo);

UPDATE caractprodutoquimico
SET refprodutoperigoso_id = (SELECT idrefprodperigoso
                             FROM refprodutoperigoso
                             WHERE caractprodutoquimico.numonu = refprodutoperigoso.numonu);

UPDATE caractprodutoquimtransportado
SET refprodutoperigoso_id = (SELECT idrefprodperigoso
                             FROM refprodutoperigoso
                             WHERE caractprodutoquimtransportado.numonu = refprodutoperigoso.numonu);

UPDATE public.empresa
SET municipio_id = (SELECT idmunicipio
                    FROM municipio2007ibge1000k
                    WHERE municipio2007ibge1000k.nm_nng = empresa.municipio);

UPDATE public.empresatransporte
SET municipio_id = (SELECT idmunicipio
                    FROM municipio2007ibge1000k
                    WHERE municipio2007ibge1000k.nm_nng = empresatransporte.municipio);

UPDATE public.historicoocoracidente
SET municipio_id = (SELECT idmunicipio
                    FROM municipio2007ibge1000k
                    WHERE municipio2007ibge1000k.nm_nng = historicoocoracidente.municipio);

UPDATE municipio2007ibge1000k
SET uf_id = (SELECT iduf
             FROM unidadefederativa
             WHERE unidadefederativa.siglauf = municipio2007ibge1000k.siglauf);

UPDATE public.passivoambiental
SET municipio_id = (SELECT idmunicipio
                    FROM municipio2007ibge1000k
                    WHERE municipio2007ibge1000k.nm_nng = passivoambiental.municipio);

UPDATE produtoquimareacontaminada
SET refprodutoperigoso_id = (SELECT idrefprodperigoso
                             FROM refprodutoperigoso
                             WHERE produtoquimareacontaminada.numonu = refprodutoperigoso.numonu);

UPDATE residuoareacontampasamb
SET refresiduo_id = (SELECT idrefresiduo
                     FROM refresiduo
                     WHERE residuoareacontampasamb.codresiduo = refresiduo.codresiduo);


UPDATE sitiofragilvulneravel
SET municipio = 'CABO DE SANTO AGOSTINHO'
WHERE idsitio = 1;
UPDATE public.sitiofragilvulneravel
SET municipio_id = (SELECT idmunicipio
                    FROM municipio2007ibge1000k
                    WHERE municipio2007ibge1000k.nm_nng = sitiofragilvulneravel.municipio);

UPDATE public.unidaderespacidente
SET municipio_id = (SELECT idmunicipio
                    FROM municipio2007ibge1000k
                    WHERE municipio2007ibge1000k.nm_nng = unidaderespacidente.municipio);

-- DEFINIR OS NOVOS CAMPOS COMO NOT NULL
ALTER TABLE public.areacontampassivoambiental
  ALTER COLUMN municipio_id SET NOT NULL;
ALTER TABLE public.empresa
  ALTER COLUMN municipio_id SET NOT NULL;
ALTER TABLE public.empresatransporte
  ALTER COLUMN municipio_id SET NOT NULL;
ALTER TABLE public.historicoocoracidente
  ALTER COLUMN municipio_id SET NOT NULL;
ALTER TABLE public.municipio2007ibge1000k
  ALTER COLUMN uf_id SET NOT NULL;
ALTER TABLE public.passivoambiental
  ALTER COLUMN municipio_id SET NOT NULL;
ALTER TABLE public.unidaderespacidente
  ALTER COLUMN municipio_id SET NOT NULL;

-- ALTERAR TIPO DE DADOS
ALTER TABLE public.algapiocoracidhistacid
  ALTER COLUMN graurisco TYPE SMALLINT;

ALTER TABLE public.algdissolveareariscoamb
  ALTER COLUMN graurisco TYPE SMALLINT;

ALTER TABLE public.algsitiofragil
  ALTER COLUMN graurisco TYPE SMALLINT;

ALTER TABLE public.areacontampassivoambiental
  ALTER COLUMN graurisco TYPE SMALLINT;

ALTER TABLE public.areacontampassivoambiental
  ALTER COLUMN numero TYPE SMALLINT;

ALTER TABLE public.areariscoambiental
  ALTER COLUMN graurisco TYPE SMALLINT;

ALTER TABLE public.arealegalmenteprotegida
  ALTER COLUMN graurisco TYPE SMALLINT;

ALTER TABLE public.arearecargaaquifero
  ALTER COLUMN graurisco TYPE SMALLINT;

ALTER TABLE public.assentamentohumano
  ALTER COLUMN graurisco TYPE SMALLINT;

ALTER TABLE public.captacao
  ALTER COLUMN graurisco TYPE SMALLINT;

ALTER TABLE public.caractativpotimpactanteempresa
  ALTER COLUMN graurisco TYPE SMALLINT;

ALTER TABLE public.caractativpotimpactanteemptransp
  ALTER COLUMN graurisco TYPE SMALLINT;

ALTER TABLE public.empresa
  ALTER COLUMN numero TYPE SMALLINT;

ALTER TABLE public.empresatransporte
  ALTER COLUMN numero TYPE SMALLINT;

ALTER TABLE public.historicoocoracidente
  ALTER COLUMN graurisco TYPE SMALLINT;

ALTER TABLE public.passivoambiental
  ALTER COLUMN graurisco TYPE SMALLINT;

ALTER TABLE public.passivoambiental
  ALTER COLUMN numero TYPE SMALLINT;

ALTER TABLE public.rechidrrepresentativo
  ALTER COLUMN graurisco TYPE SMALLINT;

ALTER TABLE public.refprodutoperigoso
  ALTER COLUMN numficha TYPE SMALLINT;

ALTER TABLE public.refresiduo
  ALTER COLUMN numficha TYPE SMALLINT;

ALTER TABLE public.trechoeixoviaprincipal
  ALTER COLUMN graurisco TYPE SMALLINT;

ALTER TABLE public.unidaderespacidente
  ALTER COLUMN graurisco TYPE SMALLINT;

-- CRIAR ÍNDICES
-- Clusterizar o índice da tabela assentamentohumano
CLUSTER assentamentohumano USING assenthumano_gix;

CREATE INDEX algapiocoracidhistacid_graurisco_idx
  ON public.algapiocoracidhistacid
  USING BTREE
  (graurisco);

CREATE INDEX algsitiofragil_graurisco_idx
  ON public.algsitiofragil
  USING BTREE
  (graurisco);


CREATE INDEX areacontampassivoambiental_graurisco_idx
  ON public.areacontampassivoambiental
  USING BTREE
  (graurisco);

CREATE INDEX arealegalmenteprotegida_graurisco_idx
  ON public.arealegalmenteprotegida
  USING BTREE
  (graurisco);

CREATE INDEX arearecargaaquifero_graurisco_idx
  ON public.arearecargaaquifero
  USING BTREE
  (graurisco);

CREATE INDEX areacontampassivoambiental_municipio_id
  ON public.areacontampassivoambiental
  USING BTREE
  (municipio_id);

CREATE INDEX arealegalmenteprotegida_idsitio_idx
  ON public.arealegalmenteprotegida
  USING BTREE
  (idsitio);

CREATE INDEX arearecargaaquifero_idsitio_idx
  ON public.arearecargaaquifero
  USING BTREE
  (idsitio);

CREATE INDEX areariscoambiental_graurisco_idx
  ON public.areariscoambiental
  USING BTREE
  (graurisco);

CREATE INDEX assentamentohumano_idsitio_idx
  ON public.assentamentohumano
  USING BTREE
  (idsitio);

CREATE INDEX assentamentohumano_graurisco_idx
  ON public.assentamentohumano
  USING BTREE
  (graurisco);

CREATE INDEX captacao_idsitio_idx
  ON public.captacao
  USING BTREE
  (idsitio);

CREATE INDEX captacao_graurisco_idx
  ON public.captacao
  USING BTREE
  (graurisco);

CREATE INDEX caractativpotimpactanteempresa_idemp_idx
  ON public.caractativpotimpactanteempresa
  USING BTREE
  (idemp);

CREATE INDEX caractativpotimpactanteempresa_graurisco_idx
  ON public.caractativpotimpactanteempresa
  USING BTREE
  (graurisco);

CREATE INDEX caractativpotimpactanteemptransp_idemptransp_idx
  ON public.caractativpotimpactanteemptransp
  USING BTREE
  (idemptransp);

CREATE INDEX caractativpotimpactanteemptransp_graurisco_idx
  ON public.caractativpotimpactanteemptransp
  USING BTREE
  (graurisco);

CREATE INDEX fk_caractprodresquimenvolvido_idocorrencia_idx
  ON public.caractprodresquimenvolvido
  USING BTREE
  (idocorrencia);

CREATE INDEX caractprodutoquimico_refprodutoperigoso_id
  ON public.caractprodutoquimico
  USING BTREE
  (refprodutoperigoso_id);

CREATE INDEX caractprodutoquimico_idativ
  ON public.caractprodutoquimico
  USING BTREE
  (idativ);

CREATE INDEX caractprodutoquimtransportado_refprodutoperigoso_id
  ON public.caractprodutoquimtransportado
  USING BTREE
  (refprodutoperigoso_id);

CREATE INDEX caractprodutoquimtransportado_idativ
  ON public.caractprodutoquimtransportado
  USING BTREE
  (idativ);

CREATE INDEX contaminacaoambiental_idocorrencia
  ON public.contaminacaoambiental
  USING BTREE
  (idocorrencia);

CREATE INDEX empresa_municipio_id
  ON public.empresa
  USING BTREE
  (municipio_id);

CREATE INDEX empresatransporte_municipio_id
  ON public.empresatransporte
  USING BTREE
  (municipio_id);

CREATE INDEX estrutcontinstrgestambareacontam_idareacont
  ON public.estrutcontinstrgestambareacontam
  USING BTREE
  (idareacont);

CREATE INDEX estrutcontinstrgestambareacontam_idpassivo
  ON public.estrutcontinstrgestambareacontam
  USING BTREE
  (idpassivo);

CREATE INDEX estrutcontinstrgestambempresa_idemp
  ON public.estrutcontinstrgestambempresa
  USING BTREE
  (idemp);

CREATE INDEX estrutcontinstrgestambemptransp_idemptransp
  ON public.estrutcontinstrgestambemptransp
  USING BTREE
  (idemptransp);

CREATE INDEX historicoocoracidente_graurisco
  ON public.historicoocoracidente
  USING BTREE
  (graurisco);

CREATE INDEX historicoocoracidente_municipio_id
  ON public.historicoocoracidente
  USING BTREE
  (municipio_id);

CREATE INDEX meioimpactado_idareacont
  ON public.meioimpactado
  USING BTREE
  (idareacont);

CREATE INDEX meioimpactado_idpassivo
  ON public.meioimpactado
  USING BTREE
  (idpassivo);

CREATE INDEX fk_municipio2007ibge1000k_uf_id_idx
  ON public.municipio2007ibge1000k
  USING BTREE
  (uf_id);

CREATE INDEX passivoambiental_graurisco
  ON public.passivoambiental
  USING BTREE
  (graurisco);

CREATE INDEX passivoambiental_municipio_id
  ON public.passivoambiental
  USING BTREE
  (municipio_id);

CREATE INDEX produtoquimareacontaminada_idareacont
  ON public.produtoquimareacontaminada
  USING BTREE
  (idareacont);

CREATE INDEX produtoquimareacontaminada_idpassivo
  ON public.produtoquimareacontaminada
  USING BTREE
  (idpassivo);

CREATE INDEX produtoquimareacontaminada_refprodutoperigoso_id
  ON public.produtoquimareacontaminada
  USING BTREE
  (refprodutoperigoso_id);

CREATE INDEX rechidrrepresentativo_idsitio
  ON public.rechidrrepresentativo
  USING BTREE
  (idsitio);

CREATE INDEX rechidrrepresentativo_graurisco
  ON public.rechidrrepresentativo
  USING BTREE
  (graurisco);

CREATE INDEX refprodutoperigoso_numonu
  ON public.refprodutoperigoso
  USING BTREE
  (numonu);

CREATE INDEX refprodutoperigoso_numficha
  ON public.refprodutoperigoso
  USING BTREE
  (numficha);

CREATE INDEX refresiduo_codresiduo
  ON public.refresiduo
  USING BTREE
  (codresiduo);

CREATE INDEX refresiduo_numficha
  ON public.refresiduo
  USING BTREE
  (numficha);

CREATE INDEX trechoeixoviaprincipal_graurisco_idx
  ON public.trechoeixoviaprincipal
  USING BTREE
  (graurisco);

CREATE INDEX residuoareacontampasamb_idareacont_idx
  ON public.residuoareacontampasamb
  USING BTREE
  (idareacont);

CREATE INDEX residuoareacontampasamb_idpassivo_idx
  ON public.residuoareacontampasamb
  USING BTREE
  (idpassivo);

CREATE INDEX residuoareacontampasamb_refresiduo_id_idx
  ON public.residuoareacontampasamb
  USING BTREE
  (refresiduo_id);

CREATE INDEX sitiofragilvulneravel_municipio_id_idx
  ON public.sitiofragilvulneravel
  USING BTREE
  (municipio_id);

CREATE INDEX unidaderespacidente_municipio_id_idx
  ON public.unidaderespacidente
  USING BTREE
  (municipio_id);

-- REMOVER ÍNDICES duplicados  
DROP INDEX public.captacao_sidx;

-- APAGAR COLUNAS (OBS: Só devemos apagar os campos abaixo após o UPDATE acima)
ALTER TABLE public.areacontampassivoambiental
  DROP COLUMN siglauf;
ALTER TABLE public.areacontampassivoambiental
  DROP COLUMN municipio;
ALTER TABLE public.caractprodresquimenvolvido
  DROP COLUMN numonu;
ALTER TABLE public.caractprodresquimenvolvido
  DROP COLUMN codresiduo;
ALTER TABLE public.caractprodutoquimico
  DROP COLUMN numonu;
ALTER TABLE public.caractprodutoquimtransportado
  DROP COLUMN numonu;
ALTER TABLE public.empresa
  DROP COLUMN siglauf;
ALTER TABLE public.empresa
  DROP COLUMN municipio;
ALTER TABLE public.empresatransporte
  DROP COLUMN siglauf;
ALTER TABLE public.empresatransporte
  DROP COLUMN municipio;
ALTER TABLE public.historicoocoracidente
  DROP COLUMN siglauf;
ALTER TABLE public.historicoocoracidente
  DROP COLUMN municipio;
ALTER TABLE public.municipio2007ibge1000k
  DROP COLUMN siglauf;
ALTER TABLE public.passivoambiental
  DROP COLUMN siglauf;
ALTER TABLE public.passivoambiental
  DROP COLUMN municipio;
ALTER TABLE public.produtoquimareacontaminada
  DROP COLUMN numonu;
ALTER TABLE public.residuoareacontampasamb
  DROP COLUMN codresiduo;
ALTER TABLE public.sitiofragilvulneravel
  DROP COLUMN siglauf;
ALTER TABLE public.sitiofragilvulneravel
  DROP COLUMN municipio;
ALTER TABLE public.unidaderespacidente
  DROP COLUMN siglauf;
ALTER TABLE public.unidaderespacidente
  DROP COLUMN municipio;
