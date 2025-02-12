/*CONSULTA PARA CUBO DE CONFERENCIA DA FOLHA*/
SELECT FI.CODEVENTO,
			FI.CODCOLIGADA,
            PE.DESCRICAO,
            FI.MESCOMP,
            FI.ANOCOMP,
            FI.CHAPA,
            PF.NOME,
            PF.JORNADAMENSAL,
            FF.NOME AS FUNÇÃO,
            CC.CODCCUSTO,
            PC.NOME AS CCUSTO,
            PE.PROVDESCBASE,

      CASE WHEN PE.PROVDESCBASE = 'D' THEN FI.REF *-1
         ELSE FI.REF
             END REF,
      CASE WHEN PE.PROVDESCBASE = 'D' THEN CC.VALOR*-1
         ELSE CC.VALOR
             END VALOR
FROM PFFINANC FI
JOIN PFUNC PF
      ON FI.CODCOLIGADA = PF.CODCOLIGADA AND FI.CHAPA = PF.CHAPA
JOIN GCOLIGADA GC
      ON GC.CODCOLIGADA=PF.CODCOLIGADA
JOIN PCCUSTO PC
      ON PC.CODCOLIGADA=GC.CODCOLIGADA
JOIN PFMOVCC CC
      ON CC.CODCOLIGADA=PC.CODCOLIGADA AND CC.CODCCUSTO=PC.CODCCUSTO
      AND CC.CODCOLIGADA = FI.CODCOLIGADA AND CC.CHAPA = FI.CHAPA
      AND CC.CODEVENTO = FI.CODEVENTO AND CC.ANOCOMP = FI.ANOCOMP 
      AND CC.MESCOMP = FI.MESCOMP AND CC.NROPERIODO = FI.NROPERIODO
JOIN PEVENTO PE
      ON PE.CODCOLIGADA = FI.CODCOLIGADA AND PE.CODIGO = FI.CODEVENTO
JOIN PFUNCAO FF
      ON FF.CODCOLIGADA = PF.CODCOLIGADA AND FF.CODIGO=PF.CODFUNCAO

WHERE 1=1 
-- FI.CODCOLIGADA=''
AND FI.ANOCOMP >= 2020
-- AND FI.MESCOMP>=''
AND FI.VALOR<>0
AND (PF.DTTRANSFERENCIA IS NULL
 OR  PF.DTTRANSFERENCIA <= (CONVERT (DATETIME, (CONVERT (VARCHAR,  '16/' + cast(FI.MESCOMP as varchar(10)) + '/' + cast(FI.ANOCOMP as varchar(10)) )),103))
 )