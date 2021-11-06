SELECT
	SO.DocEntry,
	SO.CardName AS Vendee,
	REPLACE(SO.Address, CHAR(13), ' ')AS Address,
	BP.Currency,
	SO.DocTotal AS ContractAmount,
	ITM.U_Area AS LotArea,
	CASE
		WHEN BP.U_SpouseName IS NULL THEN '________________________'
		ELSE BP.U_SpouseName
	END AS SpouseName,
	'AS-' + ITM.U_Project + '-' + CAST(so.DocEntry AS varchar) AS Series,
	ITM.UserText AS Remarks,
	(SELECT NAME FROM DBO.[@SIGNATORY] WHERE Code = 'MD') AS ManagingDirector
FROM ORDR SO
INNER JOIN RDR1 SO1 ON SO.DocEntry = SO1.DocEntry
INNER JOIN OCRD BP ON BP.CardCode = SO.CardCode
INNER JOIN OITM ITM ON ITM.ItemCode = SO.Project
