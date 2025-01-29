select 
	T.CODDISC,
	T.NOME as 'DISCIPLINA',
	TP.NOME as'TEMA',
	H.NOME as 'EXPECTATIVA',
	T.CODHABILITACAO as 'SERIE',
	T.CODCURSO as 'CICLO'

FROM Construtor.dbo.TEMA as T
    inner join 
        Construtor.dbo.TOPICO as TP on TP.IDTEMA = T.IDTEMA 
    inner join 
        Construtor.dbo.HABILIDADE as H on H.IDTOPICO = TP.IDTOPICO