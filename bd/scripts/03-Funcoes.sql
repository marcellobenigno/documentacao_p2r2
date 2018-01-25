-- DETERMINA GRAUS DE RISCO EM HISTÓRICO DE ACIDENTES AMBIENTAIS
-- Function: public.algp2r2histocoracid()

-- DROP FUNCTION public.algp2r2histocoracid();

CREATE OR REPLACE FUNCTION public.algp2r2histocoracid()
  RETURNS VOID AS
$BODY$

DECLARE
  contador      INT;
  registro      RECORD;
  vargraurisco1 INT;
  vargraurisco2 INT;
  vargraurisco3 INT;
  vargraurisco4 INT;
  varregistro1  VARCHAR;
  soma          INT;

BEGIN

  FOR registro IN SELECT *
                  FROM public.historicoocoracidente
                  ORDER BY idocorrencia LOOP
    soma = 0;
    -- Classifica grau de risco para registro de ocorrência com produto perigoso
    SELECT INTO contador count(*)
    FROM historicoocoracidente
      INNER JOIN public.caractprodresquimenvolvido
        ON (historicoocoracidente.idocorrencia = caractprodresquimenvolvido.idocorrencia)
      --INNER JOIN public.refprodutoperigoso ON (caractprodresquimenvolvido.numonu = refprodutoperigoso.numonu)
      INNER JOIN public.refprodutoperigoso
        ON (caractprodresquimenvolvido.refprodutoperigoso_id = refprodutoperigoso.idrefprodperigoso)
    WHERE historicoocoracidente.idocorrencia = registro.idocorrencia AND refprodutoperigoso.classerisco IS NOT NULL AND
          refprodutoperigoso.classerisco NOT LIKE '%2.2%';

    IF contador > 0
    THEN
      vargraurisco1 = 1;
    ELSE
      vargraurisco1 = 0;
    END IF;

    -- Classifica grau de risco para registro de derrame de produto perigoso
    SELECT INTO varregistro1 registro.tipologia;
    IF varregistro1 LIKE '%com derramamento%'
    THEN
      vargraurisco2 = 2;
    ELSIF varregistro1 LIKE '%sem derramamento%'
      THEN
        vargraurisco2 = 0;
    ELSE
      vargraurisco2 = 0;
    END IF;

    -- Classifica grau de risco para registro de contaminação (solo, ar e água)
    SELECT INTO contador count(*)
    FROM historicoocoracidente
      INNER JOIN public.contaminacaoambiental
        ON (historicoocoracidente.idocorrencia = contaminacaoambiental.idocorrencia)
    WHERE historicoocoracidente.idocorrencia = registro.idocorrencia AND contaminacaoambiental.tipo IS NOT NULL
          AND (UPPER(contaminacaoambiental.tipo) LIKE '%AR%' OR UPPER(contaminacaoambiental.tipo) LIKE '%ÁGUA%' OR
               UPPER(contaminacaoambiental.tipo) LIKE '%SOLO%');

    IF contador > 0
    THEN
      vargraurisco3 = 3;
    ELSE
      vargraurisco3 = 0;
    END IF;

    -- Classifica grau de risco para ocorrência com vítimas		
    IF registro.numvitimaobitoacidente > 0 OR registro.numvitimaobitoproduto > 0
    THEN
      vargraurisco4 = 3;
    ELSIF registro.numvitimaferidaacidente > 0 OR registro.numvitimaferidaproduto > 0
      THEN
        vargraurisco4 = 2;
    ELSIF registro.numvitimaobitoacidente = 0 AND registro.numvitimaobitoproduto = 0 AND
          registro.numvitimaferidaacidente = 0 AND registro.numvitimaferidaproduto = 0
      THEN
        vargraurisco4 = 0;
    ELSE
      vargraurisco4 = 0;
    END IF;

    soma = coalesce(vargraurisco1) + coalesce(vargraurisco2) + coalesce(vargraurisco3) + coalesce(vargraurisco4);

    UPDATE historicoocoracidente
    SET graurisco = soma
    WHERE idocorrencia = registro.idocorrencia;

  END LOOP;

END;
$BODY$
LANGUAGE plpgsql
VOLATILE
COST 100;
ALTER FUNCTION public.algp2r2histocoracid()
OWNER TO postgres;

-- DETERMINA GRAUS DE RISCO EM SÍTIOS FRÁGEIS
-- Function: public.algp2r2sitiosfrageis()

-- DROP FUNCTION public.algp2r2sitiosfrageis();

CREATE OR REPLACE FUNCTION public.algp2r2sitiosfrageis()
  RETURNS VOID AS
$BODY$

DECLARE
  registro        RECORD;
  vargraurisco1   INT;
  vargraurisco2   INT;
  varregistronum1 NUMERIC;
  soma            INT;
  risco_          VARCHAR; --descricao do risco

BEGIN
  -- DETERMINA GRAUS DE RISCO EM SÍTIOS FRÁGEIS

  -- Classifica grau de risco para Área Legalmente Protegida


  UPDATE public.arealegalmenteprotegida AS a
  SET graurisco = 1, risco = 'Floresta/parque(1) '
  FROM public.sitiofragilvulneravel AS b
  WHERE a.idsitio = b.idsitio AND (UPPER(b.nome) LIKE '%FLORESTA URBANA%' OR UPPER(b.nome) LIKE '%PARQUE%' OR
                                   UPPER(b.nome) LIKE '%RESERVA PARTICULAR%');

  UPDATE public.arealegalmenteprotegida AS a
  SET graurisco = 2, risco = 'apa/vida silvestre/ecológica(2)'
  FROM public.sitiofragilvulneravel AS b
  WHERE a.idsitio = b.idsitio AND (UPPER(b.nome) LIKE '%VIDA SILVESTRE%' OR UPPER(b.nome) LIKE '%ARIE %'
                                   OR UPPER(b.nome) LIKE '%INTERESSE ECOLÓGICO%' OR
                                   UPPER(b.nome) LIKE '%ESTAÇÃO ECOLÓGICA%'
                                   OR UPPER(b.nome) LIKE '%ESEC%' OR UPPER(b.nome) LIKE '%APA %' OR
                                   UPPER(b.nome) LIKE '%ÁREA DE PROTEÇÃO AMBIENTAL%');

  UPDATE public.arealegalmenteprotegida AS a
  SET graurisco = 3, risco = 'estuarina(3)'
  FROM public.sitiofragilvulneravel AS b
  WHERE a.idsitio = b.idsitio AND UPPER(b.nome) LIKE '%ESTUARINA%';

  -- Classifica grau de risco para Assentamento Humano
  UPDATE public.assentamentohumano
  SET graurisco = 1, risco = 'pop.<500(1)'
  WHERE populacao <= 500;

  UPDATE public.assentamentohumano
  SET graurisco = 2, risco = '500<pop<1000(2)'
  WHERE populacao > 500 AND populacao <= 1000;

  UPDATE public.assentamentohumano
  SET graurisco = 3, risco = 'pop.>1000(3)'
  WHERE populacao > 1000;

  -- Classifica grau de risco para Área de Recarga de Aquífero
  UPDATE public.arearecargaaquifero
  SET graurisco = 2, risco = 'aquifero(2)';

  -- Classifica grau de risco para Captação de Água

  FOR registro IN SELECT *
                  FROM public.captacao
                  ORDER BY idcaptacao LOOP
    risco_ = '';
    soma = 0;
    vargraurisco1 = 0;
    vargraurisco2 = 0;
    -- Grau de risco quanto ao Tipo
    IF UPPER(registro.fonte) LIKE '%SUBTERRÂNEA%'
    THEN
      risco_ = 'subterrânea(2)';
      vargraurisco1 = 2;
    ELSIF UPPER(registro.fonte) LIKE '%SUPERFICIAL%'
      THEN
        vargraurisco1 = 3;
        risco_ = 'superficial(3)';
    ELSE
      vargraurisco1 = 0;
    END IF;

    -- Grau de risco quanto ao Uso
    IF UPPER(registro.caractativ) LIKE '%INDUSTRIAL%'
    THEN
      vargraurisco2 = 1;
      risco_ = risco_ || ' industrial(1)';
    ELSIF UPPER(registro.caractativ) LIKE '%EXPLOTAÇÃO COMERCIAL%' OR UPPER(registro.caractativ) LIKE '%RURAL%'
      THEN
        vargraurisco2 = 2;
        risco_ = risco_ || ' comercial ou rural(2)';
    ELSIF UPPER(registro.caractativ) LIKE '%ABASTECIMENTO URBANO%' OR
          UPPER(registro.caractativ) LIKE '%ABASTECIMENTO HOSPITALAR%' OR
          UPPER(registro.caractativ) LIKE '%ABASTECIMENTO ESCOLAR%'
      THEN
        risco_ = risco_ || ' abastecimento(3)';
        vargraurisco2 = 3;
    END IF;

    soma = coalesce(vargraurisco1) + coalesce(vargraurisco2);
    UPDATE public.captacao
    SET graurisco = soma, risco = risco_
    WHERE idcaptacao = registro.idcaptacao;

  END LOOP;

  -- Classifica grau de risco para Recursos Hídricos Representativos
  FOR registro IN SELECT *
                  FROM public.rechidrrepresentativo
                  ORDER BY idrechidrrepr LOOP

    /*ANTIGO
    SELECT INTO varregistronum1 min(ST_DISTANCE(ST_TRANSFORM(rechidrrepresentativo.the_geom,29195), ST_TRANSFORM(caractativpotimpactanteempresa.the_geom,29195)))
    FROM rechidrrepresentativo, caractativpotimpactanteempresa
    WHERE idrechidrrepr = registro.idrechidrrepr;
    */

    SELECT INTO varregistronum1
      min(ST_DISTANCE(rechidrrepresentativo.the_geom, caractativpotimpactanteempresa.the_geom)) * 111000
    FROM rechidrrepresentativo, caractativpotimpactanteempresa
    WHERE idrechidrrepr = registro.idrechidrrepr;
    risco_ = '';
    vargraurisco1 = 0;
    IF varregistronum1 > 500
    THEN
      vargraurisco1 = 4;
      risco_ = 'maior 500mts (4)';
    ELSIF varregistronum1 > 100 AND varregistronum1 <= 500
      THEN
        vargraurisco1 = 3;
        risco_ = '100 a 500mts (3)';
    ELSIF varregistronum1 <= 100
      THEN
        vargraurisco1 = 2;
        risco_ = 'menor 100mts (2)';
    END IF;

    UPDATE public.rechidrrepresentativo
    SET graurisco = vargraurisco1, risco = risco_
    WHERE idrechidrrepr = registro.idrechidrrepr;

  END LOOP;

END;
$BODY$
LANGUAGE plpgsql
VOLATILE
COST 100;
ALTER FUNCTION public.algp2r2sitiosfrageis()
OWNER TO postgres;

-- Classifica grau de risco para Área Legalmente Protegida

-- DETERMINA GRAUS DE RISCO EM ÁREAS CONTAMINADAS

-- Function: public.algp2r2areascontaminadas()

-- DROP FUNCTION public.algp2r2areascontaminadas();

CREATE OR REPLACE FUNCTION public.algp2r2areascontaminadas()
  RETURNS VOID AS
$BODY$

DECLARE
  contador        INT;
  registro        RECORD;
  vargraurisco1   INT;
  vargraurisco2   INT;
  vargraurisco3   INT;
  varregistronum1 NUMERIC;
  varbooleano1    BOOLEAN;
  soma            INT;
  risco_          VARCHAR;

