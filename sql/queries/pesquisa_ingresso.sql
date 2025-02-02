	SELECT
		ID_INSCRICAO,
		ID_CANDIDATO,
		ID_MANIFESTACAO,
		CANDIDATO,
		ID_PERGUNTA_16,
		ID_PERGUNTA_17,
		ID_PERGUNTA_18,
		ID_PERGUNTA_19,
		ID_PERGUNTA_20,
		ID_PERGUNTA_21,
		ID_PERGUNTA_22,
		ID_PERGUNTA_23,
		ID_PERGUNTA_25,
		ID_PERGUNTA_26,
		ID_PERGUNTA_24,
		ID_PERGUNTA_27,
		ID_PERGUNTA_28
	FROM (
			SELECT
				I.ID_INSCRICAO,
				C.ID_CANDIDATO,
				MAN.ID_MANIFESTACAO,
				C.NOME AS CANDIDATO,
				CONCAT('ID_PERGUNTA_',PER.ID_PERGUNTA) AS ID_PERGUNTA,
				RES.RESPOSTA
			FROM
				INSCRICAO I
				INNER JOIN PROCESSO P ON P.ID_PROCESSO = I.ID_PROCESSO
				INNER JOIN CANDIDATO C ON C.ID_CANDIDATO = I.ID_CANDIDATO
				INNER JOIN MANIFESTACAO MAN ON MAN.ID_INSCRICAO = I.ID_INSCRICAO
				INNER JOIN MANIFESTACAO_PESQUISA_RESPOSTA MPR ON MPR.ID_MANIFESTACAO = MAN.ID_MANIFESTACAO
				INNER JOIN PESQUISA PES ON PES.ID_PESQUISA = MPR.ID_PESQUISA
				INNER JOIN PERGUNTA PER ON PER.ID_PERGUNTA = MPR.ID_PERGUNTA
				INNER JOIN OPCAO_RESPOSTA RES ON RES.ID_OPCAO_RESPOSTA = MPR.ID_OPCAO_RESPOSTA
			WHERE
				P.CODPERLET = 2024
				AND P.NOME = 'PROCESSO DE INGRESSO - 2023/2024'
				AND PES.NOME = 'Processo de Ingresso 2023/2024'
		) TB
	PIVOT (
		MAX(RESPOSTA) FOR ID_PERGUNTA IN (	[ID_PERGUNTA_16],[ID_PERGUNTA_17],[ID_PERGUNTA_18],
											[ID_PERGUNTA_19],[ID_PERGUNTA_20],[ID_PERGUNTA_21],
											[ID_PERGUNTA_22],[ID_PERGUNTA_23],[ID_PERGUNTA_25],
											[ID_PERGUNTA_26],[ID_PERGUNTA_24],[ID_PERGUNTA_27],
											[ID_PERGUNTA_28]
										)
		) PVT
	ORDER BY
		1;