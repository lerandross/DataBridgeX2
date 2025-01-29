select  eq.DESCRICAO AS EQUIPE,
        se.DESCRICAO as SECAO,
        fu.NOME as FUNCAO,
        p.SEXO,
        f.DATAADMISSAO,  
        case when datademissao is null then (DATEDIFF(hour, DATAADMISSAO, getdate()) / 8766) else (DATEDIFF(hour, DATAADMISSAO, DATADEMISSAO) / 8766) end as TCASA,
        DATEPART(YEAR, P.DTNASCIMENTO) as ANONASC,
        f.DATADEMISSAO, 
        case when f.CODSITUACAO ='D' then 'Desligado' else 'Ativo' end as SITUACAO,
        case when p.CORRACA =0 then 'Indigena'
         when p.CORRACA =2 THEN 'Branca'
         when p.CORRACA =4 THEN 'Preta'
         when p.CORRACA =6 THEN 'Amarela' 
         when p.CORRACA =8 THEN 'Parda'
         when p.CORRACA =9 THEN 'Não Informado'
         when p.CORRACA =10 THEN 'Não Declarado'
        end as 'RACA',
		case when p.NOMESOCIAL is not null then p.NOMESOCIAL else p.NOME end as NOME

        from PFUNC f
            inner join PPESSOA p on f.CODPESSOA = p.CODIGO
            inner join PCORRACA r on p.CORRACA = r.CODINTERNO
            inner join PFUNCAO fu on f.CODCOLIGADA = fu.CODCOLIGADA and f.CODFUNCAO = fu.CODIGO
            inner join PEQUIPE eq on f.CODEQUIPE = eq.CODINTERNO
            inner join PSECAO se on f.CODCOLIGADA = se.CODCOLIGADA and f.CODSECAO = se.CODIGO
    where 
        f.CODFUNCAO <> '000'
    group by eq.DESCRICAO,p.CORRACA,fu.NOME,f.DATAADMISSAO,se.DESCRICAO,p.SEXO, P.DTNASCIMENTO,f.DATADEMISSAO,f.CODSITUACAO, case when p.NOMESOCIAL is not null then p.NOMESOCIAL else p.NOME end
order by EQUIPE,SECAO,FUNCAO
