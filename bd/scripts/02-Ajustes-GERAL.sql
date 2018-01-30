/*
CAMPOS REMOVIDOS: 21
CAMPOS CRIADOS: 14
FK REMOVIDAS: 18
FK CRIADAS: 19
ÍNDICES CRIADOS: 51
ÍNDICES REMOVIDOS: 1
*/


-- RENOMEAR TABELAS
ALTER TABLE public.areacontam RENAME TO xxx_areacontam;
ALTER TABLE public.aterro_sanitario RENAME TO xxx_aterro_sanitario;
ALTER TABLE public.caractativpotimpactantesisttransp RENAME TO xxx_caractativpotimpactantesisttransp;
ALTER TABLE public.caractprodutoquimmaisfrequente RENAME TO xxx_caractprodutoquimmaisfrequente;
ALTER TABLE public.carcinicultura RENAME TO xxx_carcinicultura;
ALTER TABLE public.cips RENAME TO xxx_cips;
ALTER TABLE public.eixoviaprincipal RENAME TO xxx_eixoviaprincipal;
ALTER TABLE public.equipamento RENAME TO xxx_equipamento;
ALTER TABLE public.estrada RENAME TO xxx_estrada;
ALTER TABLE public.estrutcontinstrgestambsisttransp RENAME TO xxx_estrutcontinstrgestambsisttransp;
ALTER TABLE public.h_hidrografia RENAME TO xxx_h_hidrografia;
ALTER TABLE public.h_mancha_urbana RENAME TO xxx_h_mancha_urbana;
ALTER TABLE public.h_vegetacao_natural RENAME TO xxx_h_vegetacao_natural;
ALTER TABLE public.hidrografia RENAME TO xxx_hidrografia;
ALTER TABLE public.leito RENAME TO xxx_leito;
ALTER TABLE public.meioimpactado_passamb RENAME TO xxx_meioimpactado_passamb;
ALTER TABLE public.outrasareas RENAME TO xxx_outrasareas;
ALTER TABLE public.outrospontos RENAME TO xxx_outrospontos;
ALTER TABLE public.pessoal RENAME TO xxx_pessoal;
ALTER TABLE public.planimetria RENAME TO xxx_planimetria;
ALTER TABLE public.pointcloud_formats RENAME TO xxx_pointcloud_formats;
ALTER TABLE public.porto_suape RENAME TO xxx_porto_suape;
ALTER TABLE public.regiaometropolitanarecife RENAME TO xxx_regiaometropolitanarecife;
ALTER TABLE public.relato RENAME TO xxx_relato;
ALTER TABLE public.residuopasamb RENAME TO xxx_residuopasamb;
ALTER TABLE public.residuosolidoempresa RENAME TO xxx_residuosolidoempresa;
ALTER TABLE public.residuosolidoemptransp RENAME TO xxx_residuosolidoemptransp;
ALTER TABLE public.residuosolidosisttransp RENAME TO xxx_residuosolidosisttransp;
ALTER TABLE public.rodovia RENAME TO xxx_rodovia;
ALTER TABLE public.setorcensitario RENAME TO xxx_setorcensitario;
ALTER TABLE public.siliasubtipologia_classe RENAME TO xxx_siliasubtipologia_classe;
ALTER TABLE public.siliasubtipologia_divisao RENAME TO xxx_siliasubtipologia_divisao;
ALTER TABLE public.sistematransporte RENAME TO xxx_sistematransporte;
ALTER TABLE public.t_hidrografia RENAME TO xxx_t_hidrografia;
ALTER TABLE public.t_rodovia RENAME TO xxx_t_rodovia;
ALTER TABLE public.veiculo RENAME TO xxx_veiculo;




