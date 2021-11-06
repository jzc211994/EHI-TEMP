-- BLOCKER FOR OVER BUDGET BOQ1/BOQ2/BOQ3
SELECT 
	PO.DocEntry
FROM 
	(SELECT * FROM JC_BOQ1
	UNION
	SELECT * FROM JC_BOQ2
	UNION
	SELECT * FROM JC_BOQ3) BOQ
	INNER JOIN IGE1 GI ON GI.U_BudgetNo = BOQ.DocEntry
		AND BOQ.ProjectCode = GI.Project
		AND BOQ.ItemCode = GI.ItemCode
		AND BOQ.D1 = GI.U_Dimension1
		AND BOQ.D2 = GI.U_Dimension2
		AND BOQ.D3 = GI.U_Dimension3
		AND BOQ.D4 = GI.U_Dimension4
		AND BOQ.D5 = GI.U_Dimension5
	INNER JOIN POR1 PO ON PO.U_BudgetNo = BOQ.DocEntry
		AND BOQ.ProjectCode = PO.Project
		AND BOQ.ItemCode = PO.ItemCode
		AND BOQ.D1 = PO.U_Dimension1
		AND BOQ.D2 = PO.U_Dimension2
		AND BOQ.D3 = PO.U_Dimension3
		AND BOQ.D4 = PO.U_Dimension4
		AND BOQ.D5 = PO.U_Dimension5
WHERE 
	PO.Quantity > BOQ.QtyInt-GI.Quantity
	--AND PO.DocEntry = 