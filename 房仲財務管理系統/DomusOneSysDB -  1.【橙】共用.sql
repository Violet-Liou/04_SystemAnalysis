-- 切換到 master 資料庫，避免正在使用目標資料庫
USE master;
GO

--建立資料庫【DomusOneSysDB】

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'DomusOneSysDB')
BEGIN
    ALTER DATABASE DomusOneSysDB
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE DomusOneSysDB;
END
GO

CREATE DATABASE DomusOneSysDB;
GO


--=======< 以上請單獨執行!!! >=======================================================
--==============================================================================================
7. 若是要FK的資料欄位開頭為「DS_」則代表該資料欄位是要關連到另一個資料庫DomusOneSysDB中的資料表，請幫我做出相應的修改



use DomusOneSysDB;

/*【16. 計算單位 CalculationUnits】*/
CREATE TABLE CalculationUnits (
    DS_CUID INT IDENTITY(1,1) PRIMARY KEY,     		-- 計算單位編號
    DS_CUName NVARCHAR(30) NOT NULL,           	-- 計算單位
    DS_CUIsActive BIT NOT NULL DEFAULT 1,      		-- 是否啟用 (0:false, 1:true)
);
GO

/*【33. 申請狀態 ApplyStatus】*/
CREATE TABLE ApplyStatus (
    DS_APSID INT IDENTITY(1,1) PRIMARY KEY,        	-- 申請狀態編號
    DS_APSName NVARCHAR(20) NOT NULL,		-- 申請狀態
    DS_APSIsActive BIT NOT NULL DEFAULT 1 		-- 是否啟用 (0:false, 1:true)
);
GO

/*【49. 縣市 RegionCity】*/
CREATE TABLE RegionCity (
    DS_RCID INT IDENTITY(1,1) PRIMARY KEY,       	-- 縣市編號
    DS_RCName NVARCHAR(20) NOT NULL,             	-- 縣市名稱
    DS_RCCode CHAR(3) NOT NULL,                  		-- 縣市代碼
    DS_RCIsActive BIT NOT NULL DEFAULT 1         	-- 是否啟用 (0:false, 1:true)
);
GO

/*【50. 行政區 RegionCityDistrict】*/
CREATE TABLE RegionCityDistrict (
    DS_RCDID INT IDENTITY(1,1) PRIMARY KEY,     	-- 行政區編號
    DS_RCID INT NOT NULL,                        			-- 縣市編號 (FK)
    DS_RCDName NVARCHAR(20) NOT NULL,           	-- 行政區名稱
    DS_RCDZipCode INT NOT NULL,                  		-- 郵遞區號
    DS_RCDIsActive BIT NOT NULL DEFAULT 1,      	-- 是否啟用 (0:false, 1:true)

    /*FK 設定*/
    CONSTRAINT FK_RegionCityDistrict_RegionCity FOREIGN KEY (DS_RCID) REFERENCES RegionCity(DS_RCID)
);
GO


/*【72. 支付類型 Payment】*/
CREATE TABLE Payment (
    DS_PID INT IDENTITY(1,1) PRIMARY KEY,       		-- 支付類型編號
    DS_PName NVARCHAR(20) NOT NULL,             	-- 支付類型
    DS_PIsActive BIT NOT NULL DEFAULT 1,        		-- 是否啟用 (0:false, 1:true)
);
GO

