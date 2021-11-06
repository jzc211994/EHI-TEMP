declare @SOnum int = 2
declare @PayDate date = getdate()
declare @ExemptDay int = 1
declare @Month varchar(max) = 'January'
declare @year varchar(max) = '2021'
select *,
	PenaltyPerDay*DaysLaps as Penalty,
	case
		when SiteCode = 'rv' then 
			case
				when PenaltyPerDay*DaysLaps > 0 and PenaltyPerDay*DaysLaps < 100 then 100
				else PenaltyPerDay*DaysLaps
			end
		when SiteCode = 'sw' then 
			case
				when PenaltyPerDay*DaysLaps > 0 and PenaltyPerDay*DaysLaps < 300 then 300
				else PenaltyPerDay*DaysLaps
			end
	end as PenaltyDue
from
	(select
		eq.Code,
		so.DocEntry as SONum,
		ip.DocEntry as IPNUm,
		so.cardcode as ClientCode,
		so.CardName as ClientName,
		so.Project as ProjectCode,
		itm.ItemName as ProjectName,
		itm.U_Project as SiteCode,
		udf.Descr as SiteName,
		so.U_EquityAmortization as Equity,
		case
			when itm.U_Project = 'rv' then 0.05
			when itm.U_Project = 'sw' then 0.07
		end as PenaltyRate,

		so.U_EquityAmortization *
		case
			when itm.U_Project = 'rv' then 0.05
			when itm.U_Project = 'sw' then 0.07
		end / 30 as PenaltyPerDay,

		eq.U_DueDate as DueDate,
		format(eq.U_DueDate,'MMMM yyyy') as MonthYear,
		case
		when code = (select top 1 t0.code from dbo.[@WEBRE_REPLICATE] t0
				left join orct t1 on t0.U_IPNum = t1.DocEntry
				where U_SONum = @SOnum and t1.DocEntry is null and DATEDIFF(day, t0.U_DueDate, @PayDate) >0
				order by code desc) 
		then datediff(day, eq.U_DueDate, @PayDate)-3-@ExemptDay
		else datediff(day, eq.U_DueDate, @PayDate)
	end as DaysLaps
	from dbo.[@WEBRE_REPLICATE] eq
	left join orct ip on ip.DocEntry = eq.U_IPNum
	inner join ordr so on so.DocEntry = eq.U_SONum
	inner join oitm itm on itm.ItemCode = so.Project
	inner join ufd1 udf on udf.FldValue = itm.U_Project and udf.TableID = 'oitm'
	where so.DocEntry = @SOnum and ip.DocEntry is null) as TblPenalty

where DATEDIFF(day, DueDate, @PayDate) > 0 and MonthYear = @Month + ' ' + @year

