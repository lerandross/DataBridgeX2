/*** EVOLUÇÃO DO PROCESSO DE INGRESSO - COM INDICE ***/

    SELECT
        CODPERLET,
        NUCLEU,
        SERIE,
        DATA,
        INDICE,
        INSCRICOES,
        ACUMULADO_INSCRICOES,
        MANIFESTACOES,
        ACUMULADO_MANIFESTACOES,
		getdate() as 'ultima_atualizacao'
    FROM
        FN_EVOLUCAO_INGRESSO_INDICE (2016)

    UNION ALL

    SELECT
        CODPERLET,
        NUCLEU,
        SERIE,
        DATA,
        INDICE,
        INSCRICOES,
        ACUMULADO_INSCRICOES,
        MANIFESTACOES,
        ACUMULADO_MANIFESTACOES,
        getdate() as 'ultima_atualizacao'
    FROM
        FN_EVOLUCAO_INGRESSO_INDICE (2017)

    UNION ALL

    SELECT
        CODPERLET,
        NUCLEU,
        SERIE,
        DATA,
        INDICE,
        INSCRICOES,
        ACUMULADO_INSCRICOES,
        MANIFESTACOES,
        ACUMULADO_MANIFESTACOES,
        getdate() as 'ultima_atualizacao'
    FROM
        FN_EVOLUCAO_INGRESSO_INDICE (2018)

    UNION ALL

    SELECT
        CODPERLET,
        NUCLEU,
        SERIE,
        DATA,
        INDICE,
        INSCRICOES,
        ACUMULADO_INSCRICOES,
        MANIFESTACOES,
        ACUMULADO_MANIFESTACOES,
        getdate() as 'ultima_atualizacao'
    FROM
        FN_EVOLUCAO_INGRESSO_INDICE (2019)

    UNION ALL

    SELECT
        CODPERLET,
        NUCLEU,
        SERIE,
        DATA,
        INDICE,
        INSCRICOES,
        ACUMULADO_INSCRICOES,
        MANIFESTACOES,
        ACUMULADO_MANIFESTACOES,
        getdate() as 'ultima_atualizacao'
    FROM
        FN_EVOLUCAO_INGRESSO_INDICE (2020)

    UNION ALL

    SELECT
        CODPERLET,
        NUCLEU,
        SERIE,
        DATA,
        INDICE,
        INSCRICOES,
        ACUMULADO_INSCRICOES,
        MANIFESTACOES,
        ACUMULADO_MANIFESTACOES,
        getdate() as 'ultima_atualizacao'
    FROM
        FN_EVOLUCAO_INGRESSO_INDICE (2021)

    UNION ALL

    SELECT
        CODPERLET,
        NUCLEU,
        SERIE,
        DATA,
        INDICE,
        INSCRICOES,
        ACUMULADO_INSCRICOES,
        MANIFESTACOES,
        ACUMULADO_MANIFESTACOES,
        getdate() as 'ultima_atualizacao'
    FROM
        FN_EVOLUCAO_INGRESSO_INDICE (2022)

    UNION ALL

    SELECT
        CODPERLET,
        NUCLEU,
        SERIE,
        DATA,
        INDICE,
        INSCRICOES,
        ACUMULADO_INSCRICOES,
        MANIFESTACOES,
        ACUMULADO_MANIFESTACOES,
        getdate() as 'ultima_atualizacao'
    FROM
        FN_EVOLUCAO_INGRESSO_INDICE (2023)

    UNION ALL

    SELECT
        CODPERLET,
        NUCLEU,
        SERIE,
        DATA,
        INDICE,
        INSCRICOES,
        ACUMULADO_INSCRICOES,
        MANIFESTACOES,
        ACUMULADO_MANIFESTACOES,
        getdate() as 'ultima_atualizacao'
    FROM
        FN_EVOLUCAO_INGRESSO_INDICE (2024)

	UNION ALL

    SELECT
        CODPERLET,
        NUCLEU,
        SERIE,
        DATA,
        INDICE,
        INSCRICOES,
        ACUMULADO_INSCRICOES,
        MANIFESTACOES,
        ACUMULADO_MANIFESTACOES,
        getdate() as 'ultima_atualizacao'
    FROM
        FN_EVOLUCAO_INGRESSO_INDICE (2025)
;
