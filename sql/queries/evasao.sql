                SELECT
                    CODPERLET,
                    TIPO_EVASAO,
                    COUNT(*) AS EVASAO,
                    SERIE,
                    CASE
                        WHEN CODCURSO = '00' OR CODCURSO = '00.1' THEN 'INFANTIL'
                        WHEN CODCURSO = '01' OR CODCURSO = '01.1' THEN 'FUNDAMENTAL'
                        WHEN CODCURSO = '02' OR CODCURSO = '02.1' THEN 'FUNDAMENTAL'
                        WHEN CODCURSO = '03' THEN 'MÉDIO'
                        END AS CICLO,
                    CASE
                        WHEN CODGRADE LIKE '%.1' OR CODGRADE LIKE '%.B' THEN 'INTEGRAL'
                        ELSE 'PARCIAL'
                        END AS PERIODO,
                        dtcancelamento
                FROM
                    FNT_EVASÃO_CODPERLET({ano}) /* ANO LETIVO */
                WHERE
                    1=1
                    -- AND TIPO_EVASAO NOT IN ('INGRESSANTE DESISTENTE') /* OBS.1 */
                GROUP BY
                    CODPERLET,
                    TIPO_EVASAO,
                    SERIE,
                    CODCURSO,
                    CODGRADE,
                    dtcancelamento;

                /*
                    OBS.1:
                        OS "INGRESSANTES DESISTENTES" APARECE COMO CODPERLET DO ANO SEGUINTE POIS O ANO DE MATRÍCULA É DO PRÓXIMO ANO LETIVO.
                        POR EXEMPLO: O ALUNO FEZ A INSCRIÇÃO EM 2023 PARA ESTUDAR EM 2024, LOGO, O "CODPERLET" DELE IRÁ SAIR COMO 2024.
                */