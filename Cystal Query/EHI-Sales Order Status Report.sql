select 
	so.DocEntry,
	format(so.DocDate,'MMMM dd, yyyy') as DocDate,
	so.CardCode,
	so.CardName,
	itm.U_Project,
	udf.Descr,
	so.Project,
	itm.ItemName,
	bp.Currency,
	so.DocTotal,
	case when so.DocStatus = 'o' then 'Open'
		when so.DocStatus = 'c' then 'Close'
		when so.DocStatus = 'c' and so.CANCELED <> 'y' then 'Fully Paid'
	end as DocStatus,
	case when so.CANCELED = 'y' then 'Canceled'
	end as Canceled
from ordr so 
inner join oitm itm on itm.ItemCode = so.Project
inner join ufd1 udf on udf.FldValue = itm.U_Project and TableID = 'oitm'
inner join ocrd bp on bp.CardCode = so.CardCode 

order by so.DocEntry