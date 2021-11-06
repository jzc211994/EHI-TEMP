SELECT DISTINCT
	--Header
	GR.DocEntry,
	FORMAT(GR.DocDate, 'MMMM dd, yyyy') AS DocDate,
	FORMAT(PO.DocDate, 'MMMM dd, yyyy') AS PODate,
	GR.CardName AS VendorName,
	PO.DocEntry AS PONum,
	GR.Address AS ShipFrom,
	GR.Address2 AS ShipTo,
	CASE
		WHEN GR.DocStatus = 'O' THEN 'OPEN'
		WHEN GR.DocStatus = 'C' THEN 'CLOSE'
	END AS DocStatus,
	GR.Comments,
	GR.U_RetRes,
	--Content
	GR1.ItemCode,
	GR1.Dscription AS ItemName,
	GR1.UomCode AS Unit,
	GR1.Quantity,
	(SELECT name FROM DBO.[@SIGNATORY] WHERE U_JobDesc = 'Checker' AND U_Site = SUBSTRING(GR.U_Whse,1,2)) AS Checker,
	(SELECT name FROM DBO.[@SIGNATORY] WHERE U_JobDesc = 'Storage In-charge' AND U_Site = SUBSTRING(GR.U_Whse,1,2)) AS SIC

FROM RPD1 GR1
INNER JOIN ORPD GR ON GR.DocEntry = GR1.DocEntry
INNER JOIN PDN1 GRPO1 ON GR1.BaseEntry = GRPO1.DocEntry
INNER JOIN OPDN GRPO ON GRPO.DocEntry= GRPO1.DocEntry
INNER JOIN OPOR PO ON PO.DocEntry = GRPO1.BaseEntry