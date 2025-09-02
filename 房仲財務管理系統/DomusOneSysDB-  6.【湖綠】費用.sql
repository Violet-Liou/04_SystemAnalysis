use DomusOneSysDB;

/*【103. 帆布費用 BannerExpense】*/
CREATE TABLE BannerExpense (
    BEID INT IDENTITY(1,1) PRIMARY KEY,                 	-- 帆布費用編號
    BMDID INT NOT NULL,                                 		-- 帆布拆掛明細編號 (FK)
    BEDate DATE NOT NULL,                                		-- 費用日期
    BEAmount_Total DECIMAL(10,2) NOT NULL,       	-- 總金額(元)
    BENote NVARCHAR(100) NULL,                          	-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)
    Sys_SubmitDT DATETIME2 NOT NULL,                      			-- 提交時間
    Sys_SubmitBy INT NOT NULL,                           				-- 提交人員 (FK)
    Sys_ApprovalDT DATETIME2 NULL,                        				-- 審核時間
    Sys_ApprovedBy INT NULL                              	 				-- 審核人員 (FK)

    /*CHECK 設定*/
    ,CONSTRAINT CHK_BEAmount_Total CHECK (BEAmount_Total >= 0)

    /*FK 設定*/
    ,CONSTRAINT FK_BannerExpense_BannerMountDetail FOREIGN KEY (BMDID) REFERENCES BannerMountDetail(BMDID)
    ,CONSTRAINT FK_BannerExpense_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_BannerExpense_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_BannerExpense_SubmitBy FOREIGN KEY (Sys_SubmitBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_BannerExpense_ApprovedBy FOREIGN KEY (Sys_ApprovedBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'帆布費用表', N'Schema', N'dbo', N'Table', N'BannerExpense';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'帆布費用編號', N'Schema', N'dbo', N'Table', N'BannerExpense', N'Column', N'BEID';
EXEC sp_addextendedproperty N'MS_Description', N'帆布拆掛明細編號', N'Schema', N'dbo', N'Table', N'BannerExpense', N'Column', N'BMDID';
EXEC sp_addextendedproperty N'MS_Description', N'費用日期', N'Schema', N'dbo', N'Table', N'BannerExpense', N'Column', N'BEDate';
EXEC sp_addextendedproperty N'MS_Description', N'總金額(元)', N'Schema', N'dbo', N'Table', N'BannerExpense', N'Column', N'BEAmount_Total';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'BannerExpense', N'Column', N'BENote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'BannerExpense', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'BannerExpense', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'BannerExpense', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'BannerExpense', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'提交時間', N'Schema', N'dbo', N'Table', N'BannerExpense', N'Column', N'Sys_SubmitDT';
EXEC sp_addextendedproperty N'MS_Description', N'提交人員', N'Schema', N'dbo', N'Table', N'BannerExpense', N'Column', N'Sys_SubmitBy';
EXEC sp_addextendedproperty N'MS_Description', N'審核時間', N'Schema', N'dbo', N'Table', N'BannerExpense', N'Column', N'Sys_ApprovalDT';
EXEC sp_addextendedproperty N'MS_Description', N'審核人員', N'Schema', N'dbo', N'Table', N'BannerExpense', N'Column', N'Sys_ApprovedBy';
GO




/*【104. 帆布費用類型 BannerExpenseType】*/
CREATE TABLE BannerExpenseType (
    BETID INT IDENTITY(1,1) PRIMARY KEY,       	-- 帆布費用類型編號
    BETName NVARCHAR(20) NOT NULL,       	-- 帆布費用類型
    BETIsActive BIT NOT NULL DEFAULT 1       	-- 是否啟用 (0:false,1:true)

    /*CHECK 設定*/
    ,CONSTRAINT CHK_BETIsActive CHECK (BETIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'帆布費用類型表', N'Schema', N'dbo', N'Table', N'BannerExpenseType';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'帆布費用類型編號', N'Schema', N'dbo', N'Table', N'BannerExpenseType', N'Column', N'BETID';
EXEC sp_addextendedproperty N'MS_Description', N'帆布費用類型', N'Schema', N'dbo', N'Table', N'BannerExpenseType', N'Column', N'BETName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'BannerExpenseType', N'Column', N'BETIsActive';
GO




/*【105. 帆布費用明細 BannerExpenseDetail】*/
CREATE TABLE BannerExpenseDetail (
    BEDID INT IDENTITY(1,1) PRIMARY KEY,              	-- 帆布費用明細編號
    BETID INT NOT NULL,                               			-- 帆布費用類型編號 (FK)
    BEDAmount DECIMAL(10,2) NOT NULL,                	-- 金額(元)
    BEDNote NVARCHAR(100) NULL,                       	-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL                               					-- 修改人員 (FK)

    /*CHECK 設定*/
    ,CONSTRAINT CHK_BEDAmount CHECK (BEDAmount >= 0)

    /*FK 設定*/
    ,CONSTRAINT FK_BannerExpenseDetail_BannerExpenseType FOREIGN KEY (BETID) REFERENCES BannerExpenseType(BETID)
    ,CONSTRAINT FK_BannerExpenseDetail_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_BannerExpenseDetail_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'帆布費用明細表', N'Schema', N'dbo', N'Table', N'BannerExpenseDetail';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'帆布費用明細編號', N'Schema', N'dbo', N'Table', N'BannerExpenseDetail', N'Column', N'BEDID';
EXEC sp_addextendedproperty N'MS_Description', N'帆布費用類型', N'Schema', N'dbo', N'Table', N'BannerExpenseDetail', N'Column', N'BETID';
EXEC sp_addextendedproperty N'MS_Description', N'金額(元)', N'Schema', N'dbo', N'Table', N'BannerExpenseDetail', N'Column', N'BEDAmount';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'BannerExpenseDetail', N'Column', N'BEDNote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'BannerExpenseDetail', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'BannerExpenseDetail', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'BannerExpenseDetail', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'BannerExpenseDetail', N'Column', N'Sys_UpdateBy';
GO




/*【106. 帆布費用拆算 BannerExpenseBreakdown】*/
CREATE TABLE BannerExpenseBreakdown (
    BEBID INT IDENTITY(1,1) PRIMARY KEY,               	-- 帆布費用拆算編號
    BEDID INT NOT NULL,                                		-- 帆布費用明細編號 (FK)
    COID INT NOT NULL,                                 		-- 公司編號 (FK)
    BEBAmount_C DECIMAL(10,2) NOT NULL,      		-- 公司拆算金額(元)
    EEID INT NOT NULL,                                 			-- 員工編號 (FK)
    BEBAmount_P DECIMAL(10,2) NOT NULL,          	-- 人員拆算金額(元)
    BEBNote NVARCHAR(100) NULL,                        	-- 備註
    MSID INT NULL,                                     			-- 月度結算編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                        					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                        				-- 修改時間
    Sys_UpdateBy INT NULL                               					-- 修改人員 (FK)

    /*CHECK 設定*/
    ,CONSTRAINT CHK_BEBAmount_C CHECK (BEBAmount_C >= 0)
    ,CONSTRAINT CHK_BEBAmount_P CHECK (BEBAmount_P >= 0)

    /*FK 設定*/
    ,CONSTRAINT FK_BEB_BEDID FOREIGN KEY (BEDID) REFERENCES BannerExpenseDetail(BEDID)
    ,CONSTRAINT FK_BEB_COID FOREIGN KEY (COID) REFERENCES Company(COID)
    ,CONSTRAINT FK_BEB_EEID FOREIGN KEY (EEID) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_BEB_MSID FOREIGN KEY (MSID) REFERENCES MonthlySettlement(MSID)
    ,CONSTRAINT FK_BEB_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_BEB_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'帆布費用拆算表', N'Schema', N'dbo', N'Table', N'BannerExpenseBreakdown';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'帆布費用拆算編號', N'Schema', N'dbo', N'Table', N'BannerExpenseBreakdown', N'Column', N'BEBID';
EXEC sp_addextendedproperty N'MS_Description', N'帆布費用明細編號', N'Schema', N'dbo', N'Table', N'BannerExpenseBreakdown', N'Column', N'BEDID';
EXEC sp_addextendedproperty N'MS_Description', N'公司', N'Schema', N'dbo', N'Table', N'BannerExpenseBreakdown', N'Column', N'COID';
EXEC sp_addextendedproperty N'MS_Description', N'公司拆算金額(元)', N'Schema', N'dbo', N'Table', N'BannerExpenseBreakdown', N'Column', N'BEBAmount_C';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'BannerExpenseBreakdown', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'人員拆算金額(元)', N'Schema', N'dbo', N'Table', N'BannerExpenseBreakdown', N'Column', N'BEBAmount_P';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'BannerExpenseBreakdown', N'Column', N'BEBNote';
EXEC sp_addextendedproperty N'MS_Description', N'結算年月', N'Schema', N'dbo', N'Table', N'BannerExpenseBreakdown', N'Column', N'MSID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'BannerExpenseBreakdown', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'BannerExpenseBreakdown', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'BannerExpenseBreakdown', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'BannerExpenseBreakdown', N'Column', N'Sys_UpdateBy';
GO




/*【107. 帆布費用退款 BannerExpenseRefund】*/
CREATE TABLE BannerExpenseRefund (
    BERID INT IDENTITY(1,1) PRIMARY KEY,              	-- 帆布費用退款編號
    BEBID INT NOT NULL,                                		-- 帆布費用拆算編號 (FK)
    BERAmount_C DECIMAL(10,2) NOT NULL,    		-- 公司拆算金額(元)
    BERAmount_P DECIMAL(10,2) NOT NULL,      		-- 人員拆算金額(元)
    BERNote NVARCHAR(100) NULL,                        	-- 備註
    MSID INT NULL,                                     			-- 月度結算編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                        					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                        				-- 修改時間
    Sys_UpdateBy INT NULL                               					-- 修改人員 (FK)

    /*CHECK 設定*/
    ,CONSTRAINT CHK_BERAmount_C CHECK (BERAmount_C >= 0)
    ,CONSTRAINT CHK_BERAmount_P CHECK (BERAmount_P >= 0)

    /*FK 設定*/
    ,CONSTRAINT FK_BER_BEBID FOREIGN KEY (BEBID) REFERENCES BannerExpenseBreakdown(BEBID)
    ,CONSTRAINT FK_BER_MSID FOREIGN KEY (MSID) REFERENCES MonthlySettlement(MSID)
    ,CONSTRAINT FK_BER_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_BER_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'帆布費用退款表', N'Schema', N'dbo', N'Table', N'BannerExpenseRefund';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'帆布費用退款編號', N'Schema', N'dbo', N'Table', N'BannerExpenseRefund', N'Column', N'BERID';
EXEC sp_addextendedproperty N'MS_Description', N'帆布費用拆算編號', N'Schema', N'dbo', N'Table', N'BannerExpenseRefund', N'Column', N'BEBID';
EXEC sp_addextendedproperty N'MS_Description', N'公司拆算金額(元)', N'Schema', N'dbo', N'Table', N'BannerExpenseRefund', N'Column', N'BERAmount_C';
EXEC sp_addextendedproperty N'MS_Description', N'人員拆算金額(元)', N'Schema', N'dbo', N'Table', N'BannerExpenseRefund', N'Column', N'BERAmount_P';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'BannerExpenseRefund', N'Column', N'BERNote';
EXEC sp_addextendedproperty N'MS_Description', N'結算年月', N'Schema', N'dbo', N'Table', N'BannerExpenseRefund', N'Column', N'MSID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'BannerExpenseRefund', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'BannerExpenseRefund', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'BannerExpenseRefund', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'BannerExpenseRefund', N'Column', N'Sys_UpdateBy';
GO



/*【108. 制服保證金 UniformDeposit】*/
CREATE TABLE UniformDeposit (
    UDID INT IDENTITY(1,1) PRIMARY KEY,       	-- 制服保證金編號
    EEID INT NOT NULL,                        			-- 員工編號 (FK)
    UDDate_D DATE NOT NULL,                   		-- 扣留日期
    UDAmount_D DECIMAL(10,2) NOT NULL,  	-- 扣留金額
    MSID_D INT NULL,                          			-- 扣留結算年月 (FK)
    UDDate_R DATE NULL,                       		-- 退還日期
    UDAmount_R DECIMAL(10,2) NULL,            	-- 退還金額
    MSID_R INT NULL,                         	 		-- 退款結算年月 (FK)
    UDNote NVARCHAR(100) NULL,                	-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)

    /*CHECK 設定*/
    CONSTRAINT CK_UniformDeposit_UDAmount_D CHECK (UDAmount_D >= 0),
    CONSTRAINT CK_UniformDeposit_UDAmount_R CHECK (UDAmount_R IS NULL OR UDAmount_R >= 0),

    /*FK 設定*/
    CONSTRAINT FK_UniformDeposit_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_UniformDeposit_MonthlySettlement_D FOREIGN KEY (MSID_D) REFERENCES MonthlySettlement(MSID),
    CONSTRAINT FK_UniformDeposit_MonthlySettlement_R FOREIGN KEY (MSID_R) REFERENCES MonthlySettlement(MSID),
    CONSTRAINT FK_UniformDeposit_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_UniformDeposit_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'制服保證金', N'Schema', N'dbo', N'Table', N'UniformDeposit';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'制服保證金編號', N'Schema', N'dbo', N'Table', N'UniformDeposit', N'Column', N'UDID';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'UniformDeposit', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'扣留日期', N'Schema', N'dbo', N'Table', N'UniformDeposit', N'Column', N'UDDate_D';
EXEC sp_addextendedproperty N'MS_Description', N'扣留金額', N'Schema', N'dbo', N'Table', N'UniformDeposit', N'Column', N'UDAmount_D';
EXEC sp_addextendedproperty N'MS_Description', N'扣留結算年月', N'Schema', N'dbo', N'Table', N'UniformDeposit', N'Column', N'MSID_D';
EXEC sp_addextendedproperty N'MS_Description', N'退還日期', N'Schema', N'dbo', N'Table', N'UniformDeposit', N'Column', N'UDDate_R';
EXEC sp_addextendedproperty N'MS_Description', N'退還金額', N'Schema', N'dbo', N'Table', N'UniformDeposit', N'Column', N'UDAmount_R';
EXEC sp_addextendedproperty N'MS_Description', N'退款結算年月', N'Schema', N'dbo', N'Table', N'UniformDeposit', N'Column', N'MSID_R';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'UniformDeposit', N'Column', N'UDNote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'UniformDeposit', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'UniformDeposit', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'UniformDeposit', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'UniformDeposit', N'Column', N'Sys_UpdateBy';
GO


/*【109. 制服製作管理 UniformInventory】*/
CREATE TABLE UniformInventory (
    UIID INT IDENTITY(1,1) PRIMARY KEY,        	-- 制服製作編號
    EEID INT NOT NULL,                         			-- 員工編號 (FK)
    UIDate DATE NOT NULL,                      		-- 製作日期
    UITotalAmount DECIMAL(7,2) NOT NULL,    	-- 票據總額
    UIType CHAR(1) NOT NULL,                   		-- 付款方式 (1:自付; 2:公司付;)
    UICate CHAR(1) NOT NULL,                   		-- 費用類別 (0:扣款; 1:退款;)
    UIAmount DECIMAL(7,2) NOT NULL,            	-- 費用金額
    UINote NVARCHAR(100) NULL,                 	-- 備註
    MSID INT NOT NULL,                         		-- 月度結算編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)

    /*CHECK 設定*/
    CONSTRAINT CK_UniformInventory_UITotalAmount CHECK (UITotalAmount >= 0),
    CONSTRAINT CK_UniformInventory_UIAmount CHECK (UIAmount >= 0),
    CONSTRAINT CK_UniformInventory_UIType CHECK (UIType IN ('1','2')),
    CONSTRAINT CK_UniformInventory_UICate CHECK (UICate IN ('0','1')),

    /*FK 設定*/
    CONSTRAINT FK_UniformInventory_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_UniformInventory_MonthlySettlement FOREIGN KEY (MSID) REFERENCES MonthlySettlement(MSID),
    CONSTRAINT FK_UniformInventory_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_UniformInventory_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'制服製作管理', N'Schema', N'dbo', N'Table', N'UniformInventory';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'制服製作編號', N'Schema', N'dbo', N'Table', N'UniformInventory', N'Column', N'UIID';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'UniformInventory', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'製作日期', N'Schema', N'dbo', N'Table', N'UniformInventory', N'Column', N'UIDate';
EXEC sp_addextendedproperty N'MS_Description', N'票據總額', N'Schema', N'dbo', N'Table', N'UniformInventory', N'Column', N'UITotalAmount';
EXEC sp_addextendedproperty N'MS_Description', N'付款方式', N'Schema', N'dbo', N'Table', N'UniformInventory', N'Column', N'UIType';
EXEC sp_addextendedproperty N'MS_Description', N'費用類別', N'Schema', N'dbo', N'Table', N'UniformInventory', N'Column', N'UICate';
EXEC sp_addextendedproperty N'MS_Description', N'費用金額', N'Schema', N'dbo', N'Table', N'UniformInventory', N'Column', N'UIAmount';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'UniformInventory', N'Column', N'UINote';
EXEC sp_addextendedproperty N'MS_Description', N'結算年月', N'Schema', N'dbo', N'Table', N'UniformInventory', N'Column', N'MSID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'UniformInventory', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'UniformInventory', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'UniformInventory', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'UniformInventory', N'Column', N'Sys_UpdateBy';
GO


/*【110. 契據扣款 ContractDeduction】*/
CREATE TABLE ContractDeduction (
    CDID INT IDENTITY(1,1) PRIMARY KEY,        		-- 契據扣款編號
    CMID VARCHAR(15) NOT NULL,                 		-- 契據編號 (FK)
    CDAmount DECIMAL(7,2) NOT NULL,            		-- 扣款金額
    CDIsAnnounced BIT NOT NULL DEFAULT 0,      	-- 是否登報遺失 (0:false, 1:true)
    CDNote NVARCHAR(100) NULL,                 		-- 備註
    MSID INT NOT NULL,                         			-- 月度結算編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)

    /*CHECK 設定*/
    CONSTRAINT CK_ContractDeduction_CDAmount CHECK (CDAmount >= 0),

    /*FK 設定*/
    CONSTRAINT FK_ContractDeduction_ContractMain FOREIGN KEY (CMID) REFERENCES ContractMain(CMID),
    CONSTRAINT FK_ContractDeduction_MonthlySettlement FOREIGN KEY (MSID) REFERENCES MonthlySettlement(MSID),
    CONSTRAINT FK_ContractDeduction_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_ContractDeduction_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'契據扣款', N'Schema', N'dbo', N'Table', N'ContractDeduction';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'契據扣款編號', N'Schema', N'dbo', N'Table', N'ContractDeduction', N'Column', N'CDID';
EXEC sp_addextendedproperty N'MS_Description', N'契據編號', N'Schema', N'dbo', N'Table', N'ContractDeduction', N'Column', N'CMID';
EXEC sp_addextendedproperty N'MS_Description', N'扣款金額', N'Schema', N'dbo', N'Table', N'ContractDeduction', N'Column', N'CDAmount';
EXEC sp_addextendedproperty N'MS_Description', N'是否登報遺失', N'Schema', N'dbo', N'Table', N'ContractDeduction', N'Column', N'CDIsAnnounced';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'ContractDeduction', N'Column', N'CDNote';
EXEC sp_addextendedproperty N'MS_Description', N'結算年月', N'Schema', N'dbo', N'Table', N'ContractDeduction', N'Column', N'MSID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'ContractDeduction', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'ContractDeduction', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'ContractDeduction', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'ContractDeduction', N'Column', N'Sys_UpdateBy';
GO




/*【111. 費用總表 ExpenseMaster】*/
CREATE TABLE ExpenseMaster (
    EMID INT IDENTITY(1,1) PRIMARY KEY,                 			-- 費用總表編號
    EEID INT NOT NULL,                                  				-- 員工編號 (FK)
    EMAd_P DECIMAL(8,2) NOT NULL DEFAULT 0,             		-- 品牌廣告費-扣款
    EMAd_R DECIMAL(8,2) NOT NULL DEFAULT 0,             		-- 品牌廣告費-退款
    EMBanner_P DECIMAL(8,2) NOT NULL DEFAULT 0,         	-- 帆布費用-扣款
    EMBanner_R DECIMAL(8,2) NOT NULL DEFAULT 0,         	-- 帆布費用-退款
    EMTranscript_P DECIMAL(8,2) NOT NULL DEFAULT 0,     	-- 謄本-扣款
    EMTranscript_R DECIMAL(8,2) NOT NULL DEFAULT 0,     	-- 謄本-退款
    EMContract_P DECIMAL(8,2) NOT NULL DEFAULT 0,       	-- 契據-扣款
    EMContract_R DECIMAL(8,2) NOT NULL DEFAULT 0,       	-- 契據-退款
    EMAttendance_P DECIMAL(8,2) NOT NULL DEFAULT 0,     	-- 出勤-扣款
    EMAttendance_R DECIMAL(8,2) NOT NULL DEFAULT 0,     	-- 出勤-退款
    EMUniform_P DECIMAL(8,2) NOT NULL DEFAULT 0,        	-- 制服製作-扣款
    EMUniform_R DECIMAL(8,2) NOT NULL DEFAULT 0,        	-- 制服製作-退款
    EMOther_P DECIMAL(8,2) NOT NULL DEFAULT 0,          	-- 其他扣款
    EMOther_R DECIMAL(8,2) NOT NULL DEFAULT 0,          	-- 其他退款
    EMTotal DECIMAL(8,2) NOT NULL DEFAULT 0,            		-- 總額
    EMNote NVARCHAR(100) NULL,                          			-- 備註
    MSID INT NOT NULL,                                  				-- 月度結算編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,                				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME2 NULL,                         				-- 刪除時間
    Sys_DeleteBy INT NULL,                              					-- 刪除人員 (FK)
    Sys_SubmitDT DATETIME2 NULL,                         				-- 提交時間
    Sys_SubmitBy INT NULL,                              					-- 提交人員 (FK)
    Sys_ApprovalDT DATETIME2 NULL,                       				-- 審核時間
    Sys_ApprovedBy INT NULL,                            					-- 審核人員 (FK)

    /*CHECK 設定*/
    CONSTRAINT CK_ExpenseMaster_IsDelete CHECK (Sys_IsDelete IN (0,1)),

    /*FK 設定*/
    CONSTRAINT FK_ExpenseMaster_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_ExpenseMaster_MSID FOREIGN KEY (MSID) REFERENCES MonthlySettlement(MSID),
    CONSTRAINT FK_ExpenseMaster_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_ExpenseMaster_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_ExpenseMaster_DeleteBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_ExpenseMaster_SubmitBy FOREIGN KEY (Sys_SubmitBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_ExpenseMaster_ApprovedBy FOREIGN KEY (Sys_ApprovedBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'費用總表', N'Schema', N'dbo', N'Table', N'ExpenseMaster';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'費用總表編號', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'EMID';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'品牌廣告費-扣款', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'EMAd_P';
EXEC sp_addextendedproperty N'MS_Description', N'品牌廣告費-退款', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'EMAd_R';
EXEC sp_addextendedproperty N'MS_Description', N'帆布費用-扣款', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'EMBanner_P';
EXEC sp_addextendedproperty N'MS_Description', N'帆布費用-退款', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'EMBanner_R';
EXEC sp_addextendedproperty N'MS_Description', N'謄本-扣款', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'EMTranscript_P';
EXEC sp_addextendedproperty N'MS_Description', N'謄本-退款', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'EMTranscript_R';
EXEC sp_addextendedproperty N'MS_Description', N'契據-扣款', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'EMContract_P';
EXEC sp_addextendedproperty N'MS_Description', N'契據-退款', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'EMContract_R';
EXEC sp_addextendedproperty N'MS_Description', N'出勤-扣款', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'EMAttendance_P';
EXEC sp_addextendedproperty N'MS_Description', N'出勤-退款', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'EMAttendance_R';
EXEC sp_addextendedproperty N'MS_Description', N'制服製作-扣款', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'EMUniform_P';
EXEC sp_addextendedproperty N'MS_Description', N'制服製作-退款', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'EMUniform_R';
EXEC sp_addextendedproperty N'MS_Description', N'其他扣款', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'EMOther_P';
EXEC sp_addextendedproperty N'MS_Description', N'其他退款', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'EMOther_R';
EXEC sp_addextendedproperty N'MS_Description', N'總額', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'EMTotal';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'EMNote';
EXEC sp_addextendedproperty N'MS_Description', N'結算年月', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'MSID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'Sys_DeleteBy';
EXEC sp_addextendedproperty N'MS_Description', N'提交時間', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'Sys_SubmitDT';
EXEC sp_addextendedproperty N'MS_Description', N'提交人員', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'Sys_SubmitBy';
EXEC sp_addextendedproperty N'MS_Description', N'審核時間', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'Sys_ApprovalDT';
EXEC sp_addextendedproperty N'MS_Description', N'審核人員', N'Schema', N'dbo', N'Table', N'ExpenseMaster', N'Column', N'Sys_ApprovedBy';
GO


/*【112. 其他扣退款 ExpenseDetail】*/
CREATE TABLE ExpenseDetail (
    EDID INT IDENTITY(1,1) PRIMARY KEY,                	-- 其他扣退款編號
    EMID INT NOT NULL,                                 		-- 費用總表編號 (FK)
    EDType CHAR(1) NOT NULL,                           		-- 類別 (0:扣款; 1:退款)
    EDDescription NVARCHAR(50) NOT NULL,    		-- 明細
    EDAmount DECIMAL(8,2) NOT NULL DEFAULT 0, 	-- 金額

    /*系統欄位*/
    Sys_CreatedDT DATETIME2 NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                        					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME2 NULL,                        				-- 修改時間
    Sys_UpdateBy INT NULL,                             					-- 修改人員 (FK)

    /*CHECK 設定*/
    CONSTRAINT CK_ExpenseDetail_Type CHECK (EDType IN ('0','1')),
    CONSTRAINT CK_ExpenseDetail_Amount CHECK (EDAmount >= 0),

    /*FK 設定*/
    CONSTRAINT FK_ExpenseDetail_Master FOREIGN KEY (EMID) REFERENCES ExpenseMaster(EMID),
    CONSTRAINT FK_ExpenseDetail_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_ExpenseDetail_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'其他扣退款', N'Schema', N'dbo', N'Table', N'ExpenseDetail';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'其他扣退款編號', N'Schema', N'dbo', N'Table', N'ExpenseDetail', N'Column', N'EDID';
EXEC sp_addextendedproperty N'MS_Description', N'費用總表編號', N'Schema', N'dbo', N'Table', N'ExpenseDetail', N'Column', N'EMID';
EXEC sp_addextendedproperty N'MS_Description', N'類別', N'Schema', N'dbo', N'Table', N'ExpenseDetail', N'Column', N'EDType';
EXEC sp_addextendedproperty N'MS_Description', N'明細', N'Schema', N'dbo', N'Table', N'ExpenseDetail', N'Column', N'EDDescription';
EXEC sp_addextendedproperty N'MS_Description', N'金額', N'Schema', N'dbo', N'Table', N'ExpenseDetail', N'Column', N'EDAmount';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'ExpenseDetail', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'ExpenseDetail', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'ExpenseDetail', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'ExpenseDetail', N'Column', N'Sys_UpdateBy';
GO


