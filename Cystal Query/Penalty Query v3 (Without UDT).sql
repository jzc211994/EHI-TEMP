declare @sonum int = 2
declare @SdueDate date
declare @EdueDate date
declare @PayDate date = getdate()
declare @DueMonth varchar(max) = 'January'
declare @DueYear varchar(max) = '2021'
declare @ExemptDays int = 1
declare @EqSched table(
ID int identity(1,1) primary key,
SONum int,
DueDate date)

select @SdueDate = U_StartDueDate from ordr where DocEntry = @sonum
select @EdueDate = U_EndDueDate from ordr where DocEntry = @sonum

while (@SdueDate <= @EdueDate)
	begin
		insert into @EqSched(SONum, DueDate) values(@sonum, @SdueDate)
		set @SdueDate = DATEADD(MONTH, 1, @SdueDate)
	end


select *,
case
	when SiteCode = 'RV' then 
	case 
		when PenaltyPerDay*DaysLaps < 100 and PenaltyPerDay*DaysLaps > 0 then 100
		else PenaltyPerDay*DaysLaps
	end

	when SiteCode = 'SW' then 
	case 
		when PenaltyPerDay*DaysLaps < 300 and PenaltyPerDay*DaysLaps > 0 then 300
		else PenaltyPerDay*DaysLaps
	end
end as PenaltyDue

from
(select
	so.DocEntry as SoNum, 
	so.CardCode as ClientCode, 
	so.CardName as ClientName, 
	so.Project as ProjectCode,
	itm.ItemName as ProjectName,
	itm.U_Project as SiteCode,
	udf.Descr as SiteName,
	so.U_EquityAmortization as Equity,
	eq.DueDate,
	case
		when itm.U_Project = 'RV' then '5%'
		when itm.U_Project = 'RV' then '7%'
	end as PenaltyRate,
	case
		when itm.U_Project = 'RV' then (so.U_EquityAmortization*0.05)/30
		when itm.U_Project = 'RV' then (so.U_EquityAmortization*0.07)/30
	end as PenaltyPerDay,
	case
		when (DATEDIFF(day, eq.DueDate, @PayDate)-3)-@ExemptDays  <=0 then 0
		else (DATEDIFF(day, eq.DueDate, @PayDate)-3)-@ExemptDays
	end as DaysLaps
from ordr so 
inner join @EqSched eq on so.DocEntry = eq.SONum
inner join oitm itm on itm.ItemCode = so.Project
inner join ufd1 udf on itm.U_Project = udf.FldValue and udf.TableID = 'oitm'
where format(eq.DueDate,'MMMM yyyy') = @DueMonth + ' ' + @DueYear) as TblClient