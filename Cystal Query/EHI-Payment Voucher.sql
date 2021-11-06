Select * from ovpm op



select * from ojdt je
select * from JDT1
SELECT * FROM OACT
SELECT * FROM ODPO
SELECT * FROM OPCH
SELECT * FROM VPM2

SELECT 
	OP.DocEntry as DocNum,
	OP.DocDate as CheckDate,
	OP.CardCode as PayeeCode,
	OP.CardName as PayeeName,
	CASE
		WHEN OP1.U_CheckNo IS NULL OR OP1.U_CheckNo = '' THEN OP1.U_ChkNumExt
		WHEN OP1.U_ChkNumExt IS NULL OR OP1.U_ChkNumExt = '' THEN OP1.U_CheckNo
	END AS CheckNum,
	JE1.TransId as JENum,
	JE1.Account as AcctCode,
	ACT.AcctName,
	JE1.Debit,
	JE1.Credit,
	OP.Comments as Memo,
	OP.CheckSum as CheckAmount,
	(SELECT NAME FROM [@SIGNATORY] WHERE CODE = 'APIC1') AS APIC1,
	(SELECT NAME FROM [@SIGNATORY] WHERE CODE = 'ACCTGMNGR') AS AcctgMngr,
	(SELECT NAME FROM [@SIGNATORY] WHERE CODE = 'MD') AS MD,
	(SELECT SUM(T2.Credit+T2.Debit) FROM OVPM T1
	INNER JOIN JDT1 T2 ON T1.TransId = T2.TransId
	WHERE (T2.Account LIKE 'CL18%' OR T2.Account LIKE 'CL19%') 
	AND T1.DocEntry =OP.DocEntry) as WTTotal
FROM OVPM OP
INNER JOIN JDT1 JE1 ON OP.TransId = JE1.TransId
INNER JOIN OACT ACT ON ACT.AcctCode = JE1.Account
INNER JOIN VPM1 OP1 ON OP1.DocNum = OP.DocEntry
WHERE OP.DocEntry = 17





SELECT SUM(T2.Credit+T2.Debit) FROM OVPM T1
INNER JOIN JDT1 T2 ON T1.TransId = T2.TransId
WHERE (T2.Account LIKE 'CL18%' OR T2.Account LIKE 'CL19%') 
AND T1.DocEntry =17


select * from opdf