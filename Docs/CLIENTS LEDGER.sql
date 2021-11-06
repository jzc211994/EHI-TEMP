DECLARE @SOno INT = 2
--DECLARE @Bal INT
--DECLARE  @TBLBAL TABLE(
--ID INT IDENTITY(1,1) PRIMARY KEY ,
--SONO INT,
--ARDPNO INT,
--PAYMENT INT,
--BAL INT
--)

--SET @Bal = (SELECT U_Equity FROM ORDR WHERE DocEntry = @SOno)

--SELECT

--FROM ORDR SO
--INNER JOIN 




SELECT
	SO.Project,
	ITM.ItemName,
	SO.CardCode,
	SO.CardName,
	ITM.U_Project,
	UDF.Descr,
	SO.U_EquityTerms,
	ITM.U_Block_No,
	ITM.U_Lot_No,
	SO.U_EquityAmortization,
	DP.DocDueDate,
	IP.DocDate,
	SO.U_DPType,
	IP.DocTotal,
	IP.U_RNo,
	IP.UserSign,
	HR.lastName + ' ' + HR.firstName AS UserRep
FROM ORDR SO
LEFT JOIN RDR1 SO1 ON SO.DocEntry = SO1.DocEntry
LEFT JOIN DPI1 DP1 ON DP1.BaseEntry = SO.DocEntry AND SO1.LineNum = DP1.BaseLine
LEFT JOIN ODPI DP ON DP.DocEntry = DP1.DocEntry
LEFT JOIN RCT2 IP2 ON IP2.DocEntry = DP.DocEntry AND IP2.InvType = DP.ObjType
LEFT JOIN ORCT IP ON IP.DocEntry = IP2.DocNum
LEFT JOIN OITM ITM ON ITM.ItemCode = SO.Project
LEFT JOIN UFD1 UDF ON UDF.FldValue = ITM.U_Project AND UDF.TableID = 'OITM'
LEFT JOIN OHEM HR ON HR.userId = IP.UserSign2
WHERE SO.DocEntry = @SOno
ORDER BY SO.DocEntry

--SELECT COUNT(*) FROM ORCT