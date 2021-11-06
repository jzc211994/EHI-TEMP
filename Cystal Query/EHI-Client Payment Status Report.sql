SELECT
	SO.DocEntry AS SONUM,
	SO.CardCode,
	SO.CardName,
	SO.Project,
	ITM.ItemName,
	SO.U_EndDueDate,
	ITM.U_Project,
	UDF.Descr,
	--DP.DocDueDate,
	MIN(DATEDIFF(MONTH, DP.DocDueDate, SO.U_EndDueDate)) AS MonthRemain

FROM 
	ORDR SO
	INNER JOIN RDR1 SO1 ON SO.DocEntry = SO1.DocEntry
	INNER JOIN DPI1 DP1 ON DP1.BaseEntry = SO.DocEntry AND DP1.BaseType = SO.ObjType
	INNER JOIN ODPI DP ON DP.DocEntry = DP1.DocEntry
	LEFT JOIN RIN1 CM1 ON CM1.BaseEntry = DP.DocEntry AND CM1.BaseType = DP.ObjType
	LEFT JOIN ORIN CM ON CM.DocEntry = CM1.DocEntry
	INNER JOIN RCT2 IP2 ON IP2.DocEntry = DP.DocEntry AND IP2.InvType = DP.ObjType
	INNER JOIN ORCT IP ON IP.DocEntry = IP2.DocNum
	INNER JOIN OITM ITM ON ITM.ItemCode = SO.Project
	INNER JOIN UFD1 UDF ON UDF.FldValue = ITM.U_Project AND UDF.TableID = 'OITM'

WHERE
	CM.DocEntry IS NULL
	AND DP.DocDueDate BETWEEN DATEADD(MONTH, -6, SO.U_EndDueDate) AND SO.U_EndDueDate
	AND SO.U_TypeOfFinancing = 'Pag-ibig'
	AND IP.Canceled = 'N'
	--AND IP.DocEntry IS NULL

GROUP BY 
	SO.DocEntry,
	SO.CardCode,
	SO.CardName,
	SO.Project,
	ITM.ItemName,
	ITM.U_Project,
	UDF.Descr,
	SO.U_EndDueDate

ORDER BY
SO.DocEntry



