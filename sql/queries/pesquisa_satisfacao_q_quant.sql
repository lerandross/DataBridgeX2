select 
    pu.id,
    sc.NOME+case when sg.CODGRADE like '%.B' then ' - BINLÍGUE' else '' end as curso,
    sg.DESCRICAO as serie,
    pg.descricao as grupo,
    pq.descricao as questao,
    case when pa.descricao is not null then pa.descricao else pr.texto end as resposta
from
    pesquisasusuarios pu
    inner join 
        Pesquisas.dbo.pesquisagrupos pg on pg.idpesquisa = pu.idpesquisa
    inner join 
        Pesquisas.dbo.pesquisagruposquestoes pgq on pgq.idgrupo = pg.id and pgq.idpesquisa = pu.idpesquisa
    inner join 
        Pesquisas.dbo.pesquisaquestoes pq on pq.id = pgq.idquestao
    inner join 
        CorporeRM.dbo.SGRADE sg on sg.CODGRADE = pu.codgrade
    inner join 
        CorporeRM.dbo.SCURSO sc on sc.CODCOLIGADA = sg.CODCOLIGADA and sc.CODCURSO = sg.CODCURSO
    left join 
        Pesquisas.dbo.pesquisausuariosrespostas pr on pr.idpesquisa = pu.idpesquisa and pr.idquestao = pq.id and pr.idusuario = pu.id
    left join
        pesquisaquestoesalternativas pa on pa.idpesquisa = pr.idpesquisa and pa.idquestao = pr.idquestao and pa.id = pr.idalternativa
where 
    pu.idpesquisa >= 12
    and cast(pg.descricao as varchar(500)) <> 'Satisfação'
order by 
    len(pu.codgrade) desc,
    pu.codgrade,
    pu.id,
    pg.ordem,
    pq.ordem