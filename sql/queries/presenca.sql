DECLARE @ANO_LETIVO VARCHAR(4) = 2023;
DECLARE @TURNO VARCHAR(10) = 'INTEGRAL'; /* PARCIAL ou INTEGRAL */

WITH ALUNOS AS (
	SELECT
		DISTINCT SMAT.CODCOLIGADA,
		SPL.CODPERLET,
		SPL.IDPERLET,
		SA.RA,
		PP.NOME AS ALUNO,
		MPL.NUMALUNO,
		MPL.CODTURMA,
		SUBSTRING(MPL.CODTURMA, 3, 1) AS TURMA,
		ST.NOME AS NOME_TURMA,
		STD.CODDISC,
		SD.NOME AS DISCIPLINA,
		CASE
			WHEN STD.IDHABILITACAOFILIAL IS NULL THEN 'TURMA MISTA'
			WHEN STD.IDHABILITACAOFILIAL IS NOT NULL
			AND STD.CODDISC LIKE '%.E' THEN 'ELETIVA'
			WHEN STD.IDHABILITACAOFILIAL IS NOT NULL
			AND STD.CODDISC LIKE '%.I' THEN 'INTERDISCIPLINAR'
			ELSE 'REGULAR'
		END AS TIPO_DISCIPLINA,
		STD.CODTURMA AS CODTURMADISC,
		STO.NOME AS TURNO
	FROM
		CorporeRM.dbo.SMATRICULA SMAT
		INNER JOIN CorporeRM.dbo.SMATRICPL MPL ON MPL.CODCOLIGADA = SMAT.CODCOLIGADA AND MPL.RA = SMAT.RA AND MPL.IDPERLET = SMAT.IDPERLET AND MPL.IDHABILITACAOFILIAL = SMAT.IDHABILITACAOFILIAL
		INNER JOIN CorporeRM.dbo.SPLETIVO SPL ON SPL.CODCOLIGADA = SMAT.CODCOLIGADA	AND SPL.IDPERLET = SMAT.IDPERLET
		INNER JOIN CorporeRM.dbo.SSTATUS SST ON SST.CODCOLIGADA = SMAT.CODCOLIGADA AND SST.CODSTATUS = SMAT.CODSTATUS
		INNER JOIN CorporeRM.dbo.SALUNO SA ON SA.CODCOLIGADA = SMAT.CODCOLIGADA	AND SA.RA = SMAT.RA
		INNER JOIN CorporeRM.dbo.PPESSOA PP ON PP.CODIGO = SA.CODPESSOA
		INNER JOIN CorporeRM.dbo.STURMADISC STD ON STD.CODCOLIGADA = SMAT.CODCOLIGADA AND STD.IDTURMADISC = SMAT.IDTURMADISC
		INNER JOIN CorporeRM.dbo.STURMA ST ON ST.CODCOLIGADA = STD.CODCOLIGADA AND ST.CODFILIAL = STD.CODFILIAL	AND ST.CODTURMA = STD.CODTURMA AND ST.IDPERLET = STD.IDPERLET
		INNER JOIN CorporeRM.dbo.SDISCIPLINA SD ON SD.CODCOLIGADA = STD.CODCOLIGADA AND SD.CODDISC = STD.CODDISC
		LEFT JOIN CorporeRM.dbo.SHABILITACAOFILIAL SHF ON SHF.CODCOLIGADA = STD.CODCOLIGADA	AND SHF.IDHABILITACAOFILIAL = STD.IDHABILITACAOFILIAL
		INNER JOIN CorporeRM.dbo.STURNO STO ON STO.CODCOLIGADA = STD.CODCOLIGADA AND STO.CODTURNO = STD.CODTURNO /* OBS 2 */
	WHERE
		SMAT.CODCOLIGADA = 1
		AND MPL.CODTURMA NOT LIKE 'I%' -- remover turmas infantil
		AND SPL.CODPERLET >= @ANO_LETIVO
		AND (CASE WHEN STO.NOME = 'INTEGRAL' THEN 'INTEGRAL' ELSE 'PARCIAL' END) = @TURNO
		AND SST.PLATIVO = 'S'
),
PRESENCA_FALTAS AS (	
	SELECT
		DISTINCT STD.CODCOLIGADA,
		AA.RA,
		STD.CODTURMA,
		ETD.IDTURMADISC,
		SPL.IDPERLET,
		STD.CODDISC,
		ET.DESCRICAO,
		ETP.ETAPA,
		ETP.CODREDUZIDO,
		ETP.LABEL,
		SUM(
			CONVERT(
				DECIMAL(10, 1),
				CONVERT(
					DECIMAL(10, 1),
					DATEDIFF(N, AU.HORAINICIO, AU.HORAFIM)
				) / 50
			)
		) AS HORAS_AULAS,
		CASE
			WHEN SUM(
				CONVERT(
					DECIMAL(10, 1),
					CONVERT(
						DECIMAL(10, 1),
						DATEDIFF(N, AU.HORAINICIO, AU.HORAFIM)
					) / 50
				)
			) > 0 THEN (
				SUM(
					CASE
						
						WHEN AA.PRESENCA = 0 THEN CONVERT(
							DECIMAL(10, 1),
							CONVERT(
								DECIMAL(10, 1),
								DATEDIFF(N, AU.HORAINICIO, AU.HORAFIM)
							) / 50
						)
						ELSE 0
					END
				)
			)
		END AS HORAS_FALTAS
	FROM
		DiarioMB.dbo.AULAS AU
		INNER JOIN DiarioMB.dbo.AULASALUNOS AA ON AA.AULA = AU.AULA
		INNER JOIN DiarioMB.dbo.ETAPASTURMASDISC ETD ON ETD.CODCOLIGADA = AU.CODCOLIGADA AND ETD.IDTURMADISC = AU.IDTURMADISC
		INNER JOIN DiarioMB.dbo.ETAPAS ET ON ET.ETAPA = ETD.ETAPA AND AU.data BETWEEN ET.DATAINI AND ET.DATAFIM
		INNER JOIN DiarioMB.dbo.ETAPAS ETP ON ETP.ETAPA = ET.ETAPAPAI
		INNER JOIN CorporeRM.dbo.STURMADISC STD ON STD.CODCOLIGADA = ETD.CODCOLIGADA AND STD.IDTURMADISC = ETD.IDTURMADISC
		INNER JOIN CorporeRM.dbo.SPLETIVO SPL ON SPL.CODCOLIGADA = STD.CODCOLIGADA AND SPL.IDPERLET = STD.IDPERLET
	WHERE
		STD.CODCOLIGADA = 1
		AND SPL.CODPERLET >= @ANO_LETIVO
		AND ET.TIPOETAPA = 1 /* REGULAR */	
	GROUP BY
		STD.CODCOLIGADA,
		AA.RA,
		STD.CODTURMA,
		ETD.IDTURMADISC,
		SPL.IDPERLET,
		STD.CODDISC,
		ETP.ETAPA,
		ETP.CODREDUZIDO,
		ET.DESCRICAO,
		ETP.LABEL
)

