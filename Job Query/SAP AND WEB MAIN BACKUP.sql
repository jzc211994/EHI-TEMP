USE [master]  
GO  

SET ANSI_NULLS ON  
GO  
SET QUOTED_IDENTIFIER ON  
GO  

SET NOCOUNT ON;

	DECLARE  @name VARCHAR(50),
		@path VARCHAR(256), -- path for backup files 
		@fileName VARCHAR(256), -- filename for backup 
		@fileDate VARCHAR(20) -- used for file name

	SET @path = 'D:\EHI-BACKUP\'

	SELECT @fileDate = REPLACE(CONVERT(VARCHAR(30),GETDATE(),100), ':',' ')

	DECLARE db_cursor CURSOR FOR 
	SELECT name 
	FROM master.dbo.sysdatabases 
	WHERE name in ('EHI_LIVE_LATEST','WEBRE_LATEST')

	OPEN db_cursor  
	FETCH NEXT FROM db_cursor INTO @name  

	WHILE @@FETCH_STATUS = 0  
	BEGIN  
		   SET @fileName = @path + @name + '_BACKUP.BAK' 
		   BACKUP DATABASE @name TO DISK = @fileName WITH INIT

		   FETCH NEXT FROM db_cursor INTO @name  
	END  

	CLOSE db_cursor  
	DEALLOCATE db_cursor


	



