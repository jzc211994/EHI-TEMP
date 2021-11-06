--CREATE VIEW JC_BOQ4 AS
--ALTER VIEW JC_BOQ4 AS

SELECT 
	B1.U_PrjCode AS ProjectCode,
	B1.U_PrjName AS ProjectName,
	COALESCE(R2.DocEntry , O1.DocEntry, NULL, NULL) AS DocEntry,
	COALESCE(R2.LineID , O1.LineID, NULL, NULL) AS LineID,
	COALESCE(R2.U_Description , O1.U_Description, NULL, NULL) AS Description,
	COALESCE(R2.U_Account , O1.U_Account, NULL, NULL) AS ItemCode,
	COALESCE(R2.U_AccountName , O1.U_AccountName, NULL, NULL) AS ItemName,
	COALESCE(R2.U_D1 , O1.U_D1, NULL, NULL) AS D1,
	COALESCE(R2.U_D1Name , O1.U_D1Name, NULL, NULL) AS D1Name,
	COALESCE(R2.U_D2 , O1.U_D2, NULL, NULL) AS D2,
	COALESCE(R2.U_D2Name , O1.U_D2Name, NULL, NULL) AS D2Name,
	COALESCE(R2.U_D3 , O1.U_D3, NULL, NULL) AS D3,
	COALESCE(R2.U_D3Name , O1.U_D3Name, NULL, NULL) AS D3Name,
	COALESCE(R2.U_D4 , O1.U_D4, NULL, NULL) AS D4,
	COALESCE(R2.U_D4Name , O1.U_D4Name, NULL, NULL) AS D4Name,
	COALESCE(R2.U_D5 , O1.U_D5, NULL, NULL) AS D5,
	COALESCE(R2.U_D5Name , O1.U_D5Name, NULL, NULL) AS D5Name,
	COALESCE(O1.U_TotalIn, 0, NULL, NULL) + COALESCE(R1.TotalInt, 0, NULL, NULL) AS TotalInt,
	COALESCE(O1.U_TotalEx, 0, NULL, NULL) + COALESCE(R1.TotalExt, 0, NULL, NULL) AS TotalExt
FROM
	--REVISE--
	---------------------------------
	(SELECT
		(SELECT TOP 1 B1.DocEntry FROM [@BOQ3] B1 
			WHERE B1.U_BaseEntry = T1.U_BaseEntry 
				AND B1.U_BaseLine = T1.U_BaseLine 
			ORDER BY DocEntry DESC) AS DocEntry,
		T1.U_BaseEntry,
		T1.U_BaseLine,
		SUM(U_TotalIn) AS TotalInt,
		SUM(U_TotalEx) AS TotalExt
	FROM [@BOQ4] T1
	WHERE U_BaseEntry IS NOT NULL
	GROUP BY
		T1.U_BaseEntry,
		T1.U_BaseLine) AS R1
	
	INNER JOIN [@BOQ4] R2 ON R1.U_BaseEntry = R2.U_BaseEntry
		AND R1.U_BaseLine = R2.U_BaseLine AND R1.DocEntry = R2.DocEntry
	---------------------------------
	--Original--
	---------------------------------
	RIGHT JOIN [@BOQ4] O1 ON O1.DocEntry = R1.U_BaseEntry AND O1.LineId = R1.U_BaseLine
	---------------------------------
	INNER JOIN [@BOQ] B1 ON B1.DocEntry = O1.DocEntry 
	--	OR B1.DocEntry = O1.DocEntry

WHERE
	COALESCE(R2.U_Account , O1.U_Account, NULL, NULL) IS NOT NULL
