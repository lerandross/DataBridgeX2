select 
	mpl.CODTURMA,
	mpl.RA,
	p.NOME,
	bol.CODDISC,
	sd.NOME as DISCIPLINA,
	bol.S1,
	bol.S2,
	case
		when bol.R1 is not null then 'Recuperação'
		else NULL
	END AS 'REC_SEM1',
	case
		when bol.R2 is not null then 'Recuperação'
		else NULL
	END AS 'REC_SEM2',
	bol.CODCURSO,

	CASE	
		WHEN bol.CODDISC LIKE '%.I' THEN 'Interdisciplinar'
		WHEN bol.CODDISC LIKE '%.E' THEN 'Eletiva'
		WHEN (bol.CODDISC = 'ING' OR bol.CODDISC = 'ESP') THEN 'Turma Mista'
		ELSE 'Regular'
	END AS TIPO_DISCIPLINA,
	sst.DESCRICAO as 'STATUS',
    CASE 
		when bol.CODGRADE like '%.[1B]' then 'Integral'
		WHEN bol.codgrade LIKE '%.1' THEN 'Integral'
		WHEN bol.codgrade LIKE '%.1' THEN 'Integral'
        WHEN bol.codgrade LIKE '03%' THEN 'Médio'
        WHEN bol.codgrade LIKE '02%' THEN 'Fundamental 2'
        WHEN bol.codgrade LIKE '01%' THEN 'Fundamental 1'
        ELSE 'Outro'
    END AS CICLO,
	bol.CODPERLET as 'ano_letivo',
	bol.S1FIM,
	bol.S2FIM,
	case
		when bol.R1 = 'N/C' then 's'
		when bol.R1 = 'Rec' then 's'
		when bol.R1 is null then 'n'
		else 'n'
	end as 'status_rec1',
	case
		when R2 in ('RSR','RS','RR','Rec','RAR', 'RA') then 's'
		when R2 is not null then 's'
		else 'n'
	end as 'status_rec2',
	bol.NR1,
	bol.NR2,
	bol.R1,
	bol.NOTAULTIMOPERIODO,
	bol.NOTAULTIMOPERIODOFINAL,
	bol.MEDIAFINAL as 'MEDIA_ANUAL_FINAL',
	bol.MEDIA AS 'MEDIA_PRE_REC_ANUAL',
	bol.R2,
	bol.TIPOR2,
    -- Nova coluna NOTANECESSARIA
    CASE 
        WHEN 
            CASE 
                when bol.CODGRADE like '%.[1B]' then 'Integral'
                WHEN bol.codgrade LIKE '%.1' THEN 'Integral'
                WHEN bol.codgrade LIKE '%.1' THEN 'Integral'
                WHEN bol.codgrade LIKE '03%' THEN 'Médio'
                WHEN bol.codgrade LIKE '02%' THEN 'Fundamental 2'
                WHEN bol.codgrade LIKE '01%' THEN 'Fundamental 1'
                ELSE 'Outro'
            END = 'Médio' 
        THEN 
            CASE
				WHEN bol.TIPOR2 = 'RA' THEN 10.0 - bol.MEDIA
                WHEN bol.TIPOR2 IS NOT NULL THEN '5'
                ELSE NULL
            END
        ELSE 
            CASE 
                WHEN bol.TIPOR2 = 'RR' THEN '6.0'
                WHEN bol.TIPOR2 IN ('RS','RA') THEN 12 - CAST(bol.MEDIA AS NUMERIC(5,1))
            END
    END AS NOTANECESSARIA__REC2

from
	BOLETIMSEMESTRE bol
	inner join
		CorporeRM.dbo.SMATRICPL mpl on mpl.CODCOLIGADA = bol.CODCOLIGADA and mpl.RA = bol.RA
	inner join 
		CorporeRM.dbo.SPLETIVO pl on pl.CODCOLIGADA = mpl.CODCOLIGADA and pl.IDPERLET = mpl.IDPERLET and pl.CODPERLET = bol.CODPERLET
	inner join 
		CorporeRM.dbo.SSTATUS sst on sst.CODCOLIGADA = mpl.CODCOLIGADA and sst.CODSTATUS = mpl.CODSTATUS
	inner join
		CorporeRM.dbo.SALUNO sa on sa.CODCOLIGADA = bol.CODCOLIGADA and sa.RA = mpl.RA
	inner join
		CorporeRM.dbo.PPESSOA p on p.CODIGO = sa.CODPESSOA
	INNER JOIN 
		CorporeRM.dbo.SDISCIPLINA SD ON SD.CODCOLIGADA = bol.CODCOLIGADA AND SD.CODDISC = bol.CODDISC
where
	bol.CODPERLET >=2024
	--and bol.CODCURSO = @codcurso
	and (sst.PLATIVO = 'S' or sst.DESCRICAO = 'TRANSFERIDO')
	 -- and mpl.ra = '170204'
group by
	mpl.CODTURMA,
	mpl.RA,
	p.NOME,
	bol.CODDISC,
	bol.S1,
	bol.S2,
	case
		when bol.R1 is not null then 'Recuperação'
		else NULL
	END ,
	case
		when bol.R2 is not null then 'Recuperação'
		else NULL
	END ,
	sd.NOME,
	bol.CODCURSO,
	CASE	
		WHEN bol.CODDISC LIKE '%.I' THEN 'Interdisciplinar'
		WHEN bol.CODDISC LIKE '%.E' THEN 'Eletiva'
		WHEN (bol.CODDISC = 'ING' OR bol.CODDISC = 'ESP') THEN 'Turma Mista'
		ELSE 'Regular'
	END ,
	sst.DESCRICAO,
	CASE 
		when bol.CODGRADE like '%.[1B]' then 'Integral'
		WHEN bol.codgrade LIKE '%.1' THEN 'Integral'
		WHEN bol.codgrade LIKE '%.1' THEN 'Integral'
		WHEN bol.codgrade LIKE '03%' THEN 'Médio'
		WHEN bol.codgrade LIKE '02%' THEN 'Fundamental 2'
		WHEN bol.codgrade LIKE '01%' THEN 'Fundamental 1'
		ELSE 'Outro'
	END,
	bol.CODPERLET,
	bol.S1FIM,
	bol.S2FIM,
	case
		when bol.R1 is not null then 's'
		when bol.R1 is null then 'n'
		else 'n'
	end,
	case
		when R2 in ('RSR','RS','RR','Rec','RAR', 'RA') then 's'
		when R2 is not null then 's'
		else 'n'
	end,
	bol.NR1,
	bol.NR2,
	bol.r1,
	bol.NOTAULTIMOPERIODO,
	bol.NOTAULTIMOPERIODOFINAL,
	bol.MEDIAFINAL,
	bol.MEDIA,
	bol.R2,
	bol.TIPOR2