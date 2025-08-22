-- 切換到 master 資料庫，避免正在使用目標資料庫
USE master;
GO

--建立資料庫【DomusOneFinDB】

IF EXISTS (SELECT name FROM sys.databases WHERE name = DomusOneFinDB')
BEGIN
    ALTER DATABASE DomusOneFinDB
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE DomusOneFinDB;
END
GO

CREATE DATABASE DomusOneFinDB;
GO


--=======< 以上請單獨執行!!! >=======================================================
--==============================================================================================


use DomusOneFinDB;


/*【1. 成交原因 DealClosureType】*/
CREATE TABLE DealClosureType (
    DF_DCTID INT IDENTITY(1,1) PRIMARY KEY,         	-- 成交原因編號
    DF_DCTName NVARCHAR(20) NOT NULL,		-- 成交原因
    DF_DCTIsActive BIT NOT NULL DEFAULT 1    		-- 是否啟用 (0:false, 1:true)
);
GO

/*【2. 案件佣收狀態 CaseCommissionStatus】*/
CREATE TABLE CaseCommissionStatus (
    DF_CCSID INT IDENTITY(1,1) PRIMARY KEY,        	-- 案件佣收狀態編號
    DF_CCSName NVARCHAR(20) NOT NULL,         	-- 案件佣收狀態
    DF_CCSIsActive BIT NOT NULL DEFAULT 1  		-- 是否啟用 (0:false, 1:true)
);
GO

/*【3. 成交案件 DealClosures】*/
CREATE TABLE DealClosures (
    DF_DCID INT IDENTITY(1,1) PRIMARY KEY,          			-- 成交案件編號
    DS_PAID INT NOT NULL,                            				-- 物件編號 (FK, 跨資料庫 DomusOneSysDB)
    DF_DCTID INT NOT NULL,                           				-- 成交原因編號 (FK)
    DF_DCDate DATE NOT NULL,                          				-- 成交日期 YYYY/MM/DD
    DF_DCTotalValue DECIMAL(15,2) NOT NULL DEFAULT 0, 	-- 成交總額
    DF_DCEstimatedDate DATE NOT NULL,                			-- 預定交屋日 YYYY/MM/DD
    DF_DCNote NVARCHAR(700) NOT NULL,                		-- 備註
    DF_CCSID INT NOT NULL,                            				-- 案件佣收狀態編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間 YYYY/MM/DD hh:mm:ss
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK, 跨資料庫 DomusOneSysDB)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間 YYYY/MM/DD hh:mm:ss
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK, 跨資料庫 DomusOneSysDB)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,                				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,                          				-- 刪除時間 YYYY/MM/DD hh:mm:ss
    Sys_DeleteBy INT NULL                                					-- 刪除人員 (FK, 跨資料庫 DomusOneSysDB)

    /*FK 設定*/
    CONSTRAINT FK_DealClosures_PropertyAsset FOREIGN KEY (DS_PAID) REFERENCES DomusOneSysDB.dbo.PropertyAsset(DS_PAID),
    CONSTRAINT FK_DealClosures_DealClosureType FOREIGN KEY (DF_DCTID) REFERENCES DealClosureType(DF_DCTID),
    CONSTRAINT FK_DealClosures_CaseCommissionStatus FOREIGN KEY (DF_CCSID) REFERENCES CaseCommissionStatus(DF_CCSID),
    CONSTRAINT FK_DealClosures_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES DomusOneSysDB.dbo.Employee(DS_EEID),
    CONSTRAINT FK_DealClosures_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES DomusOneSysDB.dbo.Employee(DS_EEID),
    CONSTRAINT FK_DealClosures_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES DomusOneSysDB.dbo.Employee(DS_EEID)
);
GO

/*【4. 永慶公益款 YCCharityFund】*/
CREATE TABLE YCCharityFund (
    DF_YCFID INT IDENTITY(1,1) PRIMARY KEY,          				-- 永慶公益款編號
    DF_DCID INT NOT NULL,                             					-- 成交案件編號 (FK)
    DS_COID INT NOT NULL,                             					-- 公司編號 (FK, 跨資料庫 DomusOneSysDB)
    DF_YCFYCReceivedAmt DECIMAL(7,2) NOT NULL DEFAULT 0, 	-- 永慶收取金額(元)
    DF_YCFInternalAmt DECIMAL(7,2) NOT NULL DEFAULT 0,    		-- 體系內部金額(元)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間 YYYY/MM/DD hh:mm:ss
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK, 跨資料庫 DomusOneSysDB)
    Sys_UpdateDT DATETIME NULL,                        	 			-- 修改時間 YYYY/MM/DD hh:mm:ss
    Sys_UpdateBy INT NULL                                					-- 修改人員 (FK, 跨資料庫 DomusOneSysDB)

    /*FK 設定*/
    CONSTRAINT FK_YCCharityFund_DealClosures FOREIGN KEY (DF_DCID) REFERENCES DealClosures(DF_DCID),
    CONSTRAINT FK_YCCharityFund_Company FOREIGN KEY (DS_COID) REFERENCES DomusOneSysDB.dbo.Company(DS_COID),
    CONSTRAINT FK_YCCharityFund_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES DomusOneSysDB.dbo.Employee(DS_EEID),
    CONSTRAINT FK_YCCharityFund_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES DomusOneSysDB.dbo.Employee(DS_EEID)
);
GO