BEGIN
  -- DETERMINA GRAUS DE RISCO EM ÁREAS CONTAMINADAS

  FOR registro IN SELECT *
                  FROM public.areacontampassivoambiental
                  ORDER BY idareacont LOOP
    soma = 0;
    risco_ = '';
    -- Classifica grau de risco para Tipologia
    vargraurisco1 = 0;

    IF registro.tipologia = 'Lixão' OR registro.tipologia = 'Terreno com Contaminação de Estabelecimento Comercial'
    THEN
      vargraurisco1 = 2;
      risco_ = 'Lixao ou Terreno contaminado(2)';
    ELSIF registro.tipologia = 'Terreno com Contaminação Industrial'
      THEN
        vargraurisco1 = 3;
        risco_ = 'Terreno contaminação industrial(3)';
    END IF;

    soma = vargraurisco1;

    -- Classifica grau de risco para Área Impactada
    -- Solo superficial e sedimentos
    SELECT INTO contador count(*)
    FROM areacontampassivoambiental
      INNER JOIN public.meioimpactado ON (areacontampassivoambiental.idareacont = meioimpactado.idareacont)
    WHERE areacontampassivoambiental.idareacont = registro.idareacont AND meioimpactado.meioimpactado IS NOT NULL
          AND (UPPER(meioimpactado.meioimpactado) LIKE '%SOLO SUPERFICIAL%' OR
               UPPER(meioimpactado.meioimpactado) LIKE '%SEDIMENTOS%');

    vargraurisco1 = 0;
    --risco_=''; Comentado por Diego

    IF contador > 0
    THEN
      vargraurisco1 = 1;
      risco_ = 'Pass. amb. c/Solo superficial(1)';
    END IF;

    -- Solo, águas superficiais, ar e biota
    SELECT INTO contador count(*)
    FROM areacontampassivoambiental
      INNER JOIN public.meioimpactado ON (areacontampassivoambiental.idareacont = meioimpactado.idareacont)
    WHERE areacontampassivoambiental.idareacont = registro.idareacont AND meioimpactado.meioimpactado IS NOT NULL
          AND ((UPPER(meioimpactado.meioimpactado) LIKE '%SOLO%' AND
                UPPER(meioimpactado.meioimpactado) NOT LIKE '%SOLO SUPERFICIAL%') OR
               UPPER(meioimpactado.meioimpactado) LIKE '%ÁGUAS SUPERFICIAIS%'
               OR UPPER(meioimpactado.meioimpactado) LIKE '%AR%' OR UPPER(meioimpactado.meioimpactado) LIKE '%BIOTA%');

    IF contador > 0
    THEN
      vargraurisco1 = 2;
      risco_ = risco_ || ' (2)';
    END IF;

    -- Águas subterrâneas
    SELECT INTO contador count(*)
    FROM areacontampassivoambiental
      INNER JOIN public.meioimpactado ON (areacontampassivoambiental.idareacont = meioimpactado.idareacont)
    WHERE areacontampassivoambiental.idareacont = registro.idareacont AND meioimpactado.meioimpactado IS NOT NULL
          AND UPPER(meioimpactado.meioimpactado) LIKE '%ÁGUAS SUBTERRÂNEAS%';

    IF contador > 0
    THEN
      vargraurisco1 = 3;
      risco_ = 'Água Subterr.(3)';
    END IF;

    soma = soma + vargraurisco1;

    -- Classifica grau de risco para Produto Perigoso
    -- Classes de produto 4 (Sólidos Inflamáveis) e 9 (Perigos Diversos)
    SELECT INTO contador count(*)
    FROM areacontampassivoambiental
      INNER JOIN public.produtoquimareacontaminada
        ON (areacontampassivoambiental.idareacont = produtoquimareacontaminada.idareacont)
      --INNER JOIN public.refprodutoperigoso ON (produtoquimareacontaminada.numonu = refprodutoperigoso.numonu)
      INNER JOIN public.refprodutoperigoso
        ON (produtoquimareacontaminada.refprodutoperigoso_id = refprodutoperigoso.idrefprodperigoso)
    WHERE areacontampassivoambiental.idareacont = registro.idareacont AND refprodutoperigoso.classerisco IS NOT NULL AND
          (refprodutoperigoso.classerisco LIKE '4%' OR refprodutoperigoso.classerisco LIKE '9%');

    vargraurisco2 = 0;
    IF contador > 0
    THEN
      vargraurisco2 = 1;
      risco_ = 'Prod.perigoso(1)';
    END IF;

    -- Classes de produto 2 (Gases) e 3 (Líquido Inflamável)
    SELECT INTO contador count(*)
    FROM areacontampassivoambiental
      INNER JOIN public.produtoquimareacontaminada
        ON (areacontampassivoambiental.idareacont = produtoquimareacontaminada.idareacont)
      --INNER JOIN public.refprodutoperigoso ON (produtoquimareacontaminada.numonu = refprodutoperigoso.numonu)
      INNER JOIN public.refprodutoperigoso
        ON (produtoquimareacontaminada.refprodutoperigoso_id = refprodutoperigoso.idrefprodperigoso)
    WHERE areacontampassivoambiental.idareacont = registro.idareacont AND refprodutoperigoso.classerisco IS NOT NULL AND
          (refprodutoperigoso.classerisco LIKE '2%' OR refprodutoperigoso.classerisco LIKE '3%');

    IF contador > 0
    THEN
      vargraurisco2 = 2;
      risco_ = risco_ || ' Gás/líquido inflam.(2)';
    END IF;

    -- Classes de produto 1 (Explosivos), 5 (Oxidantes e Peróxidos), 6 (Tóxicos), 7 (Material Radioativo) e 8 (Corrosivos)
    SELECT INTO contador count(*)
    FROM areacontampassivoambiental
      INNER JOIN public.produtoquimareacontaminada
        ON (areacontampassivoambiental.idareacont = produtoquimareacontaminada.idareacont)
      --INNER JOIN public.refprodutoperigoso ON (produtoquimareacontaminada.numonu = refprodutoperigoso.numonu)
      INNER JOIN public.refprodutoperigoso
        ON (produtoquimareacontaminada.refprodutoperigoso_id = refprodutoperigoso.idrefprodperigoso)
    WHERE areacontampassivoambiental.idareacont = registro.idareacont AND refprodutoperigoso.classerisco IS NOT NULL AND
          (refprodutoperigoso.classerisco LIKE '1%'
           OR refprodutoperigoso.classerisco LIKE '5%' OR refprodutoperigoso.classerisco LIKE '6%' OR
           refprodutoperigoso.classerisco LIKE '7%' OR refprodutoperigoso.classerisco LIKE '8%');

    IF contador > 0
    THEN
      vargraurisco2 = 3;
      risco_ = risco_ || ' Prod. explosivo(3)';
    END IF;

    soma = soma + vargraurisco2;

    --Classes de resíduo
    SELECT INTO contador count(*)
    FROM areacontampassivoambiental
      INNER JOIN public.residuoareacontampasamb
        ON (areacontampassivoambiental.idareacont = residuoareacontampasamb.idareacont)
      --INNER JOIN public.refresiduo ON (residuoareacontampasamb.codresiduo = refresiduo.codresiduo)
      INNER JOIN public.refresiduo ON (residuoareacontampasamb.refresiduo_id = refresiduo.idrefresiduo)
    WHERE areacontampassivoambiental.idareacont = registro.idareacont AND refresiduo.classifresiduo IS NOT NULL AND
          (refresiduo.classifresiduo LIKE '%Classe II%');

    vargraurisco3 = 0;
    IF contador > 0
    THEN
      vargraurisco3 = 1;
      risco_ = 'Res. ClasseII(1)';
    END IF;


    SELECT INTO contador count(*)
    FROM areacontampassivoambiental
      INNER JOIN public.residuoareacontampasamb
        ON (areacontampassivoambiental.idareacont = residuoareacontampasamb.idareacont)
      --INNER JOIN public.refresiduo ON (residuoareacontampasamb.codresiduo = refresiduo.codresiduo)
      INNER JOIN public.refresiduo ON (residuoareacontampasamb.refresiduo_id = refresiduo.idrefresiduo)
    WHERE areacontampassivoambiental.idareacont = registro.idareacont AND refresiduo.classifresiduo IS NOT NULL AND
          (refresiduo.classifresiduo = 'Classe I');

    IF contador > 0
    THEN
      vargraurisco3 = 3;
      risco_ = 'Res. ClasseI(3)';
    END IF;

    soma = soma + vargraurisco3;

    -- Classifica grau de risco segundo distância a Sítios Frágeis
    -- Dentro de Área Legalmente Protegida
    SELECT INTO varbooleano1 ST_INTERSECTS(areacontampassivoambiental.the_geom, arealegalmenteprotegida.the_geom)
    FROM areacontampassivoambiental, arealegalmenteprotegida
    WHERE idareacont = registro.idareacont;

    IF varbooleano1 = 't'
    THEN
      soma = soma + 3;
      risco_ = risco_ || ' Área Proteg.(3)';
    END IF;

    -- Dentro de Assentamento Humano
    SELECT INTO varbooleano1 ST_INTERSECTS(areacontampassivoambiental.the_geom, assentamentohumano.the_geom)
    FROM areacontampassivoambiental, assentamentohumano
    WHERE idareacont = registro.idareacont;

    IF varbooleano1 = 't'
    THEN
      soma = soma + 3;
      risco_ = risco_ || ' Ass. humano(3)';
    END IF;

    -- Distância a Assentamento Humano
    varregistronum1 = 0;
    /*ANTIGO
    SELECT INTO varregistronum1 min(ST_DISTANCE(ST_TRANSFORM(areacontampassivoambiental.the_geom,29195), ST_TRANSFORM(assentamentohumano.the_geom,29195)))
      FROM areacontampassivoambiental, assentamentohumano
      WHERE idareacont = registro.idareacont AND ST_INTERSECTS(areacontampassivoambiental.the_geom,assentamentohumano.the_geom) = 'f';
    */
    SELECT INTO varregistronum1
      min(ST_DISTANCE(areacontampassivoambiental.the_geom, assentamentohumano.the_geom)) * 111000
    FROM areacontampassivoambiental, assentamentohumano
    WHERE idareacont = registro.idareacont AND
          ST_INTERSECTS(areacontampassivoambiental.the_geom, assentamentohumano.the_geom) = 'f';

    vargraurisco1 = 0;
    IF varregistronum1 <= 500
    THEN
      vargraurisco1 = 1;
      risco_ = risco_ || ' Dist.<=500(1)';
    ELSIF varregistronum1 > 500 AND varregistronum1 <= 1000
      THEN
        vargraurisco1 = 2;
        risco_ = risco_ || ' 500<Dist<1000(2)';
    ELSIF varregistronum1 > 1000
      THEN
        vargraurisco1 = 3;
        risco_ = risco_ || ' Dist.>1000(3)';
    END IF;

    soma = soma + vargraurisco1;

    -- Distância a demais Sítios Frágeis
    -- Captação
    varregistronum1 = 0;
    --risco_=''; Comentada por Diego
    /*ANTIGO
    SELECT INTO varregistronum1 min(ST_DISTANCE(ST_TRANSFORM(areacontampassivoambiental.the_geom,29195), ST_TRANSFORM(captacao.the_geom,29195)))
      FROM areacontampassivoambiental, captacao
      WHERE idareacont = registro.idareacont;
    */
    SELECT INTO varregistronum1 min(ST_DISTANCE(areacontampassivoambiental.the_geom, captacao.the_geom)) * 111000
    FROM areacontampassivoambiental, captacao
    WHERE idareacont = registro.idareacont;

    vargraurisco1 = 0;
    IF varregistronum1 > 500
    THEN
      vargraurisco1 = 1;
      risco_ = 'Dist. Sítios Frág.>500(1)';
    ELSIF varregistronum1 <= 500
      THEN
        vargraurisco1 = 2;
        risco_ = 'Dist. Sítios Frág.<500(2)';
    END IF;

    soma = soma + vargraurisco1;

    -- Áreas de Recarga de Aquífero
    varregistronum1 = 0;
    /*ANTIGO
    SELECT INTO varregistronum1 min(ST_DISTANCE(ST_TRANSFORM(areacontampassivoambiental.the_geom,29195), ST_TRANSFORM(arearecargaaquifero.the_geom,29195)))
      FROM areacontampassivoambiental, arearecargaaquifero
      WHERE idareacont = registro.idareacont;
    */
    SELECT INTO varregistronum1
      min(ST_DISTANCE(areacontampassivoambiental.the_geom, arearecargaaquifero.the_geom)) * 111000
    FROM areacontampassivoambiental, arearecargaaquifero
    WHERE idareacont = registro.idareacont;

    vargraurisco1 = 0;
    IF varregistronum1 > 500
    THEN
      vargraurisco1 = 1;
      risco_ = 'Dist. Aquífero>500(1)';
    ELSIF varregistronum1 <= 500
      THEN
        vargraurisco1 = 2;
        risco_ = 'Dist. Aquífero<500(2)';
    END IF;

    soma = soma + vargraurisco1;

    -- Recursos Hídricos
    varregistronum1 = 0;
    /*ANTIGO
    SELECT INTO varregistronum1 min(ST_DISTANCE(ST_TRANSFORM(areacontampassivoambiental.the_geom,29195), ST_TRANSFORM(rechidrrepresentativo.the_geom,29195)))
      FROM areacontampassivoambiental, rechidrrepresentativo
      WHERE idareacont = registro.idareacont;
    */
    SELECT INTO varregistronum1
      min(ST_DISTANCE(areacontampassivoambiental.the_geom, rechidrrepresentativo.the_geom)) * 111000
    FROM areacontampassivoambiental, rechidrrepresentativo
    WHERE idareacont = registro.idareacont;

    vargraurisco1 = 0;
    IF varregistronum1 > 500
    THEN
      vargraurisco1 = 1;
      risco_ = 'Dist. Rec. Hídricos>500(1)';
    ELSIF varregistronum1 <= 500
      THEN
        vargraurisco1 = 2;
        risco_ = 'Dist. Rec. Hídricos<500(2)';
    END IF;

    soma = soma + vargraurisco1;

    -- Existência de Estruturas de Contenção e Instrumentos de Gestão Ambiental
    SELECT INTO contador count(*)
    FROM areacontampassivoambiental
      INNER JOIN public.estrutcontinstrgestambareacontam
        ON (areacontampassivoambiental.idareacont = estrutcontinstrgestambareacontam.idareacont)
    WHERE areacontampassivoambiental.idareacont = registro.idareacont AND
          estrutcontinstrgestambareacontam.estrutcontencao IS NOT NULL AND
          UPPER(estrutcontinstrgestambareacontam.estrutcontencao) LIKE '%SIM%';

    IF contador > 0
    THEN
      vargraurisco1 = -2;
      risco_ = 'Estr. Contenção(-2)';
    ELSIF contador = 0
      THEN
        vargraurisco1 = 0;
    END IF;

    soma = soma + vargraurisco1;

    -- Existência de Estruturas de Contenção e Instrumentos de Gestão Ambiental
    SELECT INTO contador count(*)
    FROM areacontampassivoambiental
      INNER JOIN public.estrutcontinstrgestambareacontam
        ON (areacontampassivoambiental.idareacont = estrutcontinstrgestambareacontam.idareacont)
    WHERE areacontampassivoambiental.idareacont = registro.idareacont AND
          estrutcontinstrgestambareacontam.sistmonitoramento IS NOT NULL AND
          UPPER(estrutcontinstrgestambareacontam.sistmonitoramento) LIKE '%SIM%';

    IF contador > 0
    THEN
      vargraurisco1 = -2;
      risco_ = risco_ || ' Instr. Gestão Ambiental(-2)';
    ELSIF contador = 0
      THEN
        vargraurisco1 = 0;
    END IF;

    soma = soma + vargraurisco1;

    SELECT INTO contador count(*)
    FROM areacontampassivoambiental
      INNER JOIN public.estrutcontinstrgestambareacontam
        ON (areacontampassivoambiental.idareacont = estrutcontinstrgestambareacontam.idareacont)
    WHERE areacontampassivoambiental.idareacont = registro.idareacont AND
          estrutcontinstrgestambareacontam.planemergencia IS NOT NULL AND
          UPPER(estrutcontinstrgestambareacontam.planemergencia) LIKE '%SIM%';

    IF contador > 0
    THEN
      vargraurisco1 = -3;
      risco_ = risco_ || ' Plano de Emergência(-3)';
    ELSIF contador = 0
      THEN
        vargraurisco1 = 0;
    END IF;

    soma = soma + vargraurisco1;

    SELECT INTO contador count(*)
    FROM areacontampassivoambiental
      INNER JOIN public.estrutcontinstrgestambareacontam
        ON (areacontampassivoambiental.idareacont = estrutcontinstrgestambareacontam.idareacont)
    WHERE areacontampassivoambiental.idareacont = registro.idareacont AND
          estrutcontinstrgestambareacontam.medidaremediacao IS NOT NULL AND
          UPPER(estrutcontinstrgestambareacontam.medidaremediacao) LIKE '%SIM%';

    IF contador > 0
    THEN
      vargraurisco1 = -1;
      risco_ = risco_ || ' Medida remediação(-1)';
    ELSIF contador = 0
      THEN
        vargraurisco1 = 0;
    END IF;

    soma = soma + vargraurisco1;

    SELECT INTO contador count(*)
    FROM areacontampassivoambiental
      INNER JOIN public.estrutcontinstrgestambareacontam
        ON (areacontampassivoambiental.idareacont = estrutcontinstrgestambareacontam.idareacont)
    WHERE areacontampassivoambiental.idareacont = registro.idareacont AND
          estrutcontinstrgestambareacontam.estrutcontencao IS NOT NULL AND
          UPPER(estrutcontinstrgestambareacontam.estrutcontencao) LIKE '%SIM%';

    IF contador > 0
    THEN
      vargraurisco1 = -2;
      risco_ = risco_ || ' Estrutura de Contenção(-2)';
    ELSIF contador = 0
      THEN
        vargraurisco1 = 0;
    END IF;

    soma = soma + vargraurisco1;

    -- Grava no banco grau de risco para cada registro
    UPDATE public.areacontampassivoambiental
    SET graurisco = soma, risco = substr(risco_, 0, 150)
    WHERE idareacont = registro.idareacont;
    --risco_=''; Comentado por Diego
  END LOOP;

