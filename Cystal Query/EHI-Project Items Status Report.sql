SELECT 
	T5.FldValue AS SiteCode,
	T5.Descr AS SiteName,
	T1.U_PrjCode AS ProjectCode,
	T1.U_PrjName AS ProjectName,
	T2.U_ItemCode AS ItemCode,
	T2.U_ItemName AS ItemName,
	T2.U_D1 AS D1Code,
	(SELECT NAME FROM [@SUBDIMENSION] WHERE Code = T2.U_D1) AS D1Name,
	T2.U_D2 AS D2Code,
	(SELECT NAME FROM [@SUBDIMENSION] WHERE Code = T2.U_D2) AS D2Name,
	T2.U_D3 AS D3Code,
	(SELECT NAME FROM [@SUBDIMENSION] WHERE Code = T2.U_D3) AS D3Name,
	T2.U_D4 AS D4Code,
	(SELECT NAME FROM [@SUBDIMENSION] WHERE Code = T2.U_D4) AS D4Name,
	T2.U_D5 AS D5Code,
	(SELECT NAME FROM [@SUBDIMENSION] WHERE Code = T2.U_D5) AS D5Name,
	SUM(T2.U_QtyInt) AS Budget_Qty,
	T3.DocEntry,
	SUM(T3.Quantity) AS GRPO_Qty,
	T4.DocEntry,
	SUM(T4.Quantity) AS GI_Qty

FROM [@BOQ] T1
	INNER JOIN [@BOQ1] T2 ON T1.DocEntry = T2.DocEntry AND T2.U_ItemCode IS NOT NULL
	LEFT JOIN PDN1 T3 ON T3.U_BudgetNo = T1.DocEntry
		AND T3.ItemCode = T2.U_ItemCode
		AND T3.U_Dimension1 = T2.U_D1
		AND T3.U_Dimension2 = T2.U_D2
		AND T3.U_Dimension3 = T2.U_D3
		AND T3.U_Dimension4 = T2.U_D4
		AND T3.U_Dimension5 = T2.U_D5
	LEFT JOIN IGE1 T4 ON T4.U_BudgetNo = T1.DocEntry
		AND T4.ItemCode = T2.U_ItemCode
		AND T4.U_Dimension1 = T2.U_D1
		AND T4.U_Dimension2 = T2.U_D2
		AND T4.U_Dimension3 = T2.U_D3
		AND T4.U_Dimension4 = T2.U_D4
		AND T4.U_Dimension5 = T2.U_D5
	INNER JOIN UFD1 T5 ON  T5.FldValue = LEFT(T1.U_PrjCode, 2) AND T5.TableID = 'OITM'

--WHERE T1.U_PrjCode = 'SW-DWB01'
--WHERE T1.U_PrjCode = 'SW-CB03L03'

GROUP BY
	T5.FldValue,
	T5.Descr,
	T1.U_PrjCode,
	T1.U_PrjName,
	T2.U_ItemCode,
	T2.U_ItemName,
	T2.U_D1,
	T2.U_D2,
	T2.U_D3,
	T2.U_D4,
	T2.U_D5,
	T3.DocEntry,
	T4.DocEntry

ORDER BY 
	T2.U_D1,
	T2.U_D2



