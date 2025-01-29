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