-- INSERIR COMENTÁRIOS NAS TABELAS/COLUNAS
COMMENT ON TABLE public.algapiocoracidhistacid IS 'ALGORITMO - Junção de todas as atividades potencialmente impactantes (Fontes Fixas e Móveis), Áreas Contaminadas e Históricos de Ocorrência de Acidentes, para gerar áreas de risco ambiental';
COMMENT ON TABLE public.algdissolveareariscoamb IS 'ALGORITMO - Cruzamento das atividades potencialmente impactantes com os sítios frágeis para a identificação das áreas de risco ambiental';
COMMENT ON TABLE public.algsitiofragil IS 'ALGORITMO - Junção de todos os sítios frágeis e vulneráveis';
COMMENT ON TABLE public.areacontampassivoambiental IS 'Área Contaminada - Passivo Ambiental';
COMMENT ON TABLE public.arealegalmenteprotegida IS 'Área Legalmente Protegida';
COMMENT ON TABLE public.arearecargaaquifero IS 'Áreas de Recarga de Aquífero';
COMMENT ON TABLE public.areariscoambiental IS 'ALGORITMO - Agrega polígonos adjacentes com os mesmos graus de risco para gerar as áreas de risco ambiental';
COMMENT ON TABLE public.assentamentohumano IS 'Assentamento Humano';
COMMENT ON TABLE public.captacao IS 'Pontos de Captação de Água';
COMMENT ON TABLE public.caractativpotimpactanteempresa IS 'Caracterização da Atividade Potencialmente Impactante - Empresa';
COMMENT ON TABLE public.caractativpotimpactanteemptransp IS 'Caracterização da Atividade Potencialmente Impactante - Empresa Transporte';
COMMENT ON TABLE public.caractprodresquimenvolvido IS 'Caracterização do Produto ou Resíduo Químico Envolvido';
COMMENT ON TABLE public.caractprodutoquimico IS 'Caracterização Produtos Químicos';
COMMENT ON TABLE public.caractprodutoquimtransportado IS 'Caracterização Produtos Químicos Transportados';
COMMENT ON TABLE public.contaminacaoambiental IS 'Registro de Ocorrência de Contaminação Ambiental (solo, ar e água)';
COMMENT ON TABLE public.empresa IS 'Relação de Empresas Cadastradas';
COMMENT ON TABLE public.empresatransporte IS 'Relação de Empresas que fazem transporte de carga perigosa';
COMMENT ON TABLE public.estrutcontinstrgestambareacontam IS 'Estruturas de Contenção e Instrumentos de Gestão Ambiental - Área Contaminada';
COMMENT ON TABLE public.estrutcontinstrgestambempresa IS 'Estruturas de Contenção e Instrumentos de Gestão Ambiental - Empresa';
COMMENT ON TABLE public.estrutcontinstrgestambemptransp IS 'Estruturas de Contenção e Instrumentos de Gestão Ambiental - Empresa Transporte';
COMMENT ON TABLE public.fichaprodutoquimico IS 'Ficha Produto Químico';
COMMENT ON TABLE public.ficharesiduo IS 'Ficha Resíduo';
COMMENT ON TABLE public.historicoocoracidente IS 'Histórico de Ocorrências de Acidentes';
COMMENT ON TABLE public.meioimpactado IS 'Área Impactada';
COMMENT ON TABLE public.municipio2007ibge1000k IS 'Relação das Cidades Cadastradas';
COMMENT ON TABLE public.passivoambiental IS 'Passivo Ambiental';
COMMENT ON TABLE public.produtoquimareacontaminada IS 'Produto Químico - Área Contaminada';
COMMENT ON TABLE public.rechidrrepresentativo IS 'Recursos Hídricos Representativos';
COMMENT ON TABLE public.refprodutoperigoso IS 'Registro de Ocorrência com Produto Perigoso';
COMMENT ON TABLE public.refresiduo IS 'Classes de resíduo';
COMMENT ON TABLE public.residuoareacontampasamb IS 'Resíduo - Área Contaminada Passivo Ambiental';
COMMENT ON TABLE public.sitiofragilvulneravel IS 'Relação de Sítios Frágeis e Vulneráveis';
COMMENT ON TABLE public.trechoeixoviaprincipal IS 'Trecho Eixo Via Principal';
COMMENT ON TABLE public.unidadefederativa IS 'Relação dos Estados Cadastrados';
COMMENT ON TABLE public.unidaderespacidente IS 'Unidades de Resposta a Acidentes';



-- APENAS RENOMEAR COLUNAS
ALTER TABLE public.refprodutoperigoso RENAME numficha TO fichaprodutoquimico_id;
COMMENT ON COLUMN public.refprodutoperigoso.fichaprodutoquimico_id IS 'numficha';

