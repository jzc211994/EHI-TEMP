SELECT 
	SO.DocEntry,
	SO.CardCode AS VendeeCode,
	SO.CardName AS VendeeName,
	CASE
		WHEN BP.U_SpouseName IS NULL THEN '____________________________'
		ELSE BP.U_SpouseName
	END AS SpouseName,
	ITM.U_Area AS LotArea,
	SO.DocTotal AS PurchasePrice,
	BP.Currency,
	ITM.U_Project AS ProjectCode,
	(SELECT Name FROM DBO.[@SIGNATORY] WHERE Code = 'MD') AS ManagingDirector,
	'SC-' + ITM.U_Project + '-' + CAST(SO.DocEntry AS varchar) AS Series
FROM RDR1 SO1 
INNER JOIN ORDR SO ON SO.DocEntry = SO1.DocEntry
INNER JOIN OCRD BP ON SO.CardCode = BP.CardCode
INNER JOIN OITM ITM ON ITM.ItemCode = SO.Project
WHERE SO.U_STP = 'SU'