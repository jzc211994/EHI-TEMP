USE [EHI_SAP_MAY]
GO
/****** Object:  StoredProcedure [dbo].[SBO_SP_TransactionNotification]    Script Date: 21/05/2021 3:53:41 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--USE [EHI_Live_1025]
--GO
--/****** Object:  StoredProcedure [dbo].[SBO_SP_TransactionNotification]    Script Date: 10/26/2020 7:27:28 AM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
----USE [EHI_TEST]
--GO
--/****** Object:  StoredProcedure [dbo].[SBO_SP_TransactionNotification]    Script Date: 10/19/2020 10:46:49 AM ******/
--SET ANSI_NULLS ONgoods
--GO
--SET QUOTED_IDENTIFIER ON
--GO
----USE [EHI_TEST]
----GO
----/****** Object:  StoredProcedure [dbo].[SBO_SP_TransactionNotification]    Script Date: 10/15/2020 8:13:17 PM ******/
----SET ANSI_NULLS ON
----GO
----SET QUOTED_IDENTIFIER ON
----GO
ALTER proc [dbo].[SBO_SP_TransactionNotification] 

@object_type nvarchar(30), 				-- SBO Object Type
@transaction_type nchar(1),			-- [A]dd, [U]pdate, [D]elete, [C]ancel, C[L]ose
@num_of_cols_in_key int,
@list_of_key_cols_tab_del nvarchar(255),
@list_of_cols_val_tab_del nvarchar(255)

AS

begin

-- Return values
declare @error  int				-- Result (0 for no error)
declare @error_message nvarchar (200) 		-- Error string to be displayed
select @error = 0
select @error_message = N'Ok'

--------------------------------------------------------------------------------------------------------------------------------

--	ADD	YOUR	CODE	HERE

--ITEM MASTER DATA

---Series not Manual for Saleable Units---

if @object_type = '4' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OITM.ItemCode from OITM

where 
			OITM.ItmsGrpCod = '101'
			AND OITM.ItemCode NOT IN ('Principal', 'Interest')
			and OITM.Series <> 3 
			AND OITM.ItemCode=@list_of_cols_val_tab_del)
			begin
				set @error= 000006
				set @error_message='Saleable Units must have manual series.'
	end 
	end



---Item Lot Area is Missing---

if @object_type = '4' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OITM.ItemCode from OITM

where 
			OITM.ItmsGrpCod = '101'
			AND OITM.ItemCode NOT IN ('Principal', 'Interest')
			and OITM.U_Area is null 
			AND OITM.ItemCode=@list_of_cols_val_tab_del)
			begin
				set @error= 000005
				set @error_message='Define Unit Area for this Saleable Unit.'
	end 
	end


---Item Lot No Field Missing---

if @object_type = '4' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OITM.ItemCode from OITM

where 
			OITM.ItmsGrpCod = '101'
			AND OITM.ItemCode NOT IN ('Principal', 'Interest')
			and OITM.U_Lot_No is null 
			AND OITM.ItemCode=@list_of_cols_val_tab_del)
			begin
				set @error= 000004
				set @error_message='Fill in Lot No Field in the Header.'
	end 
	end



---Item Block No Field Missing---

if @object_type = '4' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OITM.ItemCode from OITM

where 
			OITM.ItmsGrpCod = '101'
			AND OITM.ItemCode NOT IN ('Principal', 'Interest')
			and OITM.U_Block_No is null 
			AND OITM.ItemCode=@list_of_cols_val_tab_del)
			begin
				set @error= 000003
				set @error_message='Fill in Block No Field in the Header.'
	end 
	end



---Item Model Field Missing---

if @object_type = '4' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OITM.ItemCode from OITM

where 
			OITM.ItmsGrpCod = '101'
			and OITM.U_Model is null 
			AND OITM.ItemCode NOT IN ('Principal', 'Interest')
			AND OITM.ItemCode=@list_of_cols_val_tab_del)
			begin
				set @error= 000002
				set @error_message='Fill in Model Field in the Header.'
	end 
	end




---Item Project Field Missing---

if @object_type = '4' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OITM.ItemCode from OITM

where 
			OITM.ItmsGrpCod = '101'
			and OITM.U_Project is null 
			AND OITM.ItemCode NOT IN ('Principal', 'Interest')
			AND OITM.ItemCode=@list_of_cols_val_tab_del)
			begin
				set @error= 000001
				set @error_message='Fill in Project Field in the Header.'
	end 
	end








----------------------------



---Purchase Request---


-- Requested Quantity Over Budget and Approval is NO---
	if @object_type = '1470000113' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPRQ.docentry from OPRQ
inner join PRQ1 ON PRQ1.DocEntry = OPRQ.DocEntry

where 
			
			PRQ1.FreeTxt = 'TRUE'
			and OPRQ.U_ForApprov <> 'Y'
			AND OPRQ.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00110
				set @error_message='Quantity requested is Over the Budget. Update For Approval field to Yes for PR.'
	end 
	end


-- Perform Autocheck for approval---
	if @object_type = '1470000113' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPRQ.docentry from OPRQ
inner join PRQ1 ON PRQ1.DocEntry = OPRQ.DocEntry

where 
			
			OPRQ.U_ACAR <> 'DONE'
			and OPRQ.U_SubPR_Type NOT IN ('DS', 'CU')
			--AND PRQ1.Project <> 'EHI000'
			AND OPRQ.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00109
				set @error_message='Update Autocheck for Approval field to Done for PR.'
	end 
	end




-- Incorrect Whse based on projects---
	if @object_type = '1470000113' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPRQ.docentry from OPRQ
inner join PRQ1 ON PRQ1.DocEntry = OPRQ.DocEntry

where 
			
			PRQ1.Project LIKE 'SW%'
			AND PRQ1.WhsCode <> 'SWRM WHS'
			AND OPRQ.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00108
				set @error_message='Incorrect Warehouse based on the Project defined.'
	end 
	end




-- Incorrect Whse based on projects---
	if @object_type = '1470000113' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPRQ.docentry from OPRQ
inner join PRQ1 ON PRQ1.DocEntry = OPRQ.DocEntry

where 
			
			PRQ1.Project LIKE 'RV%'
			and u_pr_type2 <> 'pcsc'
			AND PRQ1.WhsCode <> 'RVRM WHS'
			AND OPRQ.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00107
				set @error_message='Incorrect Warehouse based on the Project defined.'
	end 
	end



-- Saleable Warehouse had defined---
	if @object_type = '1470000113' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPRQ.docentry from OPRQ
inner join PRQ1 ON PRQ1.DocEntry = OPRQ.DocEntry

where 
			PRQ1.WhsCode  IN ( 'RVHU WHS', 'SWHU WHS')
			AND OPRQ.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00106
				set @error_message='Warehouse for Saleable Items had defined. Update Warehouse in the Rows.'
	end 
	end




-- No Need for Purchase Request---
	if @object_type = '1470000113' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPRQ.docentry from OPRQ

where 
			
			OPRQ.U_SubPR_Type in ('DS', 'CU', 'SV' , 'PL')
			AND OPRQ.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00105
				set @error_message='Purchase Request is not needed for this type of Transaction.'
	end 
	end

--	-- No Need for Purchase Request---
	if @object_type = '1470000113' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPRQ.docentry from OPRQ

where 
			OPRQ.U_PR_Type2 in ('PFXA', 'OSCO', 'OSIN', 'OSIBC', 'OSLO')
			AND OPRQ.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00111
				set @error_message='Purchase Request is not needed for this type of Transaction.'
	end 
	end


-- No tagging of Budget---
	if @object_type = '1470000113' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPRQ.docentry from OPRQ
Inner join prq1 on Prq1.DocEntry = OPRQ.DocEntry 

where 
			PRQ1.Project <> 'EHI000'
			and OPRQ.U_SubPR_Type <> 'DS'
		    and PRQ1.U_BudgetNo is null
			AND OPRQ.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error=00104
				set @error_message='Budget No is lacking for Chargeable to Project related transaction.'
	end 
	end



-- No tagging of Dimension for Project-related
	if @object_type = '1470000113' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPRQ.docentry from OPRQ
Inner join prq1 on Prq1.DocEntry = OPRQ.DocEntry 

where 
			
			PRQ1.Project <> 'EHI000'
			and OPRQ.U_SubPR_Type <> 'DS'
		    and PRQ1.U_Dimension1 is null
			and PRQ1.U_Dimension2 is null
			and PRQ1.U_Dimension3 is null
			and PRQ1.U_Dimension4 is null
			and PRQ1.U_Dimension5 is null
			AND OPRQ.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00103
				set @error_message='Dimension (s) is lacking for Chargeable to Project related transaction.'
	end 
	end


-- No tagging of Project---
	if @object_type = '1470000113' and (@transaction_type in ('A', 'U')) 
begin