ALTER TABLE public.refresiduo RENAME numficha TO ficharesiduo_id;
COMMENT ON COLUMN public.refresiduo.fichaprodutoquimico_id IS 'numficha';

  
  
   
-- CRIAR NOVOS CAMPOS
ALTER TABLE public.areacontampassivoambiental ADD COLUMN municipio_id smallint;

ALTER TABLE public.caractprodresquimenvolvido ADD COLUMN refprodutoperigoso_id integer;
COMMENT ON COLUMN public.caractprodresquimenvolvido.refprodutoperigoso_id IS 'numonu';

ALTER TABLE public.caractprodresquimenvolvido ADD COLUMN refresiduo_id integer;
COMMENT ON COLUMN public.caractprodresquimenvolvido.refresiduo_id IS 'codresiduo';

ALTER TABLE public.caractprodutoquimico ADD COLUMN refprodutoperigoso_id integer;
COMMENT ON COLUMN public.caractprodutoquimico.refprodutoperigoso_id IS 'numonu';

ALTER TABLE public.caractprodutoquimtransportado ADD COLUMN refprodutoperigoso_id integer;
COMMENT ON COLUMN public.caractprodutoquimtransportado.refprodutoperigoso_id IS 'numonu';

ALTER TABLE public.empresa ADD COLUMN municipio_id smallint;

ALTER TABLE public.empresatransporte ADD COLUMN municipio_id smallint;

ALTER TABLE public.historicoocoracidente ADD COLUMN municipio_id smallint;

ALTER TABLE public.municipio2007ibge1000k ADD COLUMN uf_id smallint;

ALTER TABLE public.passivoambiental ADD COLUMN municipio_id smallint;

ALTER TABLE public.produtoquimareacontaminada ADD COLUMN refprodutoperigoso_id integer;
COMMENT ON COLUMN public.produtoquimareacontaminada.refprodutoperigoso_id IS 'numonu';

ALTER TABLE public.residuoareacontampasamb ADD COLUMN refresiduo_id integer;
COMMENT ON COLUMN public.residuoareacontampasamb.refresiduo_id IS 'codresiduo';

ALTER TABLE public.sitiofragilvulneravel ADD COLUMN municipio_id smallint;

ALTER TABLE public.unidaderespacidente ADD COLUMN municipio_id smallint;





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
DELETE FROM public.meioimpactado WHERE idareacont NOT IN (SELECT idareacont FROM areacontampassivoambiental);  
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
DELETE FROM public.produtoquimareacontaminada WHERE idareacont NOT IN (SELECT idareacont FROM areacontampassivoambiental);  
ALTER TABLE public.produtoquimareacontaminada
  ADD CONSTRAINT fk_produtoquimareacontaminada_areacontampassivoambiental FOREIGN KEY (idareacont)
      REFERENCES public.areacontampassivoambiental (idareacont) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE public.produtoquimareacontaminada
  ADD CONSTRAINT fk_produtoquimareacontaminada_refprodutoperigoso FOREIGN KEY (refprodutoperigoso_id)
      REFERENCES public.refprodutoperigoso (idrefprodperigoso) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
	  
-- Apagar linhas inconsistentes:
DELETE FROM public.residuoareacontampasamb WHERE idareacont NOT IN (SELECT idareacont FROM areacontampassivoambiental);
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


UPDATE sitiofragilvulneravel SET municipio = 'CABO DE SANTO AGOSTINHO' WHERE idsitio = 1;
UPDATE public.sitiofragilvulneravel
   SET municipio_id = (SELECT idmunicipio
		       FROM municipio2007ibge1000k
		       WHERE municipio2007ibge1000k.nm_nng = sitiofragilvulneravel.municipio);
			   
UPDATE public.unidaderespacidente
   SET municipio_id = (SELECT idmunicipio
		       FROM municipio2007ibge1000k
		       WHERE municipio2007ibge1000k.nm_nng = unidaderespacidente.municipio);			   


			   

			   
