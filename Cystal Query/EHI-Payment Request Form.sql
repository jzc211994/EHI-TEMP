select 
	op.DocEntry,
	op.CardCode,
	op.CardName,
	op.DocDate as OPDocDate,
	op1.BankCode,
	bnk.BankName,
	op2.DocEntry as BaseEntry,
	case
		when op2.InvType = '18' then 'AP Invoice'
		When op2.InvType = '204'then 'AP Down Payment'
		When op2.InvType = '19' then 'AP Credit Memo'
		When op2.InvType = 'APRETENTION' then 'AP Retention'
	end as BaseOjct,
	format(
	case
		when op2.InvType = '18' then (select DocDate from opch where DocEntry = op2.DocEntry)
		When op2.InvType = '204'then (select DocDate from odpo where DocEntry = op2.DocEntry)
		When op2.InvType = '19' then (select DocDate from orpc where DocEntry = op2.DocEntry)
		When op2.InvType = 'APRETENTION' then (select DocDate from dbo.[@APRETENTION] where DocEntry = op2.DocEntry)
	end, 'MMMM dd, yyyy') as DocDate,
	
	case
		when op2.InvType = '18' then (select NumAtCard from opch where DocEntry = op2.DocEntry)
		When op2.InvType = '204'then (select NumAtCard from odpo where DocEntry = op2.DocEntry)
		When op2.InvType = '19' then (select NumAtCard from orpc where DocEntry = op2.DocEntry)
		When op2.InvType = 'APRETENTION' then (select U_AcctCode from dbo.[@APRETENTION] where DocEntry = op2.DocEntry)
	end as RefNum,

	case
		when op2.InvType = '18' then (select Comments from opch where DocEntry = op2.DocEntry)
		When op2.InvType = '204'then (select Comments from odpo where DocEntry = op2.DocEntry)
		When op2.InvType = '19' then (select Comments from orpc where DocEntry = op2.DocEntry)
		When op2.InvType = 'APRETENTION' then (select Remark from dbo.[@APRETENTION] where DocEntry = op2.DocEntry)
	end as Memo,

	case
		when op2.InvType = '18' then (select DocTotal from opch where DocEntry = op2.DocEntry)
		When op2.InvType = '204'then (select DocTotal from odpo where DocEntry = op2.DocEntry)
		When op2.InvType = '19' then (select DocTotal*(-1) from orpc where DocEntry = op2.DocEntry)
		When op2.InvType = 'APRETENTION' then (select U_Amount*(-1) from dbo.[@APRETENTION] where DocEntry = op2.DocEntry)
	end as Total,
	op2.WtAppld,
	bp.Currency,
	op.DocTotal,
	op.Comments,
	(Select name from dbo.[@SIGNATORY] where code = 'APIC1') as APIC1,
	(Select name from dbo.[@SIGNATORY] where code = 'ACCTGMNGR') as AcctgMngr,
	(Select name from dbo.[@SIGNATORY] where code = 'MD') as MD

from opdf op 
inner join pdf2 op2 on op2.DocNum = op.DocEntry
inner join pdf1 op1 on op.DocEntry = op1.DocNum
inner join odsc bnk on op1.BankCode = bnk.BankCode
inner join ocrd bp on bp.CardCode = op.CardCode


--Select * from vpm2


