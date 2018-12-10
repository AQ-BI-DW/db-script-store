
SELECT  name
        , case when snapshot_isolation_state = 1 
            then 'ON' ELSE 'OFF' end snapshot_isolation_option
        , case when is_read_committed_snapshot_on = 1
            then 'ON' else 'OFF' end read_committed_snapshot_option
FROM sys.databases
-- WHERE name = N'informatica_models';

go

ALTER DATABASE informatica_domain SET ALLOW_SNAPSHOT_ISOLATION ON
GO
ALTER DATABASE informatica_domain SET READ_COMMITTED_SNAPSHOT ON
GO