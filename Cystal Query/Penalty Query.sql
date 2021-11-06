Select 
	so.DocEntry,
	so.CardCode,
	so.CardName,
	so.U_EquityAmortization AS Equity,
	eq.DueDate,
	format(eq.DueDate,'MMMM') as DueMonth,
	datediff(day,eq.DueDate,getdate())-3 as LapsDays,
	itm.U_Project,
	so.Project,
	case
		when itm.U_Project = 'rv' then 0.05
		when itm.U_Project = 'sv' then 0.07
	end as PenaltyRate,

	((so.U_EquityAmortization *
	case
		when itm.U_Project = 'rv' then 0.05
		when itm.U_Project = 'sv' then 0.07
	end) /30) * cast((datediff(day,eq.DueDate,getdate())-3) as Int) as Penalty
	
from EVERGREEN_TEST_DB.dbo.ORDR so
inner join WEBRE.dbo.Equities eq on so.DocEntry = eq.DocEntry
inner join EVERGREEN_TEST_DB.dbo.OITM itm on itm.ItemCode = so.Project
where so.DocEntry = 1