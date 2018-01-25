# Análise e melhorias do Banco de Dados P2R2

Ao executarmos pela primeira vez a função **algoritmop2r2()** foram encontrados diversos erros que tiveram de ser corrigidos para que fosse possível executá-la:


* Criar a coluna *the_geom* na tabela **areacontampassivoambiental**;
* Adicionar coluna *risco* na tabela **areacontampassivoambiental**;
* Adicionar coluna *idpassivo* na tabela **meioimpactado**;
* Adicionar coluna *idpassivo* na tabela **produtoquimareacontaminada**;
* Adicionar coluna *idpassivo* na tabela **residuoareacontampasamb**;
* Adicionar coluna *idpassivo* na tabela **estrutcontinstrgestambareacontam**;


Após estas mudanças finalmente o **algoritmop2r2()** foi executado sem erros.

### Foi criado um script consolidado que cria todas as mudanças necessárias e também índices e chaves estrangeiras entre as tabelas ([ver script][fix]).

Em seguida foi analisado o motivo da demora da execução do algoritmo.
Cada SELECT foi analisado/executado individualmente para descobrir onde estava o gargalo.
Depois de muito estudo foi descoberto que algumas consultas espaciais precisavam ser otimizadas, e alguns índices precisariam ser criados.

Após estes ajustes o tempo de execução foi reduzido drasticamente. O algoritmo que ficava horas em execução, atualmente está rodando entre 5 e 6 minutos.

Por último chegou a hora de analisar todas as tabelas do banco, uma a uma.
Foram detectados relacionamentos não recomendáveis, colunas sem índices, redundância de colunas na mesma tabela, falta de integridade referencial entre várias tabelas, campos com tipos não recomendados, tabelas sem utilização, etc.

### Resumo do que foi customizado até o momento:
<ul>
  <li><b>CAMPOS REMOVIDOS:</b> 21</li>
  <li><b>CAMPOS CRIADOS:</b> 14</li>
  <li><b>FK REMOVIDAS:</b> 18</li>
  <li><b>FK CRIADAS:</b> 19</li>
  <li><b>ÍNDICES CRIADOS:</b> 51</li>
  <li><b>ÍNDICES REMOVIDOS:</b> 1</li>
</ul>

### Todas as mudanças acima foram consolidadas em um único script SQL ([ver script][geral]).

Após todas estas mudanças foi preciso analisar todas as funções envolvidas no algoritmop2r2 e em seguida feito os devidos ajustes (pois algumas colunas foram removidas, outras criadas, então os relacionamentos mudaram).

### Todos os ajustes efetuados também foram consolidados em um único script SQL ([ver script][funcoes]).

### Finalizando ...

Para representar todas as etapas acima mencionadas, basta restaurar o banco original e executar os 03 scripts na ordem acima.
Por último chamar o algoritmop2r2:

```sql
SELECT algoritmop2r2()
```

[fix]:scripts/01-FIX-para-rodar-a-funcao-do-algoritmop2r2.sql

[geral]:scripts/02-Ajustes-GERAL.sql

[funcoes]:scripts/03-Funcoes.sql
