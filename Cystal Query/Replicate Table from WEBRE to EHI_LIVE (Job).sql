declare @webid int
--------------------------------- Delete ---------------------------------
--loop for deleting the updated rows
while exists(select sap.Code
	from WEBRE.dbo.Equities web
	left join EVERGREEN_TEST_DB.dbo.[@WEBRE_REPLICATE] sap on sap.Code = web.LineID
	where web.ARDPDocNum <> sap.U_ARDPNum or web.IPDocNum <> sap.U_IPNum)
begin	
	--delete the updated rows
	delete from EVERGREEN_TEST_DB.dbo.[@WEBRE_REPLICATE] where code = 
	(select top 1 sap.Code from WEBRE.dbo.Equities web
	left join EVERGREEN_TEST_DB.dbo.[@WEBRE_REPLICATE] sap on sap.Code = web.LineID
	where web.ARDPDocNum <> sap.U_ARDPNum or web.IPDocNum <> sap.U_IPNum)
end

--------------------------------- Insert ---------------------------------

--loop for inserting the updated and new row for webre
while exists (select *
	from WEBRE.dbo.Equities web
	left join EVERGREEN_TEST_DB.dbo.[@WEBRE_REPLICATE] sap on sap.Code = web.LineID
	where sap.Code is null)
begin
	--insert the new rows to the sap udt
	insert into EVERGREEN_TEST_DB.dbo.[@WEBRE_REPLICATE] 
	select eq.LineID, eq.LineID, la.CardCode, la.SONum, eq.ARDPDocNum, eq.IPDocNum, eq.DueDate 
	from WEBRE.dbo.Equities eq 
	inner join WEBRE.dbo.LoanAmortizationCalculators la on la.DocEntry = eq.DocEntry
	left join EVERGREEN_TEST_DB.dbo.[@WEBRE_REPLICATE] sap on sap.Code = eq.LineID
	where sap.Code is null
end

