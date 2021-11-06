SELECT
	SO.DocEntry,
	FORMAT(SO.DocDate,'MMMM dd, yyyy') AS AgreeDate,
	ITM.ItemName AS ProjectName,
	TRIM('B' FROM ITM.U_Block_No) AS Block,
	TRIM('L' FROM ITM.U_Lot_No) AS Lot,
	FORMAT(DATEADD(DAY , -90, SO.U_EndDueDate),'MMMM dd, yyyy') AS WorkDate,
	FORMAT(SO.U_EndDueDate,'MMMM dd, yyyy') AS EndDate,
	'FF-' + ITM.U_Project + '-' + CAST(SO.DocEntry AS VARCHAR) AS Series,
	(SELECT Name FROM dbo.[@SIGNATORY] WHERE Code = 'STENGR') AS SiteEngineer,
	(SELECT Name FROM dbo.[@SIGNATORY] WHERE Code = 'SLS') AS Sales
 FROM ORDR SO 
 INNER JOIN OITM ITM ON ITM.ItemCode = SO.Project
 WHERE DATEDIFF(DAY, GETDATE(), SO.U_EndDueDate) <= 90