SELECT 
	T1.DocEntry,
	T6.CardName,
	T6.Project,
	T7.PrjName,
	CASE
		WHEN T2.DocEntry IS NOT NULL THEN 'MATERIALS'
		WHEN T3.DocEntry IS NOT NULL THEN 'EQUIPMENT'
		WHEN T4.DocEntry IS NOT NULL THEN 'LABOR'
		WHEN T5.DocEntry IS NOT NULL THEN 'OTHERS'
	END AS PO_TYPE,
	SUM(T1.LineTotal+T1.VatSum) AS POTOTAL,
	SUM(T2.U_RateIn*T1.Quantity) AS BTOTAL_MATERIALS,
	SUM(T3.U_RateIn*T1.Quantity) AS BTOTAL_EQUIPMENT,
	SUM(T4.U_RateIn*T1.Quantity) AS BTOTAL_LABOR,
	SUM(T5.U_TotalIn) AS BTOTAL_OTHERS,

	CASE 
		WHEN SUM(T2.U_RateIn*T1.Quantity) IS NOT NULL OR SUM(T2.U_RateIn*T1.Quantity) != 0 THEN SUM(T2.U_RateIn*T1.Quantity)
		WHEN SUM(T3.U_RateIn*T1.Quantity) IS NOT NULL OR SUM(T3.U_RateIn*T1.Quantity) != 0 THEN SUM(T3.U_RateIn*T1.Quantity)
		WHEN SUM(T4.U_RateIn*T1.Quantity) IS NOT NULL OR SUM(T4.U_RateIn*T1.Quantity) != 0 THEN SUM(T4.U_RateIn*T1.Quantity)
		WHEN  SUM(T5.U_TotalIn) IS NOT NULL OR SUM(T5.U_TotalIn) != 0 THEN SUM(T5.U_TotalIn)
	END AS BudgetTotal,

	CASE 
		WHEN SUM(T2.U_RateIn*T1.Quantity) IS NOT NULL OR SUM(T2.U_RateIn*T1.Quantity) != 0 THEN SUM(T2.U_RateIn*T1.Quantity)
		WHEN SUM(T3.U_RateIn*T1.Quantity) IS NOT NULL OR SUM(T3.U_RateIn*T1.Quantity) != 0 THEN SUM(T3.U_RateIn*T1.Quantity)
		WHEN SUM(T4.U_RateIn*T1.Quantity) IS NOT NULL OR SUM(T4.U_RateIn*T1.Quantity) != 0 THEN SUM(T4.U_RateIn*T1.Quantity)
		WHEN  SUM(T5.U_TotalIn) IS NOT NULL OR SUM(T5.U_TotalIn) != 0 THEN SUM(T5.U_TotalIn)
	END - SUM(T1.LineTotal+T1.VatSum) AS Gain_Loss


	
FROM DRF1 T1
	LEFT JOIN [@BOQ1] T2 ON T2.DocEntry = T1.U_BudgetNo
		AND T1.ItemCode = T2.U_ItemCode
		AND T1.U_Dimension1 = T2.U_D1
		AND T1.U_Dimension2 = T2.U_D2
		AND T1.U_Dimension3 = T2.U_D3
		AND T1.U_Dimension4 = T2.U_D4
		AND T1.U_Dimension5 = T2.U_D5
	LEFT JOIN [@BOQ2] T3 ON T3.DocEntry = T1.U_BudgetNo
		AND T1.ItemCode = T3.U_ItemCode
		AND T1.U_Dimension1 = T3.U_D1
		AND T1.U_Dimension2 = T3.U_D2
		AND T1.U_Dimension3 = T3.U_D3
		AND T1.U_Dimension4 = T3.U_D4
		AND T1.U_Dimension5 = T3.U_D5
	LEFT JOIN [@BOQ3] T4 ON T4.DocEntry = T1.U_BudgetNo
		AND T1.ItemCode = T4.U_ItemCode
		AND T1.U_Dimension1 = T4.U_D1
		AND T1.U_Dimension2 = T4.U_D2
		AND T1.U_Dimension3 = T4.U_D3
		AND T1.U_Dimension4 = T4.U_D4
		AND T1.U_Dimension5 = T4.U_D5
	LEFT JOIN [@BOQ4] T5 ON T5.DocEntry = T1.U_BudgetNo
		AND T1.AcctCode = T5.U_Account
		AND T1.Dscription = T5.U_Description
		AND T1.U_Dimension1 = T5.U_D1
		AND T1.U_Dimension2 = T5.U_D2
		AND T1.U_Dimension3 = T5.U_D3
		AND T1.U_Dimension4 = T5.U_D4
		AND T1.U_Dimension5 = T5.U_D5
	INNER JOIN ODRF T6 ON T6.DocEntry = T1.DocEntry
	INNER JOIN OPRJ T7 ON T6.Project = T7.PrjCode

WHERE 
	T6.ObjType = 22
	AND (T1.Project LIKE 'SW%'
	OR T1.Project LIKE 'RV%')
	--AND T6.DocStatus = 'O'
GROUP BY T1.DocEntry,
	T2.DocEntry,
	T6.CardName,
	T6.Project,
	T7.PrjName,
	T3.DocEntry,
	T4.DocEntry,
	T5.DocEntry
--SELECT DocTotal FROM OPOR WHERE DocEntry = 191