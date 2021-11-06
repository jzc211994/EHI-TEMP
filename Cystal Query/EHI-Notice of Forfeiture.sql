SELECT 
	SO.DocEntry,
	FORMAT(GETDATE(), 'MMMM dd, yyyy') AS CurrentDate,
	SO.CardName AS Vendee,
	BP1.Street,
	BP1.ZipCode,
	CRY.Name AS Country,
	ITM.ItemName AS ProjectName,
	'NF-' + ITM.U_Project + '-' + CAST(SO.DocEntry AS Varchar) AS Series
FROM ORDR SO 
INNER JOIN RDR1 SO1 ON SO.DocEntry = SO1.DocEntry
INNER JOIN CRD1 BP1 ON BP1.CardCode = SO.CardCode AND BP1.Address = 'Bill to'
INNER JOIN OITM ITM ON ITM.ItemCode = SO.Project
INNER JOIN OCRY CRY ON CRY.Code = BP1.Country
