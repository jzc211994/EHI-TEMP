SELECT DISTINCT
	PO.DocEntry AS PONum,
	FORMAT(PO.DocDate,'MMMM dd, yyyy') AS PODate,
	PO.CardCode AS VendorCode,
	PO.CardName AS VendorName,
	ITM.U_Project AS SiteCode,
	(SELECT Descr FROM UFD1 WHERE FldValue = ITM.U_Project AND TableID = 'OITM' AND FieldID = 0) AS SiteName,
	ITM.U_Model AS ModelCode,
	(SELECT Descr FROM UFD1 WHERE FldValue = ITM.U_Model AND TableID = 'OITM' AND FieldID = 1) AS ModelName,
	PO1.ItemCode AS ItemCode,
	PO1.Dscription AS ItemName,
	PO1.U_Dimension1 AS DimensionOne,
	(SELECT Name FROM DBO.[@SUBDIMENSION] WHERE Code = PO1.U_Dimension1) AS DimensionOneName,
	PO1.U_Dimension2 AS DimensionTwo,
	(SELECT Name FROM DBO.[@SUBDIMENSION] WHERE Code = PO1.U_Dimension2) AS DimensionTwoName,
	PO1.U_Dimension3 AS DismensionThree,
	(SELECT Name FROM DBO.[@SUBDIMENSION] WHERE Code = PO1.U_Dimension3) AS DimensionThreeName,
	PO1.U_Dimension4 AS DismensionFour,
	(SELECT Name FROM DBO.[@SUBDIMENSION] WHERE Code = PO1.U_Dimension4) AS DimensionFourName,
	PO1.U_Dimension5 AS DismensionFive,
	(SELECT Name FROM DBO.[@SUBDIMENSION] WHERE Code = PO1.U_Dimension5) AS DimensionFiveName,
	CASE
	 WHEN OP.DocEntry IS NOT NULL THEN 'PAID'
	 ELSE 'NOT PAID'
	END AS PaymentStat,
	FORMAT(OP.DocDate,'MMMM dd, yyyy') AS OPDate,
	'Block '+ TRIM('B' FROM ITM.U_Block_No) AS BlockNum,
	'Lot  '+ TRIM('L' FROM ITM.U_Lot_No) AS LotNUm,
	'BK-'+ TRIM('B' FROM ITM.U_Block_No) AS BlockCode,
	'LT-'+ TRIM('L' FROM ITM.U_Lot_No) AS LotCode
FROM POR1 PO1
LEFT JOIN OPOR PO ON PO.DocEntry = PO1.DocEntry
LEFT JOIN PCH1 AP1 ON AP1.BaseEntry = PO.DocEntry AND PO1.LineNum = AP1.BaseLine
LEFT JOIN OPCH AP ON AP.DocEntry = AP1.DocEntry
LEFT JOIN VPM2 OP2 ON OP2.DocEntry = AP.DocEntry AND OP2.InvType = 18
LEFT JOIN OVPM OP ON OP.DocNum = OP2.DocNum
INNER JOIN OITM ITM ON ITM.ItemCode = PO1.Project
WHERE
PO.U_PR_Type2 = 'PCSC'
ORDER BY PO.DocEntry

SELECT FldValue AS SiteCode, Descr AS SiteName FROM UFD1 WHERE TableID = 'OITM' AND FieldID = 0
SELECT CODE AS BlockCode, Name AS BlockName FROM DBO.[@SUBDIMENSION] WHERE CODE LIKE 'BK%'
SELECT CODE AS LotCode, Name AS LotName FROM DBO.[@SUBDIMENSION] WHERE CODE LIKE 'LT%'
SELECT CardCode AS ContractorCode, CardName AS ContractorName FROM OCRD WHERE CardCode like 'SC%'
SELECT Code AS SOWCode, Name AS SOWName FROM DBO.[@SUBDIMENSION] WHERE CODE LIKE 'SS%'


SELECT * FROM UFD1 WHERE TableID = 'OITM'