-- DEFINIR OS NOVOS CAMPOS COMO NOT NULL
ALTER TABLE public.areacontampassivoambiental ALTER COLUMN municipio_id SET NOT NULL;
ALTER TABLE public.empresa ALTER COLUMN municipio_id SET NOT NULL;
ALTER TABLE public.empresatransporte ALTER COLUMN municipio_id SET NOT NULL;
ALTER TABLE public.historicoocoracidente ALTER COLUMN municipio_id SET NOT NULL;
ALTER TABLE public.municipio2007ibge1000k ALTER COLUMN uf_id SET NOT NULL;
ALTER TABLE public.municipio2007ibge1000k ALTER COLUMN nm_nng SET NOT NULL;
ALTER TABLE public.passivoambiental ALTER COLUMN municipio_id SET NOT NULL;
ALTER TABLE public.refprodutoperigoso ALTER COLUMN numonu SET NOT NULL;
ALTER TABLE public.refresiduo ALTER COLUMN codresiduo SET NOT NULL;
ALTER TABLE public.unidadefederativa ALTER COLUMN siglauf SET NOT NULL;
ALTER TABLE public.unidaderespacidente ALTER COLUMN municipio_id SET NOT NULL;




	  
	  
-- ALTERAR TIPO DE DADOS
ALTER TABLE public.algapiocoracidhistacid
   ALTER COLUMN graurisco TYPE smallint;
   
ALTER TABLE public.algdissolveareariscoamb
   ALTER COLUMN graurisco TYPE smallint;

ALTER TABLE public.algsitiofragil
   ALTER COLUMN graurisco TYPE smallint;

ALTER TABLE public.areacontampassivoambiental
   ALTER COLUMN graurisco TYPE smallint;

ALTER TABLE public.areacontampassivoambiental
   ALTER COLUMN numero TYPE smallint;
   
ALTER TABLE public.areariscoambiental
   ALTER COLUMN graurisco TYPE smallint;

ALTER TABLE public.arealegalmenteprotegida
   ALTER COLUMN graurisco TYPE smallint;   

ALTER TABLE public.arearecargaaquifero
   ALTER COLUMN graurisco TYPE smallint;

ALTER TABLE public.assentamentohumano
   ALTER COLUMN graurisco TYPE smallint;  

ALTER TABLE public.captacao
   ALTER COLUMN graurisco TYPE smallint;

ALTER TABLE public.caractativpotimpactanteempresa
   ALTER COLUMN graurisco TYPE smallint;
  
ALTER TABLE public.caractativpotimpactanteemptransp
   ALTER COLUMN graurisco TYPE smallint;   

ALTER TABLE public.empresa
   ALTER COLUMN numero TYPE smallint;
   
ALTER TABLE public.empresatransporte
   ALTER COLUMN numero TYPE smallint;  

ALTER TABLE public.historicoocoracidente
   ALTER COLUMN graurisco TYPE smallint;   

ALTER TABLE public.passivoambiental
   ALTER COLUMN graurisco TYPE smallint;

ALTER TABLE public.passivoambiental
   ALTER COLUMN numero TYPE smallint;  
   
ALTER TABLE public.rechidrrepresentativo
   ALTER COLUMN graurisco TYPE smallint;
   
ALTER TABLE public.trechoeixoviaprincipal
   ALTER COLUMN graurisco TYPE smallint;
   
ALTER TABLE public.unidaderespacidente
   ALTER COLUMN graurisco TYPE smallint;

   
	  
	  

	  
-- CRIAR ÍNDICES
-- Clusterizar o índice da tabela assentamentohumano
CLUSTER assentamentohumano USING assenthumano_gix;

CREATE INDEX algapiocoracidhistacid_graurisco_idx
  ON public.algapiocoracidhistacid
  USING btree
  (graurisco);
  
CREATE INDEX algsitiofragil_graurisco_idx
  ON public.algsitiofragil
  USING btree
  (graurisco);
  
  
CREATE INDEX areacontampassivoambiental_graurisco_idx
  ON public.areacontampassivoambiental
  USING btree
  (graurisco);
  
CREATE INDEX arealegalmenteprotegida_graurisco_idx
  ON public.arealegalmenteprotegida
  USING btree
  (graurisco);
  
CREATE INDEX arearecargaaquifero_graurisco_idx
  ON public.arearecargaaquifero
  USING btree
  (graurisco);
  
CREATE INDEX areacontampassivoambiental_municipio_id
  ON public.areacontampassivoambiental
  USING btree
  (municipio_id);
  
