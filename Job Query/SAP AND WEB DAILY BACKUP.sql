USE [master]  
GO  

SET ANSI_NULLS ON  
GO  
SET QUOTED_IDENTIFIER ON  
GO  

SET NOCOUNT ON;

	DECLARE  @name VARCHAR(50),
		@pathSAP VARCHAR(256), -- path for backup files SAP
		@pathWEB VARCHAR(256), -- path for backup files WEB
		@fileName VARCHAR(256), -- filename for backup 
		@fileDate VARCHAR(20) -- used for file name

	SET @pathSAP = 'D:\EHI-BACKUP-PER-DAY\SAP\'
	SET @pathWEB = 'D:\EHI-BACKUP-PER-DAY\WEBRE\'

	SELECT @fileDate = REPLACE(CONVERT(VARCHAR(30),GETDATE(),100), ':',' ')

	DECLARE db_cursor CURSOR FOR 
	SELECT name 
	FROM master.dbo.sysdatabases 
	WHERE name in ('EHI_LIVE_LATEST','WEBRE_LATEST')

	OPEN db_cursor  
	FETCH NEXT FROM db_cursor INTO @name  

	WHILE @@FETCH_STATUS = 0  
	BEGIN  
		IF @name = 'EHI_LIVE_LATEST'
			BEGIN

			SET @fileName = @pathSAP + @name + '_BACKUP(' + @fileDate + ').BAK' 
			BACKUP DATABASE @name TO DISK = @fileName

			END
		ELSE IF @name = 'WEBRE_LATEST'
			BEGIN

			SET @fileName = @pathWEB + @name + '_BACKUP(' + @fileDate + ').BAK' 
			BACKUP DATABASE @name TO DISK = @fileName

			END
		FETCH NEXT FROM db_cursor INTO @name 
	END  

	CLOSE db_cursor  
	DEALLOCATE db_cursor