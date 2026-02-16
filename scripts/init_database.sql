/*
============================================================
Creating the Database 'DataWarehouse' and the Schemas (bronze, silver, gold)  
============================================================
Script Purpose:
  This script creates a new database called 'DataWareHouse' after checking if it already exists.
  If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas
  within the database: 'bronze', 'silver', and 'gold'.

!!!  WARNING  !!!
  Running this script will drop the entire 'DataWareHouse' database if it exists.  All data in 
  the database will be permanently deleted, Proceed with caution and ensure you have proper 
  backups before running this script.
*/

-- Create Database and Schemas

USE master;
GO

  
-- Drop and recreate the 'DataWareHouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWareHouse')
BEGIN
	  ALTER DATABASE DataWareHouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  	DROP DATABASE DataWareHouse;
END;
GO

  
-- Create Database 'DataWarehouse'
CREATE DATABASE DataWareHouse;
GO

USE DataWareHouse;
GO


-- Creating the bronze, silver and gold schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO

