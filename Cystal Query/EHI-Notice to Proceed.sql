SELECT DISTINCT
	PO.DocEntry,
	FORMAT(PO.DocDate, 'MMMM dd, yyyy') AS DocDate,
	PO.CardCode AS ContractoCode,
	PO.CardName AS ContractorName,
	PO.Project AS ProjectCode,
	ITM.ItemName AS ProjectName,
	(SELECT NAME FROM DBO.[@SUBDIMENSION] WHERE CODE = PO1.U_Dimension3) AS ContractName,
	BP.Currency + ' ' + CONVERT(VARCHAR, ROUND(PO.DOCTOTAL,2)) AS Amount,
	'NP-' + ITM.U_Project + '-' + CAST(PO.DocEntry AS Varchar) AS Series,
	(SELECT name FROM DBO.[@SIGNATORY] WHERE code = 'SLS') AS SalesAssoc
FROM POR1 PO1
INNER JOIN OPOR PO ON PO1.DocEntry = PO.DocEntry
INNER JOIN OITM ITM ON PO1.Project = ITM.ItemCode
INNER JOIN OCRD BP ON BP.CardCode = PO.CardCode
WHERE 
	PO.U_PR_Type2 = 'PCSC' and PO.DocEntry = 10

