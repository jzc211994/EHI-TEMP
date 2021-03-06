
--------------------------------------------------------------------------------------
SELECT
*
FROM 
(SELECT DISTINCT
	ITM.U_Project,
	'BK-' + TRIM('B' FROM ITM.U_Block_No) AS BLOCKCODE,
	'LT-' + TRIM('L' FROM ITM.U_LOT_NO) AS LOTCODE,
	BOQ.U_PrjCode PRJCODE,
	BOQ.U_PrjName PRJNAME,
	BOQ1.U_ItemCode ITMCODE,
	BOQ1.U_ItemName ITMNAME,
	BOQ1.U_D1 AS DIM1CODE,
	BOQ1.U_D1Name AS DIM1NAME,
	BOQ1.U_D2 AS DIM2CODE,
	BOQ1.U_D2Name AS DIM2NAME,
	BOQ1.U_D3 AS DIM3CODE,
	BOQ1.U_D3Name AS DIM3NAME,
	BOQ1.U_D4 AS DIM4CODE,
	BOQ1.U_D4Name AS DIM4NAME,
	BOQ1.U_D5 AS DIM5CODE,
	BOQ1.U_D5Name AS DIM5NAME,
	(SELECT SUM(T2.U_QtyInt) FROM [@BOQ] T1 
		INNER JOIN [@BOQ1] T2 ON T1.DocEntry = T2.DocEntry 
		WHERE T1.U_PrjCode = BOQ.U_PrjCode 
		AND T2.U_ItemCode = BOQ1.U_ItemCode
		AND T2.U_D1 = BOQ1.U_D1
		AND T2.U_D2 = BOQ1.U_D2) AS BOQ_QTY,
	BOQ.U_Status
FROM DBO.[@BOQ] BOQ
INNER JOIN DBO.[@BOQ1] BOQ1 ON BOQ.DocEntry = BOQ1.DocEntry
INNER JOIN OITM ITM ON ITM.ItemCode = BOQ.U_PrjCode) AS BOQ

LEFT JOIN

(SELECT DISTINCT
	PO1.Project AS PRJCODE,
	PO1.ItemCode AS ITMCODE,
	PO1.U_Dimension1 AS DIM1CODE,
	PO1.U_Dimension2 AS DIM2CODE,
	(SELECT SUM(T1.Quantity) FROM POR1 T1
		INNER JOIN OPOR T2 ON T1.DocEntry = T2.DocEntry
		WHERE T1.Project = PO1.Project 
		AND T1.ItemCode = PO1.ItemCode
		AND T1.U_Dimension1 = PO1.U_Dimension1
		AND T1.U_Dimension2 = PO1.U_Dimension2
		AND T2.CANCELED = 'N') AS PO_QTY
FROM POR1 PO1
INNER JOIN OPOR PO ON PO.DocEntry = PO1.DocEntry
WHERE PO.CANCELED = 'N') AS PO

ON BOQ.PRJCODE = PO.PRJCODE
AND BOQ.ITMCODE = PO.ITMCODE
AND BOQ.DIM1CODE = PO.DIM1CODE
AND BOQ.DIM2CODE = PO.DIM2CODE


LEFT JOIN

(SELECT DISTINCT
	GR1.Project AS PRJCODE,
	GR1.ItemCode AS ITMCODE,
	GR1.U_Dimension1 AS DIM1CODE,
	GR1.U_Dimension2 AS DIM2CODE,
	(SELECT SUM(T1.Quantity) FROM PDN1 T1
		INNER JOIN OPDN T2 ON T1.DocEntry = T2.DocEntry
		WHERE T1.Project = GR1.Project 
		AND T1.ItemCode = GR1.ItemCode
		AND T1.U_Dimension1 = GR1.U_Dimension1
		AND T1.U_Dimension2 = GR1.U_Dimension2
		AND T2.CANCELED = 'N') AS GR_QTY
FROM PDN1 GR1
INNER JOIN OPDN GR ON GR.DocEntry = GR1.DocEntry
WHERE GR.CANCELED = 'N') AS GR

ON BOQ.PRJCODE = GR.PRJCODE
AND BOQ.ITMCODE = GR.ITMCODE
AND BOQ.DIM1CODE = GR.DIM1CODE
AND BOQ.DIM2CODE = GR.DIM2CODE

WHERE BOQ.PRJCODE LIKE 'RV-HB08%'
AND (BOQ.U_Status IN ('A','APPROVED'))

ORDER BY BOQ.PRJCODE, BOQ.DIM1CODE, BOQ.DIM2CODE, BOQ.DIM3CODE , BOQ.DIM4CODE, BOQ.DIM5CODE

--------------------------------------------------------------------------------------
