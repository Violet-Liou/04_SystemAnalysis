-- 切換到 master 資料庫，避免正在使用目標資料庫
USE master;
GO

--建立資料庫【DomusOneFinDB】

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'DomusOneFinDB')
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
--跨資料庫無法進行關聯，因此所有「(FK, 跨資料庫 DomusOneSysDB)」皆是軟性關聯，要經由程式控制邏輯去控制


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
    CONSTRAINT FK_DealClosures_DealClosureType FOREIGN KEY (DF_DCTID) REFERENCES DealClosureType(DF_DCTID),
    CONSTRAINT FK_DealClosures_CaseCommissionStatus FOREIGN KEY (DF_CCSID) REFERENCES CaseCommissionStatus(DF_CCSID)
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
    CONSTRAINT FK_YCCharityFund_DealClosures FOREIGN KEY (DF_DCID) REFERENCES DealClosures(DF_DCID)
);
GO


/*【5. 佣收類別 CommissionRevenueType】*/
CREATE TABLE CommissionRevenueType (
    DF_CRTID INT IDENTITY(1,1) PRIMARY KEY,     	-- 佣收類別編號
    DF_CRTName NVARCHAR(20) NOT NULL,           	-- 佣收類別
    DF_CRTIsActive BIT NOT NULL DEFAULT 1       	-- 是否啟用 (0:false, 1:true)
);
GO


/*【6. 案件佣收單 CaseCommissionMain】*/
CREATE TABLE CaseCommissionMain (
    DF_CCMID INT IDENTITY(1,1) PRIMARY KEY,     		-- 案件佣收單編號
    DS_PAID INT NOT NULL,                       				-- 物件編號 (FK, 跨資料庫 DomusOneSysDB)
    DF_DCID INT NOT NULL,                       				-- 成交案件編號 (FK)
    DF_CRTID INT NOT NULL,                      				-- 佣收類別編號 (FK)
    DF_CCMDate DATE NOT NULL,                   			-- 佣收單成立日 YYYY/MM/DD
    DF_CCMBrokerFee DECIMAL(15,2) NULL DEFAULT 0, 	-- 中人費(元)
    DF_CCMGuarantee NVARCHAR(100) NULL,         		-- 履保證號
    DF_CCMNote NVARCHAR(500) NULL,              		-- 備註
    DF_CCSID INT NOT NULL,                      				-- 案件佣收狀態編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間 YYYY/MM/DD hh:mm:ss
    Sys_CreatedBy INT NOT NULL,                						-- 新增人員 (FK, 跨資料庫 DomusOneSysDB)
    Sys_UpdateDT DATETIME NULL,                					-- 修改時間 YYYY/MM/DD hh:mm:ss
    Sys_UpdateBy INT NULL,                     						-- 修改人員 (FK, 跨資料庫 DomusOneSysDB)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,       					-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,                					-- 刪除時間 YYYY/MM/DD hh:mm:ss
    Sys_DeleteBy INT NULL,                     						-- 刪除人員 (FK, 跨資料庫 DomusOneSysDB)
    Sys_SubmitDT DATETIME NULL,                					-- 提交時間 YYYY/MM/DD hh:mm:ss
    Sys_SubmitBy INT NULL,                     						-- 提交人員 (FK, 跨資料庫 DomusOneSysDB)
    Sys_ApprovalDT DATETIME NULL,              					-- 審核時間 YYYY/MM/DD hh:mm:ss
    Sys_ApprovedBy INT NULL,                   						-- 審核人員 (FK, 跨資料庫 DomusOneSysDB)

    /*FK 設定*/
    CONSTRAINT FK_CaseCommissionMain_DealClosures FOREIGN KEY (DF_DCID) REFERENCES DealClosures(DF_DCID),
    CONSTRAINT FK_CaseCommissionMain_CommissionRevenueType FOREIGN KEY (DF_CRTID) REFERENCES CommissionRevenueType(DF_CRTID),
    CONSTRAINT FK_CaseCommissionMain_CaseCommissionStatus FOREIGN KEY (DF_CCSID) REFERENCES CaseCommissionStatus(DF_CCSID)
);
GO


/*【7. 佣收明細 CaseCommissionDetail】*/
CREATE TABLE CaseCommissionDetail (
    DF_CCDID INT IDENTITY(1,1) PRIMARY KEY,     				-- 佣收明細編號
    DF_CCMID INT NOT NULL,                      						-- 案件佣收單編號 (FK)
    DF_CCDType CHAR(1) NOT NULL,                					-- 收支身分 D:開發; M:行銷;
    DF_CCDTotal DECIMAL(15,2) NOT NULL DEFAULT 0,   			-- 總實收(元)
    DF_CCDGuarAmount DECIMAL(15,2) NOT NULL DEFAULT 0, 	-- 履保金額(元)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間 YYYY/MM/DD hh:mm:ss
    Sys_CreatedBy INT NOT NULL,                						-- 新增人員 (FK, 跨資料庫 DomusOneSysDB)
    Sys_UpdateDT DATETIME NULL,               					-- 修改時間 YYYY/MM/DD hh:mm:ss
    Sys_UpdateBy INT NULL,                     						-- 修改人員 (FK, 跨資料庫 DomusOneSysDB)

    /*FK 設定*/
    CONSTRAINT FK_CaseCommissionDetail_CaseCommissionMain FOREIGN KEY (DF_CCMID) REFERENCES CaseCommissionMain(DF_CCMID)
);
GO


