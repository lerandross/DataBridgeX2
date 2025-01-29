select 
	   sa.id
       ,sa.codcurso
	   ,sa.codgrade
	   ,sa.ra
	   ,sa.token
	   ,sa.nota
	   ,case
			when sa.motivo_nota is null or datalength(sa.motivo_nota)=0 then 'Não Preencheu'
			else sa.motivo_nota 
	   end as motivo_nota
	   ,sa.pessoarec
	   ,sa.datahorarec
	   ,case
			when sa.nota <=6 then 'Detratores'
			when (sa.nota >=7 and sa.nota <=8) then 'Neutros'
			when sa.nota >8 then 'Promotores'
		end as 'Classificacao'
		,case
			when sa.codcurso = '00.1' then 'Infantil Integral'
			when sa.codcurso  = '01.1' then 'Fundamental 1 Integral'
			when sa.codcurso = '02.1' then 'Fundamental 2 Integral'
			when sa.codcurso = '00' then 'Infantil Parcial'
			when sa.codcurso = '01' then 'Fundamental 1 Parcial'
			when sa.codcurso = '02' then 'Fundamental 2 Parcial'
			when sa.codcurso = '03' then 'Médio'
		end as 'curso_detalhe'
		,case
			when sa.codcurso = '00.1' then '00 - Infantil'
			when sa.codcurso = '01.1' then '01 - Fundamental 1'
			when sa.codcurso = '02.1' then '02 - Fundamental 2'
			when sa.codcurso = '00' then '00 - Infantil'
			when sa.codcurso = '01' then '01 - Fundamental 1'
			when sa.codcurso = '02' then '02 - Fundamental 2'
			when sa.codcurso = '03' then '03 - Médio'
		end as 'curso_agrupado'
		,case
			when sa.codgrade = '0004.1' then '4'
			when sa.codgrade = '0005.1' then '5'
			when sa.codgrade = '0101.1' then '1'
			when sa.codgrade = '0102.1' then '2'
			when sa.codgrade = '0103.1' then '3'
			when sa.codgrade = '0104.1' then '4'
			when sa.codgrade = '0105.1' then '5'
			when sa.codgrade = '0206.1' then '6'
			when sa.codgrade = '0207.1' then '7'
			when sa.codgrade = '0208.1' then '8'
			when sa.codgrade = '0209.1' then '9'
			when sa.codgrade = '0002' then '2'
			when sa.codgrade = '0003' then '3'
			when sa.codgrade = '0004' then '4'
			when sa.codgrade = '0005' then '5'
			when sa.codgrade = '0101' then '1'
			when sa.codgrade = '0102' then '2'
			when sa.codgrade = '0103' then '3'
			when sa.codgrade = '0104' then '4'
			when sa.codgrade = '0105' then '5'
			when sa.codgrade = '0206' then '6'
			when sa.codgrade = '0207' then '7'
			when sa.codgrade = '0208' then '8'
			when sa.codgrade = '0209' then '9'
			when sa.codgrade = '0301' then '1'
			when sa.codgrade = '0302' then '2'
			when sa.codgrade = '0303' then '3'
		end as 'SERIE',
		sa.codperlet as 'ANO',
		GETDATE() as 'atualizado_em'
from
       satisfacao as sa
where 1=1
 and sa.codperlet >= 2023
       -- nota is not null
       ;