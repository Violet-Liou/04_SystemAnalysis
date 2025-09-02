use DomusOneSysDB;

/*【40. 契據類別 ContractType】*/
CREATE TABLE ContractType (
    CTID CHAR(2) PRIMARY KEY,           			-- 契據類別編號 (EX：AA、AG、BA、BG)
    CTName NVARCHAR(30) NOT NULL,       	-- 契據類別名稱
    CTIsActive BIT NOT NULL DEFAULT 1,   		-- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    CONSTRAINT CHK_ContractType_IsActive CHECK (CTIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'契據類別', N'Schema', N'dbo', N'Table', N'ContractType';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'契據類別編號 ', N'Schema', N'dbo', N'Table', N'ContractType', N'Column', N'CTID';
EXEC sp_addextendedproperty N'MS_Description', N'契據類別', N'Schema', N'dbo', N'Table', N'ContractType', N'Column', N'CTName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'ContractType', N'Column', N'CTIsActive';
GO




/*【41. 契據訂購主檔 ContractOrderMain】*/
CREATE TABLE ContractOrderMain (
    COMID INT IDENTITY(1,1) PRIMARY KEY,   	-- 契據訂購主檔編號
    COID INT NOT NULL,                       			-- 公司編號 (FK)
    EEID INT NOT NULL,                       			-- 員工編號 (FK)
    COMOrderDT DATE NOT NULL,                	-- 訂購日期 (YYYY/MM/DD)
    COMNote NVARCHAR(100) NULL,             	-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_ContractOrderMain_Company FOREIGN KEY (COID) REFERENCES Company(COID),
    CONSTRAINT FK_ContractOrderMain_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_ContractOrderMain_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_ContractOrderMain_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'契據訂購主檔', N'Schema', N'dbo', N'Table', N'ContractOrderMain';
-- 欄位描述 (單行)
EXEC sp_addextendedproperty N'MS_Description', N'契據訂購主檔編號', N'Schema', N'dbo', N'Table', N'ContractOrderMain', N'Column', N'COMID';
EXEC sp_addextendedproperty N'MS_Description', N'公司', N'Schema', N'dbo', N'Table', N'ContractOrderMain', N'Column', N'COID';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'ContractOrderMain', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'訂購日期', N'Schema', N'dbo', N'Table', N'ContractOrderMain', N'Column', N'COMOrderDT';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'ContractOrderMain', N'Column', N'COMNote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'ContractOrderMain', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'ContractOrderMain', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'ContractOrderMain', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'ContractOrderMain', N'Column', N'Sys_UpdateBy';
GO



/*【42. 契據訂購明細 ContractOrderDetail】*/
CREATE TABLE ContractOrderDetail (
    CODID INT IDENTITY(1,1) PRIMARY KEY,   	-- 契據訂購明細編號
    COMID INT NOT NULL,                     		-- 契據訂購主檔編號 (FK)
    CTID CHAR(2) NOT NULL,                  		-- 契據類別編號 (FK)
    CODAmount INT NOT NULL,                 		-- 訂購數量
    CODUnitPrice INT NOT NULL,              		-- 訂購單價
    CODDiscount INT NOT NULL DEFAULT 0,     	-- 折扣

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_ContractOrderDetail_ContractOrderMain FOREIGN KEY (COMID) REFERENCES ContractOrderMain(COMID),
    CONSTRAINT FK_ContractOrderDetail_ContractType FOREIGN KEY (CTID) REFERENCES ContractType(CTID),
    CONSTRAINT FK_ContractOrderDetail_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_ContractOrderDetail_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),

    /*CHECK 設定*/
    CONSTRAINT CHK_ContractOrderDetail_CODAmount CHECK (CODAmount >= 0),
    CONSTRAINT CHK_ContractOrderDetail_CODUnitPrice CHECK (CODUnitPrice >= 0)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'契據訂購明細', N'Schema', N'dbo', N'Table', N'ContractOrderDetail';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'契據訂購明細編號', N'Schema', N'dbo', N'Table', N'ContractOrderDetail', N'Column', N'CODID';
EXEC sp_addextendedproperty N'MS_Description', N'契據訂購主檔編號', N'Schema', N'dbo', N'Table', N'ContractOrderDetail', N'Column', N'COMID';
EXEC sp_addextendedproperty N'MS_Description', N'契據類別', N'Schema', N'dbo', N'Table', N'ContractOrderDetail', N'Column', N'CTID';
EXEC sp_addextendedproperty N'MS_Description', N'訂購數量', N'Schema', N'dbo', N'Table', N'ContractOrderDetail', N'Column', N'CODAmount';
EXEC sp_addextendedproperty N'MS_Description', N'訂購單價', N'Schema', N'dbo', N'Table', N'ContractOrderDetail', N'Column', N'CODUnitPrice';
EXEC sp_addextendedproperty N'MS_Description', N'折扣', N'Schema', N'dbo', N'Table', N'ContractOrderDetail', N'Column', N'CODDiscount';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'ContractOrderDetail', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'ContractOrderDetail', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'ContractOrderDetail', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'ContractOrderDetail', N'Column', N'Sys_UpdateBy';
GO





/*【43. 契據入庫明細 ContractReceivingDetail】*/
CREATE TABLE ContractReceivingDetail (
    CRDID INT IDENTITY(1,1) PRIMARY KEY,   	-- 契據入庫明細編號
    CODID INT NOT NULL,                     			-- 契據訂購明細編號 (FK)
    CRDReceiving DATE NOT NULL,             		-- 入庫日期 (YYYY/MM/DD)
    CRDAmount INT NOT NULL,                 		-- 入庫數量
    CRDNote NVARCHAR(100) NULL,        		-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_ContractReceivingDetail_ContractOrderDetail FOREIGN KEY (CODID) REFERENCES ContractOrderDetail(CODID),
    CONSTRAINT FK_ContractReceivingDetail_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_ContractReceivingDetail_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),

    /*CHECK 設定*/
    CONSTRAINT CHK_ContractReceivingDetail_CRDAmount CHECK (CRDAmount >= 0)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'契據入庫明細', N'Schema', N'dbo', N'Table', N'ContractReceivingDetail';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'契據入庫明細編號', N'Schema', N'dbo', N'Table', N'ContractReceivingDetail', N'Column', N'CRDID';
EXEC sp_addextendedproperty N'MS_Description', N'契據訂購明細編號', N'Schema', N'dbo', N'Table', N'ContractReceivingDetail', N'Column', N'CODID';
EXEC sp_addextendedproperty N'MS_Description', N'入庫日期', N'Schema', N'dbo', N'Table', N'ContractReceivingDetail', N'Column', N'CRDReceiving';
EXEC sp_addextendedproperty N'MS_Description', N'入庫數量', N'Schema', N'dbo', N'Table', N'ContractReceivingDetail', N'Column', N'CRDAmount';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'ContractReceivingDetail', N'Column', N'CRDNote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'ContractReceivingDetail', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'ContractReceivingDetail', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'ContractReceivingDetail', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'ContractReceivingDetail', N'Column', N'Sys_UpdateBy';
GO




/*【44. 契據使用狀況 ContractUsageStatus】*/
CREATE TABLE ContractUsageStatus (
    CUSID INT IDENTITY(1,1) PRIMARY KEY,     	-- 契據使用狀況編號
    CUSName NVARCHAR(20) NOT NULL,           	-- 契據使用狀況
    CUSIsActive BIT NOT NULL DEFAULT 1,       	-- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    CONSTRAINT CHK_ContractUsageStatus_IsActive CHECK (CUSIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'契據使用狀況', N'Schema', N'dbo', N'Table', N'ContractUsageStatus';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'契據使用狀況編號', N'Schema', N'dbo', N'Table', N'ContractUsageStatus', N'Column', N'CUSID';
EXEC sp_addextendedproperty N'MS_Description', N'契據使用狀況', N'Schema', N'dbo', N'Table', N'ContractUsageStatus', N'Column', N'CUSName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'ContractUsageStatus', N'Column', N'CUSIsActive';
GO



/*【45. 契據主檔 ContractMain】*/
CREATE TABLE ContractMain (
    CMID VARCHAR(15) PRIMARY KEY,           	-- 契據編號
    COID INT NOT NULL,                       			-- 公司編號 (FK)
    EEID INT NULL,                           			-- 員工編號 (FK)
    CMDate DATE NOT NULL,                     		-- 領取日期
    CUSID INT NOT NULL,                       		-- 契據使用狀況編號 (FK)
    CMNote NVARCHAR(100) NULL,               	-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                                  					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_ContractMain_Company FOREIGN KEY (COID) REFERENCES Company(COID),
    CONSTRAINT FK_ContractMain_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_ContractMain_UsageStatus FOREIGN KEY (CUSID) REFERENCES ContractUsageStatus(CUSID),
    CONSTRAINT FK_ContractMain_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_ContractMain_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'契據主檔', N'Schema', N'dbo', N'Table', N'ContractMain';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'契據編號', N'Schema', N'dbo', N'Table', N'ContractMain', N'Column', N'CMID';
EXEC sp_addextendedproperty N'MS_Description', N'公司', N'Schema', N'dbo', N'Table', N'ContractMain', N'Column', N'COID';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'ContractMain', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'領取日期', N'Schema', N'dbo', N'Table', N'ContractMain', N'Column', N'CMDate';
EXEC sp_addextendedproperty N'MS_Description', N'契據使用狀況', N'Schema', N'dbo', N'Table', N'ContractMain', N'Column', N'CUSID';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'ContractMain', N'Column', N'CMNote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'ContractMain', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'ContractMain', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'ContractMain', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'ContractMain', N'Column', N'Sys_UpdateBy';
GO



/*【45-1. 契據變更記錄檔 ContractRevisionLog】*/
CREATE TABLE ContractRevisionLog (
    CRLID VARCHAR(15) PRIMARY KEY,	-- 契據變更記錄檔編號
    CMID VARCHAR(15) NOT NULL,		-- 契據編號 (FK)
    COID INT NOT NULL,				-- 公司編號 (FK)
    EEID INT NULL,						-- 員工編號 (FK)
    CUSID INT NOT NULL,				-- 契據使用狀況編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                             				-- 新增人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_ContractRevisionLog_ContractMain FOREIGN KEY (CMID) REFERENCES ContractMain(CMID),
    CONSTRAINT FK_ContractRevisionLog_Company FOREIGN KEY (COID) REFERENCES Company(COID),
    CONSTRAINT FK_ContractRevisionLog_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_ContractRevisionLog_UsageStatus FOREIGN KEY (CUSID) REFERENCES ContractUsageStatus(CUSID),
    CONSTRAINT FK_ContractRevisionLog_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'契據變更記錄檔', N'Schema', N'dbo', N'Table', N'ContractRevisionLog';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'契據變更記錄檔編號', N'Schema', N'dbo', N'Table', N'ContractRevisionLog', N'Column', N'CRLID';
EXEC sp_addextendedproperty N'MS_Description', N'契據編號', N'Schema', N'dbo', N'Table', N'ContractRevisionLog', N'Column', N'CMID';
EXEC sp_addextendedproperty N'MS_Description', N'公司', N'Schema', N'dbo', N'Table', N'ContractRevisionLog', N'Column', N'COID';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'ContractRevisionLog', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'契據使用狀況', N'Schema', N'dbo', N'Table', N'ContractRevisionLog', N'Column', N'CUSID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'ContractRevisionLog', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'ContractRevisionLog', N'Column', N'Sys_CreatedBy';
GO



/*【46. 契據申請主檔 ContractApplication】*/
CREATE TABLE ContractApplication (
    CAID INT IDENTITY(1,1) PRIMARY KEY,      	-- 契據申請編號
    EEID INT NOT NULL,                        			-- 員工編號 (FK)
    CADate DATE NOT NULL,                     		-- 申請日期
    APSID INT NOT NULL,                       		-- 申請狀態編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)
    Sys_ApprovalDT DATETIME2 NULL,                        				-- 審核時間
    Sys_ApprovedBy INT NULL                               				-- 審核人員 (FK)

    /*FK 設定*/
    ,CONSTRAINT FK_ContractApplication_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_ContractApplication_ApplyStatus FOREIGN KEY (APSID) REFERENCES ApplyStatus(APSID)
    ,CONSTRAINT FK_ContractApplication_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_ContractApplication_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_ContractApplication_ApprovedBy FOREIGN KEY (Sys_ApprovedBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'契據申請主檔', N'Schema', N'dbo', N'Table', N'ContractApplication';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'契據申請編號', N'Schema', N'dbo', N'Table', N'ContractApplication', N'Column', N'CAID';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'ContractApplication', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'申請日期', N'Schema', N'dbo', N'Table', N'ContractApplication', N'Column', N'CADate';
EXEC sp_addextendedproperty N'MS_Description', N'申請狀態', N'Schema', N'dbo', N'Table', N'ContractApplication', N'Column', N'APSID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'ContractApplication', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'ContractApplication', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'ContractApplication', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'ContractApplication', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'審核時間', N'Schema', N'dbo', N'Table', N'ContractApplication', N'Column', N'Sys_ApprovalDT';
EXEC sp_addextendedproperty N'MS_Description', N'審核人員', N'Schema', N'dbo', N'Table', N'ContractApplication', N'Column', N'Sys_ApprovedBy';
GO



/*【47. 契據申請明細 ContractApplicationDetail】*/
CREATE TABLE ContractApplicationDetail (
    CADID INT IDENTITY(1,1) PRIMARY KEY,    	-- 契據申請明細編號
    CAID INT NOT NULL,                        			-- 契據申請編號 (FK)
    CTID CHAR(2) NOT NULL,                    		-- 契據類別編號 (FK)
    CADAmount INT NOT NULL,                   		-- 申請數量

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL                               					-- 修改人員 (FK)

    /*FK 設定*/
    ,CONSTRAINT FK_ContractApplicationDetail_Application FOREIGN KEY (CAID) REFERENCES ContractApplication(CAID)
    ,CONSTRAINT FK_ContractApplicationDetail_ContractType FOREIGN KEY (CTID) REFERENCES ContractType(CTID)
    ,CONSTRAINT FK_ContractApplicationDetail_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_ContractApplicationDetail_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)

    /*CHECK 設定*/
    ,CONSTRAINT CHK_ContractApplicationDetail_CADAmount CHECK (CADAmount >= 0)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'契據申請明細', N'Schema', N'dbo', N'Table', N'ContractApplicationDetail';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'契據申請明細編號', N'Schema', N'dbo', N'Table', N'ContractApplicationDetail', N'Column', N'CADID';
EXEC sp_addextendedproperty N'MS_Description', N'契據申請編號', N'Schema', N'dbo', N'Table', N'ContractApplicationDetail', N'Column', N'CAID';
EXEC sp_addextendedproperty N'MS_Description', N'契據類別', N'Schema', N'dbo', N'Table', N'ContractApplicationDetail', N'Column', N'CTID';
EXEC sp_addextendedproperty N'MS_Description', N'申請數量', N'Schema', N'dbo', N'Table', N'ContractApplicationDetail', N'Column', N'CADAmount';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'ContractApplicationDetail', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'ContractApplicationDetail', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'ContractApplicationDetail', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'ContractApplicationDetail', N'Column', N'Sys_UpdateBy';
GO


/*【48. 契據轉讓 ContractOwnershipChange】*/
CREATE TABLE ContractOwnershipChange (
    COCID INT IDENTITY(1,1) PRIMARY KEY,       		-- 契據轉讓編號
    CMID VARCHAR(15) NOT NULL,                  		-- 契據編號 (FK)
    COCTransfer INT NOT NULL,                   			-- 轉讓員工編號 (FK)
    COCTransferDate DATETIME2 NOT NULL,          	-- 轉讓日期
    COCTransferSign NVARCHAR(500) NOT NULL,     	-- 轉讓簽章
    COCReceiver INT NOT NULL,                   		-- 接收員工編號 (FK)
    COCReceiverDate DATETIME2 NULL,              		-- 接收日期
    COCReceiverSign NVARCHAR(500) NULL,        	-- 接收簽章
    COCNote NVARCHAR(100) NULL,                		-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL                                					-- 修改人員 (FK)

    /*FK 設定*/
    ,CONSTRAINT FK_ContractOwnershipChange_ContractMain FOREIGN KEY (CMID) REFERENCES ContractMain(CMID)
    ,CONSTRAINT FK_ContractOwnershipChange_TransferEmployee FOREIGN KEY (COCTransfer) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_ContractOwnershipChange_ReceiverEmployee FOREIGN KEY (COCReceiver) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_ContractOwnershipChange_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_ContractOwnershipChange_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'契據轉讓', N'Schema', N'dbo', N'Table', N'ContractOwnershipChange';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'契據轉讓編號', N'Schema', N'dbo', N'Table', N'ContractOwnershipChange', N'Column', N'COCID';
EXEC sp_addextendedproperty N'MS_Description', N'契據編號', N'Schema', N'dbo', N'Table', N'ContractOwnershipChange', N'Column', N'CMID';
EXEC sp_addextendedproperty N'MS_Description', N'轉讓人員', N'Schema', N'dbo', N'Table', N'ContractOwnershipChange', N'Column', N'COCTransfer';
EXEC sp_addextendedproperty N'MS_Description', N'轉讓日期', N'Schema', N'dbo', N'Table', N'ContractOwnershipChange', N'Column', N'COCTransferDate';
EXEC sp_addextendedproperty N'MS_Description', N'轉讓簽章', N'Schema', N'dbo', N'Table', N'ContractOwnershipChange', N'Column', N'COCTransferSign';
EXEC sp_addextendedproperty N'MS_Description', N'接收人員', N'Schema', N'dbo', N'Table', N'ContractOwnershipChange', N'Column', N'COCReceiver';
EXEC sp_addextendedproperty N'MS_Description', N'接收日期', N'Schema', N'dbo', N'Table', N'ContractOwnershipChange', N'Column', N'COCReceiverDate';
EXEC sp_addextendedproperty N'MS_Description', N'接收簽章', N'Schema', N'dbo', N'Table', N'ContractOwnershipChange', N'Column', N'COCReceiverSign';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'ContractOwnershipChange', N'Column', N'COCNote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'ContractOwnershipChange', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'ContractOwnershipChange', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'ContractOwnershipChange', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'ContractOwnershipChange', N'Column', N'Sys_UpdateBy';
GO


/*【51. 建物型態 PropertyType】*/
CREATE TABLE PropertyType (
    PTID INT IDENTITY(1,1) PRIMARY KEY,        	-- 建物型態編號
    PTName NVARCHAR(30) NOT NULL,     		-- 建物型態
    PTIsActive BIT NOT NULL DEFAULT 1,          	-- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    CONSTRAINT CHK_PropertyType_IsActive CHECK (PTIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'建物型態', N'Schema', N'dbo', N'Table', N'PropertyType';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'建物型態編號', N'Schema', N'dbo', N'Table', N'PropertyType', N'Column', N'PTID';
EXEC sp_addextendedproperty N'MS_Description', N'建物型態', N'Schema', N'dbo', N'Table', N'PropertyType', N'Column', N'PTName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'PropertyType', N'Column', N'PTIsActive';
GO



/*【52. 社區 CommunityInfo】*/
CREATE TABLE CommunityInfo (
    CIID INT IDENTITY(1,1) PRIMARY KEY,        	-- 社區編號
    CIName NVARCHAR(100) NOT NULL,            	-- 社區名稱
    RCDID INT NOT NULL,                        		-- 行政區編號 (FK)
    CIStreet NVARCHAR(50) NOT NULL,           	-- 街道名稱
    CINumber NVARCHAR(50) NOT NULL, 		-- 門牌範圍
    PTID INT NOT NULL,                         			-- 建物型態編號 (FK)
    CIBuilding INT NULL,                       			-- 社區內棟數
    CIHouseholds INT NULL,                     		-- 總戶數
    CIIsGated BIT NOT NULL DEFAULT 0,         	-- 是否為封閉型社區 (0:false, 1:true)
    CIIsActive BIT NOT NULL DEFAULT 1,        	-- 是否啟用 (0:false, 1:true)
    CILatitude DECIMAL(10,6) NOT NULL,        	-- 緯度
    CILongitude DECIMAL(10,6) NOT NULL,       	-- 經度

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_CommunityInfo_RegionCityDistrict FOREIGN KEY (RCDID) REFERENCES RegionCityDistrict(RCDID),
    CONSTRAINT FK_CommunityInfo_PropertyType FOREIGN KEY (PTID) REFERENCES PropertyType(PTID),
    CONSTRAINT FK_CommunityInfo_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_CommunityInfo_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),

    /*CHECK 設定*/
    CONSTRAINT CHK_CommunityInfo_CIBuilding CHECK (CIBuilding >= 0),
    CONSTRAINT CHK_CommunityInfo_CIHouseholds CHECK (CIHouseholds >= 0)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'社區', N'Schema', N'dbo', N'Table', N'CommunityInfo';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'社區編號', N'Schema', N'dbo', N'Table', N'CommunityInfo', N'Column', N'CIID';
EXEC sp_addextendedproperty N'MS_Description', N'社區名稱', N'Schema', N'dbo', N'Table', N'CommunityInfo', N'Column', N'CIName';
EXEC sp_addextendedproperty N'MS_Description', N'行政區', N'Schema', N'dbo', N'Table', N'CommunityInfo', N'Column', N'RCDID';
EXEC sp_addextendedproperty N'MS_Description', N'街道名稱', N'Schema', N'dbo', N'Table', N'CommunityInfo', N'Column', N'CIStreet';
EXEC sp_addextendedproperty N'MS_Description', N'門牌範圍', N'Schema', N'dbo', N'Table', N'CommunityInfo', N'Column', N'CINumber';
EXEC sp_addextendedproperty N'MS_Description', N'建物型態', N'Schema', N'dbo', N'Table', N'CommunityInfo', N'Column', N'PTID';
EXEC sp_addextendedproperty N'MS_Description', N'社區內棟數', N'Schema', N'dbo', N'Table', N'CommunityInfo', N'Column', N'CIBuilding';
EXEC sp_addextendedproperty N'MS_Description', N'總戶數', N'Schema', N'dbo', N'Table', N'CommunityInfo', N'Column', N'CIHouseholds';
EXEC sp_addextendedproperty N'MS_Description', N'是否為封閉型社區', N'Schema', N'dbo', N'Table', N'CommunityInfo', N'Column', N'CIIsGated';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'CommunityInfo', N'Column', N'CIIsActive';
EXEC sp_addextendedproperty N'MS_Description', N'緯度', N'Schema', N'dbo', N'Table', N'CommunityInfo', N'Column', N'CILatitude';
EXEC sp_addextendedproperty N'MS_Description', N'經度', N'Schema', N'dbo', N'Table', N'CommunityInfo', N'Column', N'CILongitude';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'CommunityInfo', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'CommunityInfo', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'CommunityInfo', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'CommunityInfo', N'Column', N'Sys_UpdateBy';
GO



/*【53. 物件型態 PropertyAssetType】*/
CREATE TABLE PropertyAssetType (
    PATID INT IDENTITY(1,1) PRIMARY KEY,       	-- 物件型態編號
    PATName NVARCHAR(20) NOT NULL,       	-- 物件型態
    PATIsActive BIT NOT NULL DEFAULT 1,         	-- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    CONSTRAINT CHK_PropertyAssetType_IsActive CHECK (PATIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'物件型態', N'Schema', N'dbo', N'Table', N'PropertyAssetType';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'物件型態編號', N'Schema', N'dbo', N'Table', N'PropertyAssetType', N'Column', N'PATID';
EXEC sp_addextendedproperty N'MS_Description', N'物件型態', N'Schema', N'dbo', N'Table', N'PropertyAssetType', N'Column', N'PATName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'PropertyAssetType', N'Column', N'PATIsActive';
GO



/*【54. 物件狀態 PropertyAssetStatus】*/
CREATE TABLE PropertyAssetStatus (
    PASID INT IDENTITY(1,1) PRIMARY KEY,       	-- 物件狀態編號
    PASName NVARCHAR(30) NOT NULL,      	-- 物件狀態
    PASIsActive BIT NOT NULL DEFAULT 1,         	-- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    CONSTRAINT CHK_PropertyAssetStatus_IsActive CHECK (PASIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'物件狀態', N'Schema', N'dbo', N'Table', N'PropertyAssetStatus';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'物件狀態編號', N'Schema', N'dbo', N'Table', N'PropertyAssetStatus', N'Column', N'PASID';
EXEC sp_addextendedproperty N'MS_Description', N'物件狀態', N'Schema', N'dbo', N'Table', N'PropertyAssetStatus', N'Column', N'PASName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'PropertyAssetStatus', N'Column', N'PASIsActive';
GO



/*【55. 不動產物件 PropertyAsset】*/
CREATE TABLE PropertyAsset (
    PAID INT IDENTITY(1,1) PRIMARY KEY,        		-- 物件編號
    CMID VARCHAR(15) NOT NULL,                 		-- 契據編號 (FK)
    COID INT NOT NULL,                          			-- 公司編號 (FK)
    PAStartDate DATE NOT NULL,                  		-- 合約起始日
    PAEndDate DATE NOT NULL,                    		-- 合約結束日
    PATID INT NOT NULL,                          			-- 物件型態編號 (FK)
    RCDID INT NOT NULL,                          			-- 行政區編號 (FK)
    PAAddress NVARCHAR(255) NOT NULL, 		-- 門牌地址
    PAPrice DECIMAL(15,2) NOT NULL,             		-- 總價
    PAIncludeParking BIT NOT NULL DEFAULT 0,    	-- 是否含車位費 (0:false, 1:true)
    PAUnitPrice DECIMAL(7,2) NULL,              		-- 單價
    PASID INT NOT NULL,                          			-- 物件狀態編號 (FK)
    PAMapPath NVARCHAR(500) NULL,               		-- 位置圖
    PAPlanPath NVARCHAR(500) NULL,              		-- 平面圖
    PADescription NVARCHAR(500) NULL,           	-- 物件介紹
    PALatitude DECIMAL(10,6) NOT NULL,          		-- 緯度
    PALongitude DECIMAL(10,6) NOT NULL,         	-- 經度

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,                				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME2 NULL,                          				-- 刪除時間
    Sys_DeleteBy INT NULL,                               					-- 刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_PropertyAsset_ContractMain FOREIGN KEY (CMID) REFERENCES ContractMain(CMID),
    CONSTRAINT FK_PropertyAsset_Company FOREIGN KEY (COID) REFERENCES Company(COID),
    CONSTRAINT FK_PropertyAsset_PropertyAssetType FOREIGN KEY (PATID) REFERENCES PropertyAssetType(PATID),
    CONSTRAINT FK_PropertyAsset_RegionCityDistrict FOREIGN KEY (RCDID) REFERENCES RegionCityDistrict(RCDID),
    CONSTRAINT FK_PropertyAsset_PropertyAssetStatus FOREIGN KEY (PASID) REFERENCES PropertyAssetStatus(PASID),
    CONSTRAINT FK_PropertyAsset_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_PropertyAsset_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_PropertyAsset_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID),

    /*CHECK 設定*/
    CONSTRAINT CHK_PropertyAsset_PAPrice CHECK (PAPrice >= 0),
    CONSTRAINT CHK_PropertyAsset_PAUnitPrice CHECK (PAUnitPrice >= 0)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'不動產物件', N'Schema', N'dbo', N'Table', N'PropertyAsset';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'物件編號', N'Schema', N'dbo', N'Table', N'PropertyAsset', N'Column', N'PAID';
EXEC sp_addextendedproperty N'MS_Description', N'契據編號', N'Schema', N'dbo', N'Table', N'PropertyAsset', N'Column', N'CMID';
EXEC sp_addextendedproperty N'MS_Description', N'公司', N'Schema', N'dbo', N'Table', N'PropertyAsset', N'Column', N'COID';
EXEC sp_addextendedproperty N'MS_Description', N'合約起始日', N'Schema', N'dbo', N'Table', N'PropertyAsset', N'Column', N'PAStartDate';
EXEC sp_addextendedproperty N'MS_Description', N'合約結束日', N'Schema', N'dbo', N'Table', N'PropertyAsset', N'Column', N'PAEndDate';
EXEC sp_addextendedproperty N'MS_Description', N'物件型態', N'Schema', N'dbo', N'Table', N'PropertyAsset', N'Column', N'PATID';
EXEC sp_addextendedproperty N'MS_Description', N'行政區', N'Schema', N'dbo', N'Table', N'PropertyAsset', N'Column', N'RCDID';
EXEC sp_addextendedproperty N'MS_Description', N'門牌地址', N'Schema', N'dbo', N'Table', N'PropertyAsset', N'Column', N'PAAddress';
EXEC sp_addextendedproperty N'MS_Description', N'總價', N'Schema', N'dbo', N'Table', N'PropertyAsset', N'Column', N'PAPrice';
EXEC sp_addextendedproperty N'MS_Description', N'是否含車位費', N'Schema', N'dbo', N'Table', N'PropertyAsset', N'Column', N'PAIncludeParking';
EXEC sp_addextendedproperty N'MS_Description', N'單價', N'Schema', N'dbo', N'Table', N'PropertyAsset', N'Column', N'PAUnitPrice';
EXEC sp_addextendedproperty N'MS_Description', N'物件狀態', N'Schema', N'dbo', N'Table', N'PropertyAsset', N'Column', N'PASID';
EXEC sp_addextendedproperty N'MS_Description', N'位置圖', N'Schema', N'dbo', N'Table', N'PropertyAsset', N'Column', N'PAMapPath';
EXEC sp_addextendedproperty N'MS_Description', N'平面圖', N'Schema', N'dbo', N'Table', N'PropertyAsset', N'Column', N'PAPlanPath';
EXEC sp_addextendedproperty N'MS_Description', N'物件介紹', N'Schema', N'dbo', N'Table', N'PropertyAsset', N'Column', N'PADescription';
EXEC sp_addextendedproperty N'MS_Description', N'緯度', N'Schema', N'dbo', N'Table', N'PropertyAsset', N'Column', N'PALatitude';
EXEC sp_addextendedproperty N'MS_Description', N'經度', N'Schema', N'dbo', N'Table', N'PropertyAsset', N'Column', N'PALongitude';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'PropertyAsset', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'PropertyAsset', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'PropertyAsset', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'PropertyAsset', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'PropertyAsset', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'PropertyAsset', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'PropertyAsset', N'Column', N'Sys_DeleteBy';
GO



/*【55-1. 物件合約異動紀錄 PropertyAssetRecord】*/
CREATE TABLE PropertyAssetRecord (
    PARID INT IDENTITY(1,1) PRIMARY KEY,                		-- 物件合約異動紀錄編號
    PAID INT NOT NULL,                                  			-- 物件編號 (FK)
    PARStartDate DATE NOT NULL,                        	 	-- 合約起始日
    PAREndDate DATE NOT NULL,                           		-- 合約結束日
    PATID INT NOT NULL,                                 			-- 物件型態編號 (FK)
    RCDID INT NOT NULL,                                 			-- 行政區編號 (FK)
    PARAddress NVARCHAR(255) NOT NULL,                  	-- 門牌地址
    PARPrice DECIMAL(15,2) NOT NULL,                   	 	-- 總價
    PARIncludeParking BIT NOT NULL DEFAULT 0,           	-- 是否含車位費 (0:false, 1:true)
    PARUnitPrice DECIMAL(7,2) NULL,                     		-- 單價

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(), 	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)

    /*CHECK 設定*/
    CONSTRAINT CK_PropertyAssetRecord_Price CHECK (PARPrice >= 0),
    CONSTRAINT CK_PropertyAssetRecord_UnitPrice CHECK (PARUnitPrice IS NULL OR PARUnitPrice >= 0),
    CONSTRAINT CK_PropertyAssetRecord_Date CHECK (PAREndDate >= PARStartDate),

    /*FK 設定*/
    CONSTRAINT FK_PropertyAssetRecord_PropertyAsset FOREIGN KEY (PAID) REFERENCES PropertyAsset(PAID),
    CONSTRAINT FK_PropertyAssetRecord_PropertyAssetType FOREIGN KEY (PATID) REFERENCES PropertyAssetType(PATID),
    CONSTRAINT FK_PropertyAssetRecord_RegionCityDistrict FOREIGN KEY (RCDID) REFERENCES RegionCityDistrict(RCDID),
    CONSTRAINT FK_PropertyAssetRecord_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
);
GO

-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'物件合約異動紀錄表', N'Schema', N'dbo', N'Table', N'PropertyAssetRecord';

-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'物件合約異動紀錄編號', N'Schema', N'dbo', N'Table', N'PropertyAssetRecord', N'Column', N'PARID';
EXEC sp_addextendedproperty N'MS_Description', N'物件編號', N'Schema', N'dbo', N'Table', N'PropertyAssetRecord', N'Column', N'PAID';
EXEC sp_addextendedproperty N'MS_Description', N'合約起始日', N'Schema', N'dbo', N'Table', N'PropertyAssetRecord', N'Column', N'PARStartDate';
EXEC sp_addextendedproperty N'MS_Description', N'合約結束日', N'Schema', N'dbo', N'Table', N'PropertyAssetRecord', N'Column', N'PAREndDate';
EXEC sp_addextendedproperty N'MS_Description', N'物件型態編號', N'Schema', N'dbo', N'Table', N'PropertyAssetRecord', N'Column', N'PATID';
EXEC sp_addextendedproperty N'MS_Description', N'行政區編號', N'Schema', N'dbo', N'Table', N'PropertyAssetRecord', N'Column', N'RCDID';
EXEC sp_addextendedproperty N'MS_Description', N'門牌地址', N'Schema', N'dbo', N'Table', N'PropertyAssetRecord', N'Column', N'PARAddress';
EXEC sp_addextendedproperty N'MS_Description', N'總價', N'Schema', N'dbo', N'Table', N'PropertyAssetRecord', N'Column', N'PARPrice';
EXEC sp_addextendedproperty N'MS_Description', N'是否含車位費', N'Schema', N'dbo', N'Table', N'PropertyAssetRecord', N'Column', N'PARIncludeParking';
EXEC sp_addextendedproperty N'MS_Description', N'單價', N'Schema', N'dbo', N'Table', N'PropertyAssetRecord', N'Column', N'PARUnitPrice';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'PropertyAssetRecord', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'PropertyAssetRecord', N'Column', N'Sys_CreatedBy';
GO





/*【56. 不動產物件照片 PropertyAssetPhoto】*/
CREATE TABLE PropertyAssetPhoto (
    PAPID INT IDENTITY(1,1) PRIMARY KEY,        	-- 不動產物件照片編號
    PAID INT NOT NULL,                           		-- 物件編號 (FK)
    PAPPath NVARCHAR(500) NOT NULL,        	-- 照片路徑
    PAPDescription NVARCHAR(30) NULL,         	-- 照片介紹
    PAPSort INT NOT NULL,                        		-- 顯示順序

    /*FK 設定*/
    CONSTRAINT FK_PropertyAssetPhoto_PropertyAsset FOREIGN KEY (PAID) REFERENCES PropertyAsset(PAID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'不動產物件照片', N'Schema', N'dbo', N'Table', N'PropertyAssetPhoto';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'不動產物件照片編號', N'Schema', N'dbo', N'Table', N'PropertyAssetPhoto', N'Column', N'PAPID';
EXEC sp_addextendedproperty N'MS_Description', N'物件編號', N'Schema', N'dbo', N'Table', N'PropertyAssetPhoto', N'Column', N'PAID';
EXEC sp_addextendedproperty N'MS_Description', N'照片路徑', N'Schema', N'dbo', N'Table', N'PropertyAssetPhoto', N'Column', N'PAPPath';
EXEC sp_addextendedproperty N'MS_Description', N'照片介紹', N'Schema', N'dbo', N'Table', N'PropertyAssetPhoto', N'Column', N'PAPDescription';
EXEC sp_addextendedproperty N'MS_Description', N'顯示順序', N'Schema', N'dbo', N'Table', N'PropertyAssetPhoto', N'Column', N'PAPSort';
GO



/*【57. 土地使用分區 ZoningType】*/
CREATE TABLE ZoningType (
    ZTID INT IDENTITY(1,1) PRIMARY KEY,     	-- 土地使用分區編號
    ZTName NVARCHAR(30) NOT NULL,           	-- 土地使用分區
    ZTDescription NVARCHAR(500) NULL,       	-- 分區用途說明
    ZTIsActive BIT NOT NULL DEFAULT 1,       	-- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    CONSTRAINT CHK_ZoningType_IsActive CHECK (ZTIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'土地使用分區', N'Schema', N'dbo', N'Table', N'ZoningType';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'土地使用分區編號', N'Schema', N'dbo', N'Table', N'ZoningType', N'Column', N'ZTID';
EXEC sp_addextendedproperty N'MS_Description', N'土地使用分區', N'Schema', N'dbo', N'Table', N'ZoningType', N'Column', N'ZTName';
EXEC sp_addextendedproperty N'MS_Description', N'分區用途說明', N'Schema', N'dbo', N'Table', N'ZoningType', N'Column', N'ZTDescription';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'ZoningType', N'Column', N'ZTIsActive';
GO



/*【58. 不動產物件土地資料 PropertyAssetLand】*/
CREATE TABLE PropertyAssetLand (
    PALID INT IDENTITY(1,1) PRIMARY KEY,    	-- 物件土地資料編號
    PAID INT NOT NULL,                      			-- 物件編號 (FK)
    PALSiteArea DECIMAL(15,2) NOT NULL,     	-- 地坪
    ZTID INT NULL,                          				-- 土地使用分區編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,               						-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,               					-- 修改時間
    Sys_UpdateBy INT NULL,                    						-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_PropertyAssetLand_PropertyAsset FOREIGN KEY (PAID) REFERENCES PropertyAsset(PAID),
    CONSTRAINT FK_PropertyAssetLand_ZoningType FOREIGN KEY (ZTID) REFERENCES ZoningType(ZTID),
    CONSTRAINT FK_PropertyAssetLand_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_PropertyAssetLand_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),

    /*CHECK 設定*/
    CONSTRAINT CHK_PropertyAssetLand_PALSiteArea CHECK (PALSiteArea >= 0)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'不動產物件土地資料', N'Schema', N'dbo', N'Table', N'PropertyAssetLand';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'物件土地資料編號', N'Schema', N'dbo', N'Table', N'PropertyAssetLand', N'Column', N'PALID';
EXEC sp_addextendedproperty N'MS_Description', N'物件編號', N'Schema', N'dbo', N'Table', N'PropertyAssetLand', N'Column', N'PAID';
EXEC sp_addextendedproperty N'MS_Description', N'地坪', N'Schema', N'dbo', N'Table', N'PropertyAssetLand', N'Column', N'PALSiteArea';
EXEC sp_addextendedproperty N'MS_Description', N'土地使用分區', N'Schema', N'dbo', N'Table', N'PropertyAssetLand', N'Column', N'ZTID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'PropertyAssetLand', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'PropertyAssetLand', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'PropertyAssetLand', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'PropertyAssetLand', N'Column', N'Sys_UpdateBy';
GO




/*【59. 土地使用 LandUseInfo】*/
CREATE TABLE LandUseInfo (
    LUIID INT IDENTITY(1,1) PRIMARY KEY,   	-- 土地使用編號
    LUIName NVARCHAR(30) NOT NULL,          	-- 土地使用名稱
    LUIIsActive BIT NOT NULL DEFAULT 1,      	-- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    CONSTRAINT CHK_LandUseInfo_IsActive CHECK (LUIIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'土地使用', N'Schema', N'dbo', N'Table', N'LandUseInfo';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'土地使用編號', N'Schema', N'dbo', N'Table', N'LandUseInfo', N'Column', N'LUIID';
EXEC sp_addextendedproperty N'MS_Description', N'土地使用', N'Schema', N'dbo', N'Table', N'LandUseInfo', N'Column', N'LUIName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'LandUseInfo', N'Column', N'LUIIsActive';
GO



/*【60. 土地使用明細 LandUseDetail】*/
CREATE TABLE LandUseDetail (
    LUDID INT IDENTITY(1,1) PRIMARY KEY,    	-- 土地使用明細編號
    LUIID INT NOT NULL,                     			-- 土地使用編號 (FK)
    PALID INT NOT NULL,                     			-- 物件土地資料編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,               						-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,               					-- 修改時間
    Sys_UpdateBy INT NULL,                    						-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_LandUseDetail_LandUseInfo FOREIGN KEY (LUIID) REFERENCES LandUseInfo(LUIID),
    CONSTRAINT FK_LandUseDetail_PropertyAssetLand FOREIGN KEY (PALID) REFERENCES PropertyAssetLand(PALID),
    CONSTRAINT FK_LandUseDetail_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_LandUseDetail_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'土地使用明細', N'Schema', N'dbo', N'Table', N'LandUseDetail';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'土地使用明細編號', N'Schema', N'dbo', N'Table', N'LandUseDetail', N'Column', N'LUDID';
EXEC sp_addextendedproperty N'MS_Description', N'土地使用', N'Schema', N'dbo', N'Table', N'LandUseDetail', N'Column', N'LUIID';
EXEC sp_addextendedproperty N'MS_Description', N'物件土地資料編號', N'Schema', N'dbo', N'Table', N'LandUseDetail', N'Column', N'PALID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'LandUseDetail', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'LandUseDetail', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'LandUseDetail', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'LandUseDetail', N'Column', N'Sys_UpdateBy';
GO



/*【61. 建造材質 BuildingMaterial】*/
CREATE TABLE BuildingMaterial (
    BMID INT IDENTITY(1,1) PRIMARY KEY,         	-- 建造材質編號
    BMName NVARCHAR(30) NOT NULL,		-- 建造材質
    BMIsActive BIT NOT NULL DEFAULT 1,          	-- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    CONSTRAINT CHK_BuildingMaterial_IsActive CHECK (BMIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'建造材質', N'Schema', N'dbo', N'Table', N'BuildingMaterial';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'建造材質編號', N'Schema', N'dbo', N'Table', N'BuildingMaterial', N'Column', N'BMID';
EXEC sp_addextendedproperty N'MS_Description', N'建造材質', N'Schema', N'dbo', N'Table', N'BuildingMaterial', N'Column', N'BMName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'BuildingMaterial', N'Column', N'BMIsActive';
GO




/*【62. 不動產物件建物資料 PropertyAssetBuilding】*/
CREATE TABLE PropertyAssetBuilding (
    PABID INT IDENTITY(1,1) PRIMARY KEY,        	-- 物件建物資料編號
    PAID INT NOT NULL,                          		-- 物件編號 (FK)
    PABFloor INT NOT NULL,                      		-- 樓層
    PABConfiguration INT NOT NULL,              	-- 建物格局
    PTID INT NOT NULL,                          		-- 建物型態編號 (FK)
    PABUsage NVARCHAR(50) NOT NULL, 		-- 建物登記用途
    BMID INT NOT NULL,                          		-- 建造材質編號 (FK)
    PABCompletionDate DATE NOT NULL, 		-- 建造完成日
    PABCharge DECIMAL(8,2) NULL,                      -- 管理費
    CUID INT NULL,                              			-- 計算單位編號 (FK)
    CIID INT NULL,                               			-- 社區編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                      					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                      					-- 修改時間
    Sys_UpdateBy INT NULL,                           					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_PropertyAssetBuilding_PropertyAsset FOREIGN KEY (PAID) REFERENCES PropertyAsset(PAID),
    CONSTRAINT FK_PropertyAssetBuilding_PropertyType FOREIGN KEY (PTID) REFERENCES PropertyType(PTID),
    CONSTRAINT FK_PropertyAssetBuilding_BuildingMaterial FOREIGN KEY (BMID) REFERENCES BuildingMaterial(BMID),
    CONSTRAINT FK_PropertyAssetBuilding_CalculationUnits FOREIGN KEY (CUID) REFERENCES CalculationUnits(CUID),
    CONSTRAINT FK_PropertyAssetBuilding_CommunityInfo FOREIGN KEY (CIID) REFERENCES CommunityInfo(CIID),
    CONSTRAINT FK_PropertyAssetBuilding_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_PropertyAssetBuilding_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),

    /*CHECK 設定*/
    CONSTRAINT CHK_PropertyAssetLand_PABFloor CHECK (PABFloor >= 0),
    CONSTRAINT CHK_PropertyAssetLand_PABCharge CHECK (PABCharge >= 0)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'不動產物件建物資料', N'Schema', N'dbo', N'Table', N'PropertyAssetBuilding';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'物件建物資料編號', N'Schema', N'dbo', N'Table', N'PropertyAssetBuilding', N'Column', N'PABID';
EXEC sp_addextendedproperty N'MS_Description', N'物件編號', N'Schema', N'dbo', N'Table', N'PropertyAssetBuilding', N'Column', N'PAID';
EXEC sp_addextendedproperty N'MS_Description', N'樓層', N'Schema', N'dbo', N'Table', N'PropertyAssetBuilding', N'Column', N'PABFloor';
EXEC sp_addextendedproperty N'MS_Description', N'建物格局', N'Schema', N'dbo', N'Table', N'PropertyAssetBuilding', N'Column', N'PABConfiguration';
EXEC sp_addextendedproperty N'MS_Description', N'建物型態', N'Schema', N'dbo', N'Table', N'PropertyAssetBuilding', N'Column', N'PTID';
EXEC sp_addextendedproperty N'MS_Description', N'建物登記用途', N'Schema', N'dbo', N'Table', N'PropertyAssetBuilding', N'Column', N'PABUsage';
EXEC sp_addextendedproperty N'MS_Description', N'建造材質', N'Schema', N'dbo', N'Table', N'PropertyAssetBuilding', N'Column', N'BMID';
EXEC sp_addextendedproperty N'MS_Description', N'建造完成日', N'Schema', N'dbo', N'Table', N'PropertyAssetBuilding', N'Column', N'PABCompletionDate';
EXEC sp_addextendedproperty N'MS_Description', N'管理費', N'Schema', N'dbo', N'Table', N'PropertyAssetBuilding', N'Column', N'PABCharge';
EXEC sp_addextendedproperty N'MS_Description', N'計算單位', N'Schema', N'dbo', N'Table', N'PropertyAssetBuilding', N'Column', N'CUID';
EXEC sp_addextendedproperty N'MS_Description', N'社區', N'Schema', N'dbo', N'Table', N'PropertyAssetBuilding', N'Column', N'CIID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'PropertyAssetBuilding', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'PropertyAssetBuilding', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'PropertyAssetBuilding', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'PropertyAssetBuilding', N'Column', N'Sys_UpdateBy';
GO



/*【62-1. 不動產物件建物建坪 PropertyAssetBuildingArea】*/
CREATE TABLE PropertyAssetBuildingArea (
    PABAID INT IDENTITY(1,1) PRIMARY KEY,           	-- 不動產物件建物建坪編號
    PABID INT NOT NULL,                              			-- 物件建物資料編號 (FK)
    PABAItem NVARCHAR(50) NOT NULL,                 	-- 建坪明細
    PABAFloorArea DECIMAL(15,2) NOT NULL,           	-- 建坪

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                        					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                        				-- 修改時間
    Sys_UpdateBy INT NULL,                             					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_PropertyAssetBuildingArea_PAB FOREIGN KEY (PABID) REFERENCES PropertyAssetBuilding(PABID),
    CONSTRAINT FK_PropertyAssetBuildingArea_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_PropertyAssetBuildingArea_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),

    /*CHECK 設定*/
    CONSTRAINT CHK_PropertyAssetBuildingArea_PABAFloorArea CHECK (PABAFloorArea >= 0)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'不動產物件建物建坪', N'Schema', N'dbo', N'Table', N'PropertyAssetBuildingArea';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'不動產物件建物建坪編號', N'Schema', N'dbo', N'Table', N'PropertyAssetBuildingArea', N'Column', N'PABAID';
EXEC sp_addextendedproperty N'MS_Description', N'物件建物資料編號', N'Schema', N'dbo', N'Table', N'PropertyAssetBuildingArea', N'Column', N'PABID';
EXEC sp_addextendedproperty N'MS_Description', N'建坪明細', N'Schema', N'dbo', N'Table', N'PropertyAssetBuildingArea', N'Column', N'PABAItem';
EXEC sp_addextendedproperty N'MS_Description', N'建坪', N'Schema', N'dbo', N'Table', N'PropertyAssetBuildingArea', N'Column', N'PABAFloorArea';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'PropertyAssetBuildingArea', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'PropertyAssetBuildingArea', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'PropertyAssetBuildingArea', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'PropertyAssetBuildingArea', N'Column', N'Sys_UpdateBy';
GO




/*【63. 車位類型 CarParkType】*/
CREATE TABLE CarParkType (
    CPTID INT IDENTITY(1,1) PRIMARY KEY,        	-- 車位類型編號
    CPTName NVARCHAR(30) NOT NULL,		-- 車位類型
    CPTIsActive BIT NOT NULL DEFAULT 1,          	-- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    CONSTRAINT CHK_CarParkType_IsActive CHECK (CPTIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'車位類型', N'Schema', N'dbo', N'Table', N'CarParkType';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'車位類型編號', N'Schema', N'dbo', N'Table', N'CarParkType', N'Column', N'CPTID';
EXEC sp_addextendedproperty N'MS_Description', N'車位類型', N'Schema', N'dbo', N'Table', N'CarParkType', N'Column', N'CPTName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'CarParkType', N'Column', N'CPTIsActive';
GO



/*【64. 車位明細 CarParkDetail】*/
CREATE TABLE CarParkDetail (
    CPDID INT IDENTITY(1,1) PRIMARY KEY,        	-- 車位明細編號
    PABID INT NOT NULL,                         		-- 物件建物資料編號 (FK)
    CPDNumber NVARCHAR(30) NOT NULL, 	-- 車位編號
    CPTID INT NOT NULL,                         		-- 車位類型編號 (FK)
    CPDFloorArea DECIMAL(12,2)  NULL,          	-- 車位坪數
    CPDPrice DECIMAL(12,2) NULL,       			-- 售價
    CPDServiceCharge DECIMAL(8,2) NULL,    	-- 管理費
    CUID INT NULL,                              			-- 計算單位編號 (FK)
    CPDNote NVARCHAR(100) NULL,                 	-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                      					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                      					-- 修改時間
    Sys_UpdateBy INT NULL,                           					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_CarParkDetail_PropertyAssetBuilding FOREIGN KEY (PABID) REFERENCES PropertyAssetBuilding(PABID),
    CONSTRAINT FK_CarParkDetail_CarParkType FOREIGN KEY (CPTID) REFERENCES CarParkType(CPTID),
    CONSTRAINT FK_CarParkDetail_CalculationUnits FOREIGN KEY (CUID) REFERENCES CalculationUnits(CUID),
    CONSTRAINT FK_CarParkDetail_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_CarParkDetail_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),

    /*CHECK 設定*/
    CONSTRAINT CHK_CarParkDetail_CPDFloorArea CHECK (CPDFloorArea >= 0),
    CONSTRAINT CHK_CarParkDetail_CPDPrice CHECK (CPDPrice >= 0),
    CONSTRAINT CHK_CarParkDetail_CPDServiceCharge CHECK (CPDServiceCharge >= 0)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'車位明細', N'Schema', N'dbo', N'Table', N'CarParkDetail';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'車位明細編號', N'Schema', N'dbo', N'Table', N'CarParkDetail', N'Column', N'CPDID';
EXEC sp_addextendedproperty N'MS_Description', N'物件建物資料編號', N'Schema', N'dbo', N'Table', N'CarParkDetail', N'Column', N'PABID';
EXEC sp_addextendedproperty N'MS_Description', N'車位編號', N'Schema', N'dbo', N'Table', N'CarParkDetail', N'Column', N'CPDNumber';
EXEC sp_addextendedproperty N'MS_Description', N'車位類型', N'Schema', N'dbo', N'Table', N'CarParkDetail', N'Column', N'CPTID';
EXEC sp_addextendedproperty N'MS_Description', N'車位坪數', N'Schema', N'dbo', N'Table', N'CarParkDetail', N'Column', N'CPDFloorArea';
EXEC sp_addextendedproperty N'MS_Description', N'售價', N'Schema', N'dbo', N'Table', N'CarParkDetail', N'Column', N'CPDPrice';
EXEC sp_addextendedproperty N'MS_Description', N'管理費', N'Schema', N'dbo', N'Table', N'CarParkDetail', N'Column', N'CPDServiceCharge';
EXEC sp_addextendedproperty N'MS_Description', N'計算單位', N'Schema', N'dbo', N'Table', N'CarParkDetail', N'Column', N'CUID';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'CarParkDetail', N'Column', N'CPDNote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'CarParkDetail', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'CarParkDetail', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'CarParkDetail', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'CarParkDetail', N'Column', N'Sys_UpdateBy';
GO




/*【65. 物件鑰匙 PropertyAssetKey】*/
CREATE TABLE PropertyAssetKey (
    PAKID INT IDENTITY(1,1) PRIMARY KEY,        	-- 物件鑰匙編號
    PAID INT NOT NULL,                          		-- 物件編號 (FK)
    PAKCode NVARCHAR(30) NOT NULL,      	-- 鑰匙實體編號
    PAKHolder NVARCHAR(30) NOT NULL,		-- 保管方
    PAKNote NVARCHAR(100) NULL,              	-- 備註
    PAKIsActive BIT NOT NULL DEFAULT 1,         	-- 是否啟用 (0:false, 1:true)

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                      					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                      					-- 修改時間
    Sys_UpdateBy INT NULL,                           					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_PropertyAssetKey_PropertyAsset FOREIGN KEY (PAID) REFERENCES PropertyAsset(PAID),
    CONSTRAINT FK_PropertyAssetKey_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_PropertyAssetKey_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),

    /*CHECK 設定*/
    CONSTRAINT CHK_PropertyAssetKey_IsActive CHECK (PAKIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'物件鑰匙', N'Schema', N'dbo', N'Table', N'PropertyAssetKey';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'物件鑰匙編號', N'Schema', N'dbo', N'Table', N'PropertyAssetKey', N'Column', N'PAKID';
EXEC sp_addextendedproperty N'MS_Description', N'物件編號', N'Schema', N'dbo', N'Table', N'PropertyAssetKey', N'Column', N'PAID';
EXEC sp_addextendedproperty N'MS_Description', N'鑰匙實體編號', N'Schema', N'dbo', N'Table', N'PropertyAssetKey', N'Column', N'PAKCode';
EXEC sp_addextendedproperty N'MS_Description', N'保管方', N'Schema', N'dbo', N'Table', N'PropertyAssetKey', N'Column', N'PAKHolder';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'PropertyAssetKey', N'Column', N'PAKNote';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'PropertyAssetKey', N'Column', N'PAKIsActive';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'PropertyAssetKey', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'PropertyAssetKey', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'PropertyAssetKey', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'PropertyAssetKey', N'Column', N'Sys_UpdateBy';
GO




/*【66. 物件簽約專員明細 PropertyAssetExecutive】*/
CREATE TABLE PropertyAssetExecutive (
    PAEID INT IDENTITY(1,1) PRIMARY KEY,      	-- 物件簽約專員明細編號
    PAID INT NOT NULL,                        			-- 物件編號 (FK)
    EEID INT NOT NULL,                        			-- 員工編號 (FK)
    PAEPercent INT NOT NULL,                  		-- 物件比重
    JAID INT NOT NULL,                        			-- 任職記錄編號 (FK)
    PAEIsActive BIT NOT NULL DEFAULT 1,       	-- 是否啟用 (0:false, 1:true)

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_PAE_PropertyAsset FOREIGN KEY (PAID) REFERENCES PropertyAsset(PAID),
    CONSTRAINT FK_PAE_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_PAE_JobAssignments FOREIGN KEY (JAID) REFERENCES JobAssignments(JAID),
    CONSTRAINT FK_PAE_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_PAE_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),

    /*CHECK 設定*/
    CONSTRAINT CHK_PAE_PAEPercent CHECK (PAEPercent >= 0),
    CONSTRAINT CHK_PropertyAssetExecutive_IsActive CHECK (PAEIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'物件簽約專員明細', N'Schema', N'dbo', N'Table', N'PropertyAssetExecutive';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'物件簽約專員明細編號', N'Schema', N'dbo', N'Table', N'PropertyAssetExecutive', N'Column', N'PAEID';
EXEC sp_addextendedproperty N'MS_Description', N'物件編號', N'Schema', N'dbo', N'Table', N'PropertyAssetExecutive', N'Column', N'PAID';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'PropertyAssetExecutive', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'物件比重', N'Schema', N'dbo', N'Table', N'PropertyAssetExecutive', N'Column', N'PAEPercent';
EXEC sp_addextendedproperty N'MS_Description', N'任職記錄編號', N'Schema', N'dbo', N'Table', N'PropertyAssetExecutive', N'Column', N'JAID';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'PropertyAssetExecutive', N'Column', N'PAEIsActive';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'PropertyAssetExecutive', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'PropertyAssetExecutive', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'PropertyAssetExecutive', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'PropertyAssetExecutive', N'Column', N'Sys_UpdateBy';
GO




/*【67. 客戶稱謂 CustomerSalutation】*/
CREATE TABLE CustomerSalutation (
    CSID INT IDENTITY(1,1) PRIMARY KEY,      	-- 客戶稱謂編號
    CSName NVARCHAR(20) NOT NULL,            	-- 客戶稱謂
    CSIsActive BIT NOT NULL DEFAULT 1,        	-- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    CONSTRAINT CHK_CustomerSalutation_IsActive CHECK (CSIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'客戶稱謂', N'Schema', N'dbo', N'Table', N'CustomerSalutation';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'客戶稱謂編號', N'Schema', N'dbo', N'Table', N'CustomerSalutation', N'Column', N'CSID';
EXEC sp_addextendedproperty N'MS_Description', N'客戶稱謂', N'Schema', N'dbo', N'Table', N'CustomerSalutation', N'Column', N'CSName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'CustomerSalutation', N'Column', N'CSIsActive';
GO




/*【68. 客戶資料 CustomerProfileMain】*/
CREATE TABLE CustomerProfileMain (
    CPMID INT IDENTITY(1,1) PRIMARY KEY,     		-- 客戶資料編號
    CPMFamilyName NVARCHAR(20) NOT NULL,     	-- 姓氏
    CPMName NVARCHAR(50) NULL,               		-- 名字
    CSID INT NOT NULL,                       				-- 客戶稱謂編號 (FK)
    CPMIDNumber CHAR(10) NOT NULL,           		-- 身分證字號
    RCDID INT NOT NULL,                      			-- 行政區編號 (FK)
    CPMAddress NVARCHAR(255) NOT NULL,       	-- 門牌地址
    CPMNote NVARCHAR(500) NULL,              		-- 備註
    CPMMayMarket BIT NOT NULL DEFAULT 1,     	-- 可否行銷 (0:false, 1:true)

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,                				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME2 NULL,                         				-- 刪除時間
    Sys_DeleteBy INT NULL,                              					-- 刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_CPM_CustomerSalutation FOREIGN KEY (CSID) REFERENCES CustomerSalutation(CSID),
    CONSTRAINT FK_CPM_RegionCityDistrict FOREIGN KEY (RCDID) REFERENCES RegionCityDistrict(RCDID),
    CONSTRAINT FK_CPM_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_CPM_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_CPM_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID),

    /*CHECK 設定*/
    CONSTRAINT CHK_CustomerProfileMain_MayMarket CHECK (CPMMayMarket IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'客戶資料', N'Schema', N'dbo', N'Table', N'CustomerProfileMain';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'客戶資料編號', N'Schema', N'dbo', N'Table', N'CustomerProfileMain', N'Column', N'CPMID';
EXEC sp_addextendedproperty N'MS_Description', N'姓氏', N'Schema', N'dbo', N'Table', N'CustomerProfileMain', N'Column', N'CPMFamilyName';
EXEC sp_addextendedproperty N'MS_Description', N'名字', N'Schema', N'dbo', N'Table', N'CustomerProfileMain', N'Column', N'CPMName';
EXEC sp_addextendedproperty N'MS_Description', N'客戶稱謂', N'Schema', N'dbo', N'Table', N'CustomerProfileMain', N'Column', N'CSID';
EXEC sp_addextendedproperty N'MS_Description', N'身分證字號', N'Schema', N'dbo', N'Table', N'CustomerProfileMain', N'Column', N'CPMIDNumber';
EXEC sp_addextendedproperty N'MS_Description', N'行政區', N'Schema', N'dbo', N'Table', N'CustomerProfileMain', N'Column', N'RCDID';
EXEC sp_addextendedproperty N'MS_Description', N'門牌地址', N'Schema', N'dbo', N'Table', N'CustomerProfileMain', N'Column', N'CPMAddress';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'CustomerProfileMain', N'Column', N'CPMNote';
EXEC sp_addextendedproperty N'MS_Description', N'可否行銷', N'Schema', N'dbo', N'Table', N'CustomerProfileMain', N'Column', N'CPMMayMarket';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'CustomerProfileMain', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'CustomerProfileMain', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'CustomerProfileMain', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'CustomerProfileMain', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'CustomerProfileMain', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'CustomerProfileMain', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'CustomerProfileMain', N'Column', N'Sys_DeleteBy';
GO




/*【69. 客戶連絡電話 CustomerProfilePhone】*/
CREATE TABLE CustomerProfilePhone (
    CPPID INT IDENTITY(1,1) PRIMARY KEY,     	-- 客戶連絡電話編號
    CPMID INT NOT NULL,                      		-- 客戶資料編號 (FK)
    CPPPhone VARCHAR(30) NOT NULL,           	-- 連絡電話

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_CPP_CustomerProfileMain FOREIGN KEY (CPMID) REFERENCES CustomerProfileMain(CPMID),
    CONSTRAINT FK_CPP_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_CPP_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'客戶連絡電話', N'Schema', N'dbo', N'Table', N'CustomerProfilePhone';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'客戶連絡電話編號', N'Schema', N'dbo', N'Table', N'CustomerProfilePhone', N'Column', N'CPPID';
EXEC sp_addextendedproperty N'MS_Description', N'客戶資料編號', N'Schema', N'dbo', N'Table', N'CustomerProfilePhone', N'Column', N'CPMID';
EXEC sp_addextendedproperty N'MS_Description', N'連絡電話', N'Schema', N'dbo', N'Table', N'CustomerProfilePhone', N'Column', N'CPPPhone';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'CustomerProfilePhone', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'CustomerProfilePhone', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'CustomerProfilePhone', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'CustomerProfilePhone', N'Column', N'Sys_UpdateBy';
GO



/*【70. 委託客戶明細 PropertyAssetCustomer】*/
CREATE TABLE PropertyAssetCustomer (
    PACID INT IDENTITY(1,1) PRIMARY KEY,     	-- 委託客戶明細編號
    CPMID INT NOT NULL,                   	   		-- 客戶資料編號 (FK)
    PAID INT NOT NULL,                       			-- 物件編號 (FK)
    PACIsPrimary BIT NOT NULL DEFAULT 0,     	-- 是否為主要聯繫人 (0:false, 1:true)
    PACNote NVARCHAR(100) NULL,              	-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_PAC_CustomerProfileMain FOREIGN KEY (CPMID) REFERENCES CustomerProfileMain(CPMID),
    CONSTRAINT FK_PAC_PropertyAsset FOREIGN KEY (PAID) REFERENCES PropertyAsset(PAID),
    CONSTRAINT FK_PAC_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_PAC_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),

    /*CHECK 設定*/
    CONSTRAINT CHK_PropertyAssetCustomer_IsPrimary CHECK (PACIsPrimary IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'委託客戶明細', N'Schema', N'dbo', N'Table', N'PropertyAssetCustomer';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'委託客戶明細編號', N'Schema', N'dbo', N'Table', N'PropertyAssetCustomer', N'Column', N'PACID';
EXEC sp_addextendedproperty N'MS_Description', N'客戶資料編號', N'Schema', N'dbo', N'Table', N'PropertyAssetCustomer', N'Column', N'CPMID';
EXEC sp_addextendedproperty N'MS_Description', N'物件編號', N'Schema', N'dbo', N'Table', N'PropertyAssetCustomer', N'Column', N'PAID';
EXEC sp_addextendedproperty N'MS_Description', N'是否為主要聯繫人', N'Schema', N'dbo', N'Table', N'PropertyAssetCustomer', N'Column', N'PACIsPrimary';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'PropertyAssetCustomer', N'Column', N'PACNote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'PropertyAssetCustomer', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'PropertyAssetCustomer', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'PropertyAssetCustomer', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'PropertyAssetCustomer', N'Column', N'Sys_UpdateBy';
GO




/*【71. 物件契變明細 AssetChanegeLog】*/
CREATE TABLE AssetChanegeLog (
    ACLID INT IDENTITY(1,1) PRIMARY KEY,            	-- 物件契變明細編號
    CMID VARCHAR(15) NOT NULL,                    		-- 契據編號 (FK)
    PAID INT NOT NULL,                              			-- 物件編號 (FK)
    ACLStartDate DATE NOT NULL,                     		-- 合約起始日
    ACLEndDate DATE NOT NULL,                       		-- 合約截止日
    ACLPrice_min DECIMAL(12,2) NULL,                		-- 底價
    ACLPrice_total DECIMAL(12,2) NULL,              		-- 總價
    ACLNote NVARCHAR(500) NULL,           			-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                        					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                        				-- 修改時間
    Sys_UpdateBy INT NULL,                             					-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,               				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME2 NULL,                        				-- 刪除時間
    Sys_DeleteBy INT NULL,                            	 					-- 刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_AssetChanegeLog_ContractMain FOREIGN KEY (CMID) REFERENCES ContractMain(CMID),
    CONSTRAINT FK_AssetChanegeLog_PropertyAsset FOREIGN KEY (PAID) REFERENCES PropertyAsset(PAID),
    CONSTRAINT FK_AssetChanegeLog_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_AssetChanegeLog_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_AssetChanegeLog_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID),

    /*CHECK 設定*/
    CONSTRAINT CHK_AssetChanegeLog_ACLPrice_min CHECK (ACLPrice_min >= 0),
    CONSTRAINT CHK_AssetChanegeLog_ACLPrice_total CHECK (ACLPrice_total >= 0)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'物件契變明細', N'Schema', N'dbo', N'Table', N'AssetChanegeLog';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'物件契變明細編號', N'Schema', N'dbo', N'Table', N'AssetChanegeLog', N'Column', N'ACLID';
EXEC sp_addextendedproperty N'MS_Description', N'契據編號', N'Schema', N'dbo', N'Table', N'AssetChanegeLog', N'Column', N'CMID';
EXEC sp_addextendedproperty N'MS_Description', N'物件編號', N'Schema', N'dbo', N'Table', N'AssetChanegeLog', N'Column', N'PAID';
EXEC sp_addextendedproperty N'MS_Description', N'合約起始日', N'Schema', N'dbo', N'Table', N'AssetChanegeLog', N'Column', N'ACLStartDate';
EXEC sp_addextendedproperty N'MS_Description', N'合約截止日', N'Schema', N'dbo', N'Table', N'AssetChanegeLog', N'Column', N'ACLEndDate';
EXEC sp_addextendedproperty N'MS_Description', N'底價', N'Schema', N'dbo', N'Table', N'AssetChanegeLog', N'Column', N'ACLPrice_min';
EXEC sp_addextendedproperty N'MS_Description', N'總價', N'Schema', N'dbo', N'Table', N'AssetChanegeLog', N'Column', N'ACLPrice_total';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'AssetChanegeLog', N'Column', N'ACLNote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'AssetChanegeLog', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'AssetChanegeLog', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'AssetChanegeLog', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'AssetChanegeLog', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'AssetChanegeLog', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'AssetChanegeLog', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'AssetChanegeLog', N'Column', N'Sys_DeleteBy';
GO



/*【73. 斡旋單 AssetPurchaseOffer】*/
CREATE TABLE AssetPurchaseOffer (
    APOID INT IDENTITY(1,1) PRIMARY KEY,      	-- 斡旋單編號
    CMID VARCHAR(15) NOT NULL,                    	-- 契據編號 (FK)
    PAID INT NOT NULL,                            		-- 物件編號 (FK)
    CPMID INT NOT NULL,                           		-- 客戶資料編號 (FK)
    APOOfferDate DATE NOT NULL,                   	-- 下斡日期
    APOExpiration DATE NOT NULL,                  	-- 有效日期
    APOOfferPrice DECIMAL(12,2) NOT NULL, 	-- 下斡金額
    APOOfferType INT NOT NULL,                    	-- 斡金類型 (FK)
    APOAmount DECIMAL(12,2) NOT NULL,		-- 斡旋金
    APODeposit DATETIME2 NULL,               		-- 存入時間
    APORefundDT DATETIME2 NULL,                    	-- 退還時間
    APORefundReason NVARCHAR(50) NULL,  	-- 退還原因
    APORefundType INT NULL,            			-- 退還方式 (FK)
    APONote NVARCHAR(500) NULL,  			-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,                 				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME2 NULL,                          				-- 刪除時間
    Sys_DeleteBy INT NULL,                               					-- 刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_AssetPurchaseOffer_ContractMain FOREIGN KEY (CMID) REFERENCES ContractMain(CMID),
    CONSTRAINT FK_AssetPurchaseOffer_PropertyAsset FOREIGN KEY (PAID) REFERENCES PropertyAsset(PAID),
    CONSTRAINT FK_AssetPurchaseOffer_CustomerProfileMain FOREIGN KEY (CPMID) REFERENCES CustomerProfileMain(CPMID),
    CONSTRAINT FK_AssetPurchaseOffer_OfferType FOREIGN KEY (APOOfferType) REFERENCES Payment(PID),
    CONSTRAINT FK_AssetPurchaseOffer_RefundType FOREIGN KEY (APORefundType) REFERENCES Payment(PID),
    CONSTRAINT FK_AssetPurchaseOffer_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_AssetPurchaseOffer_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_AssetPurchaseOffer_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID),

    /*CHECK 設定*/
    CONSTRAINT CHK_AssetPurchaseOffer_APOOfferPrice CHECK (APOOfferPrice >= 0),
    CONSTRAINT CHK_AssetPurchaseOffer_APOAmount CHECK (APOAmount >= 0)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'斡旋單', N'Schema', N'dbo', N'Table', N'AssetPurchaseOffer';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'斡旋單編號', N'Schema', N'dbo', N'Table', N'AssetPurchaseOffer', N'Column', N'APOID';
EXEC sp_addextendedproperty N'MS_Description', N'契據編號', N'Schema', N'dbo', N'Table', N'AssetPurchaseOffer', N'Column', N'CMID';
EXEC sp_addextendedproperty N'MS_Description', N'物件編號', N'Schema', N'dbo', N'Table', N'AssetPurchaseOffer', N'Column', N'PAID';
EXEC sp_addextendedproperty N'MS_Description', N'客戶', N'Schema', N'dbo', N'Table', N'AssetPurchaseOffer', N'Column', N'CPMID';
EXEC sp_addextendedproperty N'MS_Description', N'下斡日期', N'Schema', N'dbo', N'Table', N'AssetPurchaseOffer', N'Column', N'APOOfferDate';
EXEC sp_addextendedproperty N'MS_Description', N'有效日期', N'Schema', N'dbo', N'Table', N'AssetPurchaseOffer', N'Column', N'APOExpiration';
EXEC sp_addextendedproperty N'MS_Description', N'下斡金額', N'Schema', N'dbo', N'Table', N'AssetPurchaseOffer', N'Column', N'APOOfferPrice';
EXEC sp_addextendedproperty N'MS_Description', N'斡金類型', N'Schema', N'dbo', N'Table', N'AssetPurchaseOffer', N'Column', N'APOOfferType';
EXEC sp_addextendedproperty N'MS_Description', N'斡旋金', N'Schema', N'dbo', N'Table', N'AssetPurchaseOffer', N'Column', N'APOAmount';
EXEC sp_addextendedproperty N'MS_Description', N'存入時間', N'Schema', N'dbo', N'Table', N'AssetPurchaseOffer', N'Column', N'APODeposit';
EXEC sp_addextendedproperty N'MS_Description', N'退還時間', N'Schema', N'dbo', N'Table', N'AssetPurchaseOffer', N'Column', N'APORefundDT';
EXEC sp_addextendedproperty N'MS_Description', N'退還原因', N'Schema', N'dbo', N'Table', N'AssetPurchaseOffer', N'Column', N'APORefundReason';
EXEC sp_addextendedproperty N'MS_Description', N'退還方式', N'Schema', N'dbo', N'Table', N'AssetPurchaseOffer', N'Column', N'APORefundType';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'AssetPurchaseOffer', N'Column', N'APONote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'AssetPurchaseOffer', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'AssetPurchaseOffer', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'AssetPurchaseOffer', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'AssetPurchaseOffer', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'AssetPurchaseOffer', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'AssetPurchaseOffer', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'AssetPurchaseOffer', N'Column', N'Sys_DeleteBy';
GO



/*【74. 帆布類型 BannerSizeType】*/
CREATE TABLE BannerSizeType (
    BSTID INT IDENTITY(1,1) PRIMARY KEY,           	-- 帆布類型編號
    BSTName NVARCHAR(50) NOT NULL,                 	-- 帆布類型
    BSTCode CHAR(2) NOT NULL,                      		-- 帆布代號
    BSTPhotoPath NVARCHAR(500) NULL,               	-- 帆布範例照片
    BSTIsActive BIT NOT NULL DEFAULT 1,                	-- 是否啟用 (0:false, 1:true)

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),  	-- 新增時間 YYYY/MM/DD hh:mm:ss
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                          				-- 修改時間 YYYY/MM/DD hh:mm:ss
    Sys_UpdateBy INT NULL                                 					-- 修改人員 (FK)

    /*FK 設定*/
    ,CONSTRAINT FK_BannerSizeType_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_BannerSizeType_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)

    /*CHECK 設定*/
    ,CONSTRAINT CHK_BannerSizeType_IsActive CHECK (BSTIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'帆布類型', N'Schema', N'dbo', N'Table', N'BannerSizeType';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'帆布類型編號', N'Schema', N'dbo', N'Table', N'BannerSizeType', N'Column', N'BSTID';
EXEC sp_addextendedproperty N'MS_Description', N'帆布類型', N'Schema', N'dbo', N'Table', N'BannerSizeType', N'Column', N'BSTName';
EXEC sp_addextendedproperty N'MS_Description', N'帆布代號', N'Schema', N'dbo', N'Table', N'BannerSizeType', N'Column', N'BSTCode';
EXEC sp_addextendedproperty N'MS_Description', N'帆布範例照片', N'Schema', N'dbo', N'Table', N'BannerSizeType', N'Column', N'BSTPhotoPath';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'BannerSizeType', N'Column', N'BSTIsActive';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'BannerSizeType', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'BannerSizeType', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'BannerSizeType', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'BannerSizeType', N'Column', N'Sys_UpdateBy';
GO




/*【75. 帆布廠商 BannerSupplierList】*/
CREATE TABLE BannerSupplierList (
    BSLID INT IDENTITY(1,1) PRIMARY KEY,          	-- 帆布廠商編號
    BSLName NVARCHAR(20) NOT NULL,    		-- 廠商名稱
    BSLNote NVARCHAR(200) NULL,           		-- 備註
    BSLIsActive BIT NOT NULL DEFAULT 1,    		-- 是否有效 (0:false, 1:true)

    /*CHECK 設定*/
    CONSTRAINT CHK_BannerSupplierList_IsActive CHECK (BSLIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'帆布廠商', N'Schema', N'dbo', N'Table', N'BannerSupplierList';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'帆布廠商編號', N'Schema', N'dbo', N'Table', N'BannerSupplierList', N'Column', N'BSLID';
EXEC sp_addextendedproperty N'MS_Description', N'廠商名稱', N'Schema', N'dbo', N'Table', N'BannerSupplierList', N'Column', N'BSLName';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'BannerSupplierList', N'Column', N'BSLNote';
EXEC sp_addextendedproperty N'MS_Description', N'是否有效', N'Schema', N'dbo', N'Table', N'BannerSupplierList', N'Column', N'BSLIsActive';
GO


/*【76. 帆布訂購 BannerPurchaseLog】*/
CREATE TABLE BannerPurchaseLog (
    BPLID INT IDENTITY(1,1) PRIMARY KEY,          	-- 帆布訂購編號
    COID INT NOT NULL,                             		-- 公司編號 (FK)
    EEID INT NOT NULL,                             		-- 員工編號 (FK)
    BPLDate DATE NOT NULL,                         	-- 帆布訂購日期 YYYY/MM/DD
    BSLID INT NOT NULL,                            		-- 帆布廠商編號 (FK)
    BSTID INT NOT NULL,                            		-- 帆布類型編號 (FK)
    BPLAmount INT NOT NULL,                        	-- 訂購數量
    BPLUnitPrice DECIMAL(10,2) NOT NULL,  	-- 訂購單價
    BPLDiscount INT NOT NULL DEFAULT 0, 	-- 折扣

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),  	-- 新增時間 YYYY/MM/DD hh:mm:ss
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                          				-- 修改時間 YYYY/MM/DD hh:mm:ss
    Sys_UpdateBy INT NULL                                 					-- 修改人員 (FK)

    /*FK 設定*/
    ,CONSTRAINT FK_BannerPurchaseLog_Company FOREIGN KEY (COID) REFERENCES Company(COID)
    ,CONSTRAINT FK_BannerPurchaseLog_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_BannerPurchaseLog_BannerSupplierList FOREIGN KEY (BSLID) REFERENCES BannerSupplierList(BSLID)
    ,CONSTRAINT FK_BannerPurchaseLog_BannerSizeType FOREIGN KEY (BSTID) REFERENCES BannerSizeType(BSTID)
    ,CONSTRAINT FK_BannerPurchaseLog_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_BannerPurchaseLog_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)

    /*CHECK 設定*/
    ,CONSTRAINT CHK_BannerPurchaseLog_BPLAmount CHECK (BPLAmount >= 0)
    ,CONSTRAINT CHK_BannerPurchaseLog_BPLUnitPrice CHECK (BPLUnitPrice >= 0)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'帆布訂購', N'Schema', N'dbo', N'Table', N'BannerPurchaseLog';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'帆布訂購編號', N'Schema', N'dbo', N'Table', N'BannerPurchaseLog', N'Column', N'BPLID';
EXEC sp_addextendedproperty N'MS_Description', N'公司', N'Schema', N'dbo', N'Table', N'BannerPurchaseLog', N'Column', N'COID';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'BannerPurchaseLog', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'帆布訂購日期', N'Schema', N'dbo', N'Table', N'BannerPurchaseLog', N'Column', N'BPLDate';
EXEC sp_addextendedproperty N'MS_Description', N'帆布廠商', N'Schema', N'dbo', N'Table', N'BannerPurchaseLog', N'Column', N'BSLID';
EXEC sp_addextendedproperty N'MS_Description', N'帆布類型', N'Schema', N'dbo', N'Table', N'BannerPurchaseLog', N'Column', N'BSTID';
EXEC sp_addextendedproperty N'MS_Description', N'訂購數量', N'Schema', N'dbo', N'Table', N'BannerPurchaseLog', N'Column', N'BPLAmount';
EXEC sp_addextendedproperty N'MS_Description', N'訂購單價', N'Schema', N'dbo', N'Table', N'BannerPurchaseLog', N'Column', N'BPLUnitPrice';
EXEC sp_addextendedproperty N'MS_Description', N'折扣', N'Schema', N'dbo', N'Table', N'BannerPurchaseLog', N'Column', N'BPLDiscount';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'BannerPurchaseLog', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'BannerPurchaseLog', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'BannerPurchaseLog', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'BannerPurchaseLog', N'Column', N'Sys_UpdateBy';
GO



/*【77. 帆布狀態 BannerInventoryStatus】*/
CREATE TABLE BannerInventoryStatus (
    BISID INT IDENTITY(1,1) PRIMARY KEY,        	-- 帆布狀態編號
    BISName NVARCHAR(20) NOT NULL,       	-- 帆布狀態
    BISIsActive BIT NOT NULL DEFAULT 1,       	-- 是否有效 (0:false, 1:true)

    /*CHECK 設定*/
    CONSTRAINT CHK_BannerInventoryStatus_IsActive CHECK (BISIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'帆布狀態表', N'Schema', N'dbo', N'Table', N'BannerInventoryStatus';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'帆布狀態編號', N'Schema', N'dbo', N'Table', N'BannerInventoryStatus', N'Column', N'BISID';
EXEC sp_addextendedproperty N'MS_Description', N'帆布狀態', N'Schema', N'dbo', N'Table', N'BannerInventoryStatus', N'Column', N'BISName';
EXEC sp_addextendedproperty N'MS_Description', N'是否有效', N'Schema', N'dbo', N'Table', N'BannerInventoryStatus', N'Column', N'BISIsActive';
GO



/*【78. 帆布主檔 BannerMainList】*/
CREATE TABLE BannerMainList (
    BMLID INT IDENTITY(1,1) PRIMARY KEY,   	-- 帆布主檔編號
    BSTID INT NOT NULL,                    			-- 帆布類型編號 (FK)
    BMLCode INT NOT NULL,          			-- 帆布代號
    PAID INT NOT NULL,                      			-- 物件編號 (FK)
    BMLDate DATE NOT NULL,                  		-- 日期
    BISID INT NOT NULL,                				-- 帆布狀態編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL                                 					-- 修改人員 (FK)

    /*FK 設定*/
    ,CONSTRAINT FK_BannerMainList_BannerSizeType FOREIGN KEY (BSTID) REFERENCES BannerSizeType(BSTID)
    ,CONSTRAINT FK_BannerMainList_PropertyAsset FOREIGN KEY (PAID) REFERENCES PropertyAsset(PAID)
    ,CONSTRAINT FK_BannerMainList_BannerInventoryStatus FOREIGN KEY (BISID) REFERENCES BannerInventoryStatus(BISID)
    ,CONSTRAINT FK_BannerMainList_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_BannerMainList_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'帆布主檔表', N'Schema', N'dbo', N'Table', N'BannerMainList';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'帆布主檔編號', N'Schema', N'dbo', N'Table', N'BannerMainList', N'Column', N'BMLID';
EXEC sp_addextendedproperty N'MS_Description', N'帆布類型', N'Schema', N'dbo', N'Table', N'BannerMainList', N'Column', N'BSTID';
EXEC sp_addextendedproperty N'MS_Description', N'帆布代號', N'Schema', N'dbo', N'Table', N'BannerMainList', N'Column', N'BMLCode';
EXEC sp_addextendedproperty N'MS_Description', N'物件編號', N'Schema', N'dbo', N'Table', N'BannerMainList', N'Column', N'PAID';
EXEC sp_addextendedproperty N'MS_Description', N'日期', N'Schema', N'dbo', N'Table', N'BannerMainList', N'Column', N'BMLDate';
EXEC sp_addextendedproperty N'MS_Description', N'帆布狀態', N'Schema', N'dbo', N'Table', N'BannerMainList', N'Column', N'BISID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'BannerMainList', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'BannerMainList', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'BannerMainList', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'BannerMainList', N'Column', N'Sys_UpdateBy';
GO



/*【79. 帆布申請類型 BannerApplicationType】*/
CREATE TABLE BannerApplicationType (
    BATID INT IDENTITY(1,1) PRIMARY KEY,    	-- 帆布申請類型編號
    BATType NVARCHAR(20) NOT NULL,  		-- 帆布申請類型
    BATIsActive BIT NOT NULL DEFAULT 1,    	-- 是否有效 (0:false, 1:true)

    /*CHECK 設定*/
    CONSTRAINT CHK_BannerApplicationType_IsActive CHECK (BATIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'帆布申請類型表', N'Schema', N'dbo', N'Table', N'BannerApplicationType';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'帆布申請類型編號', N'Schema', N'dbo', N'Table', N'BannerApplicationType', N'Column', N'BATID';
EXEC sp_addextendedproperty N'MS_Description', N'帆布申請類型', N'Schema', N'dbo', N'Table', N'BannerApplicationType', N'Column', N'BATType';
EXEC sp_addextendedproperty N'MS_Description', N'是否有效', N'Schema', N'dbo', N'Table', N'BannerApplicationType', N'Column', N'BATIsActive';
GO



/*【80. 帆布拆掛申請 BannerRequest】*/
CREATE TABLE BannerRequest (
    BRID INT IDENTITY(1,1) PRIMARY KEY,           		-- 帆布拆掛申請編號
    BATID INT NOT NULL,                             			-- 帆布申請類型編號 (FK)
    EEID INT NOT NULL,                              			-- 員工編號 (FK)
    PAID INT NOT NULL,                              			-- 物件編號 (FK)
    BSTID INT NOT NULL,                             			-- 帆布類型編號 (FK)
    BRAddress NVARCHAR(100) NOT NULL,     		-- 拆掛地址簡述
    BRDescription NVARCHAR(500) NOT NULL, 		-- 拆掛詳情描述
    BSLID INT NOT NULL,                             			-- 帆布廠商編號 (FK)
    BRChargeRate_C DECIMAL(5,2) NOT NULL,     	-- 公司拆算比例
    BRChargeRate_E DECIMAL(5,2) NOT NULL,  		-- 人員拆算比例
    APSID INT NOT NULL,                             			-- 申請狀態編號 (FK)
    BRNote_admin NVARCHAR(500) NULL,            	-- 行政備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)
    Sys_ApprovalDT DATETIME2 NULL,             					-- 審核時間
    Sys_ApprovedBy INT NULL                  						-- 審核人員 (FK)

    /*FK 設定*/
    ,CONSTRAINT FK_BannerRequest_ApplicationType FOREIGN KEY (BATID) REFERENCES BannerApplicationType(BATID)
    ,CONSTRAINT FK_BannerRequest_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_BannerRequest_PropertyAsset FOREIGN KEY (PAID) REFERENCES PropertyAsset(PAID)
    ,CONSTRAINT FK_BannerRequest_BannerSizeType FOREIGN KEY (BSTID) REFERENCES BannerSizeType(BSTID)
    ,CONSTRAINT FK_BannerRequest_BannerSupplierList FOREIGN KEY (BSLID) REFERENCES BannerSupplierList(BSLID)
    ,CONSTRAINT FK_BannerRequest_ApplyStatus FOREIGN KEY (APSID) REFERENCES ApplyStatus(APSID)
    ,CONSTRAINT FK_BannerRequest_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_BannerRequest_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_BannerRequest_ApprovedBy FOREIGN KEY (Sys_ApprovedBy) REFERENCES Employee(EEID)

    /*CHECK 設定*/
    ,CONSTRAINT CHK_BannerRequest_BRChargeRate_C CHECK (BRChargeRate_C >= 0)
    ,CONSTRAINT CHK_BannerRequest_BRChargeRate_E CHECK (BRChargeRate_E >= 0)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'帆布拆掛申請表', N'Schema', N'dbo', N'Table', N'BannerRequest';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'帆布拆掛申請編號', N'Schema', N'dbo', N'Table', N'BannerRequest', N'Column', N'BRID';
EXEC sp_addextendedproperty N'MS_Description', N'帆布申請類型', N'Schema', N'dbo', N'Table', N'BannerRequest', N'Column', N'BATID';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'BannerRequest', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'物件編號', N'Schema', N'dbo', N'Table', N'BannerRequest', N'Column', N'PAID';
EXEC sp_addextendedproperty N'MS_Description', N'帆布類型', N'Schema', N'dbo', N'Table', N'BannerRequest', N'Column', N'BSTID';
EXEC sp_addextendedproperty N'MS_Description', N'拆掛地址簡述', N'Schema', N'dbo', N'Table', N'BannerRequest', N'Column', N'BRAddress';
EXEC sp_addextendedproperty N'MS_Description', N'拆掛詳情描述', N'Schema', N'dbo', N'Table', N'BannerRequest', N'Column', N'BRDescription';
EXEC sp_addextendedproperty N'MS_Description', N'帆布廠商', N'Schema', N'dbo', N'Table', N'BannerRequest', N'Column', N'BSLID';
EXEC sp_addextendedproperty N'MS_Description', N'公司拆算比例', N'Schema', N'dbo', N'Table', N'BannerRequest', N'Column', N'BRChargeRate_C';
EXEC sp_addextendedproperty N'MS_Description', N'人員拆算比例', N'Schema', N'dbo', N'Table', N'BannerRequest', N'Column', N'BRChargeRate_E';
EXEC sp_addextendedproperty N'MS_Description', N'申請狀態', N'Schema', N'dbo', N'Table', N'BannerRequest', N'Column', N'APSID';
EXEC sp_addextendedproperty N'MS_Description', N'行政備註', N'Schema', N'dbo', N'Table', N'BannerRequest', N'Column', N'BRNote_admin';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'BannerRequest', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'BannerRequest', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'BannerRequest', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'BannerRequest', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'審核時間', N'Schema', N'dbo', N'Table', N'BannerRequest', N'Column', N'Sys_ApprovalDT';
EXEC sp_addextendedproperty N'MS_Description', N'審核人員', N'Schema', N'dbo', N'Table', N'BannerRequest', N'Column', N'Sys_ApprovedBy';
GO

/*【81. 帆布拆掛明細 BannerMountDetail】*/
CREATE TABLE BannerMountDetail (
    BMDID INT IDENTITY(1,1) PRIMARY KEY,         	-- 帆布拆掛明細編號
    BRID INT NOT NULL,                             			-- 帆布拆掛申請編號 (FK)
    BMLID INT NOT NULL,                            			-- 帆布主檔編號 (FK)
    BMDDate DATE NOT NULL,                         		-- 拆掛日期
    BMDPhoto NVARCHAR(500) NULL,                   	-- 照片路徑
    BMDNote_admin NVARCHAR(500) NULL,    		-- 備註
    BISID INT NOT NULL,                      				-- 帆布狀態編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL                                					-- 修改人員 (FK)

    /*FK 設定*/
    ,CONSTRAINT FK_BannerMountDetail_Request FOREIGN KEY (BRID) REFERENCES BannerRequest(BRID)
    ,CONSTRAINT FK_BannerMountDetail_MainList FOREIGN KEY (BMLID) REFERENCES BannerMainList(BMLID)
    ,CONSTRAINT FK_BannerMountDetail_InventoryStatus FOREIGN KEY (BISID) REFERENCES BannerInventoryStatus(BISID)
    ,CONSTRAINT FK_BannerMountDetail_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_BannerMountDetail_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'帆布拆掛明細表', N'Schema', N'dbo', N'Table', N'BannerMountDetail';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'帆布拆掛明細編號', N'Schema', N'dbo', N'Table', N'BannerMountDetail', N'Column', N'BMDID';
EXEC sp_addextendedproperty N'MS_Description', N'帆布拆掛申請編號', N'Schema', N'dbo', N'Table', N'BannerMountDetail', N'Column', N'BRID';
EXEC sp_addextendedproperty N'MS_Description', N'帆布主檔編號', N'Schema', N'dbo', N'Table', N'BannerMountDetail', N'Column', N'BMLID';
EXEC sp_addextendedproperty N'MS_Description', N'拆掛日期', N'Schema', N'dbo', N'Table', N'BannerMountDetail', N'Column', N'BMDDate';
EXEC sp_addextendedproperty N'MS_Description', N'照片路徑', N'Schema', N'dbo', N'Table', N'BannerMountDetail', N'Column', N'BMDPhoto';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'BannerMountDetail', N'Column', N'BMDNote_admin';
EXEC sp_addextendedproperty N'MS_Description', N'帆布狀態', N'Schema', N'dbo', N'Table', N'BannerMountDetail', N'Column', N'BISID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'BannerMountDetail', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'BannerMountDetail', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'BannerMountDetail', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'BannerMountDetail', N'Column', N'Sys_UpdateBy';
GO

