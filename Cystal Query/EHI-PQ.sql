SELECT DISTINCT
	PQ.DocEntry AS PQNum,
	PQ.DocDate AS PQDate,
	PQ.CardCode AS VendorCode,
	PQ.CardName AS VendorName,
	PQ1.ItemCode,
	PQ1.Dscription AS ItemName,
	PQ1.UomCode AS Unit,
	PQ1.U_Dimension1 AS DimensionOne,
	PQ1.U_Dimension2 AS DimensionTwo,
	PQ1.U_Dimension3 AS DimensionThree,
		(SELECT SUM(PQT1.Quantity) FROM OPQT 
		INNER JOIN PQT1 ON OPQT.DocEntry = PQT1.DocEntry 
		WHERE OPQT.DocEntry = PQ.DocEntry AND PQ1.ItemCode = PQT1.ItemCode 
		AND PQ1.U_Dimension1 = PQT1.U_Dimension1 AND PQ1.U_Dimension2 = PQT1.U_Dimension2
		AND PQ1.U_Dimension3 = PQT1.U_Dimension3) AS Quantity
FROM OPQT PQ
INNER JOIN PQT1 PQ1 ON PQ.DocEntry = PQ1.DocEntry
WHERE PQ.DocEntry = 14