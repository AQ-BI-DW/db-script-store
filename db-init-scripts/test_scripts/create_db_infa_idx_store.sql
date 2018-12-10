
--- data infa index store db

USE [master]
GO
IF DB_ID('infa_idx_store') IS NULL CREATE DATABASE [infa_idx_store]
GO
ALTER DATABASE infa_idx_store MODIFY FILE
( NAME = N'infa_idx_store' , SIZE = 512MB , MAXSIZE = UNLIMITED, FILEGROWTH = 10% )
GO
ALTER DATABASE infa_idx_store MODIFY FILE
( NAME = N'infa_idx_store_log' , SIZE = 256MB , MAXSIZE = UNLIMITED , FILEGROWTH = 10%)
GO
ALTER DATABASE infa_idx_store SET ALLOW_SNAPSHOT_ISOLATION ON
GO
ALTER DATABASE infa_idx_store SET READ_COMMITTED_SNAPSHOT ON
GO

