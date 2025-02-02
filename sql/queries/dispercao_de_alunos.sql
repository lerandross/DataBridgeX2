USE DiarioMB;

WITH CTE_ALUNO_AVALIACAO_ETAPA
AS
(
	SELECT DISTINCT
		SPL.CODPERLET,
		MAT.CODCOLIGADA,
		AVA.RA,
		PP.NOME AS ALUNO,
		MPL.CODTURMA AS CODTURMA_REGULAR,
		IIF(MPL.CODTURMA <> STD.CODTURMA, STD.CODTURMA, NULL) AS CODTURMA_MISTA,
		ATD.IDTURMADISC,
		STD.CODDISC,
		SD.NOME AS DISCIPLINA,
		CASE    
			WHEN STD.CODDISC LIKE '%.I' THEN 'Interdisciplinar'
			WHEN STD.CODDISC LIKE '%.E' THEN 'Eletiva'
			WHEN (STD.CODDISC = 'ING' OR STD.CODDISC = 'ESP') THEN 'Turma Mista'
			ELSE 'Regular'
			END AS TIPO_DISCIPLINA,
		ETP.ETAPA AS ETAPA_PAI,
		ETP.DESCRICAO AS ETAPA_PAI_DESC,
		ETP.SEMESTRE AS SEMESTRE,
		ETP.LABEL AS SEMESTRE_DESC,
		AV.NOTAMAXIMA,
		AVA.NOTA AS NOTA_ALUNO,
		AV.PESO
	FROM
		DiarioMB.dbo.ETAPAS ET
		INNER JOIN DiarioMB.dbo.ETAPAS ETP ON ETP.ETAPA = ET.ETAPAPAI
		INNER JOIN DiarioMB.dbo.AVALIACOES AV ON AV.ETAPA = ET.ETAPA
		INNER JOIN DiarioMB.dbo.AVALIACOESTURMASDISC ATD ON ATD.AVALIACAO = AV.AVALIACAO
		INNER JOIN DiarioMB.dbo.AVALIACOESALUNOS AVA ON AVA.AVALIACAO = AV.AVALIACAO
		INNER JOIN CorporeRM.dbo.SMATRICULA MAT ON MAT.CODCOLIGADA = ATD.CODCOLIGADA AND MAT.IDTURMADISC = ATD.IDTURMADISC AND MAT.RA = AVA.RA
		INNER JOIN CorporeRM.dbo.SMATRICPL MPL ON MPL.CODCOLIGADA = MAT.CODCOLIGADA AND MPL.IDPERLET = MAT.IDPERLET AND MPL.IDHABILITACAOFILIAL = MAT.IDHABILITACAOFILIAL AND MPL.RA = MAT.RA
		INNER JOIN CorporeRM.dbo.SALUNO SA ON SA.CODCOLIGADA = MPL.CODCOLIGADA AND SA.RA = MPL.RA
		INNER JOIN CorporeRM.dbo.PPESSOA PP ON PP.CODIGO = SA.CODPESSOA
		INNER JOIN CorporeRM.dbo.SPLETIVO SPL ON SPL.CODCOLIGADA = MPL.CODCOLIGADA AND SPL.IDPERLET = MPL.IDPERLET
		INNER JOIN CorporeRM.dbo.SSTATUS SST ON SST.CODCOLIGADA = MPL.CODCOLIGADA AND SST.CODSTATUS = MPL.CODSTATUS
		INNER JOIN CorporeRM.dbo.STURMADISC STD ON STD.CODCOLIGADA = MAT.CODCOLIGADA AND STD.IDTURMADISC = MAT.IDTURMADISC
		INNER JOIN CorporeRM.dbo.SDISCIPLINA SD ON SD.CODCOLIGADA = STD.CODCOLIGADA AND SD.CODDISC = STD.CODDISC
	WHERE
		AV.PUBLICAR = 1
	  -- AND MPL.RA = '110102' /* filtro por aluno */
		AND SST.PLATIVO = 'S'
		AND SPL.CODPERLET = '2024'
		AND ETP.ETAPA IN (
			602			-- 1º Semestre - Médio - Período Parcial - 2024
			,606		-- 2º Semestre - Médio - Período Parcial - 2024
			,612		-- 1º Semestre - Fundamental 1 - Período Integral - 2024
			,613		-- 2º Semestre - Fundamental 1 - Período Integral - 2024
			,614		-- 1º Semestre - Fundamental 2 - Período Integral - 2024
			,615		-- 2º Semestre - Fundamental 2 - Período Integral - 2024
			,618		-- 1º Semestre - Fundamental 1 - Período Parcial - 2024
			,619		-- 2º Semestre - Fundamental 1 - Período Parcial - 2024
			,620		-- 1º Semestre - Fundamental 2 - Período Parcial - 2024
			,621		-- 2º Semestre - Fundamental 2 - Período Parcial - 2024
		)
)

