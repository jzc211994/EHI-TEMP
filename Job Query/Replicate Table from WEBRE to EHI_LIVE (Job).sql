declare @webid int
--------------------------------- Delete ---------------------------------
--loop for deleting the updated rows
while exists(select sap.Code
	from WEBRE_LATEST.dbo.Equities web
	left join EHI_TEST_DB.dbo.[@WEBRE_REPLICATE] sap on sap.Code = web.LineID
	where web.ARDPDocNum <> sap.U_ARDPNum or web.IPDocNum <> sap.U_IPNum or web.ARCMDocNum <> sap.U_ARCMNum or web.IPStatus <> sap.U_IPStatus collate SQL_Latin1_General_CP1_CI_AS)
begin	
	--delete the updated rows
	delete from EHI_TEST_DB.dbo.[@WEBRE_REPLICATE] where code = 
	(select top 1 sap.Code from WEBRE_LATEST.dbo.Equities web
	left join EHI_TEST_DB.dbo.[@WEBRE_REPLICATE] sap on sap.Code = web.LineID
	where web.ARDPDocNum <> sap.U_ARDPNum or web.IPDocNum <> sap.U_IPNum or web.ARCMDocNum <> sap.U_ARCMNum or web.IPStatus <> sap.U_IPStatus collate SQL_Latin1_General_CP1_CI_AS)
end

--------------------------------- Insert ---------------------------------

--loop for inserting the updated and new row for webre
while exists (select web.LineID
	from WEBRE_LATEST.dbo.Equities web
	left join EHI_TEST_DB.dbo.[@WEBRE_REPLICATE] sap on sap.Code = web.LineID
	where sap.Code is null)
begin
	--insert the new rows to the sap udt
	insert into EHI_TEST_DB.dbo.[@WEBRE_REPLICATE] 
	select 
		eq.LineID,
		eq.LineID,
		la.CardCode,
		la.SONum,
		eq.ARDPDocNum,
		eq.ARDPStatus,
		eq.IPDocNum,
		eq.IPStatus,
		eq.ARCMDocNum,
		eq.DueDate
	from WEBRE_LATEST.dbo.Equities eq 
	inner join WEBRE_LATEST.dbo.LoanAmortizationCalculators la on la.DocEntry = eq.DocEntry
	left join EHI_TEST_DB.dbo.[@WEBRE_REPLICATE] sap on sap.code = eq.LineID
	where sap.Code is null
end

--update EVERGREEN_TEST_DB.dbo.[@WEBRE_REPLICATE] set U_ARDPNum = 1000 where Code = 1

--Select * from dbo.[@WEBRE_REPLICATE]

select 
		eq.LineID,
		eq.LineID,
		la.CardCode,
		la.SONum,
		eq.ARDPDocNum,
		eq.ARDPStatus,
		eq.IPDocNum,
		eq.IPStatus,
		eq.ARCMDocNum,
		eq.DueDate, sap.*
	from WEBRE_LATEST.dbo.Equities eq 
	inner join WEBRE_LATEST.dbo.LoanAmortizationCalculators la on la.DocEntry = eq.DocEntry
	left join EHI_TEST_DB.dbo.[@WEBRE_REPLICATE] sap on sap.code = eq.LineID
	where sap.Code is null