END;
$BODY$
LANGUAGE plpgsql
VOLATILE
COST 100;
ALTER FUNCTION public.algp2r2areascontaminadas()
OWNER TO postgres;

-- Function: public.algp2r2passivo()

-- DROP FUNCTION public.algp2r2passivo();

CREATE OR REPLACE FUNCTION public.algp2r2passivo()
  RETURNS VOID AS
$BODY$

DECLARE
  contador        INT;
  registro        RECORD;
  vargraurisco1   INT;
  vargraurisco2   INT;
  vargraurisco3   INT;
  varregistronum1 NUMERIC;
  varbooleano1    BOOLEAN;
  soma            INT;
  risco_          VARCHAR;

BEGIN
  -- DETERMINA GRAUS DE RISCO EM ÁREAS CONTAMINADAS

  FOR registro IN SELECT *
                  FROM public.passivoambiental
                  ORDER BY idpassivo LOOP
    soma = 0;
    risco_ = '';
    -- Classifica grau de risco para Tipologia
    vargraurisco1 = 0;

    IF registro.tipologia = 'Lixão' OR registro.tipologia = 'Terreno com Contaminação de Estabelecimento Comercial'
    THEN
      vargraurisco1 = 2;
      risco_ = 'Lixao ou Terreno contaminado(2)';
    ELSIF registro.tipologia = 'Terreno com Contaminação Industrial'
      THEN
        vargraurisco1 = 3;
        risco_ = 'Terreno contaminação industrial(3)';
    END IF;

    soma = vargraurisco1;

    -- Classifica grau de risco para Área Impactada
    -- Solo superficial e sedimentos
    SELECT INTO contador count(*)
    FROM passivoambiental
      INNER JOIN public.meioimpactado ON (passivoambiental.idpassivo = meioimpactado.idpassivo)
    WHERE passivoambiental.idpassivo = registro.idpassivo AND meioimpactado.meioimpactado IS NOT NULL
          AND (UPPER(meioimpactado.meioimpactado) LIKE '%SOLO SUPERFICIAL%' OR
               UPPER(meioimpactado.meioimpactado) LIKE '%SEDIMENTOS%');

    vargraurisco1 = 0;
    risco_ = '';

    IF contador > 0
    THEN
      vargraurisco1 = 1;
      risco_ = 'Pass. amb. c/Solo superficial(1)';
    END IF;

    -- Solo, águas superficiais, ar e biota
    SELECT INTO contador count(*)
    FROM passivoambiental
      INNER JOIN public.meioimpactado ON (passivoambiental.idpassivo = meioimpactado.idpassivo)
    WHERE passivoambiental.idpassivo = registro.idpassivo AND meioimpactado.meioimpactado IS NOT NULL
          AND ((UPPER(meioimpactado.meioimpactado) LIKE '%SOLO%' AND
                UPPER(meioimpactado.meioimpactado) NOT LIKE '%SOLO SUPERFICIAL%') OR
               UPPER(meioimpactado.meioimpactado) LIKE '%ÁGUAS SUPERFICIAIS%'
               OR UPPER(meioimpactado.meioimpactado) LIKE '%AR%' OR UPPER(meioimpactado.meioimpactado) LIKE '%BIOTA%');

    IF contador > 0
    THEN
      vargraurisco1 = 2;
      risco_ = risco_ || ' (2)';
    END IF;

    -- Águas subterrâneas
    SELECT INTO contador count(*)
    FROM passivoambiental
      INNER JOIN public.meioimpactado ON (passivoambiental.idpassivo = meioimpactado.idpassivo)
    WHERE passivoambiental.idpassivo = registro.idpassivo AND meioimpactado.meioimpactado IS NOT NULL
          AND UPPER(meioimpactado.meioimpactado) LIKE '%ÁGUAS SUBTERRÂNEAS%';

    IF contador > 0
    THEN
      vargraurisco1 = 3;
      risco_ = 'Água Subterr.(3)';
    END IF;

    soma = soma + vargraurisco1;

    -- Classifica grau de risco para Produto Perigoso
    -- Classes de produto 4 (Sólidos Inflamáveis) e 9 (Perigos Diversos)
    SELECT INTO contador count(*)
    FROM passivoambiental
      INNER JOIN public.produtoquimareacontaminada
        ON (passivoambiental.idpassivo = produtoquimareacontaminada.idpassivo)
      --INNER JOIN public.refprodutoperigoso ON (produtoquimareacontaminada.numonu = refprodutoperigoso.numonu)
      INNER JOIN public.refprodutoperigoso
        ON (produtoquimareacontaminada.refprodutoperigoso_id = refprodutoperigoso.idrefprodperigoso)
    WHERE passivoambiental.idpassivo = registro.idpassivo AND refprodutoperigoso.classerisco IS NOT NULL AND
          (refprodutoperigoso.classerisco LIKE '4%' OR refprodutoperigoso.classerisco LIKE '9%');

    vargraurisco2 = 0;
    IF contador > 0
    THEN
      vargraurisco2 = 1;
      risco_ = 'Prod.perigoso(1)';
    END IF;

    -- Classes de produto 2 (Gases) e 3 (Líquido Inflamável)
    SELECT INTO contador count(*)
    FROM passivoambiental
      INNER JOIN public.produtoquimareacontaminada
        ON (passivoambiental.idpassivo = produtoquimareacontaminada.idpassivo)
      --INNER JOIN public.refprodutoperigoso ON (produtoquimareacontaminada.numonu = refprodutoperigoso.numonu)
      INNER JOIN public.refprodutoperigoso
        ON (produtoquimareacontaminada.refprodutoperigoso_id = refprodutoperigoso.idrefprodperigoso)
    WHERE passivoambiental.idpassivo = registro.idpassivo AND refprodutoperigoso.classerisco IS NOT NULL AND
          (refprodutoperigoso.classerisco LIKE '2%' OR refprodutoperigoso.classerisco LIKE '3%');

    IF contador > 0
    THEN
      vargraurisco2 = 2;
      risco_ = risco_ || ' Gás/líquido inflam.(2)';
    END IF;

    -- Classes de produto 1 (Explosivos), 5 (Oxidantes e Peróxidos), 6 (Tóxicos), 7 (Material Radioativo) e 8 (Corrosivos)
    SELECT INTO contador count(*)
    FROM passivoambiental
      INNER JOIN public.produtoquimareacontaminada
        ON (passivoambiental.idpassivo = produtoquimareacontaminada.idpassivo)
      --INNER JOIN public.refprodutoperigoso ON (produtoquimareacontaminada.numonu = refprodutoperigoso.numonu)
      INNER JOIN public.refprodutoperigoso
        ON (produtoquimareacontaminada.refprodutoperigoso_id = refprodutoperigoso.idrefprodperigoso)
    WHERE passivoambiental.idpassivo = registro.idpassivo AND refprodutoperigoso.classerisco IS NOT NULL AND
          (refprodutoperigoso.classerisco LIKE '1%'
           OR refprodutoperigoso.classerisco LIKE '5%' OR refprodutoperigoso.classerisco LIKE '6%' OR
           refprodutoperigoso.classerisco LIKE '7%' OR refprodutoperigoso.classerisco LIKE '8%');

    IF contador > 0
    THEN
      vargraurisco2 = 3;
      risco_ = risco_ || ' Prod. explosivo(3)';
    END IF;

    soma = soma + vargraurisco2;

    --Classes de resíduo
    SELECT INTO contador count(*)
    FROM passivoambiental
      INNER JOIN public.residuoareacontampasamb ON (passivoambiental.idpassivo = residuoareacontampasamb.idpassivo)
      --INNER JOIN public.refresiduo ON (residuoareacontampasamb.codresiduo = refresiduo.codresiduo)
      INNER JOIN public.refresiduo ON (residuoareacontampasamb.refresiduo_id = refresiduo.idrefresiduo)
    WHERE passivoambiental.idpassivo = registro.idpassivo AND refresiduo.classifresiduo IS NOT NULL AND
          (refresiduo.classifresiduo LIKE '%Classe II%');

    vargraurisco3 = 0;
    IF contador > 0
    THEN
      vargraurisco3 = 1;
      risco_ = 'Res. ClasseII(1)';
    END IF;


    SELECT INTO contador count(*)
    FROM passivoambiental
      INNER JOIN public.residuoareacontampasamb ON (passivoambiental.idpassivo = residuoareacontampasamb.idpassivo)
      --INNER JOIN public.refresiduo ON (residuoareacontampasamb.codresiduo = refresiduo.codresiduo)
      INNER JOIN public.refresiduo ON (residuoareacontampasamb.refresiduo_id = refresiduo.idrefresiduo)
    WHERE passivoambiental.idpassivo = registro.idpassivo AND refresiduo.classifresiduo IS NOT NULL AND
          (refresiduo.classifresiduo = 'Classe I');

    IF contador > 0
    THEN
      vargraurisco3 = 3;
      risco_ = 'Res. ClasseI(3)';
    END IF;

    soma = soma + vargraurisco3;

    -- Classifica grau de risco segundo distância a Sítios Frágeis
    -- Dentro de Área Legalmente Protegida
    SELECT INTO varbooleano1 ST_INTERSECTS(passivoambiental.the_geom, arealegalmenteprotegida.the_geom)
    FROM passivoambiental, arealegalmenteprotegida
    WHERE idpassivo = registro.idpassivo;

    IF varbooleano1 = 't'
    THEN
      soma = soma + 3;
      risco_ = risco_ || ' Área Proteg.(3)';
    END IF;

    -- Dentro de Assentamento Humano
    SELECT INTO varbooleano1 ST_INTERSECTS(passivoambiental.the_geom, assentamentohumano.the_geom)
    FROM passivoambiental, assentamentohumano
    WHERE idpassivo = registro.idpassivo;

    IF varbooleano1 = 't'
    THEN
      soma = soma + 3;
      risco_ = risco_ || ' Ass. humano(3)';
    END IF;

    -- Distância a Assentamento Humano
    varregistronum1 = 0;
    /* ANTIGO
    SELECT INTO varregistronum1 min(ST_DISTANCE(ST_TRANSFORM(passivoambiental.the_geom,29195), ST_TRANSFORM(assentamentohumano.the_geom,29195)))
      FROM passivoambiental, assentamentohumano
      WHERE idpassivo = registro.idpassivo AND ST_INTERSECTS(passivoambiental.the_geom,assentamentohumano.the_geom) = 'f';
          */

    SELECT INTO varregistronum1 min(ST_DISTANCE(passivoambiental.the_geom, assentamentohumano.the_geom)) * 111000
    FROM passivoambiental, assentamentohumano
    WHERE ST_INTERSECTS(passivoambiental.the_geom, assentamentohumano.the_geom) = 'f'
          AND idpassivo = registro.idpassivo;

    vargraurisco1 = 0;
    IF varregistronum1 <= 500
    THEN
      vargraurisco1 = 1;
      risco_ = risco_ || ' Dist.<=500(1)';
    ELSIF varregistronum1 > 500 AND varregistronum1 <= 1000
      THEN
        vargraurisco1 = 2;
        risco_ = risco_ || ' 500<Dist<1000(2)';
    ELSIF varregistronum1 > 1000
      THEN
        vargraurisco1 = 3;
        risco_ = risco_ || ' Dist.>1000(3)';
    END IF;

    soma = soma + vargraurisco1;

    -- Distância a demais Sítios Frágeis
    -- Captação
    varregistronum1 = 0;
    risco_ = '';
    /* ANTIGO
    SELECT INTO varregistronum1 min(ST_DISTANCE(ST_TRANSFORM(passivoambiental.the_geom,29195), ST_TRANSFORM(captacao.the_geom,29195)))
      FROM passivoambiental, captacao
      WHERE idpassivo = registro.idpassivo;
         */

    SELECT INTO varregistronum1 min(ST_DISTANCE(passivoambiental.the_geom, captacao.the_geom)) * 111000
    FROM passivoambiental, captacao
    WHERE idpassivo = registro.idpassivo;

    vargraurisco1 = 0;
    IF varregistronum1 > 500
    THEN
      vargraurisco1 = 1;
      risco_ = 'Dist. Sítios Frág.>500(1)';
    ELSIF varregistronum1 <= 500
      THEN
        vargraurisco1 = 2;
        risco_ = 'Dist. Sítios Frág.<500(2)';
    END IF;

    soma = soma + vargraurisco1;

    -- Áreas de Recarga de Aquífero
    varregistronum1 = 0;
    /* ANTIGO
    SELECT INTO varregistronum1 min(ST_DISTANCE(ST_TRANSFORM(passivoambiental.the_geom,29195), ST_TRANSFORM(arearecargaaquifero.the_geom,29195)))
      FROM passivoambiental, arearecargaaquifero
      WHERE idpassivo = registro.idpassivo;
          */

    SELECT INTO varregistronum1 min(ST_DISTANCE(passivoambiental.the_geom, arearecargaaquifero.the_geom)) * 111000
    FROM passivoambiental, arearecargaaquifero
    WHERE idpassivo = registro.idpassivo;

    vargraurisco1 = 0;
    IF varregistronum1 > 500
    THEN
      vargraurisco1 = 1;
      risco_ = 'Dist. Aquífero>500(1)';
    ELSIF varregistronum1 <= 500
      THEN
        vargraurisco1 = 2;
        risco_ = 'Dist. Aquífero<500(2)';
    END IF;

    soma = soma + vargraurisco1;

    -- Recursos Hídricos
    varregistronum1 = 0;
    /* ANTIGO
    SELECT INTO varregistronum1 min(ST_DISTANCE(ST_TRANSFORM(passivoambiental.the_geom,29195), ST_TRANSFORM(rechidrrepresentativo.the_geom,29195)))
      FROM passivoambiental, rechidrrepresentativo
      WHERE idpassivo = registro.idpassivo;
          */

    SELECT INTO varregistronum1 min(ST_DISTANCE(passivoambiental.the_geom, rechidrrepresentativo.the_geom)) * 111000
    FROM passivoambiental, rechidrrepresentativo
    WHERE idpassivo = registro.idpassivo;

    vargraurisco1 = 0;
    IF varregistronum1 > 500
    THEN
      vargraurisco1 = 1;
      risco_ = 'Dist. Rec. Hídricos>500(1)';
    ELSIF varregistronum1 <= 500
      THEN
        vargraurisco1 = 2;
        risco_ = 'Dist. Rec. Hídricos<500(2)';
    END IF;

    soma = soma + vargraurisco1;

    -- Existência de Estruturas de Contenção e Instrumentos de Gestão Ambiental
    SELECT INTO contador count(*)
    FROM passivoambiental
      INNER JOIN public.estrutcontinstrgestambareacontam
        ON (passivoambiental.idpassivo = estrutcontinstrgestambareacontam.idpassivo)
    WHERE
      passivoambiental.idpassivo = registro.idpassivo AND estrutcontinstrgestambareacontam.estrutcontencao IS NOT NULL
      AND UPPER(estrutcontinstrgestambareacontam.estrutcontencao) LIKE '%SIM%';

    IF contador > 0
    THEN
      vargraurisco1 = -2;
      risco_ = 'Estr. Contenção(-2)';
    ELSIF contador = 0
      THEN
        vargraurisco1 = 0;
    END IF;

    soma = soma + vargraurisco1;

    -- Existência de Estruturas de Contenção e Instrumentos de Gestão Ambiental
    SELECT INTO contador count(*)
    FROM passivoambiental
      INNER JOIN public.estrutcontinstrgestambareacontam
        ON (passivoambiental.idpassivo = estrutcontinstrgestambareacontam.idpassivo)
    WHERE
      passivoambiental.idpassivo = registro.idpassivo AND estrutcontinstrgestambareacontam.sistmonitoramento IS NOT NULL
      AND UPPER(estrutcontinstrgestambareacontam.sistmonitoramento) LIKE '%SIM%';

    IF contador > 0
    THEN
      vargraurisco1 = -2;
      risco_ = risco_ || ' Instr. Gestão Ambiental(-2)';
    ELSIF contador = 0
      THEN
        vargraurisco1 = 0;
    END IF;

    soma = soma + vargraurisco1;

    SELECT INTO contador count(*)
    FROM passivoambiental
      INNER JOIN public.estrutcontinstrgestambareacontam
        ON (passivoambiental.idpassivo = estrutcontinstrgestambareacontam.idpassivo)
    WHERE
      passivoambiental.idpassivo = registro.idpassivo AND estrutcontinstrgestambareacontam.planemergencia IS NOT NULL
      AND UPPER(estrutcontinstrgestambareacontam.planemergencia) LIKE '%SIM%';

    IF contador > 0
    THEN
      vargraurisco1 = -3;
      risco_ = risco_ || ' Plano de Emergência(-3)';
    ELSIF contador = 0
      THEN
        vargraurisco1 = 0;
    END IF;

    soma = soma + vargraurisco1;

    SELECT INTO contador count(*)
    FROM passivoambiental
      INNER JOIN public.estrutcontinstrgestambareacontam
        ON (passivoambiental.idpassivo = estrutcontinstrgestambareacontam.idpassivo)
    WHERE
      passivoambiental.idpassivo = registro.idpassivo AND estrutcontinstrgestambareacontam.medidaremediacao IS NOT NULL
      AND UPPER(estrutcontinstrgestambareacontam.medidaremediacao) LIKE '%SIM%';

    IF contador > 0
    THEN
      vargraurisco1 = -1;
      risco_ = risco_ || ' Medida remediação(-1)';
    ELSIF contador = 0
      THEN
        vargraurisco1 = 0;
    END IF;

    soma = soma + vargraurisco1;

    SELECT INTO contador count(*)
    FROM passivoambiental
      INNER JOIN public.estrutcontinstrgestambareacontam
        ON (passivoambiental.idpassivo = estrutcontinstrgestambareacontam.idpassivo)
    WHERE
      passivoambiental.idpassivo = registro.idpassivo AND estrutcontinstrgestambareacontam.estrutcontencao IS NOT NULL
      AND UPPER(estrutcontinstrgestambareacontam.estrutcontencao) LIKE '%SIM%';

    IF contador > 0
    THEN
      vargraurisco1 = -2;
      risco_ = risco_ || ' Estrutura de Contenção(-2)';
    ELSIF contador = 0
      THEN
        vargraurisco1 = 0;
    END IF;

    soma = soma + vargraurisco1;

    -- Grava no banco grau de risco para cada registro
    UPDATE public.passivoambiental
    SET graurisco = soma, risco = substr(risco_, 150)
    WHERE idpassivo = registro.idpassivo;
    risco_ = '';
  END LOOP;

