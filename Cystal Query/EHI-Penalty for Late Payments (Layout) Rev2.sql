--Author JervZ

declare @SOnum int = 71
declare @PaymentDate date = getdate()
declare @ExemptDate int = 0
select *,
	case
		when
			case
				when EQnum = LastLineNum then (DATEDIFF(day, DueDate, @PaymentDate)-3)-@ExemptDate
				else (DATEDIFF(day, DueDate, @PaymentDate))
			end <0 then 0
		else
			case
				when EQnum = LastLineNum then (DATEDIFF(day, DueDate, @PaymentDate)-3)-@ExemptDate
				else (DATEDIFF(day, DueDate, @PaymentDate))
			end
		end as DaysLaps,
		
	case	
		when
			((Equity * PenaltyDecimal)/30) * 
			case
				when EQnum = LastLineNum then (DATEDIFF(day, DueDate, @PaymentDate)-3)-@ExemptDate
				else (DATEDIFF(day, DueDate, @PaymentDate))
			end <0 then 0
		else
			((Equity * PenaltyDecimal)/30) * 
			case
				when EQnum = LastLineNum then (DATEDIFF(day, DueDate, @PaymentDate)-3)-@ExemptDate
				else (DATEDIFF(day, DueDate, @PaymentDate))
			end
	end as Penalty,
	
	case
	--minimum 100 for riverview
		when SiteCode = 'RV' then
			case
				when
					case	
						when
							((Equity * PenaltyDecimal)/30) * 
							case
								when EQnum = LastLineNum then (DATEDIFF(day, DueDate, @PaymentDate)-3)-@ExemptDate
								else (DATEDIFF(day, DueDate, @PaymentDate))
							end <0 then 0
						else
							((Equity * PenaltyDecimal)/30) * 
							case
								when EQnum = LastLineNum then (DATEDIFF(day, DueDate, @PaymentDate)-3)-@ExemptDate
								else (DATEDIFF(day, DueDate, @PaymentDate))
							end
					end < 100 then 100
				else
					case	
						when
							((Equity * PenaltyDecimal)/30) * 
							case
								when EQnum = LastLineNum then (DATEDIFF(day, DueDate, @PaymentDate)-3)-@ExemptDate
								else (DATEDIFF(day, DueDate, @PaymentDate))
							end <0 then 0
						else
							((Equity * PenaltyDecimal)/30) * 
							case
								when EQnum = LastLineNum then (DATEDIFF(day, DueDate, @PaymentDate)-3)-@ExemptDate
								else (DATEDIFF(day, DueDate, @PaymentDate))
							end
					end
				end	
			-- minimum 300 for southwoods
			when SiteCode = 'SW' then
			case
				when
					case	
						when
							((Equity * PenaltyDecimal)/30) * 
							case
								when EQnum = LastLineNum then (DATEDIFF(day, DueDate, @PaymentDate)-3)-@ExemptDate
								else (DATEDIFF(day, DueDate, @PaymentDate))
							end <0 then 0
						else
							((Equity * PenaltyDecimal)/30) * 
							case
								when EQnum = LastLineNum then (DATEDIFF(day, DueDate, @PaymentDate)-3)-@ExemptDate
								else (DATEDIFF(day, DueDate, @PaymentDate))
							end
					end < 300 then 300
				else
					case	
						when
							((Equity * PenaltyDecimal)/30) * 
							case
								when EQnum = LastLineNum then (DATEDIFF(day, DueDate, @PaymentDate)-3)-@ExemptDate
								else (DATEDIFF(day, DueDate, @PaymentDate))
							end <0 then 0
						else
							((Equity * PenaltyDecimal)/30) * 
							case
								when EQnum = LastLineNum then (DATEDIFF(day, DueDate, @PaymentDate)-3)-@ExemptDate
								else (DATEDIFF(day, DueDate, @PaymentDate))
							end
					end
				end	

	end as PenaltyDue

from
	(select 
		so.DocEntry as SOnum,
		dp.DocEntry as DPnum,
		eq.LineID as EQnum,
		so.CardCode as ClientCode,
		so.CardName as ClientName,
		bp.Currency,
		so.Project as ProjectCode,
		itm.ItemName as ItemName,
		itm.U_Project as SiteCode,
		udf.Descr as SiteName,
		format(eq.DueDate, 'MMMM dd, yyyy') as DueDate,
		so.U_EquityAmortization as Equity,
		case
			when itm.U_Project = 'RV' then '5%'
			when itm.U_Project = 'SW' then '7%'
		end as PenaltyPercentage,
		case
			when itm.U_Project = 'RV' then 0.05
			when itm.U_Project = 'SW' then 0.07
		end as PenaltyDecimal,
		(select top 1 t0.LineID
		from WEBRE.dbo.Equities t0 
		inner join WEBRE.dbo.LoanAmortizationCalculators t1 on t0.DocEntry =t1.DocEntry
		left join odpi t3 on t0.ARDPDocNum = t3.DocEntry
		inner join ordr t4 on t4.DocEntry = t1.SONum
		where t4.DocEntry = @SOnum and t3.DocEntry is null and datediff(day, t0.DueDate,@PaymentDate)>0
		order by t0.LineID desc) as LastLineNum
	from WEBRE.dbo.Equities eq 
	inner join WEBRE.dbo.LoanAmortizationCalculators la on la.DocEntry = eq.DocEntry
	left join odpi dp on dp.DocEntry = eq.ARDPDocNum
	inner join ordr so on so.DocEntry = la.SONum
	inner join oitm itm on itm.ItemCode = so.Project
	inner join ufd1 udf on udf.FldValue = itm.U_Project and TableID = 'oitm'
	inner join ocrd bp on bp.CardCode = so.CardCode
	where dp.DocEntry is null and so.DocEntry = @SOnum and datediff(day, eq.DueDate, @PaymentDate)>0) as TblTemp