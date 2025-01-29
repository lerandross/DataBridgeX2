select
    pl.CODPERLET as 'ano_letivo'
    ,mpl.CODTURMA
    ,av.NOME as 'avaliacao'
    ,ava.AVALIACAOALUNO
    ,avt.AVALIACAOTURMADISC
    ,td.CODDISC
    ,sd.NOME as 'disciplina'
    ,mat.RA
    ,p.NOME 
    ,ava.NOTA
    ,pg.TIPO
    ,pg.RESPOSTAS
    ,pg.SOLUCOES AS GABARITO
    ,getdate() as ultima_atualizacao
    ,CASE    
        WHEN td.CODDISC LIKE '%.I' THEN 'Interdisciplinar'
        WHEN td.CODDISC LIKE '%.E' THEN 'Eletiva'
        WHEN (td.CODDISC = 'ING' OR td.CODDISC = 'ESP') THEN 'Turma Mista'
        ELSE 'Regular'
        END AS TIPO_DISCIPLINA,
    CASE
        WHEN SHF.CODGRADE IN ('0301','0302','0303') THEN 'Ensino Médio'
        WHEN (SHF.CODGRADE LIKE '%.B' OR SHF.CODGRADE LIKE '%.1') THEN 'Integral'
        ELSE 'Parcial'
        END AS GRADE_PERIODO
from
    CorporeRM.dbo.SMATRICULA mat
    inner join
            CorporeRM.dbo.SPLETIVO pl on pl.CODCOLIGADA = mat.CODCOLIGADA and pl.IDPERLET = mat.IDPERLET
    inner join
            CorporeRM.dbo.SSTATUS sst on sst.CODCOLIGADA = mat.CODCOLIGADA and sst.CODSTATUS = mat.CODSTATUS
    inner join
            CorporeRM.dbo.SALUNO sa on sa.CODCOLIGADA = mat.CODCOLIGADA and sa.RA = mat.RA
    INNER JOIN 
            CorporeRM.dbo.SMATRICPL MPL ON MPL.CODCOLIGADA = MAT.CODCOLIGADA AND MPL.IDPERLET = MAT.IDPERLET AND MPL.IDHABILITACAOFILIAL = MAT.IDHABILITACAOFILIAL AND MPL.RA = MAT.RA
    INNER JOIN
            CorporeRM.dbo.SHABILITACAOFILIAL SHF ON SHF.CODCOLIGADA = MPL.CODCOLIGADA AND SHF.IDHABILITACAOFILIAL = MPL.IDHABILITACAOFILIAL
    inner join
            CorporeRM.dbo.PPESSOA p on p.CODIGO = sa.CODPESSOA
    inner join
            CorporeRM.dbo.STURMADISC td on td.CODCOLIGADA = mat.CODCOLIGADA and td.IDTURMADISC = mat.IDTURMADISC
    inner join 
            CorporeRM.dbo.SDISCIPLINA sd on sd.CODCOLIGADA = td.CODCOLIGADA and sd.CODDISC = td.CODDISC
    inner join
            DiarioMB.dbo.AVALIACOESALUNOS ava on ava.RA = mat.RA
    inner join
            DiarioMB.dbo.AVALIACOESTURMASDISC avt on avt.AVALIACAO = ava.AVALIACAO and avt.IDTURMADISC = mat.IDTURMADISC
    inner join
            DiarioMB.dbo.AVALIACOES av on av.AVALIACAO = ava.AVALIACAO
    left join
    (
            select
                pr.RA,
                pg.TIPO,
                pg.PROVA,
                pr.RESPOSTAS,
                g.SOLUCOES
            from
                diario.dbo.PROVAS_RESPOSTAS_17 pr
                inner join
                        diario.dbo.PROVAS_GABARITOS pg on pg.PROVA_GABARITO = pr.PROVA_GABARITO
                inner join
                        diario.dbo.GABARITOS g on g.GABARITO = pg.GABARITO
    ) as pg on pg.RA collate SQL_Latin1_General_CP1_CI_AI = mat.RA and pg.PROVA = avt.AVALIACAOTURMADISC
where
    pl.CODPERLET >= 2023
    and sst.PLATIVO = 'S'
    -- and td.CODTURMA like 'C1%'
    -- and td.CODDISC = 'MAT'
    -- and av.ETAPA = 548
    -- and av.TIPO = 16
    and RESPOSTAS is not NULL
order by
    p.NOME;