SELECT 
	GRPO.DocEntry,
	FORMAT(GRPO.DocDate,'MMMM dd, yyyy') AS DocDate,
	GRPO.CardCode AS VendorCode,
	GRPO.CardName As VendorName,
	GRPO.Address2 AS ShipTo,
	GRPO.Address AS ShipFrom,
	GRPO1.ItemCode,
	GRPO1.Dscription AS ItemName,
	GRPO1.U_BrandName AS Brand,
	GRPO1.UomCode AS Unit,
	GRPO1.Quantity,
	GRPO.U_Driver_Name AS DriverName,
	GRPO.U_Vehicle_PN AS VPlateNum,
	GRPO.Comments,
	(SELECT name FROM DBO.[@SIGNATORY] WHERE U_JobDesc = 'Checker' AND U_Site = SUBSTRING(GRPO.U_Whse,1,2)) AS Checker,
	(SELECT name FROM DBO.[@SIGNATORY] WHERE U_JobDesc = 'Storage In-charge' AND U_Site = SUBSTRING(GRPO.U_Whse,1,2)) AS SIC
FROM PDN1 GRPO1 
INNER JOIN OPDN GRPO ON GRPO1.DocEntry = GRPO.DocEntry
WHERE GRPO.DocType = 'I' AND GRPO.U_PR_Type2 IN ('PLISG','PIMPI','PLISS','PFXA')