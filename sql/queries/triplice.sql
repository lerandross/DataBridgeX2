    select
      m.periodoletivo,
      m.ciclo,
      m.serie,
      m.turno,
      et.nome as etapa,
      c.nome as classificacao,
      al.nome as aluno,
      c.contabiliza,
      m.possivelevasao,
      m.possivelretencao,
      m.posicao
from
      TripliceMB.dbo.movimentos m
      inner join
            TripliceMB.dbo.alunos al on al.id = m.idaluno
      inner join
            TripliceMB.dbo.etapas et on et.id = m.idetapa
      inner join
            TripliceMB.dbo.classificacoes c on c.id = m.idclassificacao
order by
      m.codgrade,
      m.turno,
      c.ordem,
      m.posicao,
      al.nome