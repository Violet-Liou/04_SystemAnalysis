use DomusOneSysDB;

/*【82. 成交原因 DealClosureType】*/
CREATE TABLE DealClosureType (
    DCTID INT IDENTITY(1,1) PRIMARY KEY,   	-- 成交原因編號
    DCTName NVARCHAR(20) NOT NULL,         	-- 成交原因
    DCTIsActive BIT NOT NULL DEFAULT 1,     	-- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    CONSTRAINT CHK_DealClosureType_IsActive CHECK (DCTIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'成交原因表', N'Schema', N'dbo', N'Table', N'DealClosureType';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'成交原因編號', N'Schema', N'dbo', N'Table', N'DealClosureType', N'Column', N'DCTID';
EXEC sp_addextendedproperty N'MS_Description', N'成交原因', N'Schema', N'dbo', N'Table', N'DealClosureType', N'Column', N'DCTName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'DealClosureType', N'Column', N'DCTIsActive';
GO



/*【83. 案件佣收狀態 CaseCommissionStatus】*/
CREATE TABLE CaseCommissionStatus (
    CCSID INT IDENTITY(1,1) PRIMARY KEY,   	-- 案件佣收狀態編號
    CCSName NVARCHAR(20) NOT NULL,         	-- 案件佣收狀態
    CCSIsActive BIT NOT NULL DEFAULT 1,     	-- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    CONSTRAINT CHK_CaseCommissionStatus_IsActive CHECK (CCSIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'案件佣收狀態表', N'Schema', N'dbo', N'Table', N'CaseCommissionStatus';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'案件佣收狀態編號', N'Schema', N'dbo', N'Table', N'CaseCommissionStatus', N'Column', N'CCSID';
EXEC sp_addextendedproperty N'MS_Description', N'案件佣收狀態', N'Schema', N'dbo', N'Table', N'CaseCommissionStatus', N'Column', N'CCSName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'CaseCommissionStatus', N'Column', N'CCSIsActive';
GO



/*【84. 成交案件 DealClosures】*/
CREATE TABLE DealClosures (
    DCID INT IDENTITY(1,1) PRIMARY KEY,          			-- 成交案件編號
    PAID INT NOT NULL,                            				-- 物件編號 (FK)
    DCTID INT NOT NULL,                           				-- 成交原因編號 (FK)
    DCDate DATE NOT NULL,                         			-- 成交日期
    DCTotalValue DECIMAL(15,2) NOT NULL DEFAULT 0,	-- 成交總額
    DCEstimatedDate DATE NOT NULL,               			-- 預定交屋日
    DCNote NVARCHAR(700) NOT NULL,               		-- 備註
    CCSID INT NOT NULL,                           				-- 案件佣收狀態編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                        					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                        				-- 修改時間
    Sys_UpdateBy INT NULL,                             					-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,              				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,                        				-- 刪除時間
    Sys_DeleteBy INT NULL                              					-- 刪除人員 (FK)

    /*FK 設定*/
    ,CONSTRAINT FK_DealClosures_PropertyAsset FOREIGN KEY (PAID) REFERENCES PropertyAsset(PAID)
    ,CONSTRAINT FK_DealClosures_DealClosureType FOREIGN KEY (DCTID) REFERENCES DealClosureType(DCTID)
    ,CONSTRAINT FK_DealClosures_CaseCommissionStatus FOREIGN KEY (CCSID) REFERENCES CaseCommissionStatus(CCSID)
    ,CONSTRAINT FK_DealClosures_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_DealClosures_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_DealClosures_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID)

    /*CHECK 設定*/
    ,CONSTRAINT CHK_DealClosures_DCTotalValue CHECK (DCTotalValue >= 0)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'成交案件表', N'Schema', N'dbo', N'Table', N'DealClosures';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'成交案件編號', N'Schema', N'dbo', N'Table', N'DealClosures', N'Column', N'DCID';
EXEC sp_addextendedproperty N'MS_Description', N'物件編號', N'Schema', N'dbo', N'Table', N'DealClosures', N'Column', N'PAID';
EXEC sp_addextendedproperty N'MS_Description', N'成交原因', N'Schema', N'dbo', N'Table', N'DealClosures', N'Column', N'DCTID';
EXEC sp_addextendedproperty N'MS_Description', N'成交日期', N'Schema', N'dbo', N'Table', N'DealClosures', N'Column', N'DCDate';
EXEC sp_addextendedproperty N'MS_Description', N'成交總額', N'Schema', N'dbo', N'Table', N'DealClosures', N'Column', N'DCTotalValue';
EXEC sp_addextendedproperty N'MS_Description', N'預定交屋日', N'Schema', N'dbo', N'Table', N'DealClosures', N'Column', N'DCEstimatedDate';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'DealClosures', N'Column', N'DCNote';
EXEC sp_addextendedproperty N'MS_Description', N'案件佣收狀態', N'Schema', N'dbo', N'Table', N'DealClosures', N'Column', N'CCSID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'DealClosures', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'DealClosures', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'DealClosures', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'DealClosures', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'DealClosures', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'DealClosures', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'DealClosures', N'Column', N'Sys_DeleteBy';
GO




/*【85. 永慶公益款 YCCharityFund】*/
CREATE TABLE YCCharityFund (
    YCFID INT IDENTITY(1,1) PRIMARY KEY,      				-- 永慶公益款編號
    DCID INT NOT NULL,                         					-- 成交案件編號 (FK)
    COID INT NOT NULL,                         					-- 公司編號 (FK)
    YCFYCReceivedAmt DECIMAL(7,2) NOT NULL DEFAULT 0,  	-- 永慶收取金額(元)
    YCFInternalAmt DECIMAL(7,2) NOT NULL DEFAULT 0,    	-- 體系內部金額(元)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL                                					-- 修改人員 (FK)

    /*FK 設定*/
    ,CONSTRAINT FK_YCCharityFund_DealClosures FOREIGN KEY (DCID) REFERENCES DealClosures(DCID)
    ,CONSTRAINT FK_YCCharityFund_Company FOREIGN KEY (COID) REFERENCES Company(COID)
    ,CONSTRAINT FK_YCCharityFund_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_YCCharityFund_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)

    /*CHECK 設定*/
    ,CONSTRAINT CHK_YCCharityFund_YCFYCReceivedAmt CHECK (YCFYCReceivedAmt >= 0)
    ,CONSTRAINT CHK_YCCharityFund_YCFInternalAmt CHECK (YCFInternalAmt >= 0)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'永慶公益款表', N'Schema', N'dbo', N'Table', N'YCCharityFund';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'永慶公益款編號', N'Schema', N'dbo', N'Table', N'YCCharityFund', N'Column', N'YCFID';
EXEC sp_addextendedproperty N'MS_Description', N'成交案件編號', N'Schema', N'dbo', N'Table', N'YCCharityFund', N'Column', N'DCID';
EXEC sp_addextendedproperty N'MS_Description', N'公司', N'Schema', N'dbo', N'Table', N'YCCharityFund', N'Column', N'COID';
EXEC sp_addextendedproperty N'MS_Description', N'永慶收取金額(元)', N'Schema', N'dbo', N'Table', N'YCCharityFund', N'Column', N'YCFYCReceivedAmt';
EXEC sp_addextendedproperty N'MS_Description', N'體系內部金額(元)', N'Schema', N'dbo', N'Table', N'YCCharityFund', N'Column', N'YCFInternalAmt';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'YCCharityFund', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'YCCharityFund', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'YCCharityFund', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'YCCharityFund', N'Column', N'Sys_UpdateBy';
GO




/*【86. 佣收類別 CommissionRevenueType】*/
CREATE TABLE CommissionRevenueType (
    CRTID INT IDENTITY(1,1) PRIMARY KEY,   	-- 佣收類別編號
    CRTName NVARCHAR(20) NOT NULL,         	-- 佣收類別
    CRTIsActive BIT NOT NULL DEFAULT 1,     	-- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    CONSTRAINT CHK_CommissionRevenueType_IsActive CHECK (CRTIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'佣收類別表', N'Schema', N'dbo', N'Table', N'CommissionRevenueType';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'佣收類別編號', N'Schema', N'dbo', N'Table', N'CommissionRevenueType', N'Column', N'CRTID';
EXEC sp_addextendedproperty N'MS_Description', N'佣收類別', N'Schema', N'dbo', N'Table', N'CommissionRevenueType', N'Column', N'CRTName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'CommissionRevenueType', N'Column', N'CRTIsActive';
GO




/*【87. 案件佣收單 CaseCommissionMain】*/
CREATE TABLE CaseCommissionMain (
    CCMID INT IDENTITY(1,1) PRIMARY KEY,       			-- 案件佣收單編號
    PAID INT NOT NULL,                          				-- 物件編號 (FK)
    DCID INT NOT NULL,                          				-- 成交案件編號 (FK)
    CRTID INT NOT NULL,                         				-- 佣收類別編號 (FK)
    CCMDate DATE NOT NULL,                       			-- 佣收單成立日
    CCMBrokerFee DECIMAL(15,2) NULL DEFAULT 0,  		-- 中人費(元)
    CCMGuarantee NVARCHAR(100) NULL,            		-- 履保證號
    CCMNote NVARCHAR(500) NULL,                 			-- 備註
    CCSID INT NOT NULL,                          				-- 案件佣收狀態編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,                				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,                          				-- 刪除時間
    Sys_DeleteBy INT NULL,                               					-- 刪除人員 (FK)
    Sys_SubmitDT DATETIME NULL,                          				-- 提交時間
    Sys_SubmitBy INT NULL,                               					-- 提交人員 (FK)
    Sys_ApprovalDT DATETIME NULL,                        				-- 審核時間
    Sys_ApprovedBy INT NULL                               				-- 審核人員 (FK)

    /*FK 設定*/
    ,CONSTRAINT FK_CaseCommissionMain_PropertyAsset FOREIGN KEY (PAID) REFERENCES PropertyAsset(PAID)
    ,CONSTRAINT FK_CaseCommissionMain_DealClosures FOREIGN KEY (DCID) REFERENCES DealClosures(DCID)
    ,CONSTRAINT FK_CaseCommissionMain_CommissionRevenueType FOREIGN KEY (CRTID) REFERENCES CommissionRevenueType(CRTID)
    ,CONSTRAINT FK_CaseCommissionMain_CaseCommissionStatus FOREIGN KEY (CCSID) REFERENCES CaseCommissionStatus(CCSID)
    ,CONSTRAINT FK_CaseCommissionMain_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_CaseCommissionMain_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_CaseCommissionMain_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_CaseCommissionMain_SubmitBy FOREIGN KEY (Sys_SubmitBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_CaseCommissionMain_ApprovedBy FOREIGN KEY (Sys_ApprovedBy) REFERENCES Employee(EEID)

    /*CHECK 設定*/
    ,CONSTRAINT CHK_CaseCommissionMain_CCMBrokerFee CHECK (CCMBrokerFee >= 0)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'案件佣收單表', N'Schema', N'dbo', N'Table', N'CaseCommissionMain';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'案件佣收單編號', N'Schema', N'dbo', N'Table', N'CaseCommissionMain', N'Column', N'CCMID';
EXEC sp_addextendedproperty N'MS_Description', N'物件編號', N'Schema', N'dbo', N'Table', N'CaseCommissionMain', N'Column', N'PAID';
EXEC sp_addextendedproperty N'MS_Description', N'成交案件編號', N'Schema', N'dbo', N'Table', N'CaseCommissionMain', N'Column', N'DCID';
EXEC sp_addextendedproperty N'MS_Description', N'佣收類別', N'Schema', N'dbo', N'Table', N'CaseCommissionMain', N'Column', N'CRTID';
EXEC sp_addextendedproperty N'MS_Description', N'佣收單成立日', N'Schema', N'dbo', N'Table', N'CaseCommissionMain', N'Column', N'CCMDate';
EXEC sp_addextendedproperty N'MS_Description', N'中人費(元)', N'Schema', N'dbo', N'Table', N'CaseCommissionMain', N'Column', N'CCMBrokerFee';
EXEC sp_addextendedproperty N'MS_Description', N'履保證號', N'Schema', N'dbo', N'Table', N'CaseCommissionMain', N'Column', N'CCMGuarantee';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'CaseCommissionMain', N'Column', N'CCMNote';
EXEC sp_addextendedproperty N'MS_Description', N'案件佣收狀態', N'Schema', N'dbo', N'Table', N'CaseCommissionMain', N'Column', N'CCSID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'CaseCommissionMain', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'CaseCommissionMain', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'CaseCommissionMain', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'CaseCommissionMain', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'CaseCommissionMain', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'CaseCommissionMain', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'CaseCommissionMain', N'Column', N'Sys_DeleteBy';
EXEC sp_addextendedproperty N'MS_Description', N'提交時間', N'Schema', N'dbo', N'Table', N'CaseCommissionMain', N'Column', N'Sys_SubmitDT';
EXEC sp_addextendedproperty N'MS_Description', N'提交人員', N'Schema', N'dbo', N'Table', N'CaseCommissionMain', N'Column', N'Sys_SubmitBy';
EXEC sp_addextendedproperty N'MS_Description', N'審核時間', N'Schema', N'dbo', N'Table', N'CaseCommissionMain', N'Column', N'Sys_ApprovalDT';
EXEC sp_addextendedproperty N'MS_Description', N'審核人員', N'Schema', N'dbo', N'Table', N'CaseCommissionMain', N'Column', N'Sys_ApprovedBy';
GO



/*【88. 佣收明細 CaseCommissionDetail】*/
CREATE TABLE CaseCommissionDetail (
    CCDID INT IDENTITY(1,1) PRIMARY KEY,       				-- 佣收明細編號
    CCMID INT NOT NULL,                          					-- 案件佣收單編號 (FK)
    CCDType CHAR(1) NOT NULL,                    				-- 收支身分 (D:開發; M:行銷)
    CCDTotal DECIMAL(15,2) NOT NULL DEFAULT 0,   		-- 總實收(元)
    CCDGuarAmount DECIMAL(15,2) NOT NULL DEFAULT 0,  	-- 履保金額(元)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL                               					-- 修改人員 (FK)

    /*FK 設定*/
    ,CONSTRAINT FK_CaseCommissionDetail_CaseCommissionMain FOREIGN KEY (CCMID) REFERENCES CaseCommissionMain(CCMID)
    ,CONSTRAINT FK_CaseCommissionDetail_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_CaseCommissionDetail_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)

    /*CHECK 設定*/
    ,CONSTRAINT CHK_CaseCommissionDetail_CCDTotal CHECK (CCDTotal >= 0)
    ,CONSTRAINT CHK_CaseCommissionDetail_CCDGuarAmount CHECK (CCDGuarAmount >= 0)
    ,CONSTRAINT CHK_CaseCommissionDetail_CCDType CHECK (CCDType IN ('D','M'))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'佣收明細表', N'Schema', N'dbo', N'Table', N'CaseCommissionDetail';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'佣收明細編號', N'Schema', N'dbo', N'Table', N'CaseCommissionDetail', N'Column', N'CCDID';
EXEC sp_addextendedproperty N'MS_Description', N'案件佣收單', N'Schema', N'dbo', N'Table', N'CaseCommissionDetail', N'Column', N'CCMID';
EXEC sp_addextendedproperty N'MS_Description', N'收支身分', N'Schema', N'dbo', N'Table', N'CaseCommissionDetail', N'Column', N'CCDType';
EXEC sp_addextendedproperty N'MS_Description', N'總實收(元)', N'Schema', N'dbo', N'Table', N'CaseCommissionDetail', N'Column', N'CCDTotal';
EXEC sp_addextendedproperty N'MS_Description', N'履保金額(元)', N'Schema', N'dbo', N'Table', N'CaseCommissionDetail', N'Column', N'CCDGuarAmount';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'CaseCommissionDetail', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'CaseCommissionDetail', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'CaseCommissionDetail', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'CaseCommissionDetail', N'Column', N'Sys_UpdateBy';
GO




/*【89. 佣收項目類別 CommissionEntryType】*/
CREATE TABLE CommissionEntryType (
    CETID INT IDENTITY(1,1) PRIMARY KEY,       	-- 佣收項目類別編號
    CETType CHAR(1) NOT NULL,                  		-- 類型 (0:加項; 1:扣項)
    CETName NVARCHAR(20) NOT NULL,       	-- 佣收項目類別
    CETIsActive BIT NOT NULL DEFAULT 1,        	-- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    ,CONSTRAINT CHK_CommissionEntryType_CETType CHECK (CETType IN ('0','1'))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'佣收項目類別表', N'Schema', N'dbo', N'Table', N'CommissionEntryType';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'佣收項目類別編號', N'Schema', N'dbo', N'Table', N'CommissionEntryType', N'Column', N'CETID';
EXEC sp_addextendedproperty N'MS_Description', N'類型', N'Schema', N'dbo', N'Table', N'CommissionEntryType', N'Column', N'CETType';
EXEC sp_addextendedproperty N'MS_Description', N'佣收項目類別', N'Schema', N'dbo', N'Table', N'CommissionEntryType', N'Column', N'CETName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'CommissionEntryType', N'Column', N'CETIsActive';
GO

/*【90. 佣收項目 CommissionEntry】*/
CREATE TABLE CommissionEntry (
    CEID INT IDENTITY(1,1) PRIMARY KEY,       			-- 佣收項目編號
    CCDID INT NOT NULL,                          				-- 佣收明細編號 (FK)
    CETID INT NOT NULL,                          				-- 佣收項目類別編號 (FK)
    CEName NVARCHAR(30) NOT NULL,                 		-- 項目描述
    CEAmount DECIMAL(15,2) NOT NULL DEFAULT 0,  	-- 金額(元)
    CENote NVARCHAR(100) NULL,                    			-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL                               					-- 修改人員 (FK)

    /*FK 設定*/
    ,CONSTRAINT FK_CommissionEntry_CaseCommissionDetail FOREIGN KEY (CCDID) REFERENCES CaseCommissionDetail(CCDID)
    ,CONSTRAINT FK_CommissionEntry_CommissionEntryType FOREIGN KEY (CETID) REFERENCES CommissionEntryType(CETID)
    ,CONSTRAINT FK_CommissionEntry_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_CommissionEntry_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)

    /*CHECK 設定*/
    ,CONSTRAINT CHK_CommissionEntry_CEAmount CHECK (CEAmount >= 0)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'佣收項目表', N'Schema', N'dbo', N'Table', N'CommissionEntry';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'佣收項目編號', N'Schema', N'dbo', N'Table', N'CommissionEntry', N'Column', N'CEID';
EXEC sp_addextendedproperty N'MS_Description', N'佣收明細編號', N'Schema', N'dbo', N'Table', N'CommissionEntry', N'Column', N'CCDID';
EXEC sp_addextendedproperty N'MS_Description', N'佣收項目類別', N'Schema', N'dbo', N'Table', N'CommissionEntry', N'Column', N'CETID';
EXEC sp_addextendedproperty N'MS_Description', N'項目描述', N'Schema', N'dbo', N'Table', N'CommissionEntry', N'Column', N'CEName';
EXEC sp_addextendedproperty N'MS_Description', N'金額(元)', N'Schema', N'dbo', N'Table', N'CommissionEntry', N'Column', N'CEAmount';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'CommissionEntry', N'Column', N'CENote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'CommissionEntry', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'CommissionEntry', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'CommissionEntry', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'CommissionEntry', N'Column', N'Sys_UpdateBy';
GO



/*【91. 成交客戶明細 CaseCommissionCustomer】*/
CREATE TABLE CaseCommissionCustomer (
    CCCID INT IDENTITY(1,1) PRIMARY KEY,       			-- 成交客戶明細編號
    CCMID INT NOT NULL,                          				-- 案件佣收單編號 (FK)
    CPMID INT NOT NULL,                          				-- 客戶資料編號 (FK)
    CCCNote NVARCHAR(100) NULL,                   			-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL                               					-- 修改人員 (FK)

    /*FK 設定*/
    ,CONSTRAINT FK_CaseCommissionCustomer_CaseCommissionMain FOREIGN KEY (CCMID) REFERENCES CaseCommissionMain(CCMID)
    ,CONSTRAINT FK_CaseCommissionCustomer_CustomerProfileMain FOREIGN KEY (CPMID) REFERENCES CustomerProfileMain(CPMID)
    ,CONSTRAINT FK_CaseCommissionCustomer_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_CaseCommissionCustomer_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'成交客戶明細表', N'Schema', N'dbo', N'Table', N'CaseCommissionCustomer';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'成交客戶明細編號', N'Schema', N'dbo', N'Table', N'CaseCommissionCustomer', N'Column', N'CCCID';
EXEC sp_addextendedproperty N'MS_Description', N'案件佣收單', N'Schema', N'dbo', N'Table', N'CaseCommissionCustomer', N'Column', N'CCMID';
EXEC sp_addextendedproperty N'MS_Description', N'客戶', N'Schema', N'dbo', N'Table', N'CaseCommissionCustomer', N'Column', N'CPMID';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'CaseCommissionCustomer', N'Column', N'CCCNote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'CaseCommissionCustomer', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'CaseCommissionCustomer', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'CaseCommissionCustomer', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'CaseCommissionCustomer', N'Column', N'Sys_UpdateBy';
GO

/*【92. 業績分配表 CommissionPerfAllocation】*/
CREATE TABLE CommissionPerfAllocation (
    CPAID INT IDENTITY(1,1) PRIMARY KEY,       				-- 業績分配編號
    CCMID INT NOT NULL,                          					-- 案件佣收單編號 (FK)
    EEID INT NOT NULL,                           					-- 員工編號 (FK)
    JAID INT NOT NULL,                           					-- 任職記錄編號 (FK)
    CPAType CHAR(1) NOT NULL,                    				-- 收支身分 (D:開發; M:行銷)
    CPAPercentage DECIMAL(5,2) NOT NULL DEFAULT 0, 		-- 業績分配比例(%)
    CPAAmount DECIMAL(15,2) NOT NULL DEFAULT 0, 		-- 業績(元)
    CPACharity DECIMAL(7,2) NOT NULL DEFAULT 0, 			-- 公益款(元)
    CPANote NVARCHAR(100) NULL,                    			-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL                               					-- 修改人員 (FK)

    /*FK 設定*/
    ,CONSTRAINT FK_CommissionPerfAllocation_CaseCommissionMain FOREIGN KEY (CCMID) REFERENCES CaseCommissionMain(CCMID)
    ,CONSTRAINT FK_CommissionPerfAllocation_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_CommissionPerfAllocation_JobAssignments FOREIGN KEY (JAID) REFERENCES JobAssignments(JAID)
    ,CONSTRAINT FK_CommissionPerfAllocation_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_CommissionPerfAllocation_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)

    /*CHECK 設定*/
    ,CONSTRAINT CHK_CommissionPerfAllocation_CPAType CHECK (CPAType IN ('D','M'))
    ,CONSTRAINT CHK_CommissionPerfAllocation_CPAPercentage CHECK (CPAPercentage >= 0 AND CPAPercentage <= 100)
    ,CONSTRAINT CHK_CommissionPerfAllocation_CPAAmount CHECK (CPAAmount >= 0)
    ,CONSTRAINT CHK_CommissionPerfAllocation_CPACharity CHECK (CPACharity >= 0)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'業績分配表', N'Schema', N'dbo', N'Table', N'CommissionPerfAllocation';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'業績分配編號', N'Schema', N'dbo', N'Table', N'CommissionPerfAllocation', N'Column', N'CPAAID';
EXEC sp_addextendedproperty N'MS_Description', N'案件佣收單', N'Schema', N'dbo', N'Table', N'CommissionPerfAllocation', N'Column', N'CCMID';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'CommissionPerfAllocation', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'任職記錄編號', N'Schema', N'dbo', N'Table', N'CommissionPerfAllocation', N'Column', N'JAID';
EXEC sp_addextendedproperty N'MS_Description', N'收支身分', N'Schema', N'dbo', N'Table', N'CommissionPerfAllocation', N'Column', N'CPAType';
EXEC sp_addextendedproperty N'MS_Description', N'業績分配比例(%)', N'Schema', N'dbo', N'Table', N'CommissionPerfAllocation', N'Column', N'CPAPercentage';
EXEC sp_addextendedproperty N'MS_Description', N'業績(元)', N'Schema', N'dbo', N'Table', N'CommissionPerfAllocation', N'Column', N'CPAAmount';
EXEC sp_addextendedproperty N'MS_Description', N'公益款(元)', N'Schema', N'dbo', N'Table', N'CommissionPerfAllocation', N'Column', N'CPACharity';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'CommissionPerfAllocation', N'Column', N'CPANote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'CommissionPerfAllocation', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'CommissionPerfAllocation', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'CommissionPerfAllocation', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'CommissionPerfAllocation', N'Column', N'Sys_UpdateBy';
GO



/*【93. 收付對象類別 TransactionPartyType】*/
CREATE TABLE TransactionPartyType (
    TPTID INT IDENTITY(1,1) PRIMARY KEY,      	-- 收付對象類別編號
    TPTName NVARCHAR(20) NOT NULL,      	-- 收付對象類別
    TPTIsActive BIT NOT NULL DEFAULT 1           	-- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    ,CONSTRAINT CHK_TransactionPartyType_IsActive CHECK (TPTIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'收付對象類別表', N'Schema', N'dbo', N'Table', N'TransactionPartyType';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'收付對象類別編號', N'Schema', N'dbo', N'Table', N'TransactionPartyType', N'Column', N'TPTID';
EXEC sp_addextendedproperty N'MS_Description', N'收付對象類別', N'Schema', N'dbo', N'Table', N'TransactionPartyType', N'Column', N'TPTName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'TransactionPartyType', N'Column', N'TPTIsActive';
GO




/*【94. 帳款狀態 ARAPStatus】*/
CREATE TABLE ARAPStatus (
    AASID INT IDENTITY(1,1) PRIMARY KEY,         -- 帳款狀態編號
    AASName NVARCHAR(20) NOT NULL,     	-- 帳款狀態
    AASIsActive BIT NOT NULL DEFAULT 1           -- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    ,CONSTRAINT CHK_ARAPStatus_IsActive CHECK (AASIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'帳款狀態表', N'Schema', N'dbo', N'Table', N'ARAPStatus';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'帳款狀態編號', N'Schema', N'dbo', N'Table', N'ARAPStatus', N'Column', N'AASID';
EXEC sp_addextendedproperty N'MS_Description', N'帳款狀態', N'Schema', N'dbo', N'Table', N'ARAPStatus', N'Column', N'AASName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'ARAPStatus', N'Column', N'AASIsActive';
GO



/*【95. 應收付帳款 ARAPTransaction】*/
CREATE TABLE ARAPTransaction (
    AATID INT IDENTITY(1,1) PRIMARY KEY,                		-- 應收付帳款編號
    CCMID INT NOT NULL,                                  			-- 案件佣收單編號 (FK)
    COID INT NOT NULL,                                  			-- 公司編號 (FK)
    AATType CHAR(1) NOT NULL,                            		-- 收付類型 (R:收款; P:付款)
    AATPartyType CHAR(1) NOT NULL,                       		-- 收支身分 (D:開發; M:行銷)
    TPTID INT NOT NULL,                                  			-- 收付對象類別編號 (FK)
    AATEntity NVARCHAR(30) NOT NULL,                     	-- 對象名稱
    AATAmount DECIMAL(15,2) NOT NULL DEFAULT 0,   	-- 金額(元)
    AASID INT NOT NULL,                                  			-- 帳款狀態編號 (FK)
    AATNote NVARCHAR(100) NULL,                          		-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_ARAPTransaction_CaseCommissionMain FOREIGN KEY (CCMID) REFERENCES CaseCommissionMain(CCMID),
    CONSTRAINT FK_ARAPTransaction_Company FOREIGN KEY (COID) REFERENCES Company(COID),
    CONSTRAINT FK_ARAPTransaction_TransactionPartyType FOREIGN KEY (TPTID) REFERENCES TransactionPartyType(TPTID),
    CONSTRAINT FK_ARAPTransaction_ARAPStatus FOREIGN KEY (AASID) REFERENCES ARAPStatus(AASID),
    CONSTRAINT FK_ARAPTransaction_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_ARAPTransaction_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),

    /*CHECK 設定*/
    CONSTRAINT CHK_ARAPTransaction_AATType CHECK (AATType IN ('R','P')),
    CONSTRAINT CHK_ARAPTransaction_AATPartyType CHECK (AATPartyType IN ('D','M')),
    CONSTRAINT CHK_ARAPTransaction_AATAmount CHECK (AATAmount >= 0)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'應收付帳款表', N'Schema', N'dbo', N'Table', N'ARAPTransaction';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'應收付帳款編號', N'Schema', N'dbo', N'Table', N'ARAPTransaction', N'Column', N'AATID';
EXEC sp_addextendedproperty N'MS_Description', N'案件佣收單', N'Schema', N'dbo', N'Table', N'ARAPTransaction', N'Column', N'CCMID';
EXEC sp_addextendedproperty N'MS_Description', N'公司', N'Schema', N'dbo', N'Table', N'ARAPTransaction', N'Column', N'COID';
EXEC sp_addextendedproperty N'MS_Description', N'收付類型', N'Schema', N'dbo', N'Table', N'ARAPTransaction', N'Column', N'AATType';
EXEC sp_addextendedproperty N'MS_Description', N'收支身分', N'Schema', N'dbo', N'Table', N'ARAPTransaction', N'Column', N'AATPartyType';
EXEC sp_addextendedproperty N'MS_Description', N'收付對象類別', N'Schema', N'dbo', N'Table', N'ARAPTransaction', N'Column', N'TPTID';
EXEC sp_addextendedproperty N'MS_Description', N'對象名稱', N'Schema', N'dbo', N'Table', N'ARAPTransaction', N'Column', N'AATEntity';
EXEC sp_addextendedproperty N'MS_Description', N'金額(元)', N'Schema', N'dbo', N'Table', N'ARAPTransaction', N'Column', N'AATAmount';
EXEC sp_addextendedproperty N'MS_Description', N'帳款狀態', N'Schema', N'dbo', N'Table', N'ARAPTransaction', N'Column', N'AASID';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'ARAPTransaction', N'Column', N'AATNote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'ARAPTransaction', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'ARAPTransaction', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'ARAPTransaction', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'ARAPTransaction', N'Column', N'Sys_UpdateBy';
GO




/*【96. 應收付帳款紀錄表 ARAPTransactionLog】*/
CREATE TABLE ARAPTransactionLog (
    ATLID INT IDENTITY(1,1) PRIMARY KEY,          -- 應收付帳款紀錄編號
    AATID INT NOT NULL,                            		-- 應收付帳款編號 (FK)
    ATLType CHAR(1) NOT NULL,                      	-- 收付類型 (R:收款; P:付款)
    ATLDate DATE NOT NULL,                          	-- 收付日期
    ATLAmount DECIMAL(15,2) NOT NULL,      	-- 金額(元)
    ATLNote NVARCHAR(100) NULL,                    -- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL                               					-- 修改人員 (FK)

    /*FK 設定*/
    ,CONSTRAINT FK_ARAPTransactionLog_ARAPTransaction FOREIGN KEY (AATID) REFERENCES ARAPTransaction(AATID)
    ,CONSTRAINT FK_ARAPTransactionLog_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_ARAPTransactionLog_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)

    /*CHECK 設定*/
    ,CONSTRAINT CHK_ARAPTransactionLog_ATLType CHECK (ATLType IN ('R','P'))
    ,CONSTRAINT CHK_ARAPTransactionLog_ATLAmount CHECK (ATLAmount >= 0)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'應收付帳款紀錄表', N'Schema', N'dbo', N'Table', N'ARAPTransactionLog';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'應收付帳款紀錄編號', N'Schema', N'dbo', N'Table', N'ARAPTransactionLog', N'Column', N'ATLID';
EXEC sp_addextendedproperty N'MS_Description', N'應收付帳款編號', N'Schema', N'dbo', N'Table', N'ARAPTransactionLog', N'Column', N'AATID';
EXEC sp_addextendedproperty N'MS_Description', N'收付類型', N'Schema', N'dbo', N'Table', N'ARAPTransactionLog', N'Column', N'ATLType';
EXEC sp_addextendedproperty N'MS_Description', N'收付日期', N'Schema', N'dbo', N'Table', N'ARAPTransactionLog', N'Column', N'ATLDate';
EXEC sp_addextendedproperty N'MS_Description', N'金額(元)', N'Schema', N'dbo', N'Table', N'ARAPTransactionLog', N'Column', N'ATLAmount';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'ARAPTransactionLog', N'Column', N'ATLNote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'ARAPTransactionLog', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'ARAPTransactionLog', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'ARAPTransactionLog', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'ARAPTransactionLog', N'Column', N'Sys_UpdateBy';
GO



/*【97. 發票狀態 InvoiceStatus】*/
CREATE TABLE InvoiceStatus (
    ISID INT IDENTITY(1,1) PRIMARY KEY,      	-- 發票狀態編號
    ISName NVARCHAR(20) NOT NULL,            	-- 發票狀態
    ISIsActive BIT NOT NULL DEFAULT 1        	-- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    ,CONSTRAINT CHK_InvoiceStatus_IsActive CHECK (ISIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'發票狀態表', N'Schema', N'dbo', N'Table', N'InvoiceStatus';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'發票狀態編號', N'Schema', N'dbo', N'Table', N'InvoiceStatus', N'Column', N'ISID';
EXEC sp_addextendedproperty N'MS_Description', N'發票狀態', N'Schema', N'dbo', N'Table', N'InvoiceStatus', N'Column', N'ISName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'InvoiceStatus', N'Column', N'ISIsActive';
GO




/*【98. 發票開立類型 InvoiceType】*/
CREATE TABLE InvoiceType (
    ITID INT IDENTITY(1,1) PRIMARY KEY,      	-- 發票開立類型編號
    ITName NVARCHAR(20) NOT NULL,        	-- 發票開立類型
    ITIsActive BIT NOT NULL DEFAULT 1        	-- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    ,CONSTRAINT CHK_InvoiceType_IsActive CHECK (ITIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'發票開立類型表', N'Schema', N'dbo', N'Table', N'InvoiceType';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'發票開立類型編號', N'Schema', N'dbo', N'Table', N'InvoiceType', N'Column', N'ITID';
EXEC sp_addextendedproperty N'MS_Description', N'發票開立類型', N'Schema', N'dbo', N'Table', N'InvoiceType', N'Column', N'ITName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'InvoiceType', N'Column', N'ITIsActive';
GO




/*【99. 發票主檔 InvoiceMain】*/
CREATE TABLE InvoiceMain (
    IMID INT IDENTITY(1,1) PRIMARY KEY,             			-- 發票主檔編號
    COID INT NOT NULL,                               					-- 公司編號 (FK)
    IMNumber NVARCHAR(20) NOT NULL UNIQUE,          		-- 發票號碼
    IMType CHAR(1) NOT NULL,                         				-- 收開類別 (0:開票; 1:收票)
    IMDate DATE NOT NULL,                             				-- 發票日期
    IMBuyer CHAR(1) NOT NULL,                         				-- 買受人 (D:開發; M:行銷)
    IMTaxID VARCHAR(8) NOT NULL,                      			-- 統編
    ITID INT NOT NULL,                                					-- 發票開立類型編號 (FK)
    IMAmount_before DECIMAL(15,2) NOT NULL DEFAULT 0,	-- 稅前總額(元)
    IMAmount_tax DECIMAL(15,2) NOT NULL DEFAULT 0,   	-- 營業稅額(元)
    IMAmount_after DECIMAL(15,2) NOT NULL DEFAULT 0, 	-- 銷售額(元)
    IMNote NVARCHAR(100) NULL,                        			-- 備註
    ISID INT NOT NULL,                                					-- 發票狀態編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                       					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_InvoiceMain_Company FOREIGN KEY (COID) REFERENCES Company(COID),
    CONSTRAINT FK_InvoiceMain_InvoiceType FOREIGN KEY (ITID) REFERENCES InvoiceType(ITID),
    CONSTRAINT FK_InvoiceMain_InvoiceStatus FOREIGN KEY (ISID) REFERENCES InvoiceStatus(ISID),
    CONSTRAINT FK_InvoiceMain_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_InvoiceMain_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),

    /*CHECK 設定*/
    CONSTRAINT CHK_InvoiceMain_IMType CHECK (IMType IN ('0','1')),
    CONSTRAINT CHK_InvoiceMain_IMBuyer CHECK (IMBuyer IN ('D','M')),
    CONSTRAINT CHK_InvoiceMain_Amounts CHECK (IMAmount_before >= 0 AND IMAmount_tax >= 0 AND IMAmount_after >= 0)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'發票主檔表', N'Schema', N'dbo', N'Table', N'InvoiceMain';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'發票主檔編號', N'Schema', N'dbo', N'Table', N'InvoiceMain', N'Column', N'IMID';
EXEC sp_addextendedproperty N'MS_Description', N'公司', N'Schema', N'dbo', N'Table', N'InvoiceMain', N'Column', N'COID';
EXEC sp_addextendedproperty N'MS_Description', N'發票號碼', N'Schema', N'dbo', N'Table', N'InvoiceMain', N'Column', N'IMNumber';
EXEC sp_addextendedproperty N'MS_Description', N'收開類別', N'Schema', N'dbo', N'Table', N'InvoiceMain', N'Column', N'IMType';
EXEC sp_addextendedproperty N'MS_Description', N'發票日期', N'Schema', N'dbo', N'Table', N'InvoiceMain', N'Column', N'IMDate';
EXEC sp_addextendedproperty N'MS_Description', N'買受人', N'Schema', N'dbo', N'Table', N'InvoiceMain', N'Column', N'IMBuyer';
EXEC sp_addextendedproperty N'MS_Description', N'統編', N'Schema', N'dbo', N'Table', N'InvoiceMain', N'Column', N'IMTaxID';
EXEC sp_addextendedproperty N'MS_Description', N'發票開立類型', N'Schema', N'dbo', N'Table', N'InvoiceMain', N'Column', N'ITID';
EXEC sp_addextendedproperty N'MS_Description', N'稅前總額(元)', N'Schema', N'dbo', N'Table', N'InvoiceMain', N'Column', N'IMAmount_before';
EXEC sp_addextendedproperty N'MS_Description', N'營業稅額(元)', N'Schema', N'dbo', N'Table', N'InvoiceMain', N'Column', N'IMAmount_tax';
EXEC sp_addextendedproperty N'MS_Description', N'銷售額(元)', N'Schema', N'dbo', N'Table', N'InvoiceMain', N'Column', N'IMAmount_after';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'InvoiceMain', N'Column', N'IMNote';
EXEC sp_addextendedproperty N'MS_Description', N'發票狀態', N'Schema', N'dbo', N'Table', N'InvoiceMain', N'Column', N'ISID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'InvoiceMain', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'InvoiceMain', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'InvoiceMain', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'InvoiceMain', N'Column', N'Sys_UpdateBy';
GO




/*【100. 發票明細 InvoiceDetail】*/
CREATE TABLE InvoiceDetail (
    IDID INT IDENTITY(1,1) PRIMARY KEY,      	-- 發票明細編號
    IMID INT NOT NULL,                        			-- 發票主檔編號 (FK)
    IDItem NVARCHAR(50) NOT NULL,             	-- 發票明細
    IDAmount DECIMAL(15,2) NOT NULL,          	-- 金額(元)
    CIID INT NULL,                             			-- 佣收項目編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                        					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_InvoiceDetail_InvoiceMain FOREIGN KEY (IMID) REFERENCES InvoiceMain(IMID),
    CONSTRAINT FK_InvoiceDetail_CommissionItem FOREIGN KEY (CIID) REFERENCES CommissionItem(CIID),
    CONSTRAINT FK_InvoiceDetail_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_InvoiceDetail_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),

    /*CHECK 設定*/
    CONSTRAINT CHK_InvoiceDetail_IDAmount CHECK (IDAmount >= 0)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'發票明細表', N'Schema', N'dbo', N'Table', N'InvoiceDetail';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'發票明細編號', N'Schema', N'dbo', N'Table', N'InvoiceDetail', N'Column', N'IDID';
EXEC sp_addextendedproperty N'MS_Description', N'發票主檔編號', N'Schema', N'dbo', N'Table', N'InvoiceDetail', N'Column', N'IMID';
EXEC sp_addextendedproperty N'MS_Description', N'發票明細', N'Schema', N'dbo', N'Table', N'InvoiceDetail', N'Column', N'IDItem';
EXEC sp_addextendedproperty N'MS_Description', N'金額(元)', N'Schema', N'dbo', N'Table', N'InvoiceDetail', N'Column', N'IDAmount';
EXEC sp_addextendedproperty N'MS_Description', N'佣收項目', N'Schema', N'dbo', N'Table', N'InvoiceDetail', N'Column', N'CIID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'InvoiceDetail', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'InvoiceDetail', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'InvoiceDetail', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'InvoiceDetail', N'Column', N'Sys_UpdateBy';
GO

