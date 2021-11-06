
--- Dimension 1
IF ($[$38.U_Dimension1] IS NULL OR $[$38.U_Dimension1] = '')
BEGIN
	SELECT U_Subdimension from [@SUBDIMENSION] where code = $[$39.U_Dimension1]
END
ELSE
BEGIN
	SELECT U_Subdimension from [@SUBDIMENSION] where code = $[$38.U_Dimension1]
END

--- Dimension 2
IF ($[$38.U_Dimension2] IS NULL OR $[$38.U_Dimension2] = '')
BEGIN
	SELECT U_Subdimension from [@SUBDIMENSION] where code = $[$39.U_Dimension2]
END
ELSE
BEGIN
	SELECT U_Subdimension from [@SUBDIMENSION] where code = $[$38.U_Dimension2]
END
--- Dimension 3
IF ($[$38.U_Dimension3] IS NULL OR $[$38.U_Dimension3] = '')
BEGIN
	SELECT U_Subdimension from [@SUBDIMENSION] where code = $[$39.U_Dimension3]
END
ELSE
BEGIN
	SELECT U_Subdimension from [@SUBDIMENSION] where code = $[$38.U_Dimension3]
END
--- Dimension 4
IF ($[$38.U_Dimension4] IS NULL OR $[$38.U_Dimension4] = '')
BEGIN
	SELECT U_Subdimension from [@SUBDIMENSION] where code = $[$39.U_Dimension4]
END
ELSE
BEGIN
	SELECT U_Subdimension from [@SUBDIMENSION] where code = $[$38.U_Dimension4]
END
--- Dimension 5
IF ($[$38.U_Dimension5] IS NULL OR $[$38.U_Dimension5] = '')
BEGIN
	SELECT U_Subdimension from [@SUBDIMENSION] where code = $[$39.U_Dimension5]
END
ELSE
BEGIN
	SELECT U_Subdimension from [@SUBDIMENSION] where code = $[$38.U_Dimension5]
END


SELECT code, U_Subdimension from [@SUBDIMENSION]