DECLARE @name VARCHAR(50)
DECLARE @path VARCHAR(256)
DECLARE @fileName VARCHAR(256)
DECLARE @fileDate VARCHAR(20) 

-- Sets the path where backups will be saved
SET @path = 'C:\Backups\'

POV_DS_Labor_20170217152738.BAK
-- Creates a time stamp in the format yyyyMMddHHmmss
SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112) + REPLACE(CONVERT(VARCHAR(20),GETDATE(),108),':','')

DECLARE db_cursor CURSOR FOR  
SELECT name 
FROM master.dbo.sysdatabases 
WHERE name NOT IN ('master','model','msdb','tempdb')  -- exclude these databases

OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @name   

WHILE @@FETCH_STATUS = 0   
BEGIN
   SET @fileName = @path + @name + '_' + @fileDate + '.BAK'  
   BACKUP DATABASE @name TO DISK = @fileName  
 
   FETCH NEXT FROM db_cursor INTO @name   
END   

CLOSE db_cursor   
DEALLOCATE db_cursor