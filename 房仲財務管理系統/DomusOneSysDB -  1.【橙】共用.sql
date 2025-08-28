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



use DomusOneSysDB;

/*【16. 計算單位 CalculationUnits】*/
CREATE TABLE CalculationUnits (
    CUID INT IDENTITY(1,1) PRIMARY KEY,     	-- 計算單位編號
    CUName NVARCHAR(30) NOT NULL,           	-- 計算單位
    CUIsActive BIT NOT NULL DEFAULT 1,     	-- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    CONSTRAINT CHK_CalculationUnits_IsActive CHECK (CUIsActive IN (0,1))
);
GO
-- 為表格新增描述
EXEC sp_addextendedproperty N'MS_Description', N'計算單位表', N'Schema', N'dbo', N'Table', N'CalculationUnits';
-- 為欄位新增描述
EXEC sp_addextendedproperty N'MS_Description', N'計算單位編號', N'Schema', N'dbo', N'Table', N'CalculationUnits', N'Column', N'CUID';
EXEC sp_addextendedproperty N'MS_Description', N'計算單位', N'Schema', N'dbo', N'Table', N'CalculationUnits', N'Column', N'CUName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'CalculationUnits', N'Column', N'CUIsActive';
GO



/*【33. 申請狀態 ApplyStatus】*/
CREATE TABLE ApplyStatus (
    APSID INT IDENTITY(1,1) PRIMARY KEY,        	-- 申請狀態編號
    APSName NVARCHAR(20) NOT NULL,		-- 申請狀態
    APSIsActive BIT NOT NULL DEFAULT 1, 		-- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    CONSTRAINT CHK_ApplyStatus_IsActive CHECK (APSIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'申請狀態表', N'Schema', N'dbo', N'Table', N'ApplyStatus';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'申請狀態編號', N'Schema', N'dbo', N'Table', N'ApplyStatus', N'Column', N'APSID';
EXEC sp_addextendedproperty N'MS_Description', N'申請狀態', N'Schema', N'dbo', N'Table', N'ApplyStatus', N'Column', N'APSName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'ApplyStatus', N'Column', N'APSIsActive';
GO



/*【49. 縣市 RegionCity】*/
CREATE TABLE RegionCity (
    RCID INT IDENTITY(1,1) PRIMARY KEY,       	-- 縣市編號
    RCName NVARCHAR(20) NOT NULL,             	-- 縣市名稱
    RCCode CHAR(3) NOT NULL,                  		-- 縣市代碼
    RCIsActive BIT NOT NULL DEFAULT 1,         	-- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    CONSTRAINT CHK_RegionCity_IsActive CHECK (RCIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'縣市', N'Schema', N'dbo', N'Table', N'RegionCity';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'縣市編號', N'Schema', N'dbo', N'Table', N'RegionCity', N'Column', N'RCID';
EXEC sp_addextendedproperty N'MS_Description', N'縣市名稱', N'Schema', N'dbo', N'Table', N'RegionCity', N'Column', N'RCName';
EXEC sp_addextendedproperty N'MS_Description', N'縣市代碼', N'Schema', N'dbo', N'Table', N'RegionCity', N'Column', N'RCCode';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'RegionCity', N'Column', N'RCIsActive';
GO



/*【50. 行政區 RegionCityDistrict】*/
CREATE TABLE RegionCityDistrict (
    RCDID INT IDENTITY(1,1) PRIMARY KEY,     	-- 行政區編號
    RCID INT NOT NULL,                        			-- 縣市編號 (FK)
    RCDName NVARCHAR(20) NOT NULL,        	-- 行政區名稱
    RCDZipCode INT NOT NULL,                  		-- 郵遞區號
    RCDIsActive BIT NOT NULL DEFAULT 1,      	-- 是否啟用 (0:false, 1:true)

    /*FK 設定*/
    CONSTRAINT FK_RegionCityDistrict_RegionCity FOREIGN KEY (RCID) REFERENCES RegionCity(RCID),

    /*CHECK 設定*/
    CONSTRAINT CHK_RegionCityDistrict_IsActive CHECK (RCDIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'行政區', N'Schema', N'dbo', N'Table', N'RegionCityDistrict';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'行政區編號', N'Schema', N'dbo', N'Table', N'RegionCityDistrict', N'Column', N'RCDID';
EXEC sp_addextendedproperty N'MS_Description', N'縣市', N'Schema', N'dbo', N'Table', N'RegionCityDistrict', N'Column', N'RCID';
EXEC sp_addextendedproperty N'MS_Description', N'行政區', N'Schema', N'dbo', N'Table', N'RegionCityDistrict', N'Column', N'RCDName';
EXEC sp_addextendedproperty N'MS_Description', N'郵遞區號', N'Schema', N'dbo', N'Table', N'RegionCityDistrict', N'Column', N'RCDZipCode';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'RegionCityDistrict', N'Column', N'RCDIsActive';
GO



/*【72. 支付類型 Payment】*/
CREATE TABLE Payment (
    PID INT IDENTITY(1,1) PRIMARY KEY,      		-- 支付類型編號
    PName NVARCHAR(20) NOT NULL,             	-- 支付類型
    PIsActive BIT NOT NULL DEFAULT 1,        	-- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    CONSTRAINT CHK_Payment_IsActive CHECK (PIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'支付類型', N'Schema', N'dbo', N'Table', N'Payment';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'支付類型編號', N'Schema', N'dbo', N'Table', N'Payment', N'Column', N'PID';
EXEC sp_addextendedproperty N'MS_Description', N'支付類型', N'Schema', N'dbo', N'Table', N'Payment', N'Column', N'PName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'Payment', N'Column', N'PIsActive';
GO

