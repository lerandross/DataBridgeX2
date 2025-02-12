SELECT
    LIC.RA,
    PP.NOME,
    LIC.CODPERLET AS 'ANO_LETIVO',
    LIC.ETAPA,
    LIC.CODDISC,
    LIC.CODTURMA,
    SD.NOME AS 'DISCIPLINA',
    LIC.PERCFEITAS,
    LIC.PERCNAOFEITAS,
    LIC.STRFEITAS,
    LIC.STRINCOMPLETAS,
    LIC.STRNAOFEITAS,
    LIC.IDTURMADISC,
	ET.DESCRICAO,
    CASE    
        WHEN LIC.CODDISC LIKE '%.I' THEN 'Interdisciplinar'
        WHEN LIC.CODDISC LIKE '%.E' THEN 'Eletiva'
        WHEN (LIC.CODDISC = 'ING' OR LIC.CODDISC = 'ESP') THEN 'Turma Mista'
        ELSE 'Regular'
        END AS TIPO_DISCIPLINA,
    CASE
		WHEN ET.DESCRICAO LIKE '%medio%' THEN 'Médio'
		WHEN ET.DESCRICAO LIKE '%médio%' THEN 'Médio'
        WHEN ET.DESCRICAO LIKE '%parcial%' THEN 'Parcial'
        
        
		WHEN ET.DESCRICAO LIKE '%integral%' THEN 'Integral'
        ELSE ET.DESCRICAO
        END AS CICLO,
    ETP.LABEL AS PERIODO
FROM
    DiarioMB.dbo.REL_LICOESALUNOS AS LIC
    INNER JOIN CorporeRM.dbo.SALUNO SA ON SA.CODCOLIGADA = LIC.CODCOLIGADA AND SA.RA = LIC.RA
    INNER JOIN CorporeRM.dbo.PPESSOA PP ON PP.CODIGO = SA.CODPESSOA
    INNER JOIN CorporeRM.dbo.SMATRICULA MAT ON MAT.CODCOLIGADA = LIC.CODCOLIGADA AND MAT.IDTURMADISC = LIC.IDTURMADISC AND MAT.RA = LIC.RA
    INNER JOIN CorporeRM.dbo.STURMADISC STD ON STD.CODCOLIGADA = MAT.CODCOLIGADA AND STD.IDTURMADISC = MAT.IDTURMADISC
    INNER JOIN CorporeRM.dbo.SDISCIPLINA SD ON SD.CODCOLIGADA = STD.CODCOLIGADA AND SD.CODDISC = STD.CODDISC
    INNER JOIN DiarioMB.dbo.ETAPASTURMASDISC ETTURMA ON ETTURMA.IDTURMADISC = LIC.IDTURMADISC AND ETTURMA.CODPERLET = LIC.CODPERLET AND ETTURMA.CODCOLIGADA = LIC.CODCOLIGADA
    INNER JOIN DiarioMB.dbo.ETAPAS ET ON ET.CODPERLET = ETTURMA.CODPERLET AND ET.ETAPA = ETTURMA.ETAPA
    INNER JOIN DiarioMB.dbo.ETAPAS ETP ON ETP.ETAPA = ET.ETAPAPAI AND ETP.ETAPA = LIC.ETAPA
WHERE
    1=1
     -- AND LIC.RA = 190606 Duplicando
	 -- AND LIC.RA = 240866

     --AND LIC.CODDISC = 'EC';