END;
$BODY$
LANGUAGE plpgsql
VOLATILE
COST 100;
ALTER FUNCTION public.algp2r2passivo()
OWNER TO postgres;

-- DETERMINA GRAUS DE RISCO EM ATIVIDADES POTENCIALMENTE IMPACTANTES - FONTES FIXAS
-- Function: public.algp2r2apifontesfixas()

-- DROP FUNCTION public.algp2r2apifontesfixas();

CREATE OR REPLACE FUNCTION public.algp2r2apifontesfixas()
  RETURNS VOID AS
$BODY$

DECLARE
  contador        INT;
  registro        RECORD;
  vargraurisco1   INT;
  vargraurisco2   INT;
  vargraurisco3   INT;
  varregistronum1 NUMERIC;
  varregistronum2 NUMERIC;
  varbooleano1    BOOLEAN;
  soma            INT;
  Risco_          VARCHAR(1250);

BEGIN
  -- DETERMINA GRAUS DE RISCO EM ATIVIDADES POTENCIALMENTE IMPACTANTES - FONTES FIXAS

  FOR registro IN SELECT *
                  FROM public.caractativpotimpactanteempresa
                  ORDER BY idativ LOOP
    soma = 0;
    Risco_ = '';
    -- Grau de risco para porte
    IF registro.porte = 'Pequeno'
    THEN
      Risco_ = 'Pequeno (1)';
      vargraurisco1 = 1;
    ELSIF registro.porte = 'Médio'
      THEN
        vargraurisco1 = 2;
        Risco_ = 'Médio (2)';
    ELSIF registro.porte = 'Grande'
      THEN
        vargraurisco1 = 3;
        Risco_ = 'Grande (3)';
    ELSE
      vargraurisco1 = 0;
    END IF;

    soma = coalesce(vargraurisco1);

    -- Grau de risco para potencial poluidor
    IF registro.potencialpoldegrad = 'Pequeno'
    THEN
      vargraurisco2 = 1;
      risco_ = risco_ || ' pot. poluidor peq. (1)';
    ELSIF registro.potencialpoldegrad = 'Médio'
      THEN
        vargraurisco2 = 2;
        risco_ = risco_ || ' pot. poluidor médio(2)';
    ELSIF registro.potencialpoldegrad = 'Grande'
      THEN
        vargraurisco2 = 3;
        risco_ = risco_ || ' pot. poluidor grande(3)';
    ELSE
      vargraurisco2 = 0;
    END IF;

    soma = soma + coalesce(vargraurisco2);

    -- Grau de risco para Produto Perigoso
    vargraurisco3 = 0;
    SELECT INTO contador count(*)
    FROM caractativpotimpactanteempresa
      INNER JOIN public.caractprodutoquimico ON (caractativpotimpactanteempresa.idativ = caractprodutoquimico.idativ)
      --INNER JOIN public.refprodutoperigoso ON (caractprodutoquimico.numonu = refprodutoperigoso.numonu)
      INNER JOIN public.refprodutoperigoso
        ON (caractprodutoquimico.refprodutoperigoso_id = refprodutoperigoso.idrefprodperigoso)
    WHERE caractativpotimpactanteempresa.idativ = registro.idativ AND refprodutoperigoso.classerisco IS NOT NULL AND
          (refprodutoperigoso.classerisco LIKE '9%');

    IF contador > 0
    THEN
      vargraurisco3 = 1;
      risco_ = risco_ || ' prod. perigoso(1)';
    END IF;

    SELECT INTO contador count(*)
    FROM caractativpotimpactanteempresa
      INNER JOIN public.caractprodutoquimico ON (caractativpotimpactanteempresa.idativ = caractprodutoquimico.idativ)
      --INNER JOIN public.refprodutoperigoso ON (caractprodutoquimico.numonu = refprodutoperigoso.numonu)
      INNER JOIN public.refprodutoperigoso
        ON (caractprodutoquimico.refprodutoperigoso_id = refprodutoperigoso.idrefprodperigoso)
    WHERE caractativpotimpactanteempresa.idativ = registro.idativ AND refprodutoperigoso.classerisco IS NOT NULL AND
          ((refprodutoperigoso.classerisco LIKE '8%')
           OR (refprodutoperigoso.classerisco LIKE '2.1%' AND caractprodutoquimico.qtdatual <= 6 AND
               caractprodutoquimico.unidade LIKE 'ton%') OR (refprodutoperigoso.classerisco LIKE '2.2%')
           OR (refprodutoperigoso.classerisco LIKE '2.3%' AND caractprodutoquimico.qtdatual <= 350 AND
               caractprodutoquimico.unidade LIKE 'kg%') OR
           (refprodutoperigoso.classerisco LIKE '3%' AND caractprodutoquimico.qtdatual <= 1000 AND
            caractprodutoquimico.unidade LIKE 'm%')
           OR (refprodutoperigoso.classerisco LIKE '4.3%') OR
           (refprodutoperigoso.classerisco LIKE '6%' AND caractprodutoquimico.qtdatual <= 5 AND
            caractprodutoquimico.unidade LIKE 'm%'));

    IF contador > 0
    THEN
      vargraurisco3 = 2;
      risco_ = risco_ || ' prod. perigoso(2)';
    END IF;

    SELECT INTO contador count(*)
    FROM caractativpotimpactanteempresa
      INNER JOIN public.caractprodutoquimico ON (caractativpotimpactanteempresa.idativ = caractprodutoquimico.idativ)
      --INNER JOIN public.refprodutoperigoso ON (caractprodutoquimico.numonu = refprodutoperigoso.numonu)
      INNER JOIN public.refprodutoperigoso
        ON (caractprodutoquimico.refprodutoperigoso_id = refprodutoperigoso.idrefprodperigoso)
    WHERE caractativpotimpactanteempresa.idativ = registro.idativ AND refprodutoperigoso.classerisco IS NOT NULL AND (
      (refprodutoperigoso.classerisco LIKE '2.1%' AND caractprodutoquimico.qtdatual > 6 AND
       caractprodutoquimico.unidade LIKE 'ton%')
      OR (refprodutoperigoso.classerisco LIKE '2.3%' AND caractprodutoquimico.qtdatual > 350 AND
          caractprodutoquimico.unidade LIKE 'kg%')
      OR (refprodutoperigoso.classerisco LIKE '3%' AND caractprodutoquimico.qtdatual > 1000 AND
          caractprodutoquimico.unidade LIKE 'm%')
      OR (refprodutoperigoso.classerisco LIKE '4.1%') OR (refprodutoperigoso.classerisco LIKE '4.2%') OR
      (refprodutoperigoso.classerisco LIKE '5%')
      OR (refprodutoperigoso.classerisco LIKE '6%' AND caractprodutoquimico.qtdatual > 5 AND
          caractprodutoquimico.unidade LIKE 'm%')
      OR (refprodutoperigoso.classerisco LIKE '7%'));

    IF contador > 0
    THEN
      vargraurisco3 = 3;
      risco_ = risco_ || ' prod. perigoso(3)';
    END IF;

    soma = soma + coalesce(vargraurisco3);

    -- Classifica grau de risco segundo distância da atividade a Sítios Frágeis
    -- Dentro de Área Legalmente Protegida
    SELECT INTO varbooleano1 ST_INTERSECTS(caractativpotimpactanteempresa.the_geom, arealegalmenteprotegida.the_geom)
    FROM caractativpotimpactanteempresa, arealegalmenteprotegida
    WHERE idativ = registro.idativ;

    IF varbooleano1 = 't'
    THEN
      soma = soma + 3;
    END IF;

    -- Dentro de Assentamento Humano
    SELECT INTO varbooleano1 ST_INTERSECTS(caractativpotimpactanteempresa.the_geom, assentamentohumano.the_geom)
    FROM caractativpotimpactanteempresa, assentamentohumano
    WHERE idativ = registro.idativ;

    IF varbooleano1 = 't'
    THEN
      soma = soma + 3;
    END IF;

    -- Distância a Assentamento Humano
    varregistronum2 = 0;
    /* ANTIGO
    SELECT INTO varregistronum1 min(ST_DISTANCE(ST_TRANSFORM(caractativpotimpactanteempresa.the_geom,29195), ST_TRANSFORM(assentamentohumano.the_geom,29195)))
      FROM caractativpotimpactanteempresa, assentamentohumano
      WHERE idativ = registro.idativ AND ST_INTERSECTS(caractativpotimpactanteempresa.the_geom,assentamentohumano.the_geom) = 'f';
    */

    SELECT INTO varregistronum1
      min(ST_DISTANCE(caractativpotimpactanteempresa.the_geom, assentamentohumano.the_geom)) * 111000
    FROM caractativpotimpactanteempresa, assentamentohumano
    WHERE idativ = registro.idativ AND
          ST_INTERSECTS(caractativpotimpactanteempresa.the_geom, assentamentohumano.the_geom) = 'f';

    vargraurisco1 = 0;
    IF varregistronum1 <= 500
    THEN
      vargraurisco1 = 1;
      risco_ = risco_ || ' dist. <=500 (1)';
    ELSIF varregistronum1 > 500 AND varregistronum1 <= 1000
      THEN
        vargraurisco1 = 2;
        risco_ = risco_ || ' dist. >500 <1000 (2)';
    ELSIF varregistronum1 > 1000
      THEN
        vargraurisco1 = 3;
        risco_ = risco_ || ' dist. >1000 (3)';
    END IF;

    soma = soma + vargraurisco1;

    -- Distância a demais Sítios Frágeis
    -- Captação
    varregistronum1 = 0;
    /* ANTIGO
    SELECT INTO varregistronum1 min(ST_DISTANCE(ST_TRANSFORM(caractativpotimpactanteempresa.the_geom,29195), ST_TRANSFORM(captacao.the_geom,29195)))
      FROM caractativpotimpactanteempresa, captacao
      WHERE idativ = registro.idativ;
    */

    SELECT INTO varregistronum1 min(ST_DISTANCE(caractativpotimpactanteempresa.the_geom, captacao.the_geom)) * 111000
    FROM caractativpotimpactanteempresa, captacao
    WHERE idativ = registro.idativ;

    vargraurisco1 = 0;
    IF varregistronum1 > 500
    THEN
      vargraurisco1 = 1;
      risco_ = risco_ || ' dist. captação >500 (1)';
    ELSIF varregistronum1 <= 500
      THEN
        vargraurisco1 = 2;
        risco_ = risco_ || ' dist. captação <500 (2)';
    END IF;

    soma = soma + vargraurisco1;

    -- Áreas de Recarga de Aquífero
    varregistronum1 = 0;
    /* ANTIGO
    SELECT INTO varregistronum1 min(ST_DISTANCE(ST_TRANSFORM(caractativpotimpactanteempresa.the_geom,29195), ST_TRANSFORM(arearecargaaquifero.the_geom,29195)))
      FROM caractativpotimpactanteempresa, arearecargaaquifero
      WHERE idativ = registro.idativ;
    */

    SELECT INTO varregistronum1
      min(ST_DISTANCE(caractativpotimpactanteempresa.the_geom, arearecargaaquifero.the_geom)) * 111000
    FROM caractativpotimpactanteempresa, arearecargaaquifero
    WHERE idativ = registro.idativ;

    vargraurisco1 = 0;
    IF varregistronum1 > 500
    THEN
      vargraurisco1 = 1;
      risco_ = risco_ || ' dist. aquífero >500 (1)';
    ELSIF varregistronum1 <= 500
      THEN
        vargraurisco1 = 2;
        risco_ = risco_ || ' dist. aquífero <500 (2)';
    END IF;

    soma = soma + vargraurisco1;

    -- Recursos Hídricos
    varregistronum1 = 0;
    /* ANTIGO
    SELECT INTO varregistronum1 min(ST_DISTANCE(ST_TRANSFORM(caractativpotimpactanteempresa.the_geom,29195), ST_TRANSFORM(rechidrrepresentativo.the_geom,29195)))
      FROM caractativpotimpactanteempresa, rechidrrepresentativo
      WHERE idativ = registro.idativ;
    */

    SELECT INTO varregistronum1
      min(ST_DISTANCE(caractativpotimpactanteempresa.the_geom, rechidrrepresentativo.the_geom)) * 111000
    FROM caractativpotimpactanteempresa, rechidrrepresentativo
    WHERE idativ = registro.idativ;

    vargraurisco1 = 0;
    IF varregistronum1 > 500
    THEN
      vargraurisco1 = 1;
      risco_ = risco_ || ' dist. rec. hídricos>500 (1)';
    ELSIF varregistronum1 <= 500
      THEN
        vargraurisco1 = 2;
        risco_ = risco_ || ' dist. rec. hídricos <500 (2)';
    END IF;

    soma = soma + vargraurisco1;

    -- Distância a Unidades de Resposta
    /* ANTIGO
    SELECT INTO varregistronum1 min(ST_DISTANCE(ST_TRANSFORM(caractativpotimpactanteempresa.the_geom,29195), ST_TRANSFORM(unidaderespacidente.the_geom,29195)))
      FROM caractativpotimpactanteempresa, unidaderespacidente
      WHERE idativ = registro.idativ AND ST_INTERSECTS(caractativpotimpactanteempresa.the_geom,unidaderespacidente.the_geom) = 'f';
    */

    SELECT INTO varregistronum1
      min(ST_DISTANCE(caractativpotimpactanteempresa.the_geom, unidaderespacidente.the_geom)) * 111000
    FROM caractativpotimpactanteempresa, unidaderespacidente
    WHERE idativ = registro.idativ AND
          ST_INTERSECTS(caractativpotimpactanteempresa.the_geom, unidaderespacidente.the_geom) = 'f';

    vargraurisco1 = 0;
    IF varregistronum1 <= 1000
    THEN
      vargraurisco1 = 0;
    ELSIF varregistronum1 > 1000 AND varregistronum1 <= 2000
      THEN
        vargraurisco1 = 1;
        risco_ = risco_ || ' dist. unid. resposta entre 1000 e 2000 (1)';

    ELSIF varregistronum1 > 2000 AND varregistronum1 <= 5000
      THEN
        vargraurisco1 = 2;
        risco_ = risco_ || ' dist. unid. resposta <5000 (2)';

    ELSIF varregistronum1 > 5000
      THEN
        vargraurisco1 = 3;
        risco_ = risco_ || ' dist. unid. resposta > 5000 (3)';
    END IF;

    soma = soma + coalesce(vargraurisco1);

    -- Existência de Estruturas de Contenção e Instrumentos de Gestão Ambiental
    SELECT INTO contador count(*)
    FROM caractativpotimpactanteempresa
      INNER JOIN public.empresa ON (caractativpotimpactanteempresa.idemp = empresa.idemp)
      INNER JOIN public.estrutcontinstrgestambempresa
        ON (caractativpotimpactanteempresa.idemp = estrutcontinstrgestambempresa.idemp)
    WHERE caractativpotimpactanteempresa.idemp = registro.idemp AND
          estrutcontinstrgestambempresa.sistmonitoramento IS NOT NULL AND
          UPPER(estrutcontinstrgestambempresa.sistmonitoramento) LIKE '%SIM%';

    IF contador > 0
    THEN
      vargraurisco1 = -2;
      risco_ = risco_ || ' contenção e estr. ambiental(-2)';
    ELSIF contador = 0
      THEN
        vargraurisco1 = 0;
    END IF;

    soma = soma + vargraurisco1;

    SELECT INTO contador count(*)
    FROM caractativpotimpactanteempresa
      INNER JOIN public.empresa ON (caractativpotimpactanteempresa.idemp = empresa.idemp)
      INNER JOIN public.estrutcontinstrgestambempresa
        ON (caractativpotimpactanteempresa.idemp = estrutcontinstrgestambempresa.idemp)
    WHERE caractativpotimpactanteempresa.idativ = registro.idativ AND
          estrutcontinstrgestambempresa.planemergencia IS NOT NULL AND
          UPPER(estrutcontinstrgestambempresa.planemergencia) LIKE '%SIM%';

    IF contador > 0
    THEN
      vargraurisco1 = -3;
      risco_ = risco_ || ' Plano de emergência(-3)';
    ELSIF contador = 0
      THEN
        vargraurisco1 = 0;
    END IF;

    soma = soma + vargraurisco1;

    SELECT INTO contador count(*)
    FROM caractativpotimpactanteempresa
      INNER JOIN public.empresa ON (caractativpotimpactanteempresa.idemp = empresa.idemp)
      INNER JOIN public.estrutcontinstrgestambempresa
        ON (caractativpotimpactanteempresa.idemp = estrutcontinstrgestambempresa.idemp)
    WHERE caractativpotimpactanteempresa.idativ = registro.idativ AND
          estrutcontinstrgestambempresa.certifqualidade IS NOT NULL AND
          UPPER(estrutcontinstrgestambempresa.certifqualidade) LIKE '%SIM%';

    IF contador > 0
    THEN
      vargraurisco1 = -1;
      risco_ = risco_ || ' Cert. Qualidade(-1)';
    ELSIF contador = 0
      THEN
        vargraurisco1 = 0;
    END IF;

    soma = soma + vargraurisco1;

    SELECT INTO contador count(*)
    FROM caractativpotimpactanteempresa
      INNER JOIN public.empresa ON (caractativpotimpactanteempresa.idemp = empresa.idemp)
      INNER JOIN public.estrutcontinstrgestambempresa
        ON (caractativpotimpactanteempresa.idemp = estrutcontinstrgestambempresa.idemp)
    WHERE caractativpotimpactanteempresa.idativ = registro.idativ AND
          estrutcontinstrgestambempresa.estrutcontencao IS NOT NULL AND
          UPPER(estrutcontinstrgestambempresa.estrutcontencao) LIKE '%SIM%';

    IF contador > 0
    THEN
      vargraurisco1 = -2;
    ELSIF contador = 0
      THEN
        vargraurisco1 = 0;
    END IF;

    soma = soma + vargraurisco1;

    -- Grava no banco grau de risco para cada registro de atividade potencialmente impactante
    UPDATE public.caractativpotimpactanteempresa
    SET graurisco = soma, risco = substring(risco_, 0, 150)
    WHERE idativ = registro.idativ;

    --RAISE NOTICE 'Valor de Risco =  % ', risco_;
    --risco_='';

  END LOOP;

