SELECT 
	T0.[DocEntry], 
	T0.[U_PrjCode], 
	T0.[U_PrjName], 
	T0.[CreateDate], 
	T0.[UpdateDate], 
	'Budget is approved.' as Message 
FROM [dbo].[@BOQ]  T0 
WHERE 
--ON REALTIME
((T0.U_Status = 'APPROVED' AND FORMAT(CAST(T0.UpdateDate AS DATE),'yyyy-MM-dd') = FORMAT(GETDATE(),'yyyy-MM-dd') AND T0.UpdateTime = FORMAT(GETDATE(),'Hmm'))
OR (T0.U_Status = 'APPROVED' AND FORMAT(CAST(T0.UpdateDate AS DATE),'yyyy-MM-dd') = FORMAT(GETDATE(),'yyyy-MM-dd') AND FORMAT(DATEADD(MINUTE , 1, CAST(STUFF(T0.UpdateTime, CASE WHEN LEN(T0.UpdateTime) = 4 THEN 3 WHEN LEN(T0.UpdateTime) = 3 THEN 2 END, 0, ':' ) AS DATETIME)),'Hmm') = FORMAT(GETDATE(),'Hmm'))
OR (T0.U_Status = 'APPROVED' AND FORMAT(CAST(T0.UpdateDate AS DATE),'yyyy-MM-dd') = FORMAT(GETDATE(),'yyyy-MM-dd') AND FORMAT(DATEADD(MINUTE , 2, CAST(STUFF(T0.UpdateTime, CASE WHEN LEN(T0.UpdateTime) = 4 THEN 3 WHEN LEN(T0.UpdateTime) = 3 THEN 2 END, 0, ':' ) AS DATETIME)),'Hmm') = FORMAT(GETDATE(),'Hmm'))
OR (T0.U_Status = 'APPROVED' AND FORMAT(CAST(T0.UpdateDate AS DATE),'yyyy-MM-dd') = FORMAT(GETDATE(),'yyyy-MM-dd') AND FORMAT(DATEADD(MINUTE , 3, CAST(STUFF(T0.UpdateTime, CASE WHEN LEN(T0.UpdateTime) = 4 THEN 3 WHEN LEN(T0.UpdateTime) = 3 THEN 2 END, 0, ':' ) AS DATETIME)),'Hmm') = FORMAT(GETDATE(),'Hmm')))
--ON 8AM AND LAST 5 DAYS APPROVED BUDGET
OR ((T0.U_Status = 'APPROVED' AND FORMAT(GETDATE(),'Hmm') in(800,801,802,803,804,805))
AND GETDATE() BETWEEN CAST(T0.UpdateDate AS DATETIME) AND DATEADD(DAY, 5, CAST(T0.UpdateDate AS DATETIME)))