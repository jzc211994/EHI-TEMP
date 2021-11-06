--DIFFERECT WAREHOUSE CODE(TEST)
	IF @object_type = '540000006' AND (@transaction_type IN ('A','U'))
	BEGIN
	IF EXISTS(
		SELECT PR.DocEntry FROM
			(SELECT 
				PR.DocEntry,
				PR1.WhsCode,
				PR1.LineNum
			FROM OPRQ PR 
			INNER JOIN PRQ1 PR1 ON PR.DocEntry = PR1.DocEntry) AS PR
		INNER JOIN 
			(SELECT
				PQ.DocEntry,
				PQ1.BaseEntry,
				PQ1.WhsCode,
				PQ1.BaseLine
			FROM OPQT PQ
			INNER JOIN PQT1 PQ1 ON PQ.DocEntry = PQ1.DocEntry) AS PQ 
		ON PR.DocEntry = PQ.BaseEntry AND PQ.BaseLine = PR.LineNum
		WHERE PR.WhsCode! = PQ.WhsCode
	)
	BEGIN
	SET @error = 032194
	SET @error_message = 'WAREHOUSE CODE DIDNT MATCH FORM PURCHASE REQUEUST.'
	END
	END