END;
$BODY$
LANGUAGE plpgsql
VOLATILE
COST 100;
ALTER FUNCTION public.algp2r2apifontesfixas()
OWNER TO postgres;

-- DETERMINA GRAUS DE RISCO EM ATIVIDADES POTENCIALMENTE IMPACTANTES - FONTES MÓVEIS
-- Function: public.algp2r2apifontesmoveis()

-- DROP FUNCTION public.algp2r2apifontesmoveis();

CREATE OR REPLACE FUNCTION public.algp2r2apifontesmoveis()
  RETURNS VOID AS
$BODY$

DECLARE
  contador        INT;
  registro        RECORD;
  vargraurisco1   INT;
  vargraurisco2   INT;
  vargraurisco3   INT;
  varregistronum1 NUMERIC;
  varregistronum2 NUMERIC;
  varbooleano1    BOOLEAN;
  soma            INT;
  texto           VARCHAR;
  risco_          VARCHAR;

BEGIN
  -- DETERMINA GRAUS DE RISCO EM ATIVIDADES POTENCIALMENTE IMPACTANTES - FONTES MÓVEIS

  FOR registro IN SELECT *
                  FROM public.caractativpotimpactanteemptransp
                  ORDER BY idativ LOOP
    -- Grau de risco para modal de transporte
    soma = 0;
    risco_ = '';
    vargraurisco1 = 0;
    IF UPPER(registro.modalidadetransp) LIKE '%RODOVIÁRIO%' AND UPPER(registro.porte) LIKE '%PEQUENO%'
    THEN
      vargraurisco1 = 1;
      risco_ = risco_ || ' Porte Peq.(1)';
    ELSIF UPPER(registro.modalidadetransp) LIKE '%RODOVIÁRIO%' AND UPPER(registro.porte) LIKE '%MÉDIO%'
      THEN
        vargraurisco1 = 2;
        risco_ = risco_ || ' Porte Médio(2)';
    ELSIF UPPER(registro.modalidadetransp) LIKE '%RODOVIÁRIO%' AND UPPER(registro.porte) LIKE '%GRANDE%'
      THEN
        vargraurisco1 = 3;
        risco_ = risco_ || ' Grande Porte (3)';
    ELSIF UPPER(registro.modalidadetransp) LIKE '%FERROVIÁRIO%'
      THEN
        vargraurisco1 = 2;
        risco_ = risco_ || ' Ferroviário (2)';
    ELSIF UPPER(registro.modalidadetransp) LIKE '%FLUVIAL%'
      THEN
        vargraurisco1 = 2;
        risco_ = risco_ || ' Fluvial(2)';
    ELSIF UPPER(registro.modalidadetransp) LIKE '%MARÍTIMO%'
      THEN
        vargraurisco1 = 1;
        risco_ = risco_ || ' Marítimo (1)';
    ELSIF UPPER(registro.modalidadetransp) LIKE '%DUTOVIÁRIO%'
      THEN
        vargraurisco1 = 2;
        risco_ = risco_ || ' Dutoviário (2)';
    END IF;

    soma = vargraurisco1;

    -- Grau de risco para Produto Perigoso
    vargraurisco2 = 0;
    SELECT INTO contador count(*)
    FROM caractativpotimpactanteemptransp
      INNER JOIN public.caractprodutoquimtransportado
        ON (caractativpotimpactanteemptransp.idativ = caractprodutoquimtransportado.idativ)
      --INNER JOIN public.refprodutoperigoso ON (caractprodutoquimtransportado.numonu = refprodutoperigoso.numonu)
      INNER JOIN public.refprodutoperigoso
        ON (caractprodutoquimtransportado.refprodutoperigoso_id = refprodutoperigoso.idrefprodperigoso)
    WHERE caractativpotimpactanteemptransp.idativ = registro.idativ AND refprodutoperigoso.classerisco IS NOT NULL AND
          (refprodutoperigoso.classerisco LIKE '9%');

    IF contador > 0
    THEN
      vargraurisco2 = 1;
      risco_ = risco_ || ' Prod. Classe 9xx(1)';
    ELSE
      vargraurisco2 = 0;
    END IF;

    SELECT INTO contador count(*)
    FROM caractativpotimpactanteemptransp
      INNER JOIN public.caractprodutoquimtransportado
        ON (caractativpotimpactanteemptransp.idativ = caractprodutoquimtransportado.idativ)
      --INNER JOIN public.refprodutoperigoso ON (caractprodutoquimtransportado.numonu = refprodutoperigoso.numonu)
      INNER JOIN public.refprodutoperigoso
        ON (caractprodutoquimtransportado.refprodutoperigoso_id = refprodutoperigoso.idrefprodperigoso)
    WHERE caractativpotimpactanteemptransp.idativ = registro.idativ AND refprodutoperigoso.classerisco IS NOT NULL AND
          ((refprodutoperigoso.classerisco LIKE '8%')
           OR (refprodutoperigoso.classerisco LIKE '2.1%' AND caractprodutoquimtransportado.qtdatualanual <= 6 AND
               caractprodutoquimtransportado.unidade LIKE 'ton%') OR (refprodutoperigoso.classerisco LIKE '2.2%')
           OR (refprodutoperigoso.classerisco LIKE '2.3%' AND caractprodutoquimtransportado.qtdatualanual <= 350 AND
               caractprodutoquimtransportado.unidade LIKE 'kg%') OR
           (refprodutoperigoso.classerisco LIKE '3%' AND caractprodutoquimtransportado.qtdatualanual <= 1000 AND
            caractprodutoquimtransportado.unidade LIKE 'm%')
           OR (refprodutoperigoso.classerisco LIKE '4.3%') OR
           (refprodutoperigoso.classerisco LIKE '6%' AND caractprodutoquimtransportado.qtdatualanual <= 5 AND
            caractprodutoquimtransportado.unidade LIKE 'm%'));

    IF contador > 0
    THEN
      vargraurisco2 = 2;
      risco_ = risco_ || ' Qtde Transportada(2)';
    END IF;

    SELECT INTO contador count(*)
    FROM caractativpotimpactanteemptransp
      INNER JOIN public.caractprodutoquimtransportado
        ON (caractativpotimpactanteemptransp.idativ = caractprodutoquimtransportado.idativ)
      --INNER JOIN public.refprodutoperigoso ON (caractprodutoquimtransportado.numonu = refprodutoperigoso.numonu)
      INNER JOIN public.refprodutoperigoso
        ON (caractprodutoquimtransportado.refprodutoperigoso_id = refprodutoperigoso.idrefprodperigoso)
    WHERE caractativpotimpactanteemptransp.idativ = registro.idativ AND refprodutoperigoso.classerisco IS NOT NULL AND (
      (refprodutoperigoso.classerisco LIKE '2.1%' AND caractprodutoquimtransportado.qtdatualanual > 6 AND
       caractprodutoquimtransportado.unidade LIKE 'ton%')
      OR (refprodutoperigoso.classerisco LIKE '2.3%' AND caractprodutoquimtransportado.qtdatualanual > 350 AND
          caractprodutoquimtransportado.unidade LIKE 'kg%')
      OR (refprodutoperigoso.classerisco LIKE '3%' AND caractprodutoquimtransportado.qtdatualanual > 1000 AND
          caractprodutoquimtransportado.unidade LIKE 'm%')
      OR (refprodutoperigoso.classerisco LIKE '4.1%') OR (refprodutoperigoso.classerisco LIKE '4.2%') OR
      (refprodutoperigoso.classerisco LIKE '5%')
      OR (refprodutoperigoso.classerisco LIKE '6%' AND caractprodutoquimtransportado.qtdatualanual > 5 AND
          caractprodutoquimtransportado.unidade LIKE 'm%')
      OR (refprodutoperigoso.classerisco LIKE '7%'));

    IF contador > 0
    THEN
      vargraurisco2 = 3;
      risco_ = risco_ || ' Qtde Transportada(3)';
    END IF;

    soma = soma + coalesce(vargraurisco2);

    -- Existência de Estruturas de Contenção e Instrumentos de Gestão Ambiental
    SELECT INTO contador count(*)
    FROM caractativpotimpactanteemptransp
      INNER JOIN public.empresatransporte
        ON (caractativpotimpactanteemptransp.idemptransp = empresatransporte.idemptransp)
      INNER JOIN public.estrutcontinstrgestambemptransp
        ON (empresatransporte.idemptransp = estrutcontinstrgestambemptransp.idemptransp)
    WHERE caractativpotimpactanteemptransp.idativ = registro.idativ AND
          estrutcontinstrgestambemptransp.sistmonitoramento IS NOT NULL AND
          UPPER(estrutcontinstrgestambemptransp.sistmonitoramento) LIKE '%SIM%';

    IF contador > 0
    THEN
      vargraurisco1 = -2;
      risco_ = risco_ || ' Monitoramento(-2)';
    ELSIF contador = 0
      THEN
        vargraurisco1 = 0;
    END IF;

    soma = soma + vargraurisco1;

    SELECT INTO contador count(*)
    FROM caractativpotimpactanteemptransp
      INNER JOIN public.empresatransporte
        ON (caractativpotimpactanteemptransp.idemptransp = empresatransporte.idemptransp)
      INNER JOIN public.estrutcontinstrgestambemptransp
        ON (empresatransporte.idemptransp = estrutcontinstrgestambemptransp.idemptransp)
    WHERE caractativpotimpactanteemptransp.idativ = registro.idativ AND
          estrutcontinstrgestambemptransp.planemergencia IS NOT NULL AND
          UPPER(estrutcontinstrgestambemptransp.planemergencia) LIKE '%SIM%';

    IF contador > 0
    THEN
      vargraurisco1 = -3;
      risco_ = risco_ || ' Plano de Emerg.(-3)';
    ELSIF contador = 0
      THEN
        vargraurisco1 = 0;
    END IF;

    soma = soma + vargraurisco1;

    SELECT INTO contador count(*)
    FROM caractativpotimpactanteemptransp
      INNER JOIN public.empresatransporte
        ON (caractativpotimpactanteemptransp.idemptransp = empresatransporte.idemptransp)
      INNER JOIN public.estrutcontinstrgestambemptransp
        ON (empresatransporte.idemptransp = estrutcontinstrgestambemptransp.idemptransp)
    WHERE caractativpotimpactanteemptransp.idativ = registro.idativ AND
          estrutcontinstrgestambemptransp.certifqualidade IS NOT NULL AND
          UPPER(estrutcontinstrgestambemptransp.certifqualidade) LIKE '%SIM%';

    IF contador > 0
    THEN
      vargraurisco1 = -1;
      risco_ = risco_ || ' Cert. Qualidade(-1)';
    ELSIF contador = 0
      THEN
        vargraurisco1 = 0;
    END IF;

    soma = soma + vargraurisco1;

    SELECT INTO contador count(*)
    FROM caractativpotimpactanteemptransp
      INNER JOIN public.empresatransporte
        ON (caractativpotimpactanteemptransp.idemptransp = empresatransporte.idemptransp)
      INNER JOIN public.estrutcontinstrgestambemptransp
        ON (empresatransporte.idemptransp = estrutcontinstrgestambemptransp.idemptransp)
    WHERE caractativpotimpactanteemptransp.idativ = registro.idativ AND
          estrutcontinstrgestambemptransp.estrutcontencao IS NOT NULL AND
          UPPER(estrutcontinstrgestambemptransp.estrutcontencao) LIKE '%SIM%';

    IF contador > 0
    THEN
      vargraurisco1 = -2;
      risco_ = risco_ || ' Estr. Contenção(-2)';
    ELSIF contador = 0
      THEN
        vargraurisco1 = 0;
    END IF;


    soma = soma + vargraurisco1;

    -- Atualiza grau de risco para a atividade
    UPDATE public.caractativpotimpactanteemptransp
    SET graurisco = soma, risco = substr(risco_, 0, 150)
    WHERE idativ = registro.idativ;
    risco_ = '';
  END LOOP;

  -- Classifica grau de risco segundo distância da atividade a Sítios Frágeis
  -- Dentro de Área Legalmente Protegida

  FOR registro IN SELECT *
                  FROM public.trechoeixoviaprincipal
                  ORDER BY idtrechoeixo LOOP
    soma = 0;
    risco_ = '';
    SELECT INTO varbooleano1 ST_INTERSECTS(trechoeixoviaprincipal.the_geom, arealegalmenteprotegida.the_geom)
    FROM trechoeixoviaprincipal, arealegalmenteprotegida
    WHERE idtrechoeixo = registro.idtrechoeixo;

    IF varbooleano1 = 't'
    THEN
      soma = soma + 3;
      risco_ = risco_ || ' Dist. Sítio Frágil(3)';
    END IF;

    -- Dentro de Assentamento Humano
    SELECT INTO varbooleano1 ST_INTERSECTS(trechoeixoviaprincipal.the_geom, assentamentohumano.the_geom)
    FROM trechoeixoviaprincipal, assentamentohumano
    WHERE idtrechoeixo = registro.idtrechoeixo;

    IF varbooleano1 = 't'
    THEN
      soma = soma + 3;
      risco_ = risco_ || ' Dentro Assent. Humano(3)';
    END IF;

    -- Distância a Assentamento Humano
    varregistronum2 = 0;
    /*ANTIGO
    SELECT INTO varregistronum1 min(ST_DISTANCE(ST_TRANSFORM(trechoeixoviaprincipal.the_geom,29195), ST_TRANSFORM(assentamentohumano.the_geom,29195)))
      FROM trechoeixoviaprincipal, assentamentohumano
      WHERE idtrechoeixo = registro.idtrechoeixo AND ST_INTERSECTS(trechoeixoviaprincipal.the_geom,assentamentohumano.the_geom) = 'f';
    */
    SELECT INTO varregistronum1 min(ST_DISTANCE(trechoeixoviaprincipal.the_geom, assentamentohumano.the_geom)) * 111000
    FROM trechoeixoviaprincipal, assentamentohumano
    WHERE idtrechoeixo = registro.idtrechoeixo AND
          ST_INTERSECTS(trechoeixoviaprincipal.the_geom, assentamentohumano.the_geom) = 'f';

    vargraurisco1 = 0;
    IF varregistronum1 <= 500
    THEN
      vargraurisco1 = 1;
      risco_ = risco_ || ' Dist. <=500(1)';
    ELSIF varregistronum1 > 500 AND varregistronum1 <= 1000
      THEN
        vargraurisco1 = 2;
        risco_ = risco_ || ' Dist. entre 500 e 1000(2)';
    ELSIF varregistronum1 > 1000
      THEN
        vargraurisco1 = 3;
        risco_ = risco_ || ' Dist. >1000(3)';
    END IF;

    soma = soma + vargraurisco1;

    -- Distância a demais Sítios Frágeis
    -- Captação
    varregistronum1 = 0;
    /* ANTIGO
    SELECT INTO varregistronum1 min(ST_DISTANCE(ST_TRANSFORM(trechoeixoviaprincipal.the_geom,29195), ST_TRANSFORM(captacao.the_geom,29195)))
      FROM trechoeixoviaprincipal, captacao
      WHERE idtrechoeixo = registro.idtrechoeixo;
    */
    SELECT INTO varregistronum1 min(ST_DISTANCE(trechoeixoviaprincipal.the_geom, captacao.the_geom)) * 111000
    FROM trechoeixoviaprincipal, captacao
    WHERE idtrechoeixo = registro.idtrechoeixo;

    vargraurisco1 = 0;
    IF varregistronum1 > 500
    THEN
      vargraurisco1 = 1;
      risco_ = risco_ || ' Dist. Captação > 500 (1)';
    ELSIF varregistronum1 <= 500
      THEN
        vargraurisco1 = 2;
        risco_ = risco_ || ' Dist. Captação <= 500 (2)';
    END IF;

    soma = soma + vargraurisco1;

    -- Áreas de Recarga de Aquífero
    varregistronum1 = 0;
    /*ANTIGO
    SELECT INTO varregistronum1 min(ST_DISTANCE(ST_TRANSFORM(trechoeixoviaprincipal.the_geom,29195), ST_TRANSFORM(arearecargaaquifero.the_geom,29195)))
      FROM trechoeixoviaprincipal, arearecargaaquifero
      WHERE idtrechoeixo = registro.idtrechoeixo;
    */
    SELECT INTO varregistronum1 min(ST_DISTANCE(trechoeixoviaprincipal.the_geom, arearecargaaquifero.the_geom)) * 111000
    FROM trechoeixoviaprincipal, arearecargaaquifero
    WHERE idtrechoeixo = registro.idtrechoeixo;

    vargraurisco1 = 0;
    IF varregistronum1 > 500
    THEN
      vargraurisco1 = 1;
      risco_ = risco_ || ' Dist. Aquífero > 500 (1)';
    ELSIF varregistronum1 <= 500
      THEN
        vargraurisco1 = 2;
        risco_ = risco_ || ' Dist. Aquífero <= 500 (2)';
    END IF;

    soma = soma + vargraurisco1;

    -- Recursos Hídricos
    varregistronum1 = 0;
    /*ANTIGO
    SELECT INTO varregistronum1 min(ST_DISTANCE(ST_TRANSFORM(trechoeixoviaprincipal.the_geom,29195), ST_TRANSFORM(rechidrrepresentativo.the_geom,29195)))
      FROM trechoeixoviaprincipal, rechidrrepresentativo
      WHERE idtrechoeixo = registro.idtrechoeixo;
    */
    SELECT INTO varregistronum1
      min(ST_DISTANCE(trechoeixoviaprincipal.the_geom, rechidrrepresentativo.the_geom)) * 111000
    FROM trechoeixoviaprincipal, rechidrrepresentativo
    WHERE idtrechoeixo = registro.idtrechoeixo;

    vargraurisco1 = 0;
    IF varregistronum1 > 500
    THEN
      vargraurisco1 = 1;
      risco_ = risco_ || ' Dist. Rec. Hídricos > 500 (1)';
    ELSIF varregistronum1 <= 500
      THEN
        vargraurisco1 = 2;
        risco_ = risco_ || ' Dist. Rec. Hídricos <= 500 (2)';
    END IF;

    soma = soma + vargraurisco1;

    -- Distância a Unidades de Resposta
    /*ANTIGO
    SELECT INTO varregistronum1 min(ST_DISTANCE(ST_TRANSFORM(trechoeixoviaprincipal.the_geom,29195), ST_TRANSFORM(unidaderespacidente.the_geom,29195)))
      FROM trechoeixoviaprincipal, unidaderespacidente
      WHERE idtrechoeixo = registro.idtrechoeixo AND ST_INTERSECTS(trechoeixoviaprincipal.the_geom,unidaderespacidente.the_geom) = 'f';
    */
    SELECT INTO varregistronum1 min(ST_DISTANCE(trechoeixoviaprincipal.the_geom, unidaderespacidente.the_geom)) * 111000
    FROM trechoeixoviaprincipal, unidaderespacidente
    WHERE idtrechoeixo = registro.idtrechoeixo AND
          ST_INTERSECTS(trechoeixoviaprincipal.the_geom, unidaderespacidente.the_geom) = 'f';

    vargraurisco1 = 0;
    IF varregistronum1 <= 1000
    THEN
      vargraurisco1 = 0;
    ELSIF varregistronum1 > 1000 AND varregistronum1 <= 2000
      THEN
        vargraurisco1 = 1;
        risco_ = risco_ || ' Dist. Un. Resposta <= 2000 (1)';
        risco_ = risco_ || ' Dist. Un. Resposta <= 2000 (1)';
    ELSIF varregistronum1 > 2000 AND varregistronum1 <= 5000
      THEN
        vargraurisco1 = 2;
        risco_ = risco_ || ' Dist. Un. Resposta 2000~5000 (2)';
    ELSIF varregistronum1 > 5000
      THEN
        vargraurisco1 = 3;
        risco_ = risco_ || ' Dist. Un. Resposta >5000 (3)';
    END IF;

    soma = soma + coalesce(vargraurisco1);

    -- Identifica o(s) registro(s) com grau máximo de risco na tabela de caracterização da atividade (fonte móvel)
    -- e soma o grau ao valor de risco do trecho da via

    SELECT INTO contador max(graurisco)
    FROM caractativpotimpactanteemptransp
    WHERE viaestacref LIKE $$'%$$ || registro.denominacao || $$%'$$;

    vargraurisco2 = 0;
    IF contador <> 0 OR contador IS NOT NULL
    THEN
      vargraurisco2 = contador;
      risco_ = risco_ || ' ' || to_char(contador);
    END IF;

    soma = soma + coalesce(vargraurisco2);

    UPDATE public.trechoeixoviaprincipal
    SET graurisco = soma, risco = substr(risco_, 0, 150)
    WHERE idtrechoeixo = registro.idtrechoeixo;
  END LOOP;

