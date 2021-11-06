DECLARE @SONUM INT = 3
DECLARE @PAYDATE DATE = GETDATE()
DECLARE @APPMONTH VARCHAR(MAX) = 'January'
DECLARE @APPYEAR VARCHAR(MAX) = '2021'
DECLARE @EXMPDATE INT = 0

DECLARE @TBLEQ TABLE (
ID INT IDENTITY(1,1) PRIMARY KEY,
SONum INT,
EQDate DATE
)

DECLARE @STARTDATE DATE = (SELECT SO.U_StartDueDate FROM ORDR SO WHERE SO.DocEntry = @SONUM)
DECLARE @ENDDATE DATE = (SELECT SO.U_EndDueDate FROM ORDR SO WHERE SO.DocEntry = @SONUM)

WHILE @STARTDATE <= @ENDDATE
BEGIN
	INSERT INTO @TBLEQ(SONUM,EQDATE) VALUES(@SONUM, @STARTDATE)
	SET @STARTDATE = DATEADD(MONTH,1,@STARTDATE)
END



SELECT *,
PenaltyPerDay*DaysLaps AS Penalty,
CASE
	WHEN SiteCode = 'RV' THEN
		CASE
			WHEN PenaltyPerDay*DaysLaps <= 100 THEN 100
			ELSE PenaltyPerDay*DaysLaps
		END
	WHEN SiteCode = 'SW' THEN
	CASE
			WHEN PenaltyPerDay*DaysLaps <= 300 THEN 300
			ELSE PenaltyPerDay*DaysLaps
		END
END AS PenaltyDue
FROM
(SELECT 
	SO.DocEntry,
	SO.CardCode AS CliectCode,
	SO.CardName AS ClientName,
	ITM.U_Project AS SiteCode,
	UDF.Descr AS SiteName,
	SO.Project AS ProjectCode,
	ITM.ItemName AS ProjectName,
	BP.Currency,
	SO.U_EquityAmortization AS Equity,
	EQ.EQDate AS EquitySched,
	CASE
		WHEN ITM.U_Project = 'RV' THEN '5%'
		WHEN ITM.U_Project = 'SW' THEN '7%'
	END AS PenaltyRate,
	CASE
		WHEN ITM.U_Project = 'RV' THEN (SO.U_EquityAmortization*0.05)/30
		WHEN ITM.U_Project = 'SW' THEN (SO.U_EquityAmortization*0.07)/30
	END AS PenaltyPerDay,
	CASE
		WHEN (DATEDIFF(DAY, EQ.EQDate, @PAYDATE)-3)-@EXMPDATE <= 0 THEN 0
		ELSE (DATEDIFF(DAY, EQ.EQDate, @PAYDATE)-3)-@EXMPDATE
		END AS DaysLaps
FROM ORDR SO
INNER JOIN @TBLEQ EQ ON SO.DocEntry = EQ.SONum
INNER JOIN OITM ITM ON SO.Project = ITM.ItemCode
INNER JOIN UFD1 UDF ON UDF.FldValue = ITM.U_Project AND UDF.TableID = 'OITM'
INNER JOIN OCRD BP ON BP.CardCode = SO.CardCode
) AS TblEQ WHERE FORMAT(EquitySched, 'MMMM') = @APPMONTH AND FORMAT(EquitySched, 'yyyy') = @APPYEAR
