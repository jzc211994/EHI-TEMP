SELECT DISTINCT
	1 AS Record,
	PO.DocEntry AS PONo,
	PO.DocDate AS PODate,
	PO.CardCode AS VendorCode,
	PO.CardName AS VendorName,
	PO.Comments AS Remarks,
	PO1.ItemCode,
	PO1.Dscription AS ItemName,
	PO1.U_BrandName AS BrandName,
	PO1.UomCode AS Unit,
	(SELECT SUM(Quantity) FROM POR1 WHERE DocEntry = PO.DocEntry AND ItemCode = PO1.ItemCode AND OcrCode = PO1.OcrCode AND OcrCode2 = PO1.OcrCode2) AS Quantity,
	PO1.PriceAfVAT AS Price,
	OCR.OcrName AS PSP,
	(SELECT SUM(GTotal) FROM POR1 WHERE DocEntry = PO.DocEntry AND ItemCode = PO1.ItemCode AND OcrCode = PO1.OcrCode AND OcrCode2 = PO1.OcrCode2) AS SubTotal,
	po.DocTotal AS GrandTotal,
	BP.Currency,
	(select name from dbo.[@SIGNATORY] where code = 'PRCHSR') as Purchaser,
	(select name from dbo.[@SIGNATORY] where code = 'MNGR') as Manager

FROM OPOR PO
INNER JOIN POR1 PO1 ON PO.DocEntry = PO1.DocEntry
LEFT JOIN OOCR OCR ON OCR.OcrCode = PO1.OcrCode2
LEFT JOIN OCRD BP ON BP.CardCode = PO.CardCode
