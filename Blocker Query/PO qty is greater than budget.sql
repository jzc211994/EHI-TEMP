SELECT 
	T3.DocEntry
FROM 

(--MATERIALS
SELECT 
	T1.U_PrjCode, T2.U_ItemCode, T2.U_ItemName, T2.U_D1, T2.U_D2, T2.U_D3, T2.U_D4, T2.U_D5,
	(SUM(T2.U_QtyInt)) AS QtyInt,
	(SUM(T2.U_QtyEx)) AS QtyExt,
	(SELECT TOP 1 B2.U_RateIn FROM [@BOQ] B1
		INNER JOIN [@BOQ1] B2 ON B1.DocEntry = B2.DocEntry
		AND B1.U_PrjCode = T1.U_PrjCode
		AND B2.U_ItemCode = T2.U_ItemCode
		AND B2.U_D1 = T2.U_D1
		AND B2.U_D2 = T2.U_D2
		AND B2.U_D3 = T2.U_D3
		AND B2.U_D4 = T2.U_D4
		AND B2.U_D5 = T2.U_D5
	WHERE B1.U_Type = 'O') AS RateInt,
	(SELECT TOP 1 B2.U_RateEx FROM [@BOQ] B1
		INNER JOIN [@BOQ1] B2 ON B1.DocEntry = B2.DocEntry
		AND B1.U_PrjCode = T1.U_PrjCode
		AND B2.U_ItemCode = T2.U_ItemCode
		AND B2.U_D1 = T2.U_D1
		AND B2.U_D2 = T2.U_D2
		AND B2.U_D3 = T2.U_D3
		AND B2.U_D4 = T2.U_D4
		AND B2.U_D5 = T2.U_D5
	WHERE B1.U_Type = 'O') AS RateExt,
	(SUM(T2.U_TotalIn)) AS TotalInt,
	(SUM(T2.U_TotalEx)) AS TotalExt
FROM [@BOQ] T1 
	INNER JOIN [@BOQ1] T2 ON T1.DocEntry = T2.DocEntry
WHERE 
	T2.U_ItemCode IS NOT NULL
	AND T1.U_Status = 'APPROVED'
GROUP BY 
	T1.U_PrjCode, T2.U_ItemCode, T2.U_ItemName,	T2.U_D1, T2.U_D2, T2.U_D3, T2.U_D4, T2.U_D5

UNION ALL

--EQUIPMENTS
SELECT 
	T1.U_PrjCode, T2.U_ItemCode, T2.U_ItemName, T2.U_D1, T2.U_D2, T2.U_D3, T2.U_D4, T2.U_D5,
	(SUM(T2.U_QtyInt)) AS QtyInt,
	(SUM(T2.U_QtyEx)) AS QtyExt,
	(SELECT TOP 1 B2.U_RateIn FROM [@BOQ] B1
		INNER JOIN [@BOQ2] B2 ON B1.DocEntry = B2.DocEntry
		AND B1.U_PrjCode = T1.U_PrjCode
		AND B2.U_ItemCode = T2.U_ItemCode
		AND B2.U_D1 = T2.U_D1
		AND B2.U_D2 = T2.U_D2
		AND B2.U_D3 = T2.U_D3
		AND B2.U_D4 = T2.U_D4
		AND B2.U_D5 = T2.U_D5
	WHERE B1.U_Type = 'O') AS RateInt,
	(SELECT TOP 1 B2.U_RateEx FROM [@BOQ] B1
		INNER JOIN [@BOQ2] B2 ON B1.DocEntry = B2.DocEntry
		AND B1.U_PrjCode = T1.U_PrjCode
		AND B2.U_ItemCode = T2.U_ItemCode
		AND B2.U_D1 = T2.U_D1
		AND B2.U_D2 = T2.U_D2
		AND B2.U_D3 = T2.U_D3
		AND B2.U_D4 = T2.U_D4
		AND B2.U_D5 = T2.U_D5
	WHERE B1.U_Type = 'O') AS RateExt,
	(SUM(T2.U_TotalIn)) AS TotalInt,
	(SUM(T2.U_TotalEx)) AS TotalExt
FROM [@BOQ] T1 
	INNER JOIN [@BOQ2] T2 ON T1.DocEntry = T2.DocEntry
WHERE 
	T2.U_ItemCode IS NOT NULL
	AND T1.U_Status = 'APPROVED'
GROUP BY 
	T1.U_PrjCode, T2.U_ItemCode, T2.U_ItemName,	T2.U_D1, T2.U_D2, T2.U_D3, T2.U_D4, T2.U_D5

UNION ALL

--LABOR
SELECT 
	T1.U_PrjCode, T2.U_ItemCode, T2.U_ItemName, T2.U_D1, T2.U_D2, T2.U_D3, T2.U_D4, T2.U_D5,
	(SUM(T2.U_QtyInt)) AS QtyInt,
	(SUM(T2.U_QtyEx)) AS QtyExt,
	(SELECT TOP 1 B2.U_RateIn FROM [@BOQ] B1
		INNER JOIN [@BOQ3] B2 ON B1.DocEntry = B2.DocEntry
		AND B1.U_PrjCode = T1.U_PrjCode
		AND B2.U_ItemCode = T2.U_ItemCode
		AND B2.U_D1 = T2.U_D1
		AND B2.U_D2 = T2.U_D2
		AND B2.U_D3 = T2.U_D3
		AND B2.U_D4 = T2.U_D4
		AND B2.U_D5 = T2.U_D5
	WHERE B1.U_Type = 'O') AS RateInt,
	(SELECT TOP 1 B2.U_RateEx FROM [@BOQ] B1
		INNER JOIN [@BOQ3] B2 ON B1.DocEntry = B2.DocEntry
		AND B1.U_PrjCode = T1.U_PrjCode
		AND B2.U_ItemCode = T2.U_ItemCode
		AND B2.U_D1 = T2.U_D1
		AND B2.U_D2 = T2.U_D2
		AND B2.U_D3 = T2.U_D3
		AND B2.U_D4 = T2.U_D4
		AND B2.U_D5 = T2.U_D5
	WHERE B1.U_Type = 'O') AS RateExt,
	(SUM(T2.U_TotalIn)) AS TotalInt,
	(SUM(T2.U_TotalEx)) AS TotalExt
FROM [@BOQ] T1 
	INNER JOIN [@BOQ3] T2 ON T1.DocEntry = T2.DocEntry
WHERE 
	T2.U_ItemCode IS NOT NULL
	AND T1.U_Status = 'APPROVED'
GROUP BY 
	T1.U_PrjCode, T2.U_ItemCode, T2.U_ItemName,	T2.U_D1, T2.U_D2, T2.U_D3, T2.U_D4, T2.U_D5) AS T1