SELECT
	*
FROM
	(
	SELECT
		TB.CODPERLET,
		TB.RA,
		TB.ALUNO,
		TB.IDTURMADISC,
		CONCAT(SUBSTRING(TB.MPL_CODTURMA, 2, 1), 'º Ano') AS SERIE,
		TB.MPL_CODTURMA,
		TB.STD_CODTURMA,
		CASE		
			WHEN TB.CODDISC LIKE '%.I' THEN 'Interdisciplinar'
			WHEN TB.CODDISC LIKE '%.E' THEN 'Eletiva'
			WHEN (
				TB.CODDISC = 'ING'
				OR TB.CODDISC = 'ESP'
			) THEN 'Turma Mista'
			ELSE 'Regular'
		END AS TIPO_DISCIPLINA,
		TB.CODDISC,
		TB.DISCIPLINA,
		TB.LABEL AS PERIODO,
		SUM(TB.HORAS_AULAS) TOTAL_HRS_AULAS,
		SUM(TB.HORAS_FALTAS) TOTAL_HRS_FALTAS,
		1 - (SUM(TB.HORAS_FALTAS) / SUM(TB.HORAS_AULAS)) PERCENTUAL,
		TB.CODPERLET as 'ANO_LETIVO',
		getdate() AS 'ULTIMA_ATUALIZACAO'
	FROM
		(
		SELECT
			DISTINCT AL.CODPERLET,
			AL.ALUNO,
			PF.RA,
			AL.CODTURMA AS MPL_CODTURMA,
			PF.CODTURMA AS STD_CODTURMA,
			PF.CODDISC,
			PF.IDTURMADISC,
			AL.DISCIPLINA,
			PF.LABEL,
			PF.HORAS_AULAS,
			PF.HORAS_FALTAS,
			AL.CODTURMADISC
		FROM
			ALUNOS AL
			INNER JOIN PRESENCA_FALTAS PF ON PF.CODCOLIGADA = AL.CODCOLIGADA
			AND AL.RA = PF.RA
			AND PF.CODDISC = AL.CODDISC
			AND AL.CODTURMADISC = PF.CODTURMA /* ATUALIZADO - 20/04/2023 */	
		) TB
	WHERE
		1 = 1
		--AND TB.RA = '210618'
	GROUP BY
		TB.CODPERLET,
		TB.RA,
		TB.ALUNO,
		TB.MPL_CODTURMA,
		TB.STD_CODTURMA,
		TB.CODDISC,
		TB.DISCIPLINA,
		TB.IDTURMADISC,
		TB.LABEL
) TB;