WITH ALUNOS_9ANO AS 
(
    SELECT DISTINCT
        SA.RA,
        PP.NOME,
        SH.NOME AS SERIE,
        MPL.CODSTATUS,
        SST.DESCRICAO
    FROM
        SMATRICPL MPL
        INNER JOIN SPLETIVO SPL ON SPL.CODCOLIGADA = MPL.CODCOLIGADA AND SPL.IDPERLET = MPL.IDPERLET
        INNER JOIN SSTATUS SST ON SST.CODCOLIGADA = MPL.CODCOLIGADA AND SST.CODSTATUS = MPL.CODSTATUS
        INNER JOIN SALUNO SA ON SA.CODCOLIGADA = MPL.CODCOLIGADA AND SA.RA = MPL.RA
        INNER JOIN PPESSOA PP ON PP.CODIGO = SA.CODPESSOA
        INNER JOIN SHABILITACAOFILIAL SHF ON SHF.CODCOLIGADA = MPL.CODCOLIGADA AND SHF.IDHABILITACAOFILIAL = MPL.IDHABILITACAOFILIAL
        INNER JOIN SHABILITACAO SH ON SH.CODCOLIGADA = SHF.CODCOLIGADA AND SH.CODCURSO = SHF.CODCURSO AND SH.CODHABILITACAO = SHF.CODHABILITACAO
    WHERE
        MPL.CODCOLIGADA = 1
        AND SST.PLATIVO = 'S'
        AND SHF.CODGRADE IN ('0209','0209.1')
),
ALUNOS_EM AS
(
    SELECT
        SPL.CODPERLET,
        SA.RA,
        PP.NOME,
        MPL.CODTURMA,
        SH.NOME AS SERIE,
        MPL.CODSTATUS,
        SST.DESCRICAO,
        SHF.CODGRADE,
        CONVERT(VARCHAR,SC.DTCANCELAMENTO,103) AS DATA_CANCELAMENTO_CONTRATO
    FROM
        SMATRICPL MPL
        INNER JOIN SPLETIVO SPL ON SPL.CODCOLIGADA = MPL.CODCOLIGADA AND SPL.IDPERLET = MPL.IDPERLET
        INNER JOIN SSTATUS SST ON SST.CODCOLIGADA = MPL.CODCOLIGADA AND SST.CODSTATUS = MPL.CODSTATUS
        INNER JOIN SALUNO SA ON SA.CODCOLIGADA = MPL.CODCOLIGADA AND SA.RA = MPL.RA
        INNER JOIN PPESSOA PP ON PP.CODIGO = SA.CODPESSOA
        INNER JOIN SHABILITACAOFILIAL SHF ON SHF.CODCOLIGADA = MPL.CODCOLIGADA AND SHF.IDHABILITACAOFILIAL = MPL.IDHABILITACAOFILIAL
        INNER JOIN SHABILITACAO SH ON SH.CODCOLIGADA = SHF.CODCOLIGADA AND SH.CODCURSO = SHF.CODCURSO AND SH.CODHABILITACAO = SHF.CODHABILITACAO
        INNER JOIN SCONTRATO SC ON SC.CODCOLIGADA = MPL.CODCOLIGADA AND SC.IDPERLET = MPL.IDPERLET AND SC.RA = MPL.RA AND SC.IDHABILITACAOFILIAL = MPL.IDHABILITACAOFILIAL
    WHERE
        MPL.CODCOLIGADA = 2
        AND SPL.CODPERLET IN ('2022','2023')
        AND SST.PLATIVO = 'N'
        AND SST.DESCRICAO IN ('TRANSFERIDO')
        AND DATEFROMPARTS(SPL.CODPERLET,1,31) < SC.DTCANCELAMENTO
)

SELECT
    AE.CODPERLET,
    AE.RA,
    AE.NOME AS ALUNO,
    AE.SERIE AS SERIE_EVASAO,
    CASE
        WHEN A9.SERIE LIKE '%INTEGRAL%' THEN 'INTEGRAL'
        WHEN A9.SERIE NOT LIKE '%INTEGRAL%' THEN 'PARCIAL'
        WHEN A9.SERIE IS NULL THEN 'ALUNO NOVO'
        END AS ORIGEM_ALUNO,
    AE.DATA_CANCELAMENTO_CONTRATO
FROM
    ALUNOS_EM AE
    LEFT JOIN ALUNOS_9ANO A9 ON A9.RA = AE.RA
WHERE
    AE.CODGRADE IN ('0301','0302')
ORDER BY
    AE.CODPERLET,
    AE.SERIE,
    AE.NOME;