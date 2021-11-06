declare @SOnum int = 2
declare @PayDate date = getdate()
declare @ExDays int = 100
declare @AppMonth varchar(max) = 'January'
declare @AppYear varchar(max) = '2021'

select *,
	case
		when SiteCode = 'rv' then
			case
				when PenaltyTemp < 100 and Penalty * DaysLaps > 0 then 100
				else PenaltyTemp
			end
		when SiteCode = 'sw' then
			case
				when PenaltyTemp < 300 and Penalty * DaysLaps > 0 then 300
				else PenaltyTemp 
			end
	end as PenaltyDues

from 
	(select 
		so.DocEntry as SONum,
		so.CardCode as ClientCode,
		so.CardName as ClientName,
		itm.U_Project as SiteCode,
		udf.Descr as SiteName,
		so.Project as ProjectCode,
		itm.ItemName as ProjectName,
		so.U_EquityAmortization as Equity,
		ip.DocEntry as IPNum,
		format(web.U_DueDate,'MMMM dd, yyyy') as DueDate,
		case	
			when itm.U_Project = 'rv' then '5%'
			when itm.U_Project = 'sw' then '7%'
		end as PenaltyRate,

		case	
			when itm.U_Project = 'rv' then (so.U_EquityAmortization * 0.05)/30
			when itm.U_Project = 'sw' then (so.U_EquityAmortization * 0.07)/30
		end as Penalty,

		case
			when
			(datediff(day, web.U_DueDate, @PayDate)-3)- @ExDays < 0 then 0
			else
			(datediff(day, web.U_DueDate, @PayDate)-3)- @ExDays
		end as DaysLaps,

		case
			when
			case	
				when itm.U_Project = 'rv' then ((so.U_EquityAmortization * 0.05)/30) * ((datediff(day, web.U_DueDate, @PayDate)-3)- @ExDays)
				when itm.U_Project = 'sw' then ((so.U_EquityAmortization * 0.07)/30) * ((datediff(day, web.U_DueDate, @PayDate)-3)- @ExDays)
			end < 0 then 0
			else
			case	
				when itm.U_Project = 'rv' then ((so.U_EquityAmortization * 0.05)/30) * ((datediff(day, web.U_DueDate, @PayDate)-3)- @ExDays)
				when itm.U_Project = 'sw' then ((so.U_EquityAmortization * 0.07)/30) * ((datediff(day, web.U_DueDate, @PayDate)-3)- @ExDays)
			end
			
		end as PenaltyTemp
	from 
	dbo.[@WEBRE_REPLICATE] web
	inner join ordr so on so.DocEntry = web.U_SONum
	left join orct ip on ip.DocEntry = web.U_IPNum
	inner join oitm itm on itm.ItemCode = so.Project
	inner join ufd1 udf on udf.FldValue = itm.U_Project and udf.TableID = 'oitm'
	where (web.U_IPStatus = 'Paid' or web.U_IPNum = 0) and so.DocEntry = @SOnum and format(web.U_DueDate, 'MMMM yyyy') = @AppMonth + ' ' + @AppYear) as tblPenalty