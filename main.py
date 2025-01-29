from scripts.extract.exportar_dados_para_parquet import salvar_dados
from scripts.load.load import load_dataframe
from config.configs import settings
import pandas as pd


query ="""
SELECT
    AVA.RA,
    PP.NOME AS ALUNO,
    MPL.CODTURMA,
    STD.CODTURMA AS CODTURMA_2,
    ATD.IDTURMADISC,
    STD.CODDISC,
    SD.NOME AS DISCIPLINA,
    ETP.ETAPA AS ETAPA_PAI,
    ETP.DESCRICAO AS DESC_ETAPA_PAI,
	ETP.LABEL as SEMESTRE,
    AV.NOME AS AVALIACAO,
    AV.TIPO AS TIPO_AVALIACAO,
    AV.PESO,
    AV.NOTAMAXIMA ,
    ATD.DATA AS DATA_APL_PROVA,
    AVA.NOTA AS NOTA_ALUNO,
    CONCAT('https://diario.escolamobile.com.br/php/imagem_carometro.php?ra=',AVA.RA) AS FOTO,
    GETDATE() as 'ULTIMA_ATUALIZACAO',
    case
		when lic.PERCFEITAS is null then '-'
		else lic.PERCFEITAS  
	end as 'LICAO_DE_CASA',
	CASE	
		WHEN STD.CODDISC LIKE '%.I' THEN 'Interdisciplinar'
		WHEN STD.CODDISC LIKE '%.E' THEN 'Eletiva'
		WHEN (STD.CODDISC = 'ING' OR STD.CODDISC = 'ESP') THEN 'Turma Mista'
	ELSE 'Regular'
		END AS TIPO_DISCIPLINA,
        ET.DESCRICAO AS PERIODO,
        AV.PUBLICAR,
		SPL.CODPERLET as 'ANO_LETIVO',
		CASE
			WHEN AV.ULTIMOPERIODO IS NULL THEN 0
			ELSE AV.ULTIMOPERIODO
		END AS 'ULTIMOPERIODO'
    -- falt.FALTAS,s
    -- falt.FALTASSTR
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
    left join DiarioMB.dbo.REL_LICOESALUNOS as lic on lic.RA = ava.RA and lic.CODTURMA = mpl.CODTURMA and lic.CODDISC = std.CODDISC
    and lic.CODREDUZIDO = etp.CODREDUZIDO
    -- left join DiarioMB.dbo.VW_FALTASALUNOS as falt on falt.RA = ava.RA and falt.CODTURMA = mpl.CODTURMA and falt.CODDISC = std.CODDISC
   WHERE
   1=1
    -- AV.PUBLICAR = 1
    AND SPL.CODPERLET >= 2023
    and MPL.CODTURMA not like 'C%'
    and SST.PLATIVO = 'S'
	and ETP.DESCRICAO like '%Integral%'
    -- AND ETP.ETAPA = '547' /* 1º Semestre - Médio - Período Parcial */
    -- and ava.RA = 140365
    -- and std.CODDISC = 'QUI'
                ;
"""

salvar_dados(
    origem="google_sheets",
    nome_arquivo="planilha_dados",
    formato="excel",
    path_file="data/raw/sheets",
    api_key=settings.API_GOOGLE_SHEETS,
    spreadsheet_url="https://docs.google.com/spreadsheets/d/1XE8jyzGV8Mi1XYx5UIL1t4TK4V6YdIh1hOyuSHHm0S8"
)
print("Planilha salva com sucesso!")

# Chamada da função
salvar_dados(
    origem='sql',
    nome_arquivo='alunos_teste',
    formato='parquet',
    path_file='data/raw/parquet',
    query=query,
    credenciais={'server':settings.MS_SQL_SERVER, 
                 'user':settings.MS_SQL_USER, 
                 'password':settings.MS_SQL_PASSWORD},
    nome_banco='corporeRM',
    tipo_banco='sqlserver'
)
print("Dados salvos com sucesso!")



