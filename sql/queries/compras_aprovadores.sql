USE CorporeRM
SELECT 
    DISTINCT
    P.CODIGO,
    p.CPF,
    P.NOME, 
    CC.CODCCUSTO,
    CC.NOME AS CENTRO_CUSTO,
    CASE    
        WHEN AP.DIRETOR = 0 THEN 'REGULAR'
    ELSE 'MASTER' END AS TIPO_PERMISSAO
    FROM PPESSOA P
        INNER JOIN
            ZMDAPROVADORES AP ON P.CODIGO = AP.CODPESSOA
        INNER JOIN
            GCCUSTO CC ON AP.CODCCUSTO = CC.CODCCUSTO
    ORDER BY 
        P.NOME, CC.NOME;