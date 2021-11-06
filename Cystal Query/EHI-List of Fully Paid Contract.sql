SELECT DISTINCT

	SO.DocEntry AS SOnum,
	DP.CardName AS Vendee,
	TRIM('B' FROM ITM.U_Block_No) AS Block,
	TRIM('L' FROM ITM.U_Lot_No) AS Lot,
	DP.Project AS ProjectCode,
	FORMAT(SO.U_StartDate,'MMMM dd, yyyy') AS ContractDate,
	SO.DocTotal AS ContractPrice,
	SO.U_Loanable AS LoanableAmount,
	SO.U_Equity As EquityAmount,
	(SELECT TOP 1 FORMAT(ODPI.DocDate,'MMMM dd, yyyy') FROM DPI1 INNER JOIN ODPI ON DPI1.DocEntry = ODPI.DocEntry WHERE DPI1.BaseEntry = SO.DocEntry AND ODPI.U_DPType = 'EQ' ORDER BY DPI1.DocEntry DESC) AS EuityPaid,
	(SELECT FORMAT(ODPI.DocDate,'MMMM dd, yyyy') FROM DPI1 INNER JOIN ODPI ON DPI1.DocEntry = ODPI.DocEntry WHERE DPI1.BaseEntry = SO.DocEntry AND ODPI.U_DPType = 'LA') AS LoanablePaid,
	ITM.U_Project AS SiteCode

FROM ORDR SO
INNER JOIN DPI1 DP1 ON DP1.BaseEntry = SO.DocEntry
INNER JOIN ODPI DP ON DP.DocEntry = DP1.DocEntry
INNER JOIN OITM ITM ON SO.Project = ITM.ItemCode

WHERE 
	(SELECT TOP 1 FORMAT(ODPI.DocDate,'MMMM dd, yyyy') FROM DPI1 INNER JOIN ODPI ON DPI1.DocEntry = ODPI.DocEntry WHERE DPI1.BaseEntry = SO.DocEntry AND ODPI.U_DPType = 'EQ' ORDER BY DPI1.DocEntry DESC)  IS NOT NULL AND 
	(SELECT ODPI.DocDate FROM DPI1 INNER JOIN ODPI ON DPI1.DocEntry = ODPI.DocEntry WHERE DPI1.BaseEntry = SO.DocEntry AND ODPI.U_DPType = 'LA') IS NOT NULL