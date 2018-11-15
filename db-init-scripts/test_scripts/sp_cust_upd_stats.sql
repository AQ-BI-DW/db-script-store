
IF EXISTS (select 1 from sysobjects where type = 'P' and name = N'sp_cust_upd_stats')
    BEGIN 
        DROP PROCEDURE sp_cust_upd_stats 
    END
    
GO
CREATE PROCEDURE sp_cust_upd_stats
AS

    DECLARE @table_name varchar(255)
    DECLARE @sql_table_name varchar(255)
    DECLARE @sql_exec nvarchar(4000)
	DECLARE @updated_count int
 
BEGIN
    DECLARE cur_upd_stats cursor for
    ----------------------------
    select name from sys.tables
    where type_desc = N'USER_TABLE'
    order by name

    OPEN cur_upd_stats
	FETCH NEXT FROM cur_upd_stats INTO @table_name

	WHILE (@@fetch_status = 0) -- fetch successful
	
	---    select @updated_count = 0

	BEGIN
		    select @sql_exec = 'UPDATE STATISTICS ' + quotename(rtrim(@table_name) )
		                    + ' WITH FULLSCAN'
		
		    --  print @sql_exec
			execute (@sql_exec)

    FETCH NEXT FROM cur_upd_stats INTO @table_name
    
    END

END
CLOSE cur_upd_stats  
DEALLOCATE cur_upd_stats



GO

-- exec sp_cust_upd_stats

 