SELECT
	AAE.CODPERLET,
	AAE.CODCOLIGADA,
	AAE.RA,
	AAE.ALUNO,
	AAE.CODTURMA_REGULAR,
	AAE.CODTURMA_MISTA,
	AAE.CODDISC,
	AAE.DISCIPLINA,
	AAE.SEMESTRE,
	AAE.SEMESTRE_DESC,
	COALESCE(TRY_CAST(CASE
		WHEN AAE.SEMESTRE = 1 THEN IIF(BS.S1FIM IS NOT NULL, BS.S1FIM, BS.S1)
		WHEN AAE.SEMESTRE = 2 THEN IIF(BS.S2FIM IS NOT NULL, BS.S2FIM, BS.S2)
		END AS DECIMAL(10, 2)), 0) AS MEDIA_FINAL,
	CAST(CAST(SUM(((AAE.NOTA_ALUNO/AAE.NOTAMAXIMA)*10)*AAE.PESO)/(SUM(AAE.PESO)) AS DECIMAL(10,1)) AS DECIMAL(10,2)) AS MEDIA_PARCIAL,
	LA.PERCFEITAS AS LICAO_CASA,
	FA.FALTAS AS FALTA,
	AAE.ETAPA_PAI,
	AAE.ETAPA_PAI_DESC
FROM
	CTE_ALUNO_AVALIACAO_ETAPA AAE
	LEFT JOIN DiarioMB.dbo.BOLETIMSEMESTRE BS ON BS.CODCOLIGADA = AAE.CODCOLIGADA AND BS.RA = AAE.RA AND BS.CODPERLET = AAE.CODPERLET AND BS.CODDISC = AAE.CODDISC
	LEFT JOIN DiarioMB.dbo.REL_LICOESALUNOS LA ON LA.CODCOLIGADA = AAE.CODCOLIGADA AND LA.IDTURMADISC = AAE.IDTURMADISC AND LA.RA = AAE.RA AND LA.ETAPA = AAE.ETAPA_PAI
	LEFT JOIN DiarioMB.dbo.REL_FALTASALUNOS FA ON FA.CODCOLIGADA = AAE.CODCOLIGADA AND FA.IDTURMADISC = AAE.IDTURMADISC AND FA.RA = AAE.RA AND FA.ETAPA = AAE.ETAPA_PAI
GROUP BY
	AAE.CODPERLET,
	AAE.CODCOLIGADA,
	AAE.RA,
	AAE.ALUNO,
	AAE.CODTURMA_REGULAR,
	AAE.CODTURMA_MISTA,
	AAE.CODDISC,
	AAE.DISCIPLINA,
	AAE.SEMESTRE,
	AAE.SEMESTRE_DESC,
	BS.S1FIM,
	BS.S1,
	BS.S2FIM,
	BS.S2,
	AAE.ETAPA_PAI,
	AAE.IDTURMADISC,
	LA.PERCFEITAS,
	FA.FALTAS,
	AAE.ETAPA_PAI,
	AAE.ETAPA_PAI_DESC
ORDER BY
	AAE.CODCOLIGADA,
	AAE.RA,
	AAE.SEMESTRE,
	AAE.CODTURMA_REGULAR,
	AAE.CODTURMA_MISTA;