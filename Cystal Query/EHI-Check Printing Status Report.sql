		
--DECLARE @PeriodFrom as Date ='2021-03-01'
--DECLARE @PeriodTo as Date ='2021-03-31'
SELECT 
T1.BankCode,
T1.Branch,
T1.AcctNum,
T1.U_IssueDate,
CASE  
	WHEN T1.U_ChkNumExt IS NULL OR T1.U_ChkNumExt = '' THEN  T1.U_CheckNo
	WHEN T1.U_CheckNo IS NULL OR T1.U_CheckNo = '' THEN  T1.U_ChkNumExt
END AS CheckNumber,
T2.TransRef AS OPDocNo,
T2.PmntDate AS PaymentDate,
T2.VendorCode as PayeeCode,
T2.VendorName as Payee,
T2.CheckSum as CheckAmount,
CASE 
	WHEN T2.Printed = 'N' AND T2.Canceled = 'N' THEN 'UNCONFIRMED'
	WHEN T2.Printed = 'Y'  AND T2.Canceled ='N' and t1.CheckNum <> 0 THEN 'CONFIRMED'
	WHEN T2.Canceled = 'Y' THEN 'CANCELED'
	ELSE 'UNCONFIRMED'
END AS STATUS,

T2.Printed,
T2.Canceled,
T2.CancelDate,
t2.CheckKey as ChkForPayment,
CASE WHEN T2.TransRef IS NULL THEN 'Not Printed (Before Approval)'
 WHEN T2.Printed = 'N' AND T2.CANCELED = 'N' THEN 'Not Printed (After Approval)'
ELSE
T2.Details end as Comments,
t2.CheckDate as CheckDate
FROM VPM1 T1
LEFT JOIN OCHO T2 ON T2.TransRef = T1.DocNum AND T2.CheckKey = T1.CheckAbs
LEFT JOIN OVPM T3 ON T1.DOCNUM = T3.DocEntry
WHERE U_IssueDate IS NOT NULL 
--WHERE t2.CheckDate BETWEEN @PeriodFrom AND @PeriodTo