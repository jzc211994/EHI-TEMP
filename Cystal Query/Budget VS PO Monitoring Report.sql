SELECT DISTINCT
	TB3.DocEntry AS 'PoNum',
	TB1.ProjectCode,
	TB1.ProjectName,
	TB1.ItemCode,
	TB1.ItemName,
	TB1.DIM1,
	(SELECT Name FROM [@SUBDIMENSION] WHERE CODE = TB1.DIM1) AS Dim1Name,
	TB1.Dim2,
	(SELECT Name FROM [@SUBDIMENSION] WHERE CODE = TB1.DIM2) AS Dim2Name,
	TB1.Dim3,
	(SELECT Name FROM [@SUBDIMENSION] WHERE CODE = TB1.DIM3) AS Dim3Name,
	TB1.DIM4,
	(SELECT Name FROM [@SUBDIMENSION] WHERE CODE = TB1.DIM4) AS Dim4Name,
	TB1.DIM5,
	(SELECT Name FROM [@SUBDIMENSION] WHERE CODE = TB1.DIM5) AS Dim5Name,
	--BudgetQty,
	--BudgetQty,
	--BudgetTotal,
	SUM(TB1.BudgetQty) AS Qty,
	SUM(TB1.BudgetRate) AS Rate,
	SUM(TB1.BudgetTotal) AS Total,
	SUM(TB2.Quantity) AS POQty,
	SUM(TB2.Price) AS PORate,
	SUM(TB2.LineTotal) AS POTotal

FROM

	(SELECT 
	T2.DocEntry, 
	T2.U_PrjCode AS ProjectCode, 
	T2.U_PrjName AS ProjectName,
	T1.U_ItemCode AS ItemCode, 
	T1.U_ItemName AS ItemName, 
	T1.U_D1 AS Dim1, 
	T1.U_D2 AS Dim2, 
	T1.U_D3 AS Dim3, 
	T1.U_D4 AS Dim4, 
	T1.U_D5 AS Dim5,
	T1.U_QtyInt AS BudgetQty,
	T1.U_RateIn AS BudgetRate,
	T1.U_TotalIn AS BudgetTotal
	FROM [@BOQ1] T1 
	INNER JOIN [@BOQ] T2 
	ON T1.DocEntry = T2.DocEntry
 
	UNION ALL

	SELECT 
	T2.DocEntry, 
	T2.U_PrjCode AS ProjectCode, 
	T2.U_PrjName,
	T1.U_ItemCode AS ItemCode, 
	T1.U_ItemName AS ItemName, 
	T1.U_D1 AS Dim1, 
	T1.U_D2 AS Dim2, 
	T1.U_D3 AS Dim3, 
	T1.U_D4 AS Dim4, 
	T1.U_D5 AS Dim5,
	T1.U_QtyInt AS BudgetQty,
	T1.U_RateIn AS BudgetRate,
	T1.U_TotalIn AS BudgetTotal
	FROM [@BOQ2] T1 
	INNER JOIN [@BOQ] T2 
	ON T1.DocEntry = T2.DocEntry

	UNION ALL

	SELECT 
	T2.DocEntry, 
	T2.U_PrjCode AS ProjectCode, 
	T2.U_PrjName,
	T1.U_ItemCode AS ItemCode, 
	T1.U_ItemName AS ItemName, 
	T1.U_D1 AS Dim1, 
	T1.U_D2 AS Dim2, 
	T1.U_D3 AS Dim3, 
	T1.U_D4 AS Dim4, 
	T1.U_D5 AS Dim5,
	T1.U_QtyInt AS BudgetQty,
	T1.U_RateIn AS BudgetRate,
	T1.U_TotalIn AS BudgetTotal
	FROM [@BOQ3] T1 
	INNER JOIN [@BOQ] T2 
	ON T1.DocEntry = T2.DocEntry

	UNION ALL

	SELECT 
	T2.DocEntry, 
	T2.U_PrjCode AS ProjectCode, 
	T2.U_PrjName,
	T1.U_Account AS ItemCode, 
	T1.U_AccountName AS ItemName, 
	T1.U_D1 AS Dim1, 
	T1.U_D2 AS Dim2, 
	T1.U_D3 AS Dim3, 
	T1.U_D4 AS Dim4, 
	T1.U_D5 AS Dim5,
	0 AS BudgetQty,
	0 AS BudgetRate,
	T1.U_TotalIn AS BudgetTotal
	FROM [@BOQ4] T1 
	INNER JOIN [@BOQ] T2 
	ON T1.DocEntry = T2.DocEntry) AS TB1

INNER JOIN POR1 TB2 
	ON TB2.Project = TB1.ProjectCode
	AND TB2.ItemCode = TB1.ItemCode
	AND TB2.U_Dimension1 = TB1.Dim1
	AND TB2.U_Dimension2 = TB1.Dim2
	AND TB2.U_Dimension3 = TB1.Dim3
	AND TB2.U_Dimension4 = TB1.Dim4
	AND TB2.U_Dimension5 = TB1.Dim5
INNER JOIN OPOR TB3
	ON TB2.DocEntry = TB3.DocEntry
	AND CANCELED = 'N'

WHERE 
	TB1.ItemCode IS NOT NULL

GROUP BY
	TB3.DocEntry,	
	TB1.ProjectCode,
	TB1.ProjectName,
	TB1.ItemCode,
	TB1.ItemName,
	TB1.DIM1,
	TB1.Dim2,
	TB1.Dim3,
	TB1.DIM4,
	TB1.DIM5

