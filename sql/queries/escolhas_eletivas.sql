use EscolhaEletivaMB;
select 
    pl.codperlet,
    h.NOME as serie,
    mpl.ra,
    p.nome as aluno,
    d.coddisc+case when g.idioma is not null then ' ('+g.idioma+')' else '' end as disciplina,
    ga.opcao,
    g.aula,
    ga.datahorarec
from
    EscolhaEletivaMB.dbo.gradesalunos ga
    inner join
        EscolhaEletivaMB.dbo.grades g on g.id = ga.idgrade
    inner join
        EscolhaEletivaMB.dbo.series s on s.id = g.idserie
    inner join
        EscolhaEletivaMB.dbo.disciplinas d on d.id = g.iddisciplina
    inner join
        CorporeRM.dbo.SMATRICPL mpl on mpl.ra = ga.ra
    inner join 
        CorporeRM.dbo.SHABILITACAOFILIAL hf on hf.CODCOLIGADA = mpl.CODCOLIGADA and hf.IDHABILITACAOFILIAL = mpl.IDHABILITACAOFILIAL
    inner join 
        CorporeRM.dbo.SHABILITACAO h on h.CODCOLIGADA = hf.CODCOLIGADA and h.CODCURSO = hf.CODCURSO and h.CODHABILITACAO = hf.CODHABILITACAO
    inner join 
        CorporeRM.dbo.SPLETIVO pl on pl.CODCOLIGADA = mpl.CODCOLIGADA and pl.IDPERLET = mpl.IDPERLET and pl.CODPERLET = ga.anoletivo
    inner join 
        CorporeRM.dbo.SSTATUS sst on sst.CODCOLIGADA = mpl.CODCOLIGADA and sst.CODSTATUS = mpl.CODSTATUS
    inner join
        CorporeRM.dbo.SALUNO sa on sa.CODCOLIGADA = mpl.CODCOLIGADA and sa.RA = mpl.RA
    inner join 
        CorporeRM.dbo.PPESSOA p on p.CODIGO = sa.CODPESSOA
    where 
    mpl.CODCOLIGADA in (1,2)

order by 
    hf.CODCURSO,
    hf.CODHABILITACAO,
    ga.opcao,
    d.coddisc