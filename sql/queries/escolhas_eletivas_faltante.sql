select 
    pl.codperlet,
    h.NOME as serie,
    mpl.ra,
    p.nome as aluno
from
    CorporeRM.dbo.SMATRICPL mpl
    inner join 
        CorporeRM.dbo.SHABILITACAOFILIAL hf on hf.CODCOLIGADA = mpl.CODCOLIGADA and hf.IDHABILITACAOFILIAL = mpl.IDHABILITACAOFILIAL
    inner join 
        CorporeRM.dbo.SHABILITACAO h on h.CODCOLIGADA = hf.CODCOLIGADA and h.CODCURSO = hf.CODCURSO and h.CODHABILITACAO = hf.CODHABILITACAO
    inner join 
        CorporeRM.dbo.SPLETIVO pl on pl.CODCOLIGADA = mpl.CODCOLIGADA and pl.IDPERLET = mpl.IDPERLET
    inner join 
        CorporeRM.dbo.SSTATUS sst on sst.CODCOLIGADA = mpl.CODCOLIGADA and sst.CODSTATUS = mpl.CODSTATUS
    inner join
        CorporeRM.dbo.SALUNO sa on sa.CODCOLIGADA = mpl.CODCOLIGADA and sa.RA = mpl.RA
    inner join 
        CorporeRM.dbo.PPESSOA p on p.CODIGO = sa.CODPESSOA
    left join
        EscolhaEletivaMB.dbo.gradesalunos ga on ga.anoletivo = pl.CODPERLET and ga.ra = mpl.RA
where 
    mpl.CODCOLIGADA in (1,2)
	and h.NOME in ('1º ANO - ENSINO MÉDIO','2º ANO - ENSINO MÉDIO','3º ANO - ENSINO MÉDIO')
    and sst.PLATIVO = 'S'
    and pl.CODPERLET = '2025'
    and ga.ra is null
order by 
    hf.CODCURSO,
    hf.CODHABILITACAO,
    p.NOME