--Lacking Expenses By Function (JC)
	if @object_type = '204' and (@transaction_type in ('A','U'))
	begin
		if exists(select dp.DocEntry from odpo dp inner join dpo1 dp1 on dp.DocEntry = dp1.DocEntry
				where (dp1.OcrCode is null or dp1.OcrCode = '') and dp.DocEntry = @list_of_cols_val_tab_del)
		begin
			set @error = 00306
			set @error_message = 'Expenses By Function is lacking.'
		end