CREATE INDEX arealegalmenteprotegida_idsitio_idx
  ON public.arealegalmenteprotegida
  USING btree
  (idsitio);
  
CREATE INDEX arearecargaaquifero_idsitio_idx
  ON public.arearecargaaquifero
  USING btree
  (idsitio);

CREATE INDEX areariscoambiental_graurisco_idx
  ON public.areariscoambiental
  USING btree
  (graurisco);
  
CREATE INDEX assentamentohumano_idsitio_idx
  ON public.assentamentohumano
  USING btree
  (idsitio);   

CREATE INDEX assentamentohumano_graurisco_idx
  ON public.assentamentohumano
  USING btree
  (graurisco);
  
CREATE INDEX captacao_idsitio_idx
  ON public.captacao
  USING btree
  (idsitio);    
  
CREATE INDEX captacao_graurisco_idx
  ON public.captacao
  USING btree
  (graurisco);

CREATE INDEX caractativpotimpactanteempresa_idemp_idx
  ON public.caractativpotimpactanteempresa
  USING btree
  (idemp);
  
CREATE INDEX caractativpotimpactanteempresa_graurisco_idx
  ON public.caractativpotimpactanteempresa
  USING btree
  (graurisco); 

CREATE INDEX caractativpotimpactanteemptransp_idemptransp_idx
  ON public.caractativpotimpactanteemptransp
  USING btree
  (idemptransp);  
  
CREATE INDEX caractativpotimpactanteemptransp_graurisco_idx
  ON public.caractativpotimpactanteemptransp
  USING btree
  (graurisco);
  
CREATE INDEX fk_caractprodresquimenvolvido_idocorrencia_idx
  ON public.caractprodresquimenvolvido
  USING btree
  (idocorrencia);  

CREATE INDEX caractprodutoquimico_refprodutoperigoso_id
  ON public.caractprodutoquimico
  USING btree
  (refprodutoperigoso_id);

CREATE INDEX caractprodutoquimico_idativ
  ON public.caractprodutoquimico
  USING btree
  (idativ); 

CREATE INDEX caractprodutoquimtransportado_refprodutoperigoso_id
  ON public.caractprodutoquimtransportado
  USING btree
  (refprodutoperigoso_id);

CREATE INDEX caractprodutoquimtransportado_idativ
  ON public.caractprodutoquimtransportado
  USING btree
  (idativ);
  
CREATE INDEX contaminacaoambiental_idocorrencia
  ON public.contaminacaoambiental
  USING btree
  (idocorrencia);

CREATE INDEX empresa_municipio_id
  ON public.empresa
  USING btree
  (municipio_id);
  
CREATE INDEX empresatransporte_municipio_id
  ON public.empresatransporte
  USING btree
  (municipio_id);  
  
CREATE INDEX estrutcontinstrgestambareacontam_idareacont
  ON public.estrutcontinstrgestambareacontam
  USING btree
  (idareacont);
  
CREATE INDEX estrutcontinstrgestambareacontam_idpassivo
  ON public.estrutcontinstrgestambareacontam
  USING btree
  (idpassivo);  

CREATE INDEX estrutcontinstrgestambempresa_idemp
  ON public.estrutcontinstrgestambempresa
  USING btree
  (idemp); 

CREATE INDEX estrutcontinstrgestambemptransp_idemptransp
  ON public.estrutcontinstrgestambemptransp
  USING btree
  (idemptransp);
  
CREATE INDEX historicoocoracidente_graurisco
  ON public.historicoocoracidente
  USING btree
  (graurisco);
  
CREATE INDEX historicoocoracidente_municipio_id
  ON public.historicoocoracidente
  USING btree
  (municipio_id);
  
CREATE INDEX meioimpactado_idareacont
  ON public.meioimpactado
  USING btree
  (idareacont);
  
CREATE INDEX meioimpactado_idpassivo
  ON public.meioimpactado
  USING btree
  (idpassivo);
  
CREATE INDEX fk_municipio2007ibge1000k_uf_id_idx
  ON public.municipio2007ibge1000k
  USING btree
  (uf_id);    

CREATE INDEX passivoambiental_graurisco
  ON public.passivoambiental
  USING btree
  (graurisco);

