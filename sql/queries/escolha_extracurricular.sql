select
      hf.CODCURSO,
      hf.CODHABILITACAO,
      hf.CODGRADE,
      g.DESCRICAO as serie,
      mpl.ra,
      p.nome,
      td.id,
      d.nome as disciplina,
      EscolhaEletivaMB.dbo.fc_getHorarioIdturmadisciplina(td.id) as horario,
      tda.aceito,
      tda.posicaoespera,
      tda.datahorarec,
      tda.cancelado,
      tda.datahoracancelado,
        case p.sexo
                when 'F' then 'Fêminino' 
                when 'M' then 'Masculino' 
            end as genero

from
      EscolhaEletivaMB.dbo.extracurricular_turmasdisciplinas td
      inner join
            EscolhaEletivaMB.dbo.extracurricular_disciplinas d on d.id = td.iddisciplina
      inner join
            EscolhaEletivaMB.dbo.extracurricular_turmasdisciplinas_alunos tda on tda.idturmadisciplina = td.id
      inner join
            CorporeRM.dbo.SALUNO sa on sa.RA = tda.ra
      inner join
            CorporeRM.dbo.PPESSOA p on p.CODIGO = sa.CODPESSOA
      inner join
            CorporeRM.dbo.SMATRICPL mpl on mpl.CODCOLIGADA = sa.CODCOLIGADA and mpl.RA = sa.RA
      inner join
            CorporeRM.dbo.SPLETIVO pl on pl.CODCOLIGADA = mpl.CODCOLIGADA and pl.IDPERLET = mpl.IDPERLET
      inner join
            CorporeRM.dbo.SSTATUS sst on sst.CODCOLIGADA = mpl.CODCOLIGADA and sst.CODSTATUS = mpl.CODSTATUS
      inner join
            CorporeRM.dbo.SHABILITACAOFILIAL hf on hf.CODCOLIGADA = mpl.CODCOLIGADA and hf.IDHABILITACAOFILIAL = mpl.IDHABILITACAOFILIAL
      inner join
            CorporeRM.dbo.SGRADE g on g.CODCOLIGADA = hf.CODCOLIGADA and g.CODGRADE = hf.CODGRADE
where
      pl.CODPERLET = '2025'
      and sst.PLATIVO = 'S'
      and mpl.CODCOLIGADA in (1,2)
order by
      g.CODGRADE,
      p.NOME,
      d.nome,
      isnull(tda.aceito,0) desc,
      tda.posicaoespera;