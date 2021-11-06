--Lacking Project Site Performance (JC)
		if exists(select dp.DocEntry from odpo dp inner join dpo1 dp1 on dp.DocEntry = dp1.DocEntry
				where (dp1.OcrCode2 is null or dp1.OcrCode2 = '') and dp.DocEntry = @list_of_cols_val_tab_del)
		begin
			set @error = 00305
			set @error_message = 'Project Site Performance is lacking.'
		end
	end