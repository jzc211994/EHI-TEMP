--variables
declare @sonum int = 2
declare @term int 
declare @startdate date
declare @enddate date

-- table for duedate
declare @tbldue table (
docentry int,
cardcode varchar(50),
duedate date
)

--get equity term
select @term = so.U_EquityTerms from ordr so where so.DocEntry = @sonum
select @startdate = so.U_StartDueDate from ordr so where so.DocEntry = @sonum

--insert the due dates of @sonum to @tbldue
	while (@term >0)
	begin
		set @term = @term - 1
		insert into @tbldue values(@sonum,(select cardcode from ordr where DocEntry = @sonum), dateadd(MONTH, @term, @startdate))
	end

select distinct
	so.DocEntry,
	so.CardCode as CustomerCode,
	so.CardName as CustomerName,
	so.Project as ProjectCode,
	itm.ItemName as ProjectName,
	td.duedate as DueDate,
	dp.BaseEntry as DPnum,
	so.U_EquityAmortization as Equity,
	case
		when itm.U_Project = 'RV' then 0.05
		when itm.U_Project = 'RV' then 0.07
	end as PenaltyPercentage
from ordr so
inner join @tbldue td on td.docentry = so.DocEntry

left join
(select dp1.docentry, dp1.BaseEntry, dp.DocDate ,dp1.BaseType
from dpi1 dp1 inner join odpi dp on dp.DocEntry = dp1.DocEntry 
where dp1.BaseEntry = @sonum and dp.U_DPType = 'EQ') as dp 
on dp.BaseEntry = so.DocEntry and dp.DocDate = td.duedate and dp.BaseType = 17

inner join oitm itm on itm.ItemCode = so.Project
where dp.DocEntry is null
