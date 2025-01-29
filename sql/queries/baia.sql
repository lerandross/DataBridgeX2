select 
    sg.DESCRICAO as SERIE,
    p.NOME as ALUNO,
    b.nomeBaia as BAIA,
    fb.diaFilaBaia,
    fb.horaFilaBaia
from 
    log_filasBaias fb
    inner join 
        baias b on b.idBaia = fb.idBaia
    inner join 
        CorporeRM.dbo.SMATRICPL mpl on mpl.RA = fb.raAluno
    inner join 
        CorporeRM.dbo.SALUNO sa on sa.CODCOLIGADA = mpl.CODCOLIGADA and sa.RA = mpl.RA
    inner join 
        CorporeRM.dbo.PPESSOA p on p.CODIGO = sa.CODPESSOA
    inner join 
        CorporeRM.dbo.SPLETIVO pl on pl.CODCOLIGADA = mpl.CODCOLIGADA and pl.IDPERLET = mpl.IDPERLET and pl.CODPERLET = year(fb.diaFilaBaia)
    inner join 
        CorporeRM.dbo.SHABILITACAOFILIAL hf on hf.CODCOLIGADA = mpl.CODCOLIGADA and hf.IDHABILITACAOFILIAL = mpl.IDHABILITACAOFILIAL
    inner join 
        CorporeRM.dbo.SGRADE sg on sg.CODCOLIGADA = hf.CODCOLIGADA and sg.CODGRADE = hf.CODGRADE
    inner join 
        CorporeRM.dbo.STURNO st on st.CODCOLIGADA = hf.CODCOLIGADA and st.CODTURNO = hf.CODTURNO        
where
    year(diaFilaBaia) = 2024
    and fb.acao = 'INSERT'
    and b.idTipoBaia = 1
    and mpl.CODCOLIGADA in (1,2)
    and st.NOME like '%MANHA%'
order by 
    b.idBaia,
    fb.diaFilaBaia,
    fb.horaFilaBaia