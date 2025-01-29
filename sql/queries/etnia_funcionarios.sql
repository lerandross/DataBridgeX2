select eq.DESCRICAO AS EQUIPE,se.DESCRICAO as SECAO,fu.NOME as FUNCAO,p.SEXO,f.DATAADMISSAO,  (DATEDIFF(hour, DATAADMISSAO, getdate()) / 8766) as TCASA,
        case when p.CORRACA =0 then 'Indigena'
         when p.CORRACA =2 THEN 'Branca'
         when p.CORRACA =4 THEN 'Preta'
         when p.CORRACA =6 THEN 'Amarela' 
         when p.CORRACA =8 THEN 'Parda'
         when p.CORRACA =9 THEN 'Não Informado'
         when p.CORRACA =10 THEN 'Não Declarado'
		 end as 'RACA'

        from PFUNC f
            inner join PPESSOA p on f.CODPESSOA = p.CODIGO
            inner join PCORRACA r on p.CORRACA = r.CODINTERNO
            inner join PFUNCAO fu on f.CODCOLIGADA = fu.CODCOLIGADA and f.CODFUNCAO = fu.CODIGO
            inner join PEQUIPE eq on f.CODEQUIPE = eq.CODINTERNO
            inner join PSECAO se on f.CODCOLIGADA = se.CODCOLIGADA and f.CODSECAO = se.CODIGO
    where 
        f.CODSITUACAO not in('D','I')
    group by eq.DESCRICAO,p.CORRACA,fu.NOME,f.DATAADMISSAO,se.DESCRICAO,p.sexo
order by EQUIPE,SECAO,FUNCAO
