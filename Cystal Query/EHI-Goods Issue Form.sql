SELECT 
	GI.DocEntry AS DocNo,
	FORMAT(GI.DocDate,'MMMM dd, yyyy') AS DocDate,
	BP.CardName AS IssueTo,
	GI.U_IssueType,
	UDF.Descr AS IssuanceType,
	ITM.ItemName AS ProjectName,
	GI.Comments AS Remarks,
	GI1.ItemCode,
	GI1.Dscription AS ItemName,
	GI1.UomCode AS Unit,
	GI1.Quantity,
	GI1.U_Dimension1,
	GI1.WhsCode,
	WH.WhsName,
	(SELECT NAME FROM DBO.[@SUBDIMENSION] WHERE CODE = GI1.U_Dimension1) AS Dimension1Name,
	GI1.U_Dimension2,
	(SELECT NAME FROM DBO.[@SUBDIMENSION] WHERE CODE = GI1.U_Dimension2) AS Dimension2Name,
	GI1.U_Dimension3,
	(SELECT NAME FROM DBO.[@SUBDIMENSION] WHERE CODE = GI1.U_Dimension3) AS Dimension3Name,
	GI1.U_Dimension4,
	(SELECT NAME FROM DBO.[@SUBDIMENSION] WHERE CODE = GI1.U_Dimension4) AS Dimension4Name,
	GI1.U_Dimension5,
	(SELECT NAME FROM DBO.[@SUBDIMENSION] WHERE CODE = GI1.U_Dimension5) AS Dimension5Name,
	(SELECT name FROM DBO.[@SIGNATORY] WHERE U_JobDesc = 'Checker' AND U_Site = SUBSTRING(GI1.WhsCode,1,2)) AS Checker,
	(SELECT name FROM DBO.[@SIGNATORY] WHERE U_JobDesc = 'Storage In-charge' AND U_Site = SUBSTRING(GI1.WhsCode,1,2)) AS SIC
FROM IGE1 GI1
INNER JOIN OIGE GI ON GI.DocEntry = GI1.DocEntry
INNER JOIN OCRD BP ON BP.CardCode = GI.U_Code
INNER JOIN UFD1 UDF ON UDF.FldValue = GI.U_IssueType AND UDF.TableID = 'OIGE' AND UDF.FieldID = 15
INNER JOIN OITM ITM ON GI1.Project = ITM.ItemCode
INNER JOIN OWHS WH ON GI1.WhsCode = WH.WhsCode

