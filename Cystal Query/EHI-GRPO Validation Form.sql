SELECT 
	PO.DocEntry,
	FORMAT(PO.DocDate, 'MMMM dd, yyyy') AS DocDate,
	PO.CardCode AS VendorCode,
	PO.CardName AS VendorName,
	PO.Address2 AS ShipTo,
	PO1.ItemCode,
	PO1.Dscription AS ItemName,
	PO1.U_BrandName AS Brand,
	PO1.UomCode AS Unit,
	PO1.LineTotal,
	PO.Comments,
	SUBSTRING(PO.U_Whse,1,2) AS SITE,
	(SELECT name FROM DBO.[@SIGNATORY] WHERE U_JobDesc = 'Checker' AND U_Site = SUBSTRING(PO.U_Whse,1,2)) AS Checker,
	(SELECT name FROM DBO.[@SIGNATORY] WHERE U_JobDesc = 'Storage In-charge' AND U_Site = SUBSTRING(PO.U_Whse,1,2)) AS SIC
FROM POR1 PO1
INNER JOIN OPOR PO ON PO.DocEntry = PO1.DocEntry
WHERE PO.DocType = 'I' AND PO.U_PR_Type2 IN ('PLISG','PIMPI','PLISS','PFXA')

