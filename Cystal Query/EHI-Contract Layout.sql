SELECT 
	PO.DocEntry,
	FORMAT(PO.DocDate, 'MMMM dd, yyyy') AS DocDate,
	PO.CardCode AS VendorCode,
	PO.CardName AS VendorName,
	FORMAT(PO.DocDueDate, 'MMMM dd, yyyy') AS DateRequired,
	BP.Currency + ' ' + FORMAT(PO.DocTotal, 'N2') AS CotractAmount,
	PO1.ItemCode AS SowCode,
	PO1.Dscription AS SowName,
	SUBD.NAME AS D2Name, 
	BP.Currency + ' ' +	FORMAT(PO1.LineTotal, 'N2') AS SowAmount,
	ITM.ItemCode AS ProjectCode,
	ITM.ItemName AS ProjectName,
	UDF.Descr AS ProjectSite,
	'CL-' + ITM.U_Project + '-' + CAST(PO.DocEntry AS varchar) AS Series,
	(SELECT NAME FROM DBO.[@SIGNATORY] WHERE CODE = 'MNGR') AS Manager,
	(SELECT NAME FROM DBO.[@SIGNATORY] WHERE CODE = 'MD') AS ManagingDirector,
	(SELECT NAME FROM DBO.[@SIGNATORY] WHERE CODE = 'STENGR') AS SiteEngineer
FROM POR1 PO1
INNER JOIN OPOR PO ON PO.DocEntry = PO1.DocEntry
INNER JOIN OITM ITM ON PO1.Project = ITM.ItemCode
INNER JOIN DBO.[@SUBDIMENSION] SUBD ON SUBD.CODE = PO1.U_Dimension2
INNER JOIN OCRD BP ON BP.CardCode = PO.CardCode
INNER JOIN UFD1 UDF ON UDF.FldValue = ITM.U_Project AND UDF.TableID = 'OITM' AND UDF.FieldID = 0
WHERE PO.U_PR_Type2 = 'PCSC'