CREATE INDEX passivoambiental_municipio_id
  ON public.passivoambiental
  USING btree
  (municipio_id);

CREATE INDEX produtoquimareacontaminada_idareacont
  ON public.produtoquimareacontaminada
  USING btree
  (idareacont);

CREATE INDEX produtoquimareacontaminada_idpassivo
  ON public.produtoquimareacontaminada
  USING btree
  (idpassivo);

CREATE INDEX produtoquimareacontaminada_refprodutoperigoso_id
  ON public.produtoquimareacontaminada
  USING btree
  (refprodutoperigoso_id);  

CREATE INDEX rechidrrepresentativo_idsitio
  ON public.rechidrrepresentativo
  USING btree
  (idsitio);

CREATE INDEX rechidrrepresentativo_graurisco
  ON public.rechidrrepresentativo
  USING btree
  (graurisco);
  
CREATE INDEX refprodutoperigoso_numonu
  ON public.refprodutoperigoso
  USING btree
  (numonu);
  
CREATE INDEX refprodutoperigoso_numficha
  ON public.refprodutoperigoso
  USING btree
  (numficha);

CREATE INDEX refresiduo_codresiduo
  ON public.refresiduo
  USING btree
  (codresiduo);
  
CREATE INDEX refresiduo_numficha
  ON public.refresiduo
  USING btree
  (numficha);

CREATE INDEX trechoeixoviaprincipal_graurisco_idx
  ON public.trechoeixoviaprincipal
  USING btree
  (graurisco);
  
CREATE INDEX residuoareacontampasamb_idareacont_idx
  ON public.residuoareacontampasamb
  USING btree
  (idareacont); 
  
CREATE INDEX residuoareacontampasamb_idpassivo_idx
  ON public.residuoareacontampasamb
  USING btree
  (idpassivo);  

CREATE INDEX residuoareacontampasamb_refresiduo_id_idx
  ON public.residuoareacontampasamb
  USING btree
  (refresiduo_id);
  
CREATE INDEX sitiofragilvulneravel_municipio_id_idx
  ON public.sitiofragilvulneravel
  USING btree
  (municipio_id);

CREATE INDEX unidaderespacidente_municipio_id_idx
  ON public.unidaderespacidente
  USING btree
  (municipio_id);
  

  
  
-- REMOVER ÍNDICES duplicados  
DROP INDEX public.captacao_sidx;

 
  
  


-- APAGAR COLUNAS (OBS: Só devemos apagar os campos abaixo após o UPDATE acima)
ALTER TABLE public.areacontampassivoambiental DROP COLUMN siglauf;
ALTER TABLE public.areacontampassivoambiental DROP COLUMN municipio;
ALTER TABLE public.caractprodresquimenvolvido DROP COLUMN numonu;
ALTER TABLE public.caractprodresquimenvolvido DROP COLUMN codresiduo;
ALTER TABLE public.caractprodutoquimico DROP COLUMN numonu; 
ALTER TABLE public.caractprodutoquimtransportado DROP COLUMN numonu;
ALTER TABLE public.empresa DROP COLUMN siglauf;
ALTER TABLE public.empresa DROP COLUMN municipio;
ALTER TABLE public.empresatransporte DROP COLUMN siglauf;
ALTER TABLE public.empresatransporte DROP COLUMN municipio;
ALTER TABLE public.historicoocoracidente DROP COLUMN siglauf;
ALTER TABLE public.historicoocoracidente DROP COLUMN municipio;
ALTER TABLE public.municipio2007ibge1000k DROP COLUMN siglauf;
ALTER TABLE public.passivoambiental DROP COLUMN siglauf;
ALTER TABLE public.passivoambiental DROP COLUMN municipio;
ALTER TABLE public.produtoquimareacontaminada DROP COLUMN numonu;
ALTER TABLE public.residuoareacontampasamb DROP COLUMN codresiduo;
ALTER TABLE public.sitiofragilvulneravel DROP COLUMN siglauf;
ALTER TABLE public.sitiofragilvulneravel DROP COLUMN municipio;
ALTER TABLE public.unidaderespacidente DROP COLUMN siglauf;
ALTER TABLE public.unidaderespacidente DROP COLUMN municipio;