INNER JOIN 
	--GRPO
	(SELECT 
		T2.Project,
		T2.ItemCode,
		T2.Dscription,
		T2.U_Dimension1,
		T2.U_Dimension2,
		T2.U_Dimension3,
		T2.U_Dimension4,
		T2.U_Dimension5,
		SUM(T2.Quantity) AS Quantity
	FROM OPDN T1 
		INNER JOIN PDN1 T2 ON T1.DocEntry = T2.DocEntry
	WHERE
		T1.CANCELED = 'N'
	GROUP BY 
		T2.Project,
		T2.ItemCode,
		T2.Dscription,
		T2.U_Dimension1,
		T2.U_Dimension2,
		T2.U_Dimension3,
		T2.U_Dimension4,
		T2.U_Dimension5) AS T2
ON T1.U_ItemCode = T2.ItemCode
	AND T1.U_PrjCode = T2.Project
	AND T1.U_D1 = T2.U_Dimension1
	AND T1.U_D2 = T2.U_Dimension2
	AND T1.U_D3 = T2.U_Dimension3
	AND T1.U_D4 = T2.U_Dimension4
	AND T1.U_D5 = T2.U_Dimension5
INNER JOIN 
	POR1 T3 ON T1.U_ItemCode = T3.ItemCode
	AND T1.U_PrjCode = T3.Project
	AND T1.U_D1 = T3.U_Dimension1
	AND T1.U_D2 = T3.U_Dimension2
	AND T1.U_D3 = T3.U_Dimension3
	AND T1.U_D4 = T3.U_Dimension4
	AND T1.U_D5 = T3.U_Dimension5

WHERE 
	(T1.QtyInt - T2.Quantity)<T3.Quantity
	--AND T3.DocEntry = 1
	