if exists (select PRQ1.docentry from PRQ1
Inner join OPRQ on Prq1.DocEntry = OPRQ.DocEntry 

where 
			
			ISNULL (PRQ1.Project,'')=''
			--and OPRQ.U_SubPR_Type <> 'DS'
			--and OPRQ.U_SubPR_Type <> 'CU'
			--and OPRQ.U_SubPR_Type <> 'SV'
			--and OPRQ.U_SubPR_Type <> 'PL'
			AND PRQ1.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00102
				set @error_message='Project is lacking in the row. Define Project Code.'
	end 
	end


-- No tagging of Purchase Subcategory Transaction Type---
	if @object_type = '1470000113' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPRQ.docentry from OPRQ 

where 
			
			OPRQ.U_PR_Type2 in ( 'PLISG', 'PIMPI' , 'PLISS')
			AND OPRQ.U_SubPR_Type is null
			AND OPRQ.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00101
				set @error_message='Subcategory Purchase Transaction Type is lacking for this transaction.'
	end 
	end



-- No tagging of Purchase Transaction Type---
	if @object_type = '1470000113' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPRQ.docentry from OPRQ 

where 
			
			OPRQ.U_PR_Type2 is null
			AND OPRQ.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00100
				set @error_message='Purchase Transaction Type is lacking.'
	end 
	end





---------------------------------



---Purchase Request Draft---

-- Requested Quantity Over Budget and Approval is NO---
	if @object_type = '1470000113' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ODRF.docentry from ODRF
inner join DRF1 ON DRF1.DocEntry = ODRF.DocEntry

where 
			
			DRF1.FreeTxt = 'TRUE'
			AND ODRF.ObjType =  '1470000113'
			and ODRF.U_ForApprov <> 'Y'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= -00110
				set @error_message='Quantity requested is Over the Budget. Update For Approval field to Yes for PR.'
	end 
	end

-- Perform Autocheck for approval---
	if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ODRF.docentry from ODRF
inner join DRF1 ON DRF1.DocEntry = ODRF.DocEntry

where 
			
			ODRF.U_ACAR <> 'DONE'
			and ODRF.U_SubPR_Type NOT IN ('DS', 'CU')
			AND ODRF.ObjType =  '1470000113'
			--AND DRF1.Project <> 'EHI000'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= -00109
				set @error_message='Update Autocheck for Approval field to Done for PR.'
	end 
	end


-- Incorrect Whse based on projects---
	if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ODRF.docentry from ODRF
inner join DRF1 ON DRF1.DocEntry = ODRF.DocEntry

where 
			
			DRF1.Project LIKE 'SW%'
			AND DRF1.WhsCode <> 'SWRM WHS'
			AND ODRF.ObjType =  '1470000113'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= -00108
				set @error_message='Incorrect Warehouse based on the Project defined.'
	end 
	end




-- Incorrect Whse based on projects---
	if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ODRF.docentry from ODRF
inner join DRF1 ON DRF1.DocEntry = ODRF.DocEntry

where 
			
			DRF1.Project LIKE 'RV%'
			AND DRF1.WhsCode <> 'RVRM WHS'
			and U_PR_Type2 <> 'pcsc'
			AND ODRF.ObjType =  '1470000113'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= -00108
				set @error_message='Incorrect Warehouse based on the Project defined.'
	end 
	end



-- Saleable Warehouse had defined---
	if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ODRF.docentry from ODRF
inner join DRF1 ON DRF1.DocEntry = ODRF.DocEntry

where 
			DRF1.WhsCode  IN ( 'RVHU WHS', 'SWHU WHS')
			AND ODRF.ObjType =  '1470000113'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= -00106
				set @error_message='Warehouse for Saleable Items had defined. Update Warehouse in the Rows.'
	end 
	end



-- No Need for Purchase Request---
	if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ODRF.docentry from ODRF

where 
			ODRF.U_SubPR_Type in ('DS', 'CU', 'SV' , 'PL')
			AND ODRF.ObjType =  '1470000113'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00105
				set @error_message='Purchase Request is not needed for this type of Transaction.'
	end 
	end



-- No tagging of Dimension for Project-related
	if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ODRF.docentry from ODRF
Inner join DRF1 on DRF1.DocEntry = ODRF.DocEntry 

where 
			
			DRF1.Project <> 'EHI000'
		    and DRF1.U_Dimension1 is null
			and DRF1.U_Dimension2 is null
			and DRF1.U_Dimension3 is null
			and DRF1.U_Dimension4 is null
			and DRF1.U_Dimension5 is null
			AND ODRF.ObjType =  '1470000113'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= -00103
				set @error_message='Dimension (s) is lacking for Chargeable to Project related transaction.'
	end 
	end


-- No tagging of Project---
	if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ODRF.docentry from ODRF
Inner Join DRF1 ON ODRF.DocEntry = drf1.DocEntry

where 
			
			ISNULL (DRF1.Project,'')=''
			AND ODRF.ObjType =  '1470000113'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= -00102
				set @error_message='Project is lacking in the row. Define Project Code.'
	end 
	end


-- No tagging of Purchase Subcategory Transaction Type---
	if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ODRF.docentry from ODRF 

where 
			
			ODRF.U_PR_Type2 in ( 'PLISG', 'PIMPI' , 'PLISS')
			AND ODRF.U_SubPR_Type is null
			AND ODRF.ObjType =  '1470000113'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= -00101
				set @error_message='Subcategory Purchase Transaction Type is lacking for this transaction.'
	end 
	end



-- No tagging of Purchase Transaction Type---
	if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ODRF.docentry from ODRF 

where 
			
			ODRF.U_PR_Type2 is null
			AND ODRF.ObjType =  '1470000113'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= -00100
				set @error_message='Purchase Transaction Type is lacking.'
	end 
	end

---------------------------------

---PURCHASE QUOTATION


--Adding of Purchase Quotation with Dummy Supplier

		if @object_type = '540000006' and (@transaction_type in ('A', 'U')) 
		begin

		if exists (select OPQT.docentry from OPQT

		where 
					OPQT.CardName = 'Dummy Supplier'
					AND OPQT.DocEntry=@list_of_cols_val_tab_del)
					begin
						set @error=00205
						set @error_message='Cannot add Dummy Supplier. Update Supplier Code.'
			end 
			end



-- No tagging of Budget---
	if @object_type = '540000006' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPQT.docentry from OPQT
Inner join PQT1 on PQT1.DocEntry = OPQT.DocEntry 

where 
			PQT1.Project <> 'EHI000'
		    and PQT1.U_BudgetNo is null
			AND OPQT.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error=00204
				set @error_message='Budget No is lacking for Chargeable to Project related transaction.'
	end 
	end



-- No tagging of Dimension for Project-related
	if @object_type = '540000006' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPQT.docentry from OPQT
Inner join PQT1 on PQT1.DocEntry = OPQT.DocEntry 

where 
			
			PQT1.Project <> 'EHI000'
		    and PQT1.U_Dimension1 is null
			and PQT1.U_Dimension2 is null
			and PQT1.U_Dimension3 is null
			and PQT1.U_Dimension4 is null
			and PQT1.U_Dimension5 is null
			AND OPQT.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00203
				set @error_message='Dimension (s) is lacking for Chargeable to Project related transaction.'
	end 
	end


-- No tagging of Project---
	if @object_type = '540000006' and (@transaction_type in ('A', 'U')) 
begin

if exists (select PQT1.docentry from PQT1

where 
			
			ISNULL (PQT1.Project,'')=''
			AND PQT1.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00202
				set @error_message='Project is lacking in the row. Define Project Code.'
	end 
	end


-- No tagging of Purchase Subcategory Transaction Type---
	if @object_type = '540000006' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPQT.docentry from OPQT 

where 
			
			OPQT.U_PR_Type2 in ( 'PLISG', 'PIMPI' , 'PLISS')
			AND OPQT.U_SubPR_Type is null
			AND OPQT.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00201
				set @error_message='Subcategory Purchase Transaction Type is lacking for this transaction.'
	end 
	end



-- No tagging of Purchase Transaction Type---
	if @object_type = '540000006' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPQT.docentry from OPQT 

where 
			
			OPQT.U_PR_Type2 is null
			AND OPQT.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00200
				set @error_message='Purchase Transaction Type is lacking.'
	end 
	end

---------------------------


---PURCHASE QUOTATION DRAFT


--Adding of Purchase Quotation with Dummy Supplier

		if @object_type = '112' and (@transaction_type in ('A', 'U')) 
		begin

		if exists (select ODRF.docentry from ODRF

		where 
					ODRF.CardName = 'Dummy Supplier'
					AND ODRF.ObjType =  '540000006'
					AND ODRF.DocEntry=@list_of_cols_val_tab_del)
					begin
						set @error=-00205
						set @error_message='Cannot add Dummy Supplier. Update Supplier Code.'
			end 
			end



-- No tagging of Budget---
	if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ODRF.docentry from ODRF
Inner join DRF1 on DRF1.DocEntry = ODRF.DocEntry 

where 
			DRF1.Project <> 'EHI000'
		    and DRF1.U_BudgetNo is null
			AND ODRF.ObjType =  '540000006'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error=-00204
				set @error_message='Budget No is lacking for Chargeable to Project related transaction.'
	end 
	end



-- No tagging of Dimension for Project-related
	if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ODRF.docentry from ODRF
Inner join DRF1 on DRF1.DocEntry = ODRF.DocEntry 

where 
			
			DRF1.Project <> 'EHI000'
		    and DRF1.U_Dimension1 is null
			and DRF1.U_Dimension2 is null
			and DRF1.U_Dimension3 is null
			and DRF1.U_Dimension4 is null
			and DRF1.U_Dimension5 is null
			AND ODRF.ObjType =  '540000006'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= -00203
				set @error_message='Dimension (s) is lacking for Chargeable to Project related transaction.'
	end 
	end


-- No tagging of Project---
	if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

if exists (select DRF1.docentry from DRF1
INNER JOIN ODRF ON DRF1.DocEntry = ODRF.DocEntry

where 
			
			ISNULL (DRF1.Project,'')=''
			AND ODRF.ObjType =  '540000006'
			AND DRF1.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= -00202
				set @error_message='Project is lacking in the row. Define Project Code.'
	end 
	end


-- No tagging of Purchase Subcategory Transaction Type---
	if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ODRF.docentry from ODRF 

where 
			
			ODRF.U_PR_Type2 in ( 'PLISG', 'PIMPI' , 'PLISS')
			AND ODRF.U_SubPR_Type is null
			AND ODRF.ObjType =  '540000006'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= -00201
				set @error_message='Subcategory Purchase Transaction Type is lacking for this transaction.'
	end 
	end



-- No tagging of Purchase Transaction Type---
	if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ODRF.docentry from ODRF 

where 
			
			ODRF.U_PR_Type2 is null
			AND ODRF.ObjType =  '540000006'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= -00200
				set @error_message='Purchase Transaction Type is lacking.'
	end 
	end


---------------------------------

---PURCHASE ORDER---

-- Ordered Total Over Budget and Approval is NO---
	if @object_type = '22' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPOR.docentry from OPOR
inner join POR1 ON POR1.DocEntry = OPOR.DocEntry

where 
			
			POR1.FreeTxt = 'TRUE'
			and OPOR.U_ForApprov <> 'P'
			AND OPOR.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00219
				set @error_message='Total Amount Ordered is Over the Budget. Update For Approval field to Yes for PO.'
	end 
	end


-- Perform Autocheck for approval---
	if @object_type = '22' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPOR.docentry from OPOR
inner join POR1 ON POR1.DocEntry = OPOR.DocEntry

where 
			
			OPOR.U_ACAR <> 'PO'
			and OPOR.U_SubPR_Type NOT IN ('DS', 'CU')
			AND POR1.Project <> 'EHI000'
			AND OPOR.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00218
				set @error_message='Update Autocheck for Approval field to Done for PO.'
	end 
	end






--Document ToTal Higher than Total Commission in Sales Order--

		if @object_type = '22' and (@transaction_type in ('A', 'U')) 
		begin

		if exists (select OPOR.docentry from OPOR
		Left Join ORDR on OPOR.U_SONo1 = ORDR.DocEntry

		where 
					OPOR.U_PR_Type2 ='OSCO'
					and OPOR.U_SONo1 = ORDR.DocEntry
					AND OPOR.DocTotal > ORDR.U_TotCom
					AND OPOR.DocEntry=@list_of_cols_val_tab_del)
					begin
						set @error= 00217
						set @error_message='Document ToTal Higher than Total Commission in Sales Order'
			end 
			end




-- SO Number is required for Commission--

		if @object_type = '22' and (@transaction_type in ('A', 'U')) 
		begin

		if exists (select OPOR.docentry from OPOR
		where 
					OPOR.U_PR_Type2 ='OSCO'
					AND OPOR.U_SONo1 IS NULL
					AND OPOR.DocEntry=@list_of_cols_val_tab_del)
	begin
						set @error= 00216
						set @error_message='Tag the related Sales Order for this transaction'
			end 
			end



--- Purchase Quotation is Required

		if @object_type = '22' and (@transaction_type in ('A', 'U')) 
		begin

			if exists (select OPOR.docentry from OPOR 
		LEFT JOIN POR1 ON POR1.Docentry = OPOR.Docentry

		Where POR1.BaseType IN ( -1, 1470000113)
		and OPOR.U_PR_Type2 = 'PFXA'
		and OPOR.DocEntry=@list_of_cols_val_tab_del) 

		Begin 

		set @error=  00215

		set @error_message = 'Based Purchase Quotation is required in adding this transaction.' 

		End 

		End 

--- Purchase Request and Purchase Quotation are Required

			if @object_type = '22'  and (@transaction_type in ('A', 'U')) 
		begin

			if exists (select OPOR.docentry from OPOR 
		LEFT JOIN POR1 ON POR1.Docentry = OPOR.Docentry

		Where POR1.BaseType IN ( -1, 1470000113)
		and OPOR.U_SubPR_Type in ('CM', 'CS', 'EQ')
		AND OPOR.ObjType =  '22'
		and OPOR.DocEntry=@list_of_cols_val_tab_del) 

		Begin 

		set @error=  -00315

		set @error_message = 'Base Purchase Request and Purchase Quotation are required in adding this transaction.' 

		End 

		End 

--- Purchase Request and Purchase Quotation are Required

			if @object_type = '22'  and (@transaction_type in ('A', 'U')) 
		begin

			if exists (select OPOR.docentry from OPOR 
		LEFT JOIN POR1 ON POR1.Docentry = OPOR.Docentry

		Where POR1.BaseType IN ( -1, 1470000113)
		and OPOR.U_PR_Type2 = 'PCSC'
		AND OPOR.ObjType =  '22'
		and OPOR.DocEntry=@list_of_cols_val_tab_del) 

		Begin 

		set @error=  -00420

		set @error_message = 'Base Purchase Request and Purchase Quotation are required in adding this transaction.' 

		End

		End

---Adding of Dummy Supplier--

		if @object_type = '22' and (@transaction_type in ('A', 'U')) 
		begin

		if exists (select OPOR.docentry from OPOR

		where 
					OPOR.CardName = 'Dummy Supplier'
					AND OPOR.DocEntry=@list_of_cols_val_tab_del)
					begin
						set @error=  00214
						set @error_message='Cannot add Dummy Supplier. Update Supplier Code.'
			end 
			end


--Transaction Type Inconsistent in Purchase Request--



if @object_type = '22' and (@transaction_type in ('A', 'U')) 
begin

			if exists (select OPOR.docentry from OPOR 
			Inner Join POR1 on OPOR.DocEntry = POR1.DocEntry
			inner join PRQ1  on PRQ1.DocEntry = POR1.BaseEntry 
			inner join OPRQ on OPRQ.DocEntry= PRQ1.DocEntry AND POR1.BaseType=OPRQ.ObjType 

			WHERE 
			OPRQ.U_PR_Type2 <> OPOR.U_PR_Type2
			AND OPOR.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error = 00213
				set @error_message='Transaction Type Inconsistent in Purchase Request.'

		end
		end
		
--Project Code Inconsistent in Purchase Request--

if @object_type = '22' and (@transaction_type in ('A', 'U')) 
begin

			if exists (select OPOR.docentry from OPOR 
			Inner Join POR1 on oPOR.DocEntry = POR1.DocEntry
			inner join PRQ1  on PRQ1.DocEntry = POR1.BaseEntry 
			inner join OPRQ on OPRQ.DocEntry= PRQ1.DocEntry AND POR1.BaseType=OPRQ.ObjType 

			WHERE 
			PRQ1.Project <> POR1.Project
			AND OPOR.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error= 00212
				set @error_message= 'Project Code Inconsistent in Purchase Request.'

		end
		end

--Budget No. Inconsistent in Purchase Request--

if @object_type = '22' and (@transaction_type in ('A', 'U')) 
begin

			if exists (select OPOR.docentry from OPOR 
			Inner Join POR1 on oPOR.DocEntry = POR1.DocEntry
			inner join PRQ1  on PRQ1.DocEntry = POR1.BaseEntry 
			inner join OPRQ on OPRQ.DocEntry= PRQ1.DocEntry AND POR1.BaseType=OPRQ.ObjType 

			WHERE 
			PRQ1.U_BudgetNo <> POR1.U_BudgetNo
			AND OPOR.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error= 00211
				set @error_message= 'Budget No. Inconsistent in Purchase Request.'

		end
		end

--Transaction Type Inconsistent with based Purchase Quotation--

if @object_type = '22' and (@transaction_type in ('A', 'U')) 
begin

			if exists (select OPOR.docentry from OPOR 
			Inner Join POR1 on oPOR.DocEntry = POR1.DocEntry
			inner join PQT1  on PQT1.DocEntry = POR1.BaseEntry and POR1.BaseType = 540000006
			Inner JOIN OPQT ON OPQT.DocEntry = PQT1.DocEntry


			WHERE 
			OPQT.U_PR_Type2 <> OPOR.U_PR_Type2
			AND OPOR.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error= 00210
				set @error_message='Transaction Type Inconsistent with based Purchase Quotation.'

		end
		end



--Transaction Type Inconsistent with based Purchase Request--

if @object_type = '22' and (@transaction_type in ('A', 'U')) 
begin

			if exists (select OPOR.docentry from OPOR 
			Inner Join POR1 on oPOR.DocEntry = POR1.DocEntry
			inner join PRQ1  on PRQ1.DocEntry = POR1.BaseEntry and POR1.BaseType = 1470000113
			Inner JOIN OPRQ ON OPRQ.DocEntry = PRQ1.DocEntry


			WHERE 
			OPRQ.U_PR_Type2 <> OPOR.U_PR_Type2
			AND OPOR.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error= 00209
				set @error_message='Transaction Type Inconsistent with based Purchase Request.'

		end
		end

--Project Code Inconsistent with based Purchase Quotation--

if @object_type = '22' and (@transaction_type in ('A', 'U')) 
begin

			if exists (select OPOR.docentry from OPOR 
			Inner Join POR1 on oPOR.DocEntry = POR1.DocEntry
			inner join PQT1  on PQT1.DocEntry = POR1.BaseEntry and POR1.BaseType = 540000006

			WHERE 
			PQT1.Project <> POR1.Project
			AND OPOR.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error = 00208
				set @error_message= 'Project Code Inconsistent with the based Purchase Quotation.'

		end
		end


--Project Code Inconsistent with the based Purchase Request--

if @object_type = '22' and (@transaction_type in ('A', 'U')) 
begin

			if exists (select OPOR.docentry from OPOR 
			Inner Join POR1 on oPOR.DocEntry = POR1.DocEntry
			LEFT JOIN PRQ1 ON PRQ1.DocEntry = POR1.BaseEntry AND POR1.BaseType = 1470000113

			WHERE 
			PRQ1.Project <> POR1.Project
			AND OPOR.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error= 00207
				set @error_message= 'Project Code Inconsistent with the based Purchase Request.'

		end
		end



--Budget No. Inconsistent in Purchase Quotation--

if @object_type = '22' and (@transaction_type in ('A', 'U')) 
begin

			if exists (select OPOR.docentry from OPOR 
			Inner Join POR1 on oPOR.DocEntry = POR1.DocEntry
			inner join PQT1  on PQT1.DocEntry = POR1.BaseEntry and POR1.BaseType = 540000006


			WHERE 
			PQT1.U_BudgetNo <> POR1.U_BudgetNo
			AND OPOR.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error= 00206
				set @error_message= 'Budget No. Inconsistent with the based Purchase Quotation.'

		end
		end


--Budget No. Inconsistent in Purchase Request--

if @object_type = '22' and (@transaction_type in ('A', 'U')) 
begin

			if exists (select OPOR.docentry from OPOR 
			Inner Join POR1 on oPOR.DocEntry = POR1.DocEntry
			LEFT JOIN PRQ1 ON PRQ1.DocEntry = POR1.BaseEntry AND POR1.BaseType = 1470000113
		

			WHERE 
			PRQ1.U_BudgetNo <> POR1.U_BudgetNo
			AND OPOR.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error= 00205
				set @error_message= 'Budget No. Inconsistent with the based Purchase Request.'

		end
		end



-- No tagging of Budget---
	if @object_type = '22' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPOR.docentry from OPOR
Inner join POR1 on POR1.DocEntry = OPOR.DocEntry 

where 
			POR1.Project <> 'EHI000'
		    and POR1.U_BudgetNo is null
			AND OPOR.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error=00204
				set @error_message='Budget No is lacking for Chargeable to Project related transaction.'
	end 
	end



-- No tagging of Dimension for Project-related
	if @object_type = '22' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPOR.docentry from OPOR
Inner join POR1 on POR1.DocEntry = OPOR.DocEntry 

where 
			
			POR1.Project <> 'EHI000'
		    and POR1.U_Dimension1 is null
			and POR1.U_Dimension2 is null
			and POR1.U_Dimension3 is null
			and POR1.U_Dimension4 is null
			and POR1.U_Dimension5 is null
			AND OPOR.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00203
				set @error_message='Dimension (s) is lacking for Chargeable to Project related transaction.'
	end 
	end


-- No tagging of Project---
	if @object_type = '22' and (@transaction_type in ('A', 'U')) 
begin

if exists (select POR1.docentry from POR1

where 
			
			ISNULL (POR1.Project,'')=''
			AND POR1.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00202
				set @error_message='Project is lacking in the row. Define Project Code.'
	end 
	end



-- No tagging of Purchase Subcategory Transaction Type---
	if @object_type = '22' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPOR.docentry from OPOR 

where 
			
			OPOR.U_PR_Type2 in ( 'PLISG', 'PIMPI' , 'PLISS')
			AND OPOR.U_SubPR_Type is null
			AND OPOR.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00601
				set @error_message='Subcategory Purchase Transaction Type is lacking for this transaction.'
	end 
	end




-- No tagging of Purchase Transaction Type---
	if @object_type = '22' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPOR.docentry from OPOR 

where 
			
			OPOR.U_PR_Type2 is null
			AND OPOR.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00201
				set @error_message='Purchase Transaction Type is lacking.'
	end 
	end




----
---PURCHASE ORDER DRAFT

-- Requested Quantity Over Budget and Approval is NO---
	if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ODRF.docentry from ODRF
inner join DRF1 ON DRF1.DocEntry = ODRF.DocEntry

where 
			
			DRF1.FreeTxt = 'TRUE'
			and ODRF.U_ForApprov <> 'P'
			AND ODRF.ObjType =  '22'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00219
				set @error_message='Total Amount Ordered is Over the Budget. Update For Approval field to Yes for PO.'
	end 
	end


-- Perform Autocheck for approval---
	if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ODRF.docentry from ODRF
inner join DRF1 ON DRF1.DocEntry = ODRF.DocEntry

where 
			
			ODRF.U_ACAR <> 'PO'
			and ODRF.U_SubPR_Type NOT IN ('DS', 'CU')
			AND DRF1.Project <> 'EHI000'
			AND ODRF.ObjType =  '22'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= -00218
				set @error_message='Update Autocheck for Approval field to Done for PO.'
	end 
	end


--Document ToTal Higher than Total Commission in Sales Order--

		if @object_type = '112'  and (@transaction_type in ('A', 'U')) 
		begin

		if exists (select ODRF.docentry from ODRF
		Left Join ORDR on ODRF.U_SONo1 = ORDR.DocEntry

		where 
					ODRF.U_PR_Type2 ='OSCO'
					and ODRF.U_SONo1 = ORDR.DocEntry
					AND ODRF.DocTotal > ORDR.U_TotCom
					AND ODRF.ObjType =  '22'
					AND ODRF.DocEntry=@list_of_cols_val_tab_del)
					begin
						set @error= -00217
						set @error_message='Document ToTal Higher than Total Commission in Sales Order'
			end 
			end




-- SO Number is required for Commission--

		if @object_type = '112'  and (@transaction_type in ('A', 'U')) 
		begin

		if exists (select ODRF.docentry from ODRF
		where 
					ODRF.U_PR_Type2 ='OSCO'
					AND ODRF.U_SONo1 IS NULL
						AND ODRF.ObjType =  '22'
					AND ODRF.DocEntry=@list_of_cols_val_tab_del)
	begin
						set @error= -00216
						set @error_message='Tag the related Sales Order for this transaction'
			end 
			end


----- Purchase Request and Purchase Quotation are Required

			if @object_type = '112'  and (@transaction_type in ('A', 'U')) 
		begin

			if exists (select ODRF.docentry from ODRF 
		LEFT JOIN DRF1 ON DRF1.Docentry = ODRF.Docentry

		Where DRF1.BaseType IN ( -1, 1470000113)
		and ODRF.U_SubPR_Type in ('CM', 'CS', 'EQ')
		--or ODRF.U_PR_Type2 = 'PCSC'
		AND ODRF.ObjType =  '22'
		and ODRF.DocEntry=@list_of_cols_val_tab_del) 

		Begin 

		set @error=  -00515

		set @error_message = 'Base Purchase Request and Purchase Quotation are required in adding this transaction.' 

		End 

		End 



---Adding of Dummy Supplier--

		if @object_type = '112'  and (@transaction_type in ('A', 'U'))  
		begin

		if exists (select ODRF.docentry from ODRF

		where 
					ODRF.CardName = 'Dummy Supplier'
					AND ODRF.ObjType =  '22'
					AND ODRF.DocEntry=@list_of_cols_val_tab_del)
					begin
						set @error=  -00214
						set @error_message='Cannot add Dummy Supplier. Update Supplier Code.'
			end 
			end


--Transaction Type Inconsistent in Purchase Request--



if @object_type = '112'  and (@transaction_type in ('A', 'U'))  
begin

			if exists (select ODRF.docentry from ODRF 
			Inner Join DRF1 on ODRF.DocEntry = DRF1.DocEntry
			inner join PRQ1  on PRQ1.DocEntry = DRF1.BaseEntry 
			inner join OPRQ on OPRQ.DocEntry= PRQ1.DocEntry AND DRF1.BaseType=OPRQ.ObjType 

			WHERE 
			OPRQ.U_PR_Type2 <> ODRF.U_PR_Type2
			AND ODRF.ObjType =  '22'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error = -00213
				set @error_message='Transaction Type Inconsistent in Purchase Request.'

		end
		end
		
--Project Code Inconsistent in Purchase Request--

if @object_type = '112'  and (@transaction_type in ('A', 'U'))  
begin

			if exists (select ODRF.docentry from ODRF 
			Inner Join DRF1 on oDRF.DocEntry = DRF1.DocEntry
			inner join PRQ1  on PRQ1.DocEntry = DRF1.BaseEntry 
			inner join OPRQ on OPRQ.DocEntry= PRQ1.DocEntry AND DRF1.BaseType=OPRQ.ObjType 

			WHERE 
			PRQ1.Project <> DRF1.Project
			AND ODRF.ObjType =  '22'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error= -00212
				set @error_message= 'Project Code Inconsistent in Purchase Request.'

		end
		end

--Budget No. Inconsistent in Purchase Request--

if @object_type = '112'  and (@transaction_type in ('A', 'U'))  
begin

			if exists (select ODRF.docentry from ODRF 
			Inner Join DRF1 on oDRF.DocEntry = DRF1.DocEntry
			inner join PRQ1  on PRQ1.DocEntry = DRF1.BaseEntry 
			inner join OPRQ on OPRQ.DocEntry= PRQ1.DocEntry AND DRF1.BaseType=OPRQ.ObjType 

			WHERE 
			PRQ1.U_BudgetNo <> DRF1.U_BudgetNo
			AND ODRF.ObjType =  '22'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error= -00211
				set @error_message= 'Budget No. Inconsistent in Purchase Request.'

		end
		end

--Transaction Type Inconsistent with based Purchase Quotation--
if @object_type = '112'  and (@transaction_type in ('A', 'U')) 
begin

			if exists (select ODRF.docentry from ODRF 
			Inner Join DRF1 on oDRF.DocEntry = DRF1.DocEntry
			inner join PQT1  on PQT1.DocEntry = DRF1.BaseEntry and DRF1.BaseType = 540000006
			Inner JOIN OPQT ON OPQT.DocEntry = PQT1.DocEntry


			WHERE 
			OPQT.U_PR_Type2 <> ODRF.U_PR_Type2
			AND ODRF.ObjType =  '22'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error= -00210
				set @error_message='Transaction Type Inconsistent with based Purchase Quotation.'

		end
		end



--Transaction Type Inconsistent with based Purchase Request--

if @object_type = '112'  and (@transaction_type in ('A', 'U')) 
begin

			if exists (select ODRF.docentry from ODRF 
			Inner Join DRF1 on oDRF.DocEntry = DRF1.DocEntry
			inner join PRQ1  on PRQ1.DocEntry = DRF1.BaseEntry and DRF1.BaseType = 1470000113
			Inner JOIN OPRQ ON OPRQ.DocEntry = PRQ1.DocEntry


			WHERE 
			OPRQ.U_PR_Type2 <> ODRF.U_PR_Type2
			AND ODRF.ObjType =  '22'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error= -00209
				set @error_message='Transaction Type Inconsistent with based Purchase Request.'

		end
		end

--Project Code Inconsistent with based Purchase Quotation--

if @object_type = '112'  and (@transaction_type in ('A', 'U')) 
begin

			if exists (select ODRF.docentry from ODRF 
			Inner Join DRF1 on oDRF.DocEntry = DRF1.DocEntry
			inner join PQT1  on PQT1.DocEntry = DRF1.BaseEntry and DRF1.BaseType = 540000006

			WHERE 
			PQT1.Project <> DRF1.Project
			AND ODRF.ObjType =  '22'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error = -00208
				set @error_message= 'Project Code Inconsistent with the based Purchase Quotation.'

		end
		end


--Project Code Inconsistent with the based Purchase Request--

if @object_type = '112'  and (@transaction_type in ('A', 'U')) 
begin

			if exists (select ODRF.docentry from ODRF 
			Inner Join DRF1 on oDRF.DocEntry = DRF1.DocEntry
			LEFT JOIN PRQ1 ON PRQ1.DocEntry = DRF1.BaseEntry AND DRF1.BaseType = 1470000113

			WHERE 
			PRQ1.Project <> DRF1.Project
			AND ODRF.ObjType =  '22'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error= -00207
				set @error_message= 'Project Code Inconsistent with the based Purchase Request.'

		end
		end



--Budget No. Inconsistent in Purchase Quotation--

if @object_type = '112'  and (@transaction_type in ('A', 'U')) 
begin

			if exists (select ODRF.docentry from ODRF 
			Inner Join DRF1 on oDRF.DocEntry = DRF1.DocEntry
			inner join PQT1  on PQT1.DocEntry = DRF1.BaseEntry and DRF1.BaseType = 540000006


			WHERE 
			PQT1.U_BudgetNo <> DRF1.U_BudgetNo
			AND ODRF.ObjType =  '22'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error= -00206
				set @error_message= 'Budget No. Inconsistent with the based Purchase Quotation.'

		end
		end


--Budget No. Inconsistent in Purchase Request--


if @object_type = '112'  and (@transaction_type in ('A', 'U')) 
begin

			if exists (select ODRF.docentry from ODRF 
			Inner Join DRF1 on oDRF.DocEntry = DRF1.DocEntry
			LEFT JOIN PRQ1 ON PRQ1.DocEntry = DRF1.BaseEntry AND DRF1.BaseType = 1470000113
		

			WHERE 
			PRQ1.U_BudgetNo <> DRF1.U_BudgetNo
			AND ODRF.ObjType =  '22'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error= -00205
				set @error_message= 'Budget No. Inconsistent with the based Purchase Request.'

		end
		end



-- No tagging of Budget---
	if @object_type = '112'  and (@transaction_type in ('A', 'U')) 
begin

if exists (select ODRF.docentry from ODRF
Inner join DRF1 on DRF1.DocEntry = ODRF.DocEntry 

where 
			DRF1.Project <> 'EHI000'
		    and DRF1.U_BudgetNo is null
			AND ODRF.ObjType =  '22'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error=-00204
				set @error_message='Budget No is lacking for Chargeable to Project related transaction.'
	end 
	end



-- No tagging of Dimension for Project-related
		if @object_type = '112'  and (@transaction_type in ('A', 'U'))
begin

if exists (select ODRF.docentry from ODRF
Inner join DRF1 on DRF1.DocEntry = ODRF.DocEntry 

where 
			
			DRF1.Project <> 'EHI000'
		    and DRF1.U_Dimension1 is null
			and DRF1.U_Dimension2 is null
			and DRF1.U_Dimension3 is null
			and DRF1.U_Dimension4 is null
			and DRF1.U_Dimension5 is null
			AND ODRF.ObjType =  '22'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= -00203
				set @error_message='Dimension (s) is lacking for Chargeable to Project related transaction.'
	end 
	end


-- No tagging of Project---
	if @object_type = '112'  and (@transaction_type in ('A', 'U'))
begin

if exists (select DRF1.docentry from DRF1


where 
			
			ISNULL (DRF1.Project,'')=''
			and drf1.ObjType = '22'
			AND DRF1.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= -00202
				set @error_message='Project is lacking in the row. Define Project Code.'
	end 
	end


-- No tagging of Purchase Subcategory Transaction Type---
	if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ODRF.docentry from ODRF 

where 
			
			ODRF.U_PR_Type2 in ( 'PLISG', 'PIMPI' , 'PLISS')
			AND ODRF.U_SubPR_Type is null
			AND ODRF.ObjType =  '22'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00201
				set @error_message='Subcategory Purchase Transaction Type is lacking for this transaction.'
	end 
	end



-- No tagging of Purchase Transaction Type---
	if @object_type = '112'  and (@transaction_type in ('A', 'U'))
begin

if exists (select ODRF.docentry from ODRF 

where 
			
			ODRF.U_PR_Type2 is null
			AND ODRF.ObjType =  '22'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= -00200
				set @error_message='Purchase Transaction Type is lacking.'
	end 
	end


-----------------------------------







---A/P Down Payment Invoice



-- No tagging of Budget---
	if @object_type = '204' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ODPO.docentry from ODPO
Inner join DPO1 on DPO1.DocEntry = ODPO.DocEntry 

where 
			DPO1.Project <> 'EHI000'
		    and DPO1.U_BudgetNo is null
			AND ODPO.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error=00304
				set @error_message='Budget No is lacking for Chargeable to Project related transaction.'
	end 
	end



-- No tagging of Dimension for Project-related
	if @object_type = '204' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ODPO.docentry from ODPO
Inner join DPO1 on DPO1.DocEntry = ODPO.DocEntry 

where 
			
			DPO1.Project <> 'EHI000'
		    and DPO1.U_Dimension1 is null
			and DPO1.U_Dimension2 is null
			and DPO1.U_Dimension3 is null
			and DPO1.U_Dimension4 is null
			and DPO1.U_Dimension5 is null
			AND ODPO.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00303
				set @error_message='Dimension (s) is lacking for Chargeable to Project related transaction.'
	end 
	end


-- No tagging of Project---
	if @object_type = '204' and (@transaction_type in ('A', 'U')) 
begin

if exists (select DPO1.docentry from DPO1

where 
			
			ISNULL (DPO1.Project,'')=''
			AND DPO1.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00302
				set @error_message='Project is lacking in the row. Define Project Code.'
	end 
	end


-- No tagging of Purchase Transaction Type---
	if @object_type = '204' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ODPO.docentry from ODPO 

where 
			
			ODPO.U_PR_Type2 is null
			AND ODPO.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00301
				set @error_message='Purchase Transaction Type is lacking.'
	end 
	end



---AP DOWN PAYMENT DRAFT


-- No tagging of Budget---
	if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ODRF.docentry from ODRF
Inner join DRF1 on DRF1.DocEntry = ODRF.DocEntry 

where 
			DRF1.Project <> 'EHI000'
		    and DRF1.U_BudgetNo is null
			AND ODRF.ObjType =  '204'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= -00304
				set @error_message='Budget No is lacking for Chargeable to Project related transaction.'
	end 
	end



-- No tagging of Dimension for Project-related
	if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ODRF.docentry from ODRF
Inner join DRF1 on DRF1.DocEntry = ODRF.DocEntry 

where 
			
			DRF1.Project <> 'EHI000'
		    and DRF1.U_Dimension1 is null
			and DRF1.U_Dimension2 is null
			and DRF1.U_Dimension3 is null
			and DRF1.U_Dimension4 is null
			and DRF1.U_Dimension5 is null
			AND ODRF.ObjType =  '204'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= -00303
				set @error_message='Dimension (s) is lacking for Chargeable to Project related transaction.'
	end 
	end


-- No tagging of Project---
	if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

if exists (select DRF1.docentry from DRF1

where 
			
			ISNULL (DRF1.Project,'')=''
			AND DRF1.ObjType =  '204'
			AND DRF1.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00302
				set @error_message='Project is lacking in the row. Define Project Code.'
	end 
	end




-- No tagging of Purchase Transaction Type---
	if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ODRF.docentry from ODRF 

where 
			
			ODRF.U_PR_Type2 is null
			AND ODRF.ObjType =  '204'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= -00301
				set @error_message='Purchase Transaction Type is lacking.'
	end 
	end


--------------------------------------------


---GOODS RECEIPT PO

--- Plate No. is lacking
if @object_type = '20' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPDN.DocEntry FROM OPDN

where 
			OPDN.U_Vehicle_PN is null
			AND OPDN.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00507
				set @error_message='Input Vehicle Plate No.'
	end 
	end



--- Driver's Name is Lacking
if @object_type = '20' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPDN.DocEntry FROM OPDN

where 
			OPDN.U_Driver_Name is null
			AND OPDN.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00506
				set @error_message='Input Driver Name'
	end 
	end



--- Vendor Reference Number is lacking
if @object_type = '20' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPDN.DocEntry FROM OPDN

where 
			ISNULL (OPDN.NumAtCard, '') = ''
			AND OPDN.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00505
				set @error_message='Input Vendor Reference Number.'
	end 
	end

-- No tagging of Budget---
	if @object_type = '20' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPDN.docentry from OPDN
Inner join PDN1 on PDN1.DocEntry = OPDN.DocEntry 

where 
			PDN1.Project <> 'EHI000'
		    and PDN1.U_BudgetNo is null
			AND OPDN.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error=00504
				set @error_message='Budget No is lacking for Chargeable to Project related transaction.'
	end 
	end



-- No tagging of Dimension for Project-related
	if @object_type = '20' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPDN.docentry from OPDN
Inner join PDN1 on PDN1.DocEntry = OPDN.DocEntry 

where 
			
			PDN1.Project <> 'EHI000'
		    and PDN1.U_Dimension1 is null
			and PDN1.U_Dimension2 is null
			and PDN1.U_Dimension3 is null
			and PDN1.U_Dimension4 is null
			and PDN1.U_Dimension5 is null
			AND OPDN.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00503
				set @error_message='Dimension (s) is lacking for Chargeable to Project related transaction.'
	end 
	end


-- No tagging of Project---
	if @object_type = '20' and (@transaction_type in ('A', 'U')) 
begin

if exists (select PDN1.docentry from PDN1

where 
			
			ISNULL (PDN1.Project,'')=''
			AND PDN1.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00502
				set @error_message='Project is lacking in the row. Define Project Code.'
	end 
	end


-- No tagging of Purchase Transaction Type---
	if @object_type = '20' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPDN.docentry from OPDN 

where 
			
			OPDN.U_PR_Type2 is null
			AND OPDN.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00401
				set @error_message='Purchase Transaction Type is lacking.'
	end 
	end

--NO BASE PO
if @object_type = '20' and (@transaction_type in ('A', 'U')) 
begin

			if exists (select OPDN.docentry from OPDN 
			Inner Join PDN1 on OPDN.DocEntry = PDN1.DocEntry

			WHERE 
			PDN1.BaseType = -1
			and OPDN.DocType = 'I'
			AND OPDN.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error=01112
				set @error_message='Base PO is Required for this transaction.' 

		end
		end



---------------------------------------------


---GOODS RETURN


---Reason for Return in the Rows
if @object_type = '21' and (@transaction_type in ('A', 'U')) 
begin

if exists (select RPD1.DocEntry from RPD1

where 
			RPD1.ReturnRsn = -1
			AND RPD1.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00503
				set @error_message='Enter Reason for Return in the Rows.'
	end 
	end


---Reason for Return in the Header
if @object_type = '21' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ORPD.DocEntry from ORPD

where 
			ORPD.U_RetRes is null 
			AND ORPD.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00502
				set @error_message='Enter Reason for Return in the Header.'
	end 
	end


-- No tagging of Purchase Transaction Type---
	if @object_type = '21' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ORPD.docentry from ORPD 

where 
			
			ORPD.U_PR_Type2 is null
			AND ORPD.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00501
				set @error_message='Purchase Transaction Type is lacking.'
	end 
	end



---------------------------------------
-----AP INVOICE DRAFT

-- No tagging of Purchase Transaction Type---
	if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ODRF.docentry from ODRF 

where 
			
			ODRF.U_PR_Type2 is null
			AND ODRF.ObjType =  '18'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00700
				set @error_message='Purchase Transaction Type is lacking.'
	end 
	end

-- No tagging of Purchase Subcategory Transaction Type---
	if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ODRF.docentry from ODRF 

where 
			
			ODRF.U_PR_Type2 in ( 'PLISG', 'PIMPI' , 'PLISS')
			AND ODRF.ObjType =  '18'
			AND ODRF.U_SubPR_Type is null
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00701
				set @error_message='Subcategory Purchase Transaction Type is lacking for this transaction.'
	end 
	end

-- No tagging of Project---
	if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ODRF.docentry from ODRF

where 
			
			ISNULL (ODRF.Project,'')=''
			AND ODRF.ObjType =  '18'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00400
				set @error_message='Project is lacking. Define Project Code.'
	end 
	end

---Lacking Percentage of Completion
if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

			if exists (select ODRF.docentry from ODRF 
			INNER JOIN DRF1 ON ODRF.DocEntry = DRF1.DocEntry
			

			WHERE 
			ODRF.U_PR_Type2 = 'PCSC'
			AND ODRF.ObjType =  '18'
			and DRF1.U_CTPC IS NULL
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error=00411
				set @error_message='Input Current Percentage of Completion for this contracted services in row.'

		end
		end

--Update G/L Code to Subcon Charges-

if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

			if exists (select ODRF.docentry from ODRF 
			Inner Join DRF1 on ODRF.DocEntry = DRF1.DocEntry

			WHERE 
			ODRF.U_PR_Type2 = 'PLISS'
			AND ODRF.ObjType =  '18'
			and DRF1.AcctCode <> 'OC390000'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error=002111
				set @error_message='Update G/L Code to Subcon Charges for this transaction'

		end
		end

--Update G/L Code to Subcon Charges-

if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

			if exists (select ODRF.docentry from ODRF 
			Inner Join DRF1 on ODRF.DocEntry = DRF1.DocEntry

			WHERE 
			ODRF.U_PR_Type2 = 'PLISS'
			AND ODRF.ObjType =  '18'
			and DRF1.AcctCode <> 'OC390000'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error=00511
				set @error_message='Update G/L Code to Subcon Charges for this transaction'

		end
		end

---- NO BASE PURCHASE REQUEST AND PURCHASE QUOTATION
--if @object_type = '112' and (@transaction_type in ('A', 'U')) 
--begin

--			if exists (select ODRF.docentry from ODRF 
--			Inner Join DRF1 on ODRF.DocEntry = DRF1.DocEntry

--			WHERE 
--			DRF1.BaseType = -1
--			and ODRF.U_PR_Type2 = 'PCSC'
--			or ODRF.U_SubPR_Type in ('CM', 'CS', 'EQ')
--			AND ODRF.ObjType =  '18'
--			and DRF1.AcctCode <> 'OC390000'
--			AND ODRF.DocEntry=@list_of_cols_val_tab_del)

--			begin
--				set @error=01111
--				set @error_message='Base Purchase Request and Purchase Quotation are required for this transaction.'

--		end
--		end

---- NO BASE PURCHASE QUOTATION
--if @object_type = '112' and (@transaction_type in ('A', 'U')) 
--begin

--			if exists (select ODRF.docentry from ODRF 
--			Inner Join DRF1 on ODRF.DocEntry = DRF1.DocEntry

--			WHERE 
--			DRF1.BaseType = 1470000113
--			and ODRF.U_PR_Type2 = 'PCSC'
--			or ODRF.U_SubPR_Type in ('CM', 'CS', 'EQ')
--			AND ODRF.ObjType =  '18'
--			and DRF1.AcctCode <> 'OC390000'
--			AND ODRF.DocEntry=@list_of_cols_val_tab_del)

--			begin
--				set @error=01111
--				set @error_message='Base Purchase Quotation is required for this transaction.'

--		end
--		end

----NO BASE PURCHASE QUOTATION
--if @object_type = '112' and (@transaction_type in ('A', 'U')) 
--begin

--			if exists (select ODRF.docentry from ODRF 
--			Inner Join DRF1 on ODRF.DocEntry = DRF1.DocEntry

--			WHERE 
--			DRF1.BaseType = -1
--			or DRF1.BaseType <> 540000006
--			and ODRF.U_PR_Type2 = 'PFXA'
--			or ODRF.U_SubPR_Type in ('DS', 'CU', 'SV')
--			AND ODRF.ObjType =  '18'
--			and DRF1.AcctCode <> 'OC390000'
--			AND ODRF.DocEntry=@list_of_cols_val_tab_del)

--			begin
--				set @error=01113
--				set @error_message='Base Purchase Quotation is required for this transaction.'

--		end
--		end

		--NO BASE GRPO
if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin

			if exists (select ODRF.docentry from ODRF 
			Inner Join DRF1 on ODRF.DocEntry = DRF1.DocEntry

			WHERE 
			DRF1.BaseType = -1
			and ODRF.DocType = 'I'
			AND ODRF.ObjType =  '18'
			and DRF1.AcctCode <> 'OC390000'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error=01112
				set @error_message='Base Goods Receipt PO is Required for this transaction.' 

		end
		end

--Over Billing

if @object_type = '112' and (@transaction_type in ('A', 'U')) 
begin			
	if exists (Select distinct 
		--'TRUE',
		--		PO.Item,
		--		PO.POTotal,
		AP.ItemCode
		--AP.PercentCom,
		--ISNULL(AP.APTotal,0) AS PO,
		--ISNULL((po.POTotal * ap.PercentCom),0) AS MAXIM
		from 			
		-- ap details
				(select 
					A.U_CTPC AS PercentCom,
					a.itemcode,
					A.DocEntry,
					A.BaseRef [PODocEntry]
					from DRF1 A
					left join ODRF B ON B.DocEntry = A.DocEntry
					WHERE B.CANCELED = 'N' and a.ItemCode like 'RU%'
					AND A.ObjType =  '18'
					GROUP BY A.ItemCode, A.U_CTPC, A.DocEntry , A.BaseRef
				) as AP			
				left join
		--To get details of the Budget based on per ItemCode and Budget Number. Except for unapproved and Canceled Budget--
				(select 
					sum(isnull(a.LineTotal,0)) as POTotal,
					a.itemcode as Item,
					A.DocEntry as PODocEntry	
					from POR1 A
					left join OPOR B ON A.DocEntry = B.DocEntry
					WHERE B.CANCELED = 'N' and a.ItemCode like 'RU%'
					GROUP BY A.ItemCode, A.DocEntry 
				) as PO on AP.ItemCode = PO.Item AND PO.PODocEntry = AP.PODocEntry
				LEFT JOIN DRF1 ON DRF1.DocEntry = AP.DocEntry 
				WHERE ISNULL((SELECT sum(isnull(p.linetotal,0)) FROM DRF1 p WHERE p.BaseRef = ap.PODocEntry AND p.BaseType = 22),0) > ((po.POTotal) * (ap.PercentCom/100))
				AND AP.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error=00413
				set @error_message='Over Billing.'
			end
		end



---AP INVOICE---

--Adding of Dummy Supplier--

		if @object_type = '18' and (@transaction_type in ('A', 'U')) 
		begin

		if exists (select OPCH.docentry from OPCH

		where 
					OPCH.CardName = 'Dummy Supplier'
					AND OPCH.DocEntry=@list_of_cols_val_tab_del)
					begin
						set @error= 00417
						set @error_message='Cannot add Dummy Supplier. Update Supplier Code.'
			end 
			end


---OverBilling

---OverBilling

if @object_type = '18' and (@transaction_type in ('A', 'U')) 
begin			
	if exists (Select distinct 
		--'TRUE',
		--		PO.Item,
		--		PO.POTotal,
		AP.ItemCode
		--AP.PercentCom,
		--ISNULL(AP.APTotal,0) AS PO,
		--ISNULL((po.POTotal * ap.PercentCom),0) AS MAXIM
		from 			
		-- ap details
				(select 
					A.U_CTPC AS PercentCom,
					a.itemcode,
					A.DocEntry,
					C.DocEntry [PODocEntry]
					from PCH1 A
					left join OPCH B ON B.DocEntry = A.DocEntry
					left join POR1 C ON C.DocEntry = A.BaseEntry AND A.BaseType = 22
					WHERE B.CANCELED = 'N' and a.ItemCode like 'RU%'
					GROUP BY A.ItemCode, A.U_CTPC, A.DocEntry , C.DocEntry
				) as AP			
				left join
		--To get details of the Budget based on per ItemCode and Budget Number. Except for unapproved and Canceled Budget--
				(select 
					sum(isnull(a.LineTotal,0)) as POTotal,
					a.itemcode as Item,
					A.DocEntry as PODocEntry	
					from POR1 A
					left join OPOR B ON A.DocEntry = B.DocEntry
					WHERE B.CANCELED = 'N' and a.ItemCode like 'RU%'
					GROUP BY A.ItemCode, A.DocEntry 
				) as PO on AP.ItemCode = PO.Item AND PO.PODocEntry = AP.PODocEntry
				LEFT JOIN PCH1 ON PCH1.DocEntry = AP.DocEntry 
				WHERE ISNULL((SELECT sum(isnull(p.linetotal,0)) FROM PCH1 p WHERE p.BaseRef = ap.PODocEntry AND p.BaseType = 22),0) > ((po.POTotal) * (ap.PercentCom/100))
				AND PCH1.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error=00413
				set @error_message='Over Billing.'
			end
		end

		


-----Lacking Percentage of Completion (ERROR)
----if @object_type = '18' and (@transaction_type in ('A', 'U')) 
----begin

----			if exists (select OPCH.docentry from OPCH 
----			INNER JOIN PCH1 ON OPCH.DocEntry = PCH1.DocEntry
----			LEFT JOIN POR1 ON POR1.DocEntry = PCH1.BaseEntry AND PCH1.BaseType = 22
			

----			WHERE 
----			OPCH.U_PR_Type2 = 'PCSC'
----			AND PCH1.ItemCode = POR1.ItemCode
----			AND PCH1.U_BudgetNo = POR1.U_BudgetNo
----			AND	((SELECT SUM(PCH1.GTotal) from PCH1 
----			Inner Join OPCH ON OPCH.DocEntry = PCH1.DocEntry where OPCH.DocEntry=@list_of_cols_val_tab_del Group by PCH1.ItemCode
----			)) > POR1.GTotal
----			AND PCH1.GTotal >= POR1.GTotal
		

----			AND OPCH.DocEntry=@list_of_cols_val_tab_del)
	

----			begin
----				set @error=00411
----				set @error_message='Input Percentage of Completion in the Rows'

----		end
----		end


---Lacking Percentage of Completion
if @object_type = '18' and (@transaction_type in ('A', 'U')) 
begin

			if exists (select OPCH.docentry from OPCH 
			INNER JOIN PCH1 ON OPCH.DocEntry = PCH1.DocEntry
			

			WHERE 
			OPCH.U_PR_Type2 = 'PCSC'
			and PCH1.U_CTPC IS NULL
			AND OPCH.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error=00411
				set @error_message='Input Current Percentage of Completion for this contracted services in row.'

		end
		end





--Update G/L Code to Subcon Charges-

if @object_type = '18' and (@transaction_type in ('A', 'U')) 
begin

			if exists (select OPCH.docentry from OPCH 
			Inner Join PCH1 on OPCH.DocEntry = PCH1.DocEntry

			WHERE 
			OPCH.U_PR_Type2 = 'PLISS'
			and PCH1.AcctCode <> 'OC390000'
			AND OPCH.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error=00411
				set @error_message='Update G/L Code to Subcon Charges for this transaction'

		end
		end



--Budget No Inconsistent in Purchase Order (WITH GRPO)

if @object_type = '18' and (@transaction_type in ('A', 'U')) 
begin

			if exists (select OPCH.docentry from OPCH 
			Inner Join PCH1 on oPCH.DocEntry = PCH1.DocEntry
			LEFT JOIN PDN1 ON PDN1.DocEntry = pch1.BaseEntry	
			left join POR1 ON POR1.DocEntry = PDN1.BaseEntry

			WHERE 
			POR1.U_BudgetNo <> PCH1.U_BudgetNo
			AND OPCH.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error=00611
				set @error_message= 'Budget No. Inconsistent in Purchase Order.'

		end
		end


--Budget No. Inconsistent in Purchase Order (No GRPO)

if @object_type = '18' and (@transaction_type in ('A', 'U')) 
begin

			if exists (select OPCH.docentry from OPCH 
			Inner Join PCH1 on oPCH.DocEntry = PCH1.DocEntry
			inner join Por1  on Por1.DocEntry = Pch1.BaseEntry 
			inner join OPOR on OPOR.DocEntry= Por1.DocEntry AND PCH1.BaseType=OPOR.ObjType 

			WHERE 
			POR1.U_BudgetNo <>  PCH1.U_BudgetNo
			AND OPCH.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error=00610
				set @error_message= 'Budget No. Inconsistent in Purchase Order.'

		end
		end





--Project Code Inconsistent in Purchase Order (WITH GRPO)

if @object_type = '18' and (@transaction_type in ('A', 'U')) 
begin

			if exists (select OPCH.docentry from OPCH 
			Inner Join PCH1 on oPCH.DocEntry = PCH1.DocEntry
			LEFT JOIN PDN1 ON PDN1.DocEntry = pch1.BaseEntry	
			left join POR1 ON POR1.DocEntry = PDN1.BaseEntry

			WHERE 
			POR1.Project <> PCH1.Project
			AND OPCH.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error=00609
				set @error_message= 'Project Code Inconsistent in Purchase Order.'

		end
		end


--Project Code Inconsistent in Purchase Order (No GRPO)

if @object_type = '18' and (@transaction_type in ('A', 'U')) 
begin

			if exists (select OPCH.docentry from OPCH 
			Inner Join PCH1 on oPCH.DocEntry = PCH1.DocEntry
			inner join Por1  on Por1.DocEntry = Pch1.BaseEntry 
			inner join OPOR on OPOR.DocEntry= Por1.DocEntry AND PCH1.BaseType=OPOR.ObjType 

			WHERE 
			POR1.Project <> PCH1.Project
			AND OPCH.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error=00608
				set @error_message= 'Project Code Inconsistent in Purchase Order.'

		end
		end




--Transaction Type Inconsistent in Purchase Order (WITH GRPO)

if @object_type = '18' and (@transaction_type in ('A', 'U')) 
begin

			if exists (select OPCH.docentry from OPCH 
			Inner Join PCH1 on oPCH.DocEntry = PCH1.DocEntry
			LEFT JOIN PDN1 ON PDN1.DocEntry = pch1.BaseEntry	
			left join POR1 ON POR1.DocEntry = PDN1.BaseEntry
			INNER JOIN OPOR ON POR1.DocEntry = OPOR.DocEntry

			WHERE 
			OPCH.U_PR_Type2 <> OPOR.U_PR_Type2
			AND OPCH.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error=00607
				set @error_message= 'Purchase Transaction Type Inconsistent in Purchase Order.'

		end
		end


--- Transaction Type Inconsistent with the Purchase Order (NO GRPO)

if @object_type = '18' and (@transaction_type in ('A', 'U')) 
begin

			if exists (select OPCH.docentry from OPCH 
			Inner Join PCH1 on oPCH.DocEntry = PCH1.DocEntry
			inner join Por1  on Por1.DocEntry = Pch1.BaseEntry 
			inner join OPOR on OPOR.DocEntry= Por1.DocEntry AND PCH1.BaseType=OPOR.ObjType 

			WHERE 
			OPCH.U_PR_Type2 <> OPOR.U_PR_Type2
			AND OPCH.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error=00606
				set @error_message= 'Purchase Transaction Type Inconsistent in Purchase Order.'

		end
		end




-- NO BASED GRPO
if @object_type = '18' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPCH.docentry from OPCH
Inner join PCH1 on PCH1.DocEntry = OPCH.DocEntry 

where 
			PCH1.BaseType = -1
			--or PCH1.BaseType <> 22
			and OPCH.DocType = 'I'
			AND OPCH.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error=00605
				set @error_message='Base Goods Receipt PO is required for this transaction.'
	end 
	end





-- No tagging of Budget---
	if @object_type = '18' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPCH.docentry from OPCH
Inner join PCH1 on PCH1.DocEntry = OPCH.DocEntry 

where 
			PCH1.Project <> 'EHI000'
		    and PCH1.U_BudgetNo is null
			AND OPCH.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error=00604
				set @error_message='Budget No is lacking for Chargeable to Project related transaction.'
	end 
	end



-- No tagging of Dimension for Project-related
	if @object_type = '18' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPCH.docentry from OPCH
Inner join PCH1 on PCH1.DocEntry = OPCH.DocEntry 

where 
			
			PCH1.Project <> 'EHI000'
		    and PCH1.U_Dimension1 is null
			and PCH1.U_Dimension2 is null
			and PCH1.U_Dimension3 is null
			and PCH1.U_Dimension4 is null
			and PCH1.U_Dimension5 is null
			AND OPCH.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00603
				set @error_message='Dimension (s) is lacking for Chargeable to Project related transaction.'
	end 
	end


-- No tagging of Project---
	if @object_type = '18' and (@transaction_type in ('A', 'U')) 
begin

if exists (select PCH1.docentry from PCH1

where 
			
			ISNULL (PCH1.Project,'')=''
			AND PCH1.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00602
				set @error_message='Project is lacking in the row. Define Project Code.'
	end 
	end

-- No tagging of Purchase Subcategory Transaction Type---
	if @object_type = '18' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPCH.docentry from OPCH 

where 
			
			OPCH.U_PR_Type2 in ( 'PLISG', 'PIMPI' , 'PLISS')
			AND OPCH.U_SubPR_Type is null
			AND OPCH.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00601
				set @error_message='Subcategory Purchase Transaction Type is lacking for this transaction.'
	end 
	end



-- No tagging of Purchase Transaction Type---
	if @object_type = '18' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPCH.docentry from OPCH 

where 
			
			OPCH.U_PR_Type2 is null
			AND OPCH.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00600
				set @error_message='Purchase Transaction Type is lacking.'
	end 
	end

---- NO BASE PURCHASE REQUEST AND PURCHASE QUOTATION
if @object_type = '18' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPCH.docentry from OPCH
Inner join PCH1 on PCH1.DocEntry = OPCH.DocEntry 

where 
			PCH1.BaseType = -1
			AND OPCH.U_PR_Type2 = 'PCSC'
			AND OPCH.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error=00906
				set @error_message='Base Purchase Request and Purchase Quotation are required for this transaction.'
	end 
	end

---- NO BASE PURCHASE REQUEST AND PURCHASE QUOTATION
if @object_type = '18' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPCH.docentry from OPCH
Inner join PCH1 on PCH1.DocEntry = OPCH.DocEntry 

where 
			PCH1.BaseType = -1
			AND OPCH.U_SubPR_Type in ('CM', 'CS', 'EQ')
			AND OPCH.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error=00907
				set @error_message='Base Purchase Request and Purchase Quotation are required for this transaction.'
	end 
	end


-- NO BASE PURCHASE QUOTATION
if @object_type = '18' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OPCH.docentry from OPCH
Inner join PCH1 on PCH1.DocEntry = OPCH.DocEntry 

where 
			PCH1.BaseType = -1
			--AND OPCH.U_PR_Type2 in ('PFXA')
			AND OPCH.U_SubPR_Type in ('DS', 'CU', 'SV')
			AND OPCH.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error=00908
				set @error_message='Base Purchase Quotation is required for this transaction.'
	end 
	end











---AP CM---

---- Reason for Return-----------------------
	if @object_type = '19' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ORPC.docentry from ORPC

where 
			
			ORPC.U_RetRes is null
			AND ORPC.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00407
				set @error_message='Enter Reason for Return.'
	end 
	end

---GOODS ISSUE DRAFT

--Subcon/BP Code---

if @object_type = '112' and (@transaction_type in ('A', 'U')) 

begin

if exists (select ODRF.docentry from ODRF 

where 
			ODRF.U_IssueType in ('DS', 'ICS')
			And ODRF.U_Code is null
			AND ODRF.ObjType =  '60'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00408
				set @error_message='Fill In Subcon/BP Code field.'
	end 
	end

--Fill in Project in rows---

if @object_type = '112' and (@transaction_type in ('A', 'U')) 

begin

if exists (select ODRF.docentry from ODRF 
inner join drf1 on drf1.docentry = odrf.docentry

where 
			ODRF.U_IssueType in ('DS', 'ICS')
			And drf1.project is null
			AND ODRF.ObjType =  '60'
			AND ODRF.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00408
				set @error_message='Fill In Project in Rows.'
	end 
	end

---GOODS ISSUE

--Lacking Issuance Type

if @object_type = '60' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OIGE.docentry from OIGE

where 
			
			OIGE.U_IssueType is NULL
			AND OIGE.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00308
				set @error_message='Lacking Issuance Type.'
	end 
	end

--Subcon/BP Code---

if @object_type = '60' and (@transaction_type in ('A', 'U')) 

begin

if exists (select OIGE.docentry from OIGE 

where 
			OIGE.U_IssueType in ('DS', 'ICS')
			And OIGE.U_Code is null
			AND OIGE.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00408
				set @error_message='Fill In Subcon/BP Code field.'
	end 
	end

--Issuance Exceeds Budgeted Quantity

if @object_type = '60' and (@transaction_type in ('A', 'U')) 

begin

if exists (select OIGE.docentry from OIGE 
Inner join IGE1 on IGE1.DocEntry = OIGE.DocEntry 

where 
			IGE1.U_TQuantity = 'TRUE'
			AND OIGE.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00508
				set @error_message='Issuance Exceeds Budgeted Quantity.'
	end 
	end

---LACKING PROJECT in ROWS

if @object_type = '60' and (@transaction_type in ('A', 'U')) 

begin

if exists (select OIGE.docentry from OIGE 
Inner join IGE1 on IGE1.DocEntry = OIGE.DocEntry 

where 
			ISNULL (IGE1.Project,'')=''
			AND OIGE.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00608
				set @error_message='Fill In Project in Rows.'
	end 
	end

---RETIREMENT---

--Project---

if @object_type = 'Retirement' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ORTI.docentry from ORTI
inner join RTI1 on RTI1.DocEntry = ORTI.DocEntry

where 
			
			ORTI.DocType in ('Scrapping')
			and RTI1.Project is Null
			AND ORTI.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00409
				set @error_message='Fill In Project field.'
	end 
	end


---AR INVOICE---

if @object_type = '13' and (@transaction_type in ('A', 'U')) 

begin
			if exists (select OINV.docentry from OINV
			inner join INV1 on OINV.docentry = inv1.docentry
			inner join DPI1 on dpi1.docentry = inv1.docentry
			inner join RDR1  on DPI1.DocEntry = RDR1.BaseEntry 
			inner join ORDR on ORDR.docentry = rdr1.docentry

			WHERE 
			ORDR.Docstatus = 'C'
			AND OINV.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error=00411
				set @error_message='Invalid AR Down Payment Invoice appiled from Cancelled Sales Order.'

		end
		end

---ISSUE FOR PRODUCTION

---RCM Reference Missing

if @object_type = '60' and (@transaction_type in ('A', 'U')) 

begin
			if exists (select OIGE.docentry from OIGE
			inner join IGE1 on OIGE.docentry = IGE1.docentry
			

			WHERE 
			OIGE.U_RMC is null
			and IGE1.Itemcode like 'RM%'
			AND OIGE.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error=00418
				set @error_message='Ready Mixed Concrete Reference is Missing.'

		end
		end

---CPP Reference Missing

if @object_type = '60' and (@transaction_type in ('A', 'U')) 

begin
			if exists (select OIGE.docentry from OIGE
			inner join IGE1 on OIGE.docentry = IGE1.docentry
			

			WHERE 
			OIGE.U_CPP is null
			and IGE1.Itemcode like 'RM%'
			AND OIGE.DocEntry=@list_of_cols_val_tab_del)

			begin
				set @error=00415
				set @error_message='Concrete Pouring Permit Reference is missing .'

		end
		end



---Outgoing Payment---

--Posting Data, Due date and Check date must be the same for Postdated Checks---

if @object_type = '46' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OVPM.docentry from OVPM

where 
			
			OVPM.DocDate <> OVPM.DocDueDate 
			AND OVPM.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00412
				set @error_message='Posting Data, Due date and Check date must be the same for Postdated Checks.'
	end 
	end

---Incoming Payment---

--Posting Data, Due date and Check date must be the same for Postdated Checks---

if @object_type = '24' and (@transaction_type in ('A', 'U')) 
begin

if exists (select ORCT.docentry from ORCT

where 
			
			ORCT.DocDate <> ORCT.DocDueDate 
			AND ORCT.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00419
				set @error_message='Posting Data, Due date and Check date must be the same for Postdated Checks.'
	end 
	end

--Goods Receipt--

if @object_type = '59' and (@transaction_type in ('A', 'U')) 
begin

if exists (select OIGN.docentry from OIGN
inner join IGN1 on OIGN.docentry = ign1.docentry
inner join oitm on oitm.itemcode = ign1.itemcode


where 
			
			OITM.ItmsGrpCod <> '101'
			and IGN1.WhsCode in ('RVHU WHS', 'SWHU WHS')
			AND OIGN.DocEntry=@list_of_cols_val_tab_del)
			begin
				set @error= 00416
				set @error_message='Item received is not a Saleable Unit.'
	end 
	end



--Project Accounting---

if (@object_type in
('DIMENSION','BOQ','SCBOQ','PROJECT','SUBCONTRACTS','ASSETTRANSFER','APRETENTION',
'ARRETENTION'))
begin
exec PA_SP_TransactionNotification
@object_type,@transaction_type,@num_of_cols_in_key,@list_of_key_cols_tab_del,@list_of_cols_val_tab_del
end


--------------------------------------------------------------------------------------------------------------------------------

-- Select the return values
select @error, @error_message

end