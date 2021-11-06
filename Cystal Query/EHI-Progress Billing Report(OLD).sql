SELECT
	API.DocEntry,
	API.CardCode AS ContractorCode,
	API.CardName AS Contractor,
	ITM.ItemName AS ProjectCode,
	ITM.U_Model AS ModelCode,
	(SELECT Descr FROM UFD1 WHERE FldValue = ITM.U_Model AND TableID = 'OITM') AS ModelName,
	API1.U_Dimension4 AS BlockCode,
	(SELECT NAME FROM DBO.[@SUBDIMENSION] WHERE CODE = API1.U_Dimension4) AS Block,
	API1.U_Dimension5 AS LotCode,
	(SELECT NAME FROM DBO.[@SUBDIMENSION] WHERE CODE = API1.U_Dimension5) AS Lot,
	API1.ItemCode AS SOWCode,
	API1.Dscription AS SOW,
	API1.U_Dimension2 AS D2Code,
	(SELECT NAME FROM DBO.[@SUBDIMENSION] WHERE CODE = API1.U_Dimension2) AS Dimension2,
	CASE 
		WHEN OP2.DocEntry IS NOT NULL THEN 'ü'
		ELSE '-'
	END AS PaymentStatus,
	FORMAT(OP.DocDate, 'MMMM dd, yyyy') AS PaymentDate,
	--PARAMETERS
	UDF.FldValue,
	UDF.Descr

FROM PCH1 API1
INNER JOIN OPCH API ON API.DocEntry = API1.DocEntry
INNER JOIN OITM ITM ON API.Project = ITM.ItemCode 
LEFT JOIN VPM2 OP2 ON OP2.DocEntry = API.DocEntry AND OP2.InvType = '18'
LEFT JOIN OVPM OP ON OP.DocNum = OP2.DocNum
INNER JOIN UFD1 UDF ON UDF.FldValue = ITM.U_Project AND UDF.TableID = 'OITM'
WHERE API.U_PR_Type2 = 'PCSC' AND API.U_PerCom = 100
ORDER BY API1.U_Dimension4, API1.U_Dimension5, API.CardName

