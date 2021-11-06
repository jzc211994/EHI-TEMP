SELECT 
	AR.DocEntry,
	AR.DocDate,
	AR.CardName AS Vendee,
	UDF.Descr AS ProjectSite,
	AR.Project AS ProjectCode,
	AR1.Dscription,
	AR.DocTotal AS TotalPenalty,
	BP.Currency
FROM OINV AR 
INNER JOIN INV1 AR1 ON AR.DocEntry = AR1.DocEntry
INNER JOIN OITM ITM ON ITM.ItemCode = AR.Project
INNER JOIN UFD1 UDF ON ITM.U_Project = UDF.FldValue AND UDF.TableID = 'OITM' AND UDF.FieldID = 0
INNER JOIN OCRD BP ON BP.CardCode = AR.CardCode
WHERE AR.DocType = 'S' AND AR.U_STP = 'PEN'

Select * from ufd1 where TableID = 'oitm' and FieldID = 0