END;
$BODY$
LANGUAGE plpgsql
VOLATILE
COST 100;
ALTER FUNCTION public.algp2r2apifontesmoveis()
OWNER TO postgres;

-- CRUZAMENTOS ESPACIAIS
-- Junção de todas as atividades potencialmente impactantes (Fontes Fixas e Móveis), Áreas Contaminadas e Históricos de Ocorrência de Acidentes,
-- para gerar áreas de risco ambiental

-- Function: public.alg2r2areasriscoamb()

-- DROP FUNCTION public.alg2r2areasriscoamb();

CREATE OR REPLACE FUNCTION public.alg2r2areasriscoamb()
  RETURNS VOID AS
$BODY$

DECLARE

BEGIN

  -- CRUZAMENTOS ESPACIAIS
  -- Junção de todas as atividades potencialmente impactantes (Fontes Fixas e Móveis), Áreas Contaminadas e Históricos de Ocorrência de Acidentes,
  -- para gerar áreas de risco ambiental
  TRUNCATE algapiocoracidhistacid;

  INSERT INTO algapiocoracidhistacid (the_geom, graurisco, risco)
    SELECT
      ST_MemUnion(ST_Buffer(caractativpotimpactanteempresa.the_geom, 0.004535)),
      graurisco,
      risco
    FROM caractativpotimpactanteempresa
    GROUP BY graurisco, risco;

  INSERT INTO algapiocoracidhistacid (the_geom, graurisco, risco)
    SELECT
      ST_MemUnion(ST_Buffer(trechoeixoviaprincipal.the_geom, 0.001)),
      graurisco,
      risco
    FROM trechoeixoviaprincipal
    GROUP BY graurisco, risco;

  INSERT INTO algapiocoracidhistacid (the_geom, graurisco, risco)
    SELECT
      ST_MemUnion(ST_Buffer(areacontampassivoambiental.the_geom, 0.0000000001)),
      graurisco,
      risco
    FROM areacontampassivoambiental
    GROUP BY graurisco, risco;

  INSERT INTO algapiocoracidhistacid (the_geom, graurisco, risco)
    SELECT
      ST_MemUnion(ST_Buffer(historicoocoracidente.the_geom, 0.00907)),
      graurisco,
      risco
    FROM historicoocoracidente
    GROUP BY graurisco, risco;

  -- Junção de todos os sítios frágeis e vulneráveis
  TRUNCATE algsitiofragil;
  INSERT INTO algsitiofragil (graurisco, the_geom, risco)
    SELECT
      graurisco,
      ST_MemUnion(ST_Buffer(the_geom, 0.0000000001)),
      risco
    FROM arearecargaaquifero
    GROUP BY graurisco, the_geom, risco;

  INSERT INTO algsitiofragil (graurisco, the_geom, risco)
    SELECT
      graurisco,
      ST_MemUnion(ST_Buffer(the_geom, 0.0000000001)),
      risco
    FROM arealegalmenteprotegida
    GROUP BY graurisco, risco;

  /*ANTIGO
  INSERT INTO algsitiofragil (graurisco,the_geom,risco)
  SELECT graurisco,ST_MemUnion(ST_Buffer(the_geom,0.000000005)),risco
  FROM assentamentohumano
  WHERE idassenthumano = 234
  GROUP BY graurisco,risco;
  */
  INSERT INTO algsitiofragil (graurisco, the_geom, risco)
    SELECT
      graurisco,
      ST_UnaryUnion(ST_Buffer(grp, 0.00001)) AS ST_MemUnion,
      risco
    FROM
      (SELECT
         graurisco,
         risco,
         unnest(ST_ClusterWithin(the_geom, 0.5)) AS grp
       FROM assentamentohumano
       GROUP BY graurisco, risco) sq;


  INSERT INTO algsitiofragil (graurisco, the_geom, risco)
    SELECT
      graurisco,
      ST_MemUnion(ST_Buffer(captacao.the_geom, 0.001)),
      risco
    FROM captacao
    GROUP BY graurisco, risco;

  -- Cruzamento das atividades potencialmente impactantes com os sítios frágeis para a identificação das áreas de risco ambiental
  TRUNCATE algdissolveareariscoamb;
  INSERT INTO algdissolveareariscoamb (the_geom, graurisco, risco)
    SELECT
      ST_Intersection(algapiocoracidhistacid.the_geom, algsitiofragil.the_geom),
      (algapiocoracidhistacid.graurisco + algsitiofragil.graurisco),
      substr(algapiocoracidhistacid.risco || algsitiofragil.risco, 0, 150)
    FROM algapiocoracidhistacid, algsitiofragil;

  -- Agrega polígonos adjacentes com os mesmos graus de risco para gerar as áreas de risco ambiental
  TRUNCATE areariscoambiental;
  INSERT INTO areariscoambiental (graurisco, the_geom, risco)
    SELECT
      graurisco,
      ST_MemUnion(ST_Buffer(the_geom, 0.000000005)),
      risco
    FROM algdissolveareariscoamb
    WHERE graurisco IS NOT NULL
    GROUP BY graurisco, risco;

END;

$BODY$
LANGUAGE plpgsql
VOLATILE
COST 100;
ALTER FUNCTION public.alg2r2areasriscoamb()
OWNER TO postgres;