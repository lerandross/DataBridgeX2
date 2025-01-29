select
       ma.nomeseriedestino+' - '+ma.nometurnodestino as serie,
       'Migração - Entrada' as classificacao,
       1 as quantidade
from
    Migracao.dbo.migracoes m
    inner join
        Migracao.dbo.migracoesalunos ma on ma.idmigracao = m.id
    inner join
        CorporeRM.dbo.SMATRICPL mpl on mpl.RA = ma.RA
    inner join
        CorporeRM.dbo.SPLETIVO pl on pl.CODCOLIGADA = mpl.CODCOLIGADA and pl.IDPERLET = mpl.IDPERLET and pl.CODPERLET = (m.codperlet-1)
    inner join
        CorporeRM.dbo.SSTATUS sst on sst.CODCOLIGADA = mpl.CODCOLIGADA and sst.CODSTATUS = mpl.CODSTATUS
    inner join
        CorporeRM.dbo.SHABILITACAOFILIAL hf on hf.CODCOLIGADA = mpl.CODCOLIGADA and hf.IDHABILITACAOFILIAL = mpl.IDHABILITACAOFILIAL
    inner join
        CorporeRM.dbo.STURNO st on st.CODCOLIGADA = hf.CODCOLIGADA and st.CODTURNO = hf.CODTURNO
where
    m.codperlet = '2024'
    and sst.PLATIVO = 'S'
    and mpl.CODCOLIGADA in (1,2)
union all
select
       ma.nomeseriedestino+' - '+case when ma.codhabilitacaodestino = '06.1' then 'MANHÃ' else st.NOME end as serie,
       'Migração - Saída' as classificacao,
       1 as quantidade
from
    Migracao.dbo.migracoes m
    inner join
        Migracao.dbo.migracoesalunos ma on ma.idmigracao = m.id
    inner join
        CorporeRM.dbo.SMATRICPL mpl on mpl.RA = ma.RA
    inner join
        CorporeRM.dbo.SPLETIVO pl on pl.CODCOLIGADA = mpl.CODCOLIGADA and pl.IDPERLET = mpl.IDPERLET and pl.CODPERLET = (m.codperlet-1)
    inner join
        CorporeRM.dbo.SSTATUS sst on sst.CODCOLIGADA = mpl.CODCOLIGADA and sst.CODSTATUS = mpl.CODSTATUS
    inner join
        CorporeRM.dbo.SHABILITACAOFILIAL hf on hf.CODCOLIGADA = mpl.CODCOLIGADA and hf.IDHABILITACAOFILIAL = mpl.IDHABILITACAOFILIAL
    inner join
        CorporeRM.dbo.STURNO st on st.CODCOLIGADA = hf.CODCOLIGADA and st.CODTURNO = hf.CODTURNO
where
    m.codperlet = '2024'
    and sst.PLATIVO = 'S'
    and mpl.CODCOLIGADA in (1,2)
union all
select 
       rtrim(replace(mpa.nomeseriedestino,' - ENSINO FUNDAMENTAL I',''))+' - '+mpa.nometurnodestino as serie,
       'Mudança de Período - Entrada' as classificacao,
       1 as quantidade
from
        MudancaPeriodo.dbo.mudancasperiodo mp
        inner join
            MudancaPeriodo.dbo.mudancasperiodoalunos mpa on mpa.idmudancaperiodo = mp.id
        inner join
            CorporeRM.dbo.SMATRICPL mpl on mpl.RA = mpa.RA
        inner join
            CorporeRM.dbo.SPLETIVO pl on pl.CODCOLIGADA = mpl.CODCOLIGADA and pl.IDPERLET = mpl.IDPERLET and pl.CODPERLET = (mp.codperlet-1)
        inner join
            CorporeRM.dbo.SSTATUS sst on sst.CODCOLIGADA = mpl.CODCOLIGADA and sst.CODSTATUS = mpl.CODSTATUS
        inner join
            CorporeRM.dbo.SHABILITACAOFILIAL hf on hf.CODCOLIGADA = mpl.CODCOLIGADA and hf.IDHABILITACAOFILIAL = mpl.IDHABILITACAOFILIAL
        inner join
            CorporeRM.dbo.STURNO st on st.CODCOLIGADA = hf.CODCOLIGADA and st.CODTURNO = hf.CODTURNO
where
        mp.codperlet = '2024'
        and sst.PLATIVO = 'S'
        and mpl.CODCOLIGADA in (1,2)
union all
select 
       rtrim(replace(mpa.nomeseriedestino,' - ENSINO FUNDAMENTAL I',''))+' - '+st.NOME as serie,
       'Mudança de Período - Saída' as classificacao,
       1 as quantidade
from
        MudancaPeriodo.dbo.mudancasperiodo mp
        inner join
            MudancaPeriodo.dbo.mudancasperiodoalunos mpa on mpa.idmudancaperiodo = mp.id
        inner join
            CorporeRM.dbo.SMATRICPL mpl on mpl.RA = mpa.RA
        inner join
            CorporeRM.dbo.SPLETIVO pl on pl.CODCOLIGADA = mpl.CODCOLIGADA and pl.IDPERLET = mpl.IDPERLET and pl.CODPERLET = (mp.codperlet-1)
        inner join
            CorporeRM.dbo.SSTATUS sst on sst.CODCOLIGADA = mpl.CODCOLIGADA and sst.CODSTATUS = mpl.CODSTATUS
        inner join
            CorporeRM.dbo.SHABILITACAOFILIAL hf on hf.CODCOLIGADA = mpl.CODCOLIGADA and hf.IDHABILITACAOFILIAL = mpl.IDHABILITACAOFILIAL
        inner join
            CorporeRM.dbo.STURNO st on st.CODCOLIGADA = hf.CODCOLIGADA and st.CODTURNO = hf.CODTURNO
where
        mp.codperlet = '2024'
        and sst.PLATIVO = 'S'
        and mpl.CODCOLIGADA in (1,2);