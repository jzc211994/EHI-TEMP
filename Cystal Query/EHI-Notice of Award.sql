SELECT DISTINCT
	PO.DocEntry,
	FORMAT(PO.DocDate, 'MMMM dd, yyyy') As DocDate,
	FORMAT(PO.DocDueDate,'MMMM dd, yyyy') AS DateRequired,
	PO.CardCode AS VendorCode,
	PO.CardName AS VendorName,
	BP.Currency + ' ' +(CONVERT(VARCHAR, FORMAT(PO.DocTotal, 'N2'))) AS ContractAmount,	
	SUBD.Name AS ContName,
	ITM.ItemName AS ProjectName,
	'NA-'+ ITM.U_Project + '-' + CAST(PO.DocEntry AS VARCHAR) AS Series,
	(SELECT NAME FROM DBO.[@SIGNATORY] WHERE CODE = 'MNGR') AS Manager
FROM POR1 PO1 
INNER JOIN OPOR PO ON PO1.DocEntry = PO.DocEntry
INNER JOIN OITM ITM ON PO1.Project = ITM.ItemCode
INNER JOIN DBO.[@SUBDIMENSION] SUBD ON PO1.U_Dimension3 = SUBD.Code
INNER JOIN OCRD BP ON BP.CardCode = PO.CardCode
WHERE
	PO.U_PR_Type2 = 'PCSC'