query_mysql = """
SELECT
	STU.identification AS 'ALUNO_RA',
    STU.name AS 'ALUNO_NOME',
    SQ.class_code AS 'ALUNO_CLASSE',	-- PEGANDO A TURMA DA LIGAÇÃO DE ESTUDANTES E QUIZZES
    LEFT(QUI.grade,1) AS 'ALUNO_GRADE', -- PEGANDO GRADE DA PROVA
    SQ.identification AS 'DIARIO_AVALIACOESALUNOS',
    SQ.final_score AS 'NOTA_FINAL',
    QUI.id AS 'PROVA_ID',
    QUI.name AS 'PROVA_NOME',
    QUI.question_quantity AS 'PROVA_QTD_QUESTOES',
    QUI.year AS 'ANO_LETIVO',
    QUI.taken_date AS 'PROVA_DATA',
    QUI.status AS 'PROVA_STATUS',
    QUI.stage AS 'PROVA_PERIODO',
    QUI.maximum_points AS 'PROVA_NOTA_MAX',
    SUB.name AS 'DISCIPLINA',
    SUB.code AS 'DISCIPLINA _COD', 
    QQ.question_number AS 'QUESTAO_NUM',
    QQ.maximum_points AS 'QUESTAO_NOTA_MAX',
    AP.question_penalty AS 'QUESTAO_PONTUACAO',
    STA.id AS 'CARIMBO_ID',
    STA.name AS 'CARIMBO_NOME',
    STA.description AS 'CARIMBO_DESC',
    CAT.name AS 'CAT_NOME',
    CAT.color AS 'CAT_COLOR',
    NOW() AS 'ULTIMA_ATUALIZACAO',
    CASE	
		WHEN SUB.code LIKE '%.I' THEN 'Interdisciplinar'
		WHEN SUB.code LIKE '%.E' THEN 'Eletiva'
		WHEN (SUB.code = 'ING' OR SUB.code = 'ESP') THEN 'Turma Mista'
		ELSE 'Regular'
		END AS TIPO_DISCIPLINA,
	SF.folder_id AS 'PASTA_ID',
    F.name AS 'PASTA'
FROM
	students STU
    INNER JOIN student_quizzes SQ ON SQ.student_id = STU.id
    INNER JOIN quizzes QUI ON QUI.id = SQ.quiz_id
    INNER JOIN quiz_questions QQ ON QQ.quiz_id = QUI.id
    INNER JOIN questions QUE ON QUE.quiz_question_id = QQ.id AND QUE.student_quiz_id = SQ.id
    LEFT JOIN (SELECT
					APS.id,
					APS.question_id,
					APS.stampable_type,
					APS.stampable_id,
					CASE
						WHEN APS.stampable_type = 'QuizStamp' THEN QUIS.question_penalty
						WHEN APS.stampable_type = 'QuestionStamp' THEN QUES.question_penalty
						END AS 'question_penalty',
					CASE
						WHEN APS.stampable_type = 'QuizStamp' THEN QUIS.stamp_id
						WHEN APS.stampable_type = 'QuestionStamp' THEN QUES.stamp_id
						END AS 'stamp_id'
				FROM
					applied_stamps APS
					LEFT JOIN quiz_stamps QUIS ON QUIS.id = APS.stampable_id AND APS.stampable_type = 'QuizStamp'
					LEFT JOIN question_stamps QUES ON QUES.id = APS.stampable_id AND APS.stampable_type = 'QuestionStamp'
				) AP ON AP.question_id = QUE.id
    INNER JOIN stamps STA ON STA.id = AP.stamp_id
    INNER JOIN stamp_folders SF ON SF.stamp_id = STA.id
    INNER JOIN folders F ON F.id = SF.folder_id
    INNER JOIN categories CAT ON CAT.id = STA.category_id
    INNER JOIN subjects SUB ON SUB.id = QUI.subject_id
WHERE
	QUI.year >= 2022
   -- AND STU.identification = '100045'		-- RA
   -- AND SQ.identification = '6630192'		-- AVALIAÇÕES ALUNOS
   -- AND QUI.id = '11' 					-- ID DA PROVA
ORDER BY
	STU.name,
    QUI.id,
    QQ.question_number,
    STA.name
-- LIMIT 100
;
"""

# Chamada da função
salvar_dados(
    origem='sql',
    nome_arquivo='teste_mysql',
    formato='parquet',
    path_file='data/raw/parquet',
    query=query_mysql,
    credenciais={
        'user': settings.MYSQL_USER,
        'password': settings.MYSQL_PASSWORD,
        'host': settings.MYSQL_HOST,
        'port': settings.MYSQL_PORT
    },
    nome_banco='escola_mobile_corretor',
    tipo_banco='mysql'
)

print(pd.read_parquet('data/raw/parquet/teste_mysql.parquet'))
print(pd.read_parquet('data/raw/parquet/alunos_teste.parquet'))