/*【8. 佣收項目類別 CommissionItemType】*/
CREATE TABLE CommissionItemType (
    DF_CITID INT IDENTITY(1,1) PRIMARY KEY,     	-- 佣收項目類別編號
    DF_CITName NVARCHAR(20) NOT NULL,           	-- 佣收項目類別
    DF_CITIsActive BIT NOT NULL DEFAULT 1       	-- 是否啟用 (0:false, 1:true)
);
GO


/*【9. 佣收項目 CommissionItem】*/
CREATE TABLE CommissionItem (
    DF_CIID INT IDENTITY(1,1) PRIMARY KEY,      			-- 佣收項目編號
    DF_CCDID INT NOT NULL,                      				-- 佣收明細編號 (FK)
    DF_CITID INT NOT NULL,                      				-- 佣收項目類別編號 (FK)
    DF_CIName NVARCHAR(30) NOT NULL,            		-- 項目描述
    DF_CIAmount DECIMAL(15,2) NOT NULL DEFAULT 0, 	-- 金額(元)
    DF_CINote NVARCHAR(100) NULL,               			-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間 YYYY/MM/DD hh:mm:ss
    Sys_CreatedBy INT NOT NULL,                						-- 新增人員 (FK, 跨資料庫 DomusOneSysDB)
    Sys_UpdateDT DATETIME NULL,                					-- 修改時間 YYYY/MM/DD hh:mm:ss
    Sys_UpdateBy INT NULL,                     						-- 修改人員 (FK, 跨資料庫 DomusOneSysDB)

    /*FK 設定*/
    CONSTRAINT FK_CommissionItem_CaseCommissionDetail FOREIGN KEY (DF_CCDID) REFERENCES CaseCommissionDetail(DF_CCDID),
    CONSTRAINT FK_CommissionItem_CommissionItemType FOREIGN KEY (DF_CITID) REFERENCES CommissionItemType(DF_CITID)
);
GO

/*【10. 成交客戶明細 CaseCommissionCustomer】*/
CREATE TABLE CaseCommissionCustomer (
    DF_CCCID INT IDENTITY(1,1) PRIMARY KEY,             	-- 成交客戶明細編號
    DF_CCMID INT NOT NULL,                               			-- 案件佣收單編號 (FK)
    DS_CPMID INT NOT NULL,                               			-- 客戶資料編號 (FK, 跨資料庫 DomusOneSysDB)
    DS_CCCNote NVARCHAR(100) NULL,                       	-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),   	-- 新增時間 YYYY/MM/DD hh:mm:ss
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK, 跨資料庫 DomusOneSysDB)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間 YYYY/MM/DD hh:mm:ss
    Sys_UpdateBy INT NULL                                 					-- 修改人員 (FK, 跨資料庫 DomusOneSysDB)

    /*FK 設定*/
    CONSTRAINT FK_CaseCommissionCustomer_CaseCommissionMain FOREIGN KEY (DF_CCMID) REFERENCES CaseCommissionMain(DF_CCMID)
);
GO

/*【11. 業績分配表 CommissionAllocation】*/
CREATE TABLE CommissionAllocation (
    DF_CAID INT IDENTITY(1,1) PRIMARY KEY,             			-- 業績分配編號
    DF_CCMID INT NOT NULL,                               				-- 案件佣收單編號 (FK)
    DS_EEID INT NOT NULL,                                				-- 員工編號 (FK)
    DS_JAID INT NOT NULL,                                				-- 任職記錄編號 (FK, 跨資料庫 DomusOneSysDB)
    DF_CAType CHAR(1) NOT NULL,                          			-- 收支身分 D:開發; M:行銷;
    DF_CAPercentage DECIMAL(5,2) NOT NULL DEFAULT 0,     	-- 業績分配比例(%)
    DF_CAAmount DECIMAL(15,2) NOT NULL DEFAULT 0,        	-- 業績(元)
    DF_CACharity DECIMAL(7,2) NOT NULL DEFAULT 0,        	-- 公益款(元)
    DF_CDINote NVARCHAR(100) NULL,                       		-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),    	-- 新增時間 YYYY/MM/DD hh:mm:ss
    Sys_CreatedBy INT NOT NULL,                           				-- 新增人員 (FK, 跨資料庫 DomusOneSysDB)
    Sys_UpdateDT DATETIME NULL,                           				-- 修改時間 YYYY/MM/DD hh:mm:ss
    Sys_UpdateBy INT NULL                                  					-- 修改人員 (FK, 跨資料庫 DomusOneSysDB)

    /*FK 設定*/
    CONSTRAINT FK_CommissionAllocation_CaseCommissionMain FOREIGN KEY (DF_CCMID) REFERENCES CaseCommissionMain(DF_CCMID)
);
GO

