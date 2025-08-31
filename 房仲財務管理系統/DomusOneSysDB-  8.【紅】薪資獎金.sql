use DomusOneSysDB;

/*【101. 月度結算狀態 MonthlySettlementStatus】*/
CREATE TABLE MonthlySettlementStatus (
    MSSID INT IDENTITY(1,1) PRIMARY KEY,    	-- 月度結算狀態編號
    MSSName NVARCHAR(20) NOT NULL,          -- 月度結算狀態
    MSSIsActive BIT NOT NULL DEFAULT 1      	-- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    ,CONSTRAINT CHK_MonthlySettlementStatus_IsActive CHECK (MSSIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'月度結算狀態表', N'Schema', N'dbo', N'Table', N'MonthlySettlementStatus';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'月度結算狀態編號', N'Schema', N'dbo', N'Table', N'MonthlySettlementStatus', N'Column', N'MSSID';
EXEC sp_addextendedproperty N'MS_Description', N'月度結算狀態', N'Schema', N'dbo', N'Table', N'MonthlySettlementStatus', N'Column', N'MSSName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'MonthlySettlementStatus', N'Column', N'MSSIsActive';
GO



/*【102. 月度結算 MonthlySettlement】*/
CREATE TABLE MonthlySettlement (
    MSID INT IDENTITY(1,1) PRIMARY KEY,         	-- 月度結算編號
    MSMonthYear VARCHAR(7) NOT NULL,  	-- 所屬年月 (EX:2025/07)
    MSStartDate DATE NOT NULL,                  	-- 計算起始日
    MSEndDate DATE NOT NULL,                    	-- 計算截止日
    MSPayDate DATE NULL,                        		-- 實際發薪日
    MSSID INT NOT NULL,                          		-- 月度結算狀態編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                            				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                             				-- 修改時間
    Sys_UpdateBy INT NULL,                                  					-- 修改人員 (FK)
    Sys_PreliminaryDT DATETIME NOT NULL,                   			-- 試算時間
    Sys_PreliminaryBy INT NOT NULL,                        				-- 試算人員 (FK)
    Sys_FinalizedDT DATETIME NULL,                          				-- 結算時間
    Sys_FinalizedBy INT NULL,                                				-- 結算人員 (FK)

    /*CHECK 設定*/
    CONSTRAINT CHK_MonthlySettlement_Dates CHECK (MSStartDate <= MSEndDate),

    /*FK 設定*/
    CONSTRAINT FK_MonthlySettlement_Status FOREIGN KEY (MSSID) REFERENCES MonthlySettlementStatus(MSSID),
    CONSTRAINT FK_MonthlySettlement_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_MonthlySettlement_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_MonthlySettlement_PreliminaryBy FOREIGN KEY (Sys_PreliminaryBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_MonthlySettlement_FinalizedBy FOREIGN KEY (Sys_FinalizedBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'月度結算表', N'Schema', N'dbo', N'Table', N'MonthlySettlement';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'月度結算編號', N'Schema', N'dbo', N'Table', N'MonthlySettlement', N'Column', N'MSID';
EXEC sp_addextendedproperty N'MS_Description', N'所屬年月', N'Schema', N'dbo', N'Table', N'MonthlySettlement', N'Column', N'MSMonthYear';
EXEC sp_addextendedproperty N'MS_Description', N'計算起始日', N'Schema', N'dbo', N'Table', N'MonthlySettlement', N'Column', N'MSStartDate';
EXEC sp_addextendedproperty N'MS_Description', N'計算截止日', N'Schema', N'dbo', N'Table', N'MonthlySettlement', N'Column', N'MSEndDate';
EXEC sp_addextendedproperty N'MS_Description', N'實際發薪日', N'Schema', N'dbo', N'Table', N'MonthlySettlement', N'Column', N'MSPayDate';
EXEC sp_addextendedproperty N'MS_Description', N'月度結算狀態', N'Schema', N'dbo', N'Table', N'MonthlySettlement', N'Column', N'MSSID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'MonthlySettlement', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'MonthlySettlement', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'MonthlySettlement', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'MonthlySettlement', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'試算時間', N'Schema', N'dbo', N'Table', N'MonthlySettlement', N'Column', N'Sys_PreliminaryDT';
EXEC sp_addextendedproperty N'MS_Description', N'試算人員', N'Schema', N'dbo', N'Table', N'MonthlySettlement', N'Column', N'Sys_PreliminaryBy';
EXEC sp_addextendedproperty N'MS_Description', N'結算時間', N'Schema', N'dbo', N'Table', N'MonthlySettlement', N'Column', N'Sys_FinalizedDT';
EXEC sp_addextendedproperty N'MS_Description', N'結算人員', N'Schema', N'dbo', N'Table', N'MonthlySettlement', N'Column', N'Sys_FinalizedBy';
GO



/*【118. 獎金拆算主檔 BonusAllocaationMain】*/
CREATE TABLE BonusAllocaationMain (
    BAMID INT IDENTITY(1,1) PRIMARY KEY,                   			-- 獎金拆算主檔編號
    CPAID INT NOT NULL,                                    					-- 業績分配編號 (FK)
    BAMPerf_Total DECIMAL(15,2) NOT NULL DEFAULT 0,        	-- 本次拆算總業績(元)
    BAMBonus DECIMAL(15,2) NOT NULL DEFAULT 0,             		-- 本次拆算獎金(元)
    BAMNote NVARCHAR(250) NULL,                            				-- 備註
    MSID INT NOT NULL,                                     					-- 月度結算編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),     		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                            					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                            					-- 修改時間
    Sys_UpdateBy INT NULL,                                 						-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,                   				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,                            					-- 刪除時間
    Sys_DeleteBy INT NULL,                                 						-- 刪除人員 (FK)

    /*CHECK 設定*/
    CONSTRAINT CHK_BonusAllocaationMain_BAMPerf_Total CHECK (BAMPerf_Total >= 0),
    CONSTRAINT CHK_BonusAllocaationMain_BAMBonus CHECK (BAMBonus >= 0),

    /*FK 設定*/
    CONSTRAINT FK_BonusAllocaationMain_CommissionPerfAllocation FOREIGN KEY (CPAID) REFERENCES CommissionPerfAllocation(CPAID),
    CONSTRAINT FK_BonusAllocaationMain_MonthlySettlement FOREIGN KEY (MSID) REFERENCES MonthlySettlement(MSID),
    CONSTRAINT FK_BonusAllocaationMain_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_BonusAllocaationMain_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_BonusAllocaationMain_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'獎金拆算主檔', N'Schema', N'dbo', N'Table', N'BonusAllocaationMain';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'獎金拆算主檔編號', N'Schema', N'dbo', N'Table', N'BonusAllocaationMain', N'Column', N'BAMID';
EXEC sp_addextendedproperty N'MS_Description', N'業績分配編號', N'Schema', N'dbo', N'Table', N'BonusAllocaationMain', N'Column', N'CPAID';
EXEC sp_addextendedproperty N'MS_Description', N'本次拆算總業績(元)', N'Schema', N'dbo', N'Table', N'BonusAllocaationMain', N'Column', N'BAMPerf_Total';
EXEC sp_addextendedproperty N'MS_Description', N'本次拆算獎金(元)', N'Schema', N'dbo', N'Table', N'BonusAllocaationMain', N'Column', N'BAMBonus';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'BonusAllocaationMain', N'Column', N'BAMNote';
EXEC sp_addextendedproperty N'MS_Description', N'結算年月', N'Schema', N'dbo', N'Table', N'BonusAllocaationMain', N'Column', N'MSID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'BonusAllocaationMain', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'BonusAllocaationMain', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'BonusAllocaationMain', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'BonusAllocaationMain', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'BonusAllocaationMain', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'BonusAllocaationMain', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'BonusAllocaationMain', N'Column', N'Sys_DeleteBy';
GO


/*【119. 獎金拆算明細 BonusAllocaationDetail】*/
CREATE TABLE BonusAllocaationDetail (
    BADID INT IDENTITY(1,1) PRIMARY KEY,                  			-- 獎金拆算明細編號
    BAMID INT NOT NULL,                                   					-- 獎金拆算主檔編號 (FK)
    BSAID INT NOT NULL,                                   					-- 人員規章套用編號 (FK)
    BADPerformance DECIMAL(15,2) NOT NULL DEFAULT 0,      	-- 業績(元)
    BADTax DECIMAL(15,2) NOT NULL DEFAULT 0,              		-- 稅金(元)
    BADPercentage DECIMAL(5,2) NOT NULL DEFAULT 0,        		-- 獎金比例(%)
    BADBonus DECIMAL(15,2) NOT NULL DEFAULT 0,            		-- 業績獎金(元)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),    		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                           						-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                           					-- 修改時間
    Sys_UpdateBy INT NULL,                                						-- 修改人員 (FK)

    /*CHECK 設定*/
    CONSTRAINT CHK_BonusAllocaationDetail_BADPerformance CHECK (BADPerformance >= 0),
    CONSTRAINT CHK_BonusAllocaationDetail_BADTax CHECK (BADTax >= 0),
    CONSTRAINT CHK_BonusAllocaationDetail_BADPercentage CHECK (BADPercentage >= 0 AND BADPercentage <= 100),
    CONSTRAINT CHK_BonusAllocaationDetail_BADBonus CHECK (BADBonus >= 0),

    /*FK 設定*/
    CONSTRAINT FK_BonusAllocaationDetail_BonusAllocaationMain FOREIGN KEY (BAMID) REFERENCES BonusAllocaationMain(BAMID),
    CONSTRAINT FK_BonusAllocaationDetail_BonusStructureAssignment FOREIGN KEY (BSAID) REFERENCES BonusStructureAssignment(BSAID),
    CONSTRAINT FK_BonusAllocaationDetail_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_BonusAllocaationDetail_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'獎金拆算明細', N'Schema', N'dbo', N'Table', N'BonusAllocaationDetail';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'獎金拆算明細編號', N'Schema', N'dbo', N'Table', N'BonusAllocaationDetail', N'Column', N'BADID';
EXEC sp_addextendedproperty N'MS_Description', N'獎金拆算主檔編號', N'Schema', N'dbo', N'Table', N'BonusAllocaationDetail', N'Column', N'BAMID';
EXEC sp_addextendedproperty N'MS_Description', N'規章套用', N'Schema', N'dbo', N'Table', N'BonusAllocaationDetail', N'Column', N'BSAID';
EXEC sp_addextendedproperty N'MS_Description', N'業績(元)', N'Schema', N'dbo', N'Table', N'BonusAllocaationDetail', N'Column', N'BADPerformance';
EXEC sp_addextendedproperty N'MS_Description', N'稅金(元)', N'Schema', N'dbo', N'Table', N'BonusAllocaationDetail', N'Column', N'BADTax';
EXEC sp_addextendedproperty N'MS_Description', N'獎金比例(%)', N'Schema', N'dbo', N'Table', N'BonusAllocaationDetail', N'Column', N'BADPercentage';
EXEC sp_addextendedproperty N'MS_Description', N'業績獎金(元)', N'Schema', N'dbo', N'Table', N'BonusAllocaationDetail', N'Column', N'BADBonus';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'BonusAllocaationDetail', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'BonusAllocaationDetail', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'BonusAllocaationDetail', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'BonusAllocaationDetail', N'Column', N'Sys_UpdateBy';
GO



/*【120. 人員年度累積業績 EmployeeBonusSummary】*/
CREATE TABLE EmployeeBonusSummary (
    EBSID INT IDENTITY(1,1) PRIMARY KEY,           			-- 人員年度累積業績編號
    EEID INT NOT NULL,                             						-- 員工編號 (FK)
    EBSYear CHAR(4) NOT NULL,                      					-- 所屬年度 (格式:YYYY)
    EBSPerformance DECIMAL(15,2) NOT NULL DEFAULT 0,  	-- 累積業績(元)
    EBSPercentage DECIMAL(5,2) NOT NULL DEFAULT 0,    	-- 獎金比例(%)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                        					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                        				-- 修改時間
    Sys_UpdateBy INT NULL,                             						-- 修改人員 (FK)

    /*CHECK 設定*/
    CONSTRAINT CK_EBS_Year CHECK (EBSYear LIKE '[0-9][0-9][0-9][0-9]'),
    CONSTRAINT CK_EBS_Percentage CHECK (EBSPercentage >= 0 AND EBSPercentage <= 100),

    /*FK 設定*/
    CONSTRAINT FK_EBS_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_EBS_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_EBS_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'人員年度累積業績表', N'Schema', N'dbo', N'Table', N'EmployeeBonusSummary';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'人員年度累積業績編號', N'Schema', N'dbo', N'Table', N'EmployeeBonusSummary', N'Column', N'EBSID';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'EmployeeBonusSummary', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'所屬年度', N'Schema', N'dbo', N'Table', N'EmployeeBonusSummary', N'Column', N'EBSYear';
EXEC sp_addextendedproperty N'MS_Description', N'累積業績(元)', N'Schema', N'dbo', N'Table', N'EmployeeBonusSummary', N'Column', N'EBSPerformance';
EXEC sp_addextendedproperty N'MS_Description', N'獎金比例(%)', N'Schema', N'dbo', N'Table', N'EmployeeBonusSummary', N'Column', N'EBSPercentage';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'EmployeeBonusSummary', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'EmployeeBonusSummary', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'EmployeeBonusSummary', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'EmployeeBonusSummary', N'Column', N'Sys_UpdateBy';
GO





/*【121. 人員年度累積明細 EmployeeBonusDetail】*/
CREATE TABLE EmployeeBonusDetail (
    EBDID INT IDENTITY(1,1) PRIMARY KEY,           			-- 人員年度累積明細編號
    EBSID INT NOT NULL,                            					-- 人員年度累積業績編號 (FK)
    BAMID INT NOT NULL,                            					-- 獎金拆算主檔編號 (FK)
    EBDSequence INT NOT NULL,                      				-- 年度案件序號
    EBDPerf_S DECIMAL(15,2) NOT NULL DEFAULT 0,    		-- 本次起始業績(元)
    EBDPerf_E DECIMAL(15,2) NOT NULL DEFAULT 0,    		-- 累積後業績(元)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                        						-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                        					-- 修改時間
    Sys_UpdateBy INT NULL,                             							-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,               					-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,                        						-- 刪除時間
    Sys_DeleteBy INT NULL,                             							-- 刪除人員 (FK)

    /*CHECK 設定*/
    CONSTRAINT CK_EBD_Sequence CHECK (EBDSequence > 0),

    /*FK 設定*/
    CONSTRAINT FK_EBD_EBS FOREIGN KEY (EBSID) REFERENCES EmployeeBonusSummary(EBSID),
    CONSTRAINT FK_EBD_BAM FOREIGN KEY (BAMID) REFERENCES BonusAllocaationMain(BAMID),
    CONSTRAINT FK_EBD_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_EBD_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_EBD_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'人員年度累積明細表', N'Schema', N'dbo', N'Table', N'EmployeeBonusDetail';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'人員年度累積明細編號', N'Schema', N'dbo', N'Table', N'EmployeeBonusDetail', N'Column', N'EBDID';
EXEC sp_addextendedproperty N'MS_Description', N'人員年度累積業績', N'Schema', N'dbo', N'Table', N'EmployeeBonusDetail', N'Column', N'EBSID';
EXEC sp_addextendedproperty N'MS_Description', N'獎金拆算主檔編號', N'Schema', N'dbo', N'Table', N'EmployeeBonusDetail', N'Column', N'BAMID';
EXEC sp_addextendedproperty N'MS_Description', N'年度案件序號', N'Schema', N'dbo', N'Table', N'EmployeeBonusDetail', N'Column', N'EBDSequence';
EXEC sp_addextendedproperty N'MS_Description', N'本次起始業績(元)', N'Schema', N'dbo', N'Table', N'EmployeeBonusDetail', N'Column', N'EBDPerf_S';
EXEC sp_addextendedproperty N'MS_Description', N'累積後業績(元)', N'Schema', N'dbo', N'Table', N'EmployeeBonusDetail', N'Column', N'EBDPerf_E';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'EmployeeBonusDetail', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'EmployeeBonusDetail', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'EmployeeBonusDetail', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'EmployeeBonusDetail', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'EmployeeBonusDetail', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'EmployeeBonusDetail', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'EmployeeBonusDetail', N'Column', N'Sys_DeleteBy';
GO



/*【122. 回饋獎金 IncentiveBonusRecords】*/
CREATE TABLE IncentiveBonusRecords (
    IBRID INT IDENTITY(1,1) PRIMARY KEY,               			-- 回饋獎金編號
    BAMID INT NOT NULL,                                					-- 獎金拆算主檔編號 (FK)
    BSAID INT NOT NULL,                                					-- 人員規章套用編號 (FK)
    EEID INT NOT NULL,                                 					-- 回饋人員(員工編號) (FK)
    IBRPerformance DECIMAL(15,2) NOT NULL DEFAULT 0,   	-- 業績(元)
    IBRTax DECIMAL(15,2) NOT NULL DEFAULT 0,           		-- 稅金(元)
    IBRPercentage DECIMAL(5,2) NOT NULL DEFAULT 0,     	-- 獎金比例(%)
    IBRBonus DECIMAL(15,2) NOT NULL DEFAULT 0,         		-- 回饋獎金(元)
    IBRNote NVARCHAR(500) NULL,                        			-- 備註
    MSID INT NOT NULL,                                 					-- 月度結算編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                        					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                        				-- 修改時間
    Sys_UpdateBy INT NULL,                             						-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,               				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,                        					-- 刪除時間
    Sys_DeleteBy INT NULL,                             						-- 刪除人員 (FK)

    /*CHECK 設定*/
    CONSTRAINT CK_IncentiveBonusRecords_Percentage CHECK (IBRPercentage >= 0 AND IBRPercentage <= 100),
    CONSTRAINT CK_IncentiveBonusRecords_Performance CHECK (IBRPerformance >= 0),
    CONSTRAINT CK_IncentiveBonusRecords_Tax CHECK (IBRTax >= 0),
    CONSTRAINT CK_IncentiveBonusRecords_Bonus CHECK (IBRBonus >= 0),

    /*FK 設定*/
    CONSTRAINT FK_IncentiveBonusRecords_BAMID FOREIGN KEY (BAMID) REFERENCES BonusAllocaationMain(BAMID),
    CONSTRAINT FK_IncentiveBonusRecords_BSAID FOREIGN KEY (BSAID) REFERENCES BonusStructureAssignment(BSAID),
    CONSTRAINT FK_IncentiveBonusRecords_EEID FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_IncentiveBonusRecords_MSID FOREIGN KEY (MSID) REFERENCES MonthlySettlement(MSID),
    CONSTRAINT FK_IncentiveBonusRecords_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_IncentiveBonusRecords_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_IncentiveBonusRecords_DeleteBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'回饋獎金表', N'Schema', N'dbo', N'Table', N'IncentiveBonusRecords';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'回饋獎金編號', N'Schema', N'dbo', N'Table', N'IncentiveBonusRecords', N'Column', N'IBRID';
EXEC sp_addextendedproperty N'MS_Description', N'獎金拆算主檔編號', N'Schema', N'dbo', N'Table', N'IncentiveBonusRecords', N'Column', N'BAMID';
EXEC sp_addextendedproperty N'MS_Description', N'規章套用', N'Schema', N'dbo', N'Table', N'IncentiveBonusRecords', N'Column', N'BSAID';
EXEC sp_addextendedproperty N'MS_Description', N'回饋人員', N'Schema', N'dbo', N'Table', N'IncentiveBonusRecords', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'業績(元)', N'Schema', N'dbo', N'Table', N'IncentiveBonusRecords', N'Column', N'IBRPerformance';
EXEC sp_addextendedproperty N'MS_Description', N'稅金(元)', N'Schema', N'dbo', N'Table', N'IncentiveBonusRecords', N'Column', N'IBRTax';
EXEC sp_addextendedproperty N'MS_Description', N'獎金比例(%)', N'Schema', N'dbo', N'Table', N'IncentiveBonusRecords', N'Column', N'IBRPercentage';
EXEC sp_addextendedproperty N'MS_Description', N'回饋獎金(元)', N'Schema', N'dbo', N'Table', N'IncentiveBonusRecords', N'Column', N'IBRBonus';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'IncentiveBonusRecords', N'Column', N'IBRNote';
EXEC sp_addextendedproperty N'MS_Description', N'結算年月', N'Schema', N'dbo', N'Table', N'IncentiveBonusRecords', N'Column', N'MSID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'IncentiveBonusRecords', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'IncentiveBonusRecords', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'IncentiveBonusRecords', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'IncentiveBonusRecords', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'IncentiveBonusRecords', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'IncentiveBonusRecords', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'IncentiveBonusRecords', N'Column', N'Sys_DeleteBy';
GO



/*【123. 主管績效獎金 SupervisorPerformance】*/
CREATE TABLE SupervisorPerformance (
    SPID INT IDENTITY(1,1) PRIMARY KEY,                     		-- 主管績效獎金編號
    BAMID INT NOT NULL,                                     				-- 獎金拆算主檔編號 (FK)
    BSAID INT NOT NULL,                                     				-- 人員規章套用編號 (FK)
    EEID INT NOT NULL,                                      				-- 主管 (員工編號) (FK)
    SPPerformance DECIMAL(15,2) NOT NULL DEFAULT 0,  	-- 業績(元)
    SPTax DECIMAL(15,2) NOT NULL DEFAULT 0,                 	-- 稅金(元)
    SPPercentage DECIMAL(5,2) NOT NULL DEFAULT 0,           	-- 獎金比例(%)
    SPBonus DECIMAL(15,2) NOT NULL DEFAULT 0,               	-- 主管領導獎金(元)
    SPNote NVARCHAR(500) NULL,                              			-- 備註
    MSID INT NOT NULL,                                      				-- 月度結算編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),      	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                             					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                             					-- 修改時間
    Sys_UpdateBy INT NULL,                                  						-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,                    				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,                             					-- 刪除時間
    Sys_DeleteBy INT NULL,                                  						-- 刪除人員 (FK)

    /*CHECK 設定*/
    CONSTRAINT CK_SupervisorPerformance_SPPerformance CHECK (SPPerformance >= 0),
    CONSTRAINT CK_SupervisorPerformance_SPTax CHECK (SPTax >= 0),
    CONSTRAINT CK_SupervisorPerformance_SPPercentage CHECK (SPPercentage >= 0 AND SPPercentage <= 100),
    CONSTRAINT CK_SupervisorPerformance_SPBonus CHECK (SPBonus >= 0),
    CONSTRAINT CK_SupervisorPerformance_SysIsDelete CHECK (Sys_IsDelete IN (0,1)),


    /*FK 設定*/
    CONSTRAINT FK_SupervisorPerformance_BAM FOREIGN KEY (BAMID) REFERENCES BonusAllocaationMain(BAMID),
    CONSTRAINT FK_SupervisorPerformance_BSA FOREIGN KEY (BSAID) REFERENCES BonusStructureAssignment(BSAID),
    CONSTRAINT FK_SupervisorPerformance_EE FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_SupervisorPerformance_MS FOREIGN KEY (MSID) REFERENCES MonthlySettlement(MSID),
    CONSTRAINT FK_SupervisorPerformance_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_SupervisorPerformance_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_SupervisorPerformance_DeleteBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'主管績效獎金表', N'Schema', N'dbo', N'Table', N'SupervisorPerformance';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'主管績效獎金編號', N'Schema', N'dbo', N'Table', N'SupervisorPerformance', N'Column', N'SPID';
EXEC sp_addextendedproperty N'MS_Description', N'獎金拆算主檔編號', N'Schema', N'dbo', N'Table', N'SupervisorPerformance', N'Column', N'BAMID';
EXEC sp_addextendedproperty N'MS_Description', N'規章套用', N'Schema', N'dbo', N'Table', N'SupervisorPerformance', N'Column', N'BSAID';
EXEC sp_addextendedproperty N'MS_Description', N'主管', N'Schema', N'dbo', N'Table', N'SupervisorPerformance', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'業績(元)', N'Schema', N'dbo', N'Table', N'SupervisorPerformance', N'Column', N'SPPerformance';
EXEC sp_addextendedproperty N'MS_Description', N'稅金(元)', N'Schema', N'dbo', N'Table', N'SupervisorPerformance', N'Column', N'SPTax';
EXEC sp_addextendedproperty N'MS_Description', N'獎金比例(%)', N'Schema', N'dbo', N'Table', N'SupervisorPerformance', N'Column', N'SPPercentage';
EXEC sp_addextendedproperty N'MS_Description', N'主管領導獎金(元)', N'Schema', N'dbo', N'Table', N'SupervisorPerformance', N'Column', N'SPBonus';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'SupervisorPerformance', N'Column', N'SPNote';
EXEC sp_addextendedproperty N'MS_Description', N'結算年月', N'Schema', N'dbo', N'Table', N'SupervisorPerformance', N'Column', N'MSID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'SupervisorPerformance', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'SupervisorPerformance', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'SupervisorPerformance', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'SupervisorPerformance', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'SupervisorPerformance', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'SupervisorPerformance', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'SupervisorPerformance', N'Column', N'Sys_DeleteBy';
GO



/*【124. 店長績效獎金 ExecutivePerformance】*/
CREATE TABLE ExecutivePerformance (
    EPID INT IDENTITY(1,1) PRIMARY KEY,        				-- 店長績效獎金編號
    BAMID INT NOT NULL,                        						-- 獎金拆算主檔編號 (FK)
    BSAID INT NOT NULL,                        						-- 人員規章套用編號 (FK)
    EEID INT NOT NULL,                         						-- 店長 (員工編號) (FK)
    EPPerformance DECIMAL(15,2) NOT NULL DEFAULT 0,  	-- 業績(元)
    EPTax DECIMAL(15,2) NOT NULL DEFAULT 0,         	 	-- 稅金(元)
    EPPercentage DECIMAL(5,2) NOT NULL DEFAULT 0,    		-- 獎金比例(%)
    EPBonus DECIMAL(15,2) NOT NULL DEFAULT 0,        		-- 店長領導獎金(元)
    EPNote NVARCHAR(500) NULL,                 					-- 備註
    MSID INT NOT NULL,                         						-- 月度結算編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,                				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,                         					-- 刪除時間
    Sys_DeleteBy INT NULL,                              						-- 刪除人員 (FK)

    /*CHECK 設定*/
    CONSTRAINT CK_ExecutivePerformance_EPPerformance CHECK (EPPerformance >= 0),
    CONSTRAINT CK_ExecutivePerformance_EPTax CHECK (EPTax >= 0),
    CONSTRAINT CK_ExecutivePerformance_Percentage CHECK (EPPercentage >= 0 AND EPPercentage <= 100),
    CONSTRAINT CK_ExecutivePerformance_EPBonus CHECK (EPBonus >= 0),
    CONSTRAINT CK_ExecutivePerformance_Delete CHECK (Sys_IsDelete IN (0,1)),

    /*FK 設定*/
    CONSTRAINT FK_ExecutivePerformance_BAM FOREIGN KEY (BAMID) REFERENCES BonusAllocationMain(BAMID),
    CONSTRAINT FK_ExecutivePerformance_BSA FOREIGN KEY (BSAID) REFERENCES BonusStructureAssignment(BSAID),
    CONSTRAINT FK_ExecutivePerformance_EE FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_ExecutivePerformance_MS FOREIGN KEY (MSID) REFERENCES MonthlySettlement(MSID),
    CONSTRAINT FK_ExecutivePerformance_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_ExecutivePerformance_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_ExecutivePerformance_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'店長績效獎金表', N'Schema', N'dbo', N'Table', N'ExecutivePerformance';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'店長績效獎金編號', N'Schema', N'dbo', N'Table', N'ExecutivePerformance', N'Column', N'EPID';
EXEC sp_addextendedproperty N'MS_Description', N'獎金拆算主檔編號', N'Schema', N'dbo', N'Table', N'ExecutivePerformance', N'Column', N'BAMID';
EXEC sp_addextendedproperty N'MS_Description', N'規章套用', N'Schema', N'dbo', N'Table', N'ExecutivePerformance', N'Column', N'BSAID';
EXEC sp_addextendedproperty N'MS_Description', N'店長', N'Schema', N'dbo', N'Table', N'ExecutivePerformance', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'業績(元)', N'Schema', N'dbo', N'Table', N'ExecutivePerformance', N'Column', N'EPPerformance';
EXEC sp_addextendedproperty N'MS_Description', N'稅金(元)', N'Schema', N'dbo', N'Table', N'ExecutivePerformance', N'Column', N'EPTax';
EXEC sp_addextendedproperty N'MS_Description', N'獎金比例(%)', N'Schema', N'dbo', N'Table', N'ExecutivePerformance', N'Column', N'EPPercentage';
EXEC sp_addextendedproperty N'MS_Description', N'店長領導獎金(元)', N'Schema', N'dbo', N'Table', N'ExecutivePerformance', N'Column', N'EPBonus';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'ExecutivePerformance', N'Column', N'EPNote';
EXEC sp_addextendedproperty N'MS_Description', N'結算年月', N'Schema', N'dbo', N'Table', N'ExecutivePerformance', N'Column', N'MSID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'ExecutivePerformance', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'ExecutivePerformance', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'ExecutivePerformance', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'ExecutivePerformance', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'ExecutivePerformance', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'ExecutivePerformance', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'ExecutivePerformance', N'Column', N'Sys_DeleteBy';
GO




/*【125. 成交案件暫止 SuspendedDeals】*/
CREATE TABLE SuspendedDeals (
    SDID INT IDENTITY(1,1) PRIMARY KEY,                  	-- 成交案件暫止編號
    DCID INT NOT NULL,                                   			-- 成交案件編號 (FK)
    SDDate_S DATE NOT NULL,                              		-- 暫止日期
    SDReason_S NVARCHAR(50) NOT NULL,         	-- 暫止原因
    SDDate_E DATE NULL,                                  			-- 結束日期
    SDReason_E NVARCHAR(50) NULL,                        	-- 結束原因
    SDNote NVARCHAR(500) NULL,                           	-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,                 				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,                          				-- 刪除時間
    Sys_DeleteBy INT NULL,                               						-- 刪除人員 (FK)

    /*CHECK 設定*/
    CONSTRAINT CK_SuspendedDeals_DateRange CHECK (SDDate_E IS NULL OR SDDate_E >= SDDate_S),
    CONSTRAINT CK_SuspendedDeals_IsDelete CHECK (Sys_IsDelete IN (0,1)),

    /*FK 設定*/
    CONSTRAINT FK_SuspendedDeals_DealClosures FOREIGN KEY (DCID) REFERENCES DealClosures(DCID),
    CONSTRAINT FK_SuspendedDeals_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_SuspendedDeals_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_SuspendedDeals_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'成交案件暫止表', N'Schema', N'dbo', N'Table', N'SuspendedDeals';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'成交案件暫止編號', N'Schema', N'dbo', N'Table', N'SuspendedDeals', N'Column', N'SDID';
EXEC sp_addextendedproperty N'MS_Description', N'成交案件編號', N'Schema', N'dbo', N'Table', N'SuspendedDeals', N'Column', N'DCID';
EXEC sp_addextendedproperty N'MS_Description', N'暫止日期', N'Schema', N'dbo', N'Table', N'SuspendedDeals', N'Column', N'SDDate_S';
EXEC sp_addextendedproperty N'MS_Description', N'暫止原因', N'Schema', N'dbo', N'Table', N'SuspendedDeals', N'Column', N'SDReason_S';
EXEC sp_addextendedproperty N'MS_Description', N'結束日期', N'Schema', N'dbo', N'Table', N'SuspendedDeals', N'Column', N'SDDate_E';
EXEC sp_addextendedproperty N'MS_Description', N'結束原因', N'Schema', N'dbo', N'Table', N'SuspendedDeals', N'Column', N'SDReason_E';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'SuspendedDeals', N'Column', N'SDNote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'SuspendedDeals', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'SuspendedDeals', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'SuspendedDeals', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'SuspendedDeals', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'SuspendedDeals', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'SuspendedDeals', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'SuspendedDeals', N'Column', N'Sys_DeleteBy';
GO



/*【126. 秘書績效獎金 AssistantPerformance】*/
CREATE TABLE AssistantPerformance (
    APID INT IDENTITY(1,1) PRIMARY KEY,                   			-- 秘書績效獎金編號
    BAMID INT NULL,                                       					-- 獎金拆算主檔編號 (FK)
    BSAID INT NOT NULL,                                   				-- 人員規章套用編號 (FK)
    EEID INT NOT NULL,                                    					-- 秘書 (員工編號) (FK)
    APMonthY NVARCHAR(7) NOT NULL,                        		-- 所屬年月 (EX: 2025/07)
    APPerf_Total DECIMAL(15,2) NOT NULL DEFAULT 0,        	-- 本次累積總業績(元)
    APAchieved_tier INT NOT NULL,                         			-- 已達成的獎金級數 (代入【獎金規章明細編號】)
    APBonus DECIMAL(15,2) NOT NULL DEFAULT 0,             	-- 本次可發放獎金(元)
    APNote NVARCHAR(500) NULL,                            			-- 備註
    MSID INT NOT NULL,                                    					-- 月度結算編號 (FK)
    SDID INT NULL,                                        					-- 成交案件暫止編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),    	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                           					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                           				-- 修改時間
    Sys_UpdateBy INT NULL,                                					-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,                  				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,                           				-- 刪除時間
    Sys_DeleteBy INT NULL,                                					-- 刪除人員 (FK)

    /*CHECK 設定*/
    CONSTRAINT CK_AssistantPerformance_APMonthY CHECK (APMonthY LIKE '[0-9][0-9][0-9][0-9]/[0-1][0-9]'),
    CONSTRAINT CK_AssistantPerformance_APPerf_Total CHECK (APPerf_Total >= 0),
    CONSTRAINT CK_AssistantPerformance_APBonus CHECK (APBonus >= 0),
    CONSTRAINT CK_AssistantPerformance_APAchieved_tier CHECK (APAchieved_tier >= 0),

    /*FK 設定*/
    CONSTRAINT FK_AssistantPerformance_BAMID FOREIGN KEY (BAMID) REFERENCES BonusAllocationMain(BAMID),
    CONSTRAINT FK_AssistantPerformance_BSAID FOREIGN KEY (BSAID) REFERENCES BonusStructureAssignment(BSAID),
    CONSTRAINT FK_AssistantPerformance_EEID FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_AssistantPerformance_MSID FOREIGN KEY (MSID) REFERENCES MonthlySettlement(MSID),
    CONSTRAINT FK_AssistantPerformance_SDID FOREIGN KEY (SDID) REFERENCES SuspendedDeals(SDID),
    CONSTRAINT FK_AssistantPerformance_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_AssistantPerformance_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_AssistantPerformance_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'秘書績效獎金表', N'Schema', N'dbo', N'Table', N'AssistantPerformance';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'秘書績效獎金編號', N'Schema', N'dbo', N'Table', N'AssistantPerformance', N'Column', N'APID';
EXEC sp_addextendedproperty N'MS_Description', N'獎金拆算主檔編號', N'Schema', N'dbo', N'Table', N'AssistantPerformance', N'Column', N'BAMID';
EXEC sp_addextendedproperty N'MS_Description', N'規章套用', N'Schema', N'dbo', N'Table', N'AssistantPerformance', N'Column', N'BSAID';
EXEC sp_addextendedproperty N'MS_Description', N'秘書', N'Schema', N'dbo', N'Table', N'AssistantPerformance', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'所屬年月', N'Schema', N'dbo', N'Table', N'AssistantPerformance', N'Column', N'APMonthY';
EXEC sp_addextendedproperty N'MS_Description', N'本次累積總業績(元)', N'Schema', N'dbo', N'Table', N'AssistantPerformance', N'Column', N'APPerf_Total';
EXEC sp_addextendedproperty N'MS_Description', N'已達成的獎金級數', N'Schema', N'dbo', N'Table', N'AssistantPerformance', N'Column', N'APAchieved_tier';
EXEC sp_addextendedproperty N'MS_Description', N'本次可發放獎金(元)', N'Schema', N'dbo', N'Table', N'AssistantPerformance', N'Column', N'APBonus';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'AssistantPerformance', N'Column', N'APNote';
EXEC sp_addextendedproperty N'MS_Description', N'結算年月', N'Schema', N'dbo', N'Table', N'AssistantPerformance', N'Column', N'MSID';
EXEC sp_addextendedproperty N'MS_Description', N'成交案件暫止編號', N'Schema', N'dbo', N'Table', N'AssistantPerformance', N'Column', N'SDID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'AssistantPerformance', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'AssistantPerformance', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'AssistantPerformance', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'AssistantPerformance', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'AssistantPerformance', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'AssistantPerformance', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'AssistantPerformance', N'Column', N'Sys_DeleteBy';
GO




/*【127. 獎金退還原因 BonusRefundReasons】*/
CREATE TABLE BonusRefundReasons (
    BRRID INT IDENTITY(1,1) PRIMARY KEY,   	-- 獎金退還原因編號
    BRRName NVARCHAR(20) NOT NULL,         	-- 獎金退還原因
    BRRIsActive BIT NOT NULL DEFAULT 1     	-- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    ,CONSTRAINT CK_BonusRefundReasons_BRRIsActive CHECK (BRRIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'獎金退還原因表', N'Schema', N'dbo', N'Table', N'BonusRefundReasons';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'獎金退還原因編號', N'Schema', N'dbo', N'Table', N'BonusRefundReasons', N'Column', N'BRRID';
EXEC sp_addextendedproperty N'MS_Description', N'獎金退還原因', N'Schema', N'dbo', N'Table', N'BonusRefundReasons', N'Column', N'BRRName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'BonusRefundReasons', N'Column', N'BRRIsActive';
GO




/*【128. 獎金退還計算 BonusRefundCalculation】*/
CREATE TABLE BonusRefundCalculation (
    BRCID INT IDENTITY(1,1) PRIMARY KEY,           				-- 獎金退還計算編號
    SDID INT NOT NULL,                             							-- 成交案件暫止編號 (FK)
    BAMID INT NOT NULL,                            						-- 獎金拆算主檔編號 (FK)
    BRRID INT NOT NULL,                            						-- 獎金退還原因編號 (FK)
    BRCPerf_Total DECIMAL(15,2) NOT NULL DEFAULT 0,			-- 本次退還總業績(元)
    BRCBonus_Perf DECIMAL(15,2) NOT NULL DEFAULT 0,		-- 本次業績獎金(元)
    BRCBonus_Refund DECIMAL(15,2) NOT NULL DEFAULT 0,		-- 退還獎金(元)
    BRCNote NVARCHAR(250) NULL,                    					-- 備註
    MSID INT NOT NULL,                             						-- 月度結算編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                       					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                       					-- 修改時間
    Sys_UpdateBy INT NULL,                            						-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,              				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,                       					-- 刪除時間
    Sys_DeleteBy INT NULL,                            						-- 刪除人員 (FK)

    /*CHECK 設定*/
    CONSTRAINT CK_BonusRefundCalculation_PerfTotal CHECK (BRCPerf_Total >= 0),
    CONSTRAINT CK_BonusRefundCalculation_BonusPerf CHECK (BRCBonus_Perf >= 0),
    CONSTRAINT CK_BonusRefundCalculation_BonusRefund CHECK (BRCBonus_Refund >= 0),
    CONSTRAINT CK_BonusRefundCalculation_IsDelete CHECK (Sys_IsDelete IN (0,1)),

    /*FK 設定*/
    CONSTRAINT FK_BonusRefundCalculation_SuspendedDeals FOREIGN KEY (SDID) REFERENCES SuspendedDeals(SDID),
    CONSTRAINT FK_BonusRefundCalculation_BonusAllocationMain FOREIGN KEY (BAMID) REFERENCES BonusAllocationMain(BAMID),
    CONSTRAINT FK_BonusRefundCalculation_BonusRefundReasons FOREIGN KEY (BRRID) REFERENCES BonusRefundReasons(BRRID),
    CONSTRAINT FK_BonusRefundCalculation_MonthlySettlement FOREIGN KEY (MSID) REFERENCES MonthlySettlement(MSID),
    CONSTRAINT FK_BonusRefundCalculation_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_BonusRefundCalculation_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_BonusRefundCalculation_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'獎金退還計算表', N'Schema', N'dbo', N'Table', N'BonusRefundCalculation';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'獎金退還計算編號', N'Schema', N'dbo', N'Table', N'BonusRefundCalculation', N'Column', N'BRCID';
EXEC sp_addextendedproperty N'MS_Description', N'成交案件暫止編號', N'Schema', N'dbo', N'Table', N'BonusRefundCalculation', N'Column', N'SDID';
EXEC sp_addextendedproperty N'MS_Description', N'獎金拆算主檔編號', N'Schema', N'dbo', N'Table', N'BonusRefundCalculation', N'Column', N'BAMID';
EXEC sp_addextendedproperty N'MS_Description', N'獎金退還原因', N'Schema', N'dbo', N'Table', N'BonusRefundCalculation', N'Column', N'BRRID';
EXEC sp_addextendedproperty N'MS_Description', N'本次退還總業績(元)', N'Schema', N'dbo', N'Table', N'BonusRefundCalculation', N'Column', N'BRCPerf_Total';
EXEC sp_addextendedproperty N'MS_Description', N'本次業績獎金(元)', N'Schema', N'dbo', N'Table', N'BonusRefundCalculation', N'Column', N'BRCBonus_Perf';
EXEC sp_addextendedproperty N'MS_Description', N'退還獎金(元)', N'Schema', N'dbo', N'Table', N'BonusRefundCalculation', N'Column', N'BRCBonus_Refund';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'BonusRefundCalculation', N'Column', N'BRCNote';
EXEC sp_addextendedproperty N'MS_Description', N'結算年月', N'Schema', N'dbo', N'Table', N'BonusRefundCalculation', N'Column', N'MSID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'BonusRefundCalculation', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'BonusRefundCalculation', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'BonusRefundCalculation', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'BonusRefundCalculation', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'BonusRefundCalculation', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'BonusRefundCalculation', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'BonusRefundCalculation', N'Column', N'Sys_DeleteBy';
GO



/*【129. 獎金退還計算明細 BonusRefundDetail】*/
CREATE TABLE BonusRefundDetail (
    BRDID INT IDENTITY(1,1) PRIMARY KEY,            				-- 獎金退還計算明細編號
    BRCID INT NOT NULL,                             						-- 獎金退還計算編號 (FK)
    BSAID INT NOT NULL,                             						-- 人員規章套用編號 (FK)
    BRDPerformance DECIMAL(15,2) NOT NULL DEFAULT 0,		-- 業績(元)
    BRDTax DECIMAL(15,2) NOT NULL DEFAULT 0,        			-- 稅金(元)
    BRDPercentage DECIMAL(15,2) NOT NULL DEFAULT 0, 		-- 獎金比例(%)
    BRDBonus DECIMAL(15,2) NOT NULL DEFAULT 0,      			-- 獎金(元)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                        					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                        				-- 修改時間
    Sys_UpdateBy INT NULL,                             						-- 修改人員 (FK)

    /*CHECK 設定*/
    CONSTRAINT CK_BonusRefundDetail_Performance CHECK (BRDPerformance >= 0),
    CONSTRAINT CK_BonusRefundDetail_Tax CHECK (BRDTax >= 0),
    CONSTRAINT CK_BonusRefundDetail_Percentage CHECK (BRDPercentage >= 0),
    CONSTRAINT CK_BonusRefundDetail_Bonus CHECK (BRDBonus >= 0),

    /*FK 設定*/
    CONSTRAINT FK_BonusRefundDetail_BonusRefundCalculation FOREIGN KEY (BRCID) REFERENCES BonusRefundCalculation(BRCID),
    CONSTRAINT FK_BonusRefundDetail_BonusStructureAssignment FOREIGN KEY (BSAID) REFERENCES BonusStructureAssignment(BSAID),
    CONSTRAINT FK_BonusRefundDetail_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_BonusRefundDetail_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'獎金退還計算明細表', N'Schema', N'dbo', N'Table', N'BonusRefundDetail';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'獎金退還計算明細編號', N'Schema', N'dbo', N'Table', N'BonusRefundDetail', N'Column', N'BRDID';
EXEC sp_addextendedproperty N'MS_Description', N'獎金退還計算編號', N'Schema', N'dbo', N'Table', N'BonusRefundDetail', N'Column', N'BRCID';
EXEC sp_addextendedproperty N'MS_Description', N'規章套用', N'Schema', N'dbo', N'Table', N'BonusRefundDetail', N'Column', N'BSAID';
EXEC sp_addextendedproperty N'MS_Description', N'業績(元)', N'Schema', N'dbo', N'Table', N'BonusRefundDetail', N'Column', N'BRDPerformance';
EXEC sp_addextendedproperty N'MS_Description', N'稅金(元)', N'Schema', N'dbo', N'Table', N'BonusRefundDetail', N'Column', N'BRDTax';
EXEC sp_addextendedproperty N'MS_Description', N'獎金比例(%)', N'Schema', N'dbo', N'Table', N'BonusRefundDetail', N'Column', N'BRDPercentage';
EXEC sp_addextendedproperty N'MS_Description', N'獎金(元)', N'Schema', N'dbo', N'Table', N'BonusRefundDetail', N'Column', N'BRDBonus';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'BonusRefundDetail', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'BonusRefundDetail', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'BonusRefundDetail', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'BonusRefundDetail', N'Column', N'Sys_UpdateBy';
GO




/*【130. 主管績效獎金退還 SupervisorPerformanceRefund】*/
CREATE TABLE SupervisorPerformanceRefund (
    SPRID INT IDENTITY(1,1) PRIMARY KEY,                   			-- 主管績效獎金退還編號
    BRCID INT NOT NULL,                                    					-- 獎金退還計算編號 (FK)
    SPID INT NOT NULL,                                     						-- 主管績效獎金編號 (FK)
    BSAID INT NOT NULL,                                    					-- 人員規章套用編號 (FK)
    SPRPerformance DECIMAL(15,2) NOT NULL DEFAULT 0,       	-- 業績(元)
    SPRTax DECIMAL(15,2) NOT NULL DEFAULT 0,               		-- 稅金(元)
    SPRPercentage DECIMAL(15,2) NOT NULL DEFAULT 0,        	-- 獎金比例(%)
    SPRBonus DECIMAL(15,2) NOT NULL DEFAULT 0,             		-- 獎金(元)
    SPRBonus_Refund DECIMAL(15,2) NOT NULL DEFAULT 0,      	-- 退還獎金(元)
    SPRNote NVARCHAR(250) NULL,                            				-- 備註
    MSID INT NOT NULL,                                     					-- 月度結算編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),     	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                            				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                            				-- 修改時間
    Sys_UpdateBy INT NULL,                                 					-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,                   			-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,                            				-- 刪除時間
    Sys_DeleteBy INT NULL,                                 					-- 刪除人員 (FK)

    /*CHECK 設定*/
    CONSTRAINT CK_SPR_Percentage CHECK (SPRPercentage >= 0 AND SPRPercentage <= 100),
    CONSTRAINT CK_SPR_Performance CHECK (SPRPerformance >= 0),
    CONSTRAINT CK_SPR_Tax CHECK (SPRTax >= 0),
    CONSTRAINT CK_SPR_Bonus CHECK (SPRBonus >= 0),
    CONSTRAINT CK_SPR_BonusRefund CHECK (SPRBonus_Refund >= 0),

    /*FK 設定*/
    CONSTRAINT FK_SPR_BonusRefundCalculation FOREIGN KEY (BRCID) REFERENCES BonusRefundCalculation(BRCID),
    CONSTRAINT FK_SPR_SupervisorPerformance FOREIGN KEY (SPID) REFERENCES SupervisorPerformance(SPID),
    CONSTRAINT FK_SPR_BonusStructureAssignment FOREIGN KEY (BSAID) REFERENCES BonusStructureAssignment(BSAID),
    CONSTRAINT FK_SPR_MonthlySettlement FOREIGN KEY (MSID) REFERENCES MonthlySettlement(MSID),
    CONSTRAINT FK_SPR_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_SPR_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_SPR_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'主管績效獎金退還表', N'Schema', N'dbo', N'Table', N'SupervisorPerformanceRefund';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'主管績效獎金退還編號', N'Schema', N'dbo', N'Table', N'SupervisorPerformanceRefund', N'Column', N'SPRID';
EXEC sp_addextendedproperty N'MS_Description', N'獎金退還計算編號', N'Schema', N'dbo', N'Table', N'SupervisorPerformanceRefund', N'Column', N'BRCID';
EXEC sp_addextendedproperty N'MS_Description', N'主管績效獎金編號', N'Schema', N'dbo', N'Table', N'SupervisorPerformanceRefund', N'Column', N'SPID';
EXEC sp_addextendedproperty N'MS_Description', N'規章套用', N'Schema', N'dbo', N'Table', N'SupervisorPerformanceRefund', N'Column', N'BSAID';
EXEC sp_addextendedproperty N'MS_Description', N'業績(元)', N'Schema', N'dbo', N'Table', N'SupervisorPerformanceRefund', N'Column', N'SPRPerformance';
EXEC sp_addextendedproperty N'MS_Description', N'稅金(元)', N'Schema', N'dbo', N'Table', N'SupervisorPerformanceRefund', N'Column', N'SPRTax';
EXEC sp_addextendedproperty N'MS_Description', N'獎金比例(%)', N'Schema', N'dbo', N'Table', N'SupervisorPerformanceRefund', N'Column', N'SPRPercentage';
EXEC sp_addextendedproperty N'MS_Description', N'獎金(元)', N'Schema', N'dbo', N'Table', N'SupervisorPerformanceRefund', N'Column', N'SPRBonus';
EXEC sp_addextendedproperty N'MS_Description', N'退還獎金(元)', N'Schema', N'dbo', N'Table', N'SupervisorPerformanceRefund', N'Column', N'SPRBonus_Refund';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'SupervisorPerformanceRefund', N'Column', N'SPRNote';
EXEC sp_addextendedproperty N'MS_Description', N'結算年月', N'Schema', N'dbo', N'Table', N'SupervisorPerformanceRefund', N'Column', N'MSID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'SupervisorPerformanceRefund', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'SupervisorPerformanceRefund', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'SupervisorPerformanceRefund', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'SupervisorPerformanceRefund', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'SupervisorPerformanceRefund', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'SupervisorPerformanceRefund', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'SupervisorPerformanceRefund', N'Column', N'Sys_DeleteBy';
GO





/*【131. 店長績效獎金退還 ExecutivePerformanceRefund】*/
CREATE TABLE ExecutivePerformanceRefund (
    EPRID INT IDENTITY(1,1) PRIMARY KEY,                 			-- 店長績效獎金退還編號
    BRCID INT NOT NULL,                                  					-- 獎金退還計算編號 (FK)
    EPID INT NOT NULL,                                   					-- 店長績效獎金編號 (FK)
    BSAID INT NOT NULL,                                  					-- 人員規章套用編號 (FK)
    EPRPerformance DECIMAL(15,2) NOT NULL DEFAULT 0,	-- 業績(元)
    EPRTax DECIMAL(15,2) NOT NULL DEFAULT 0,             		-- 稅金(元)
    EPRPercentage DECIMAL(15,2) NOT NULL DEFAULT 0,      	-- 獎金比例(%)
    EPRBonus DECIMAL(15,2) NOT NULL DEFAULT 0,           	-- 獎金(元)
    EPRBonus_Refund DECIMAL(15,2) NOT NULL DEFAULT 0, 	-- 退還獎金(元)
    EPRNote NVARCHAR(250) NULL,                          			-- 備註
    MSID INT NOT NULL,                                   					-- 月度結算編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,                 				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,                          				-- 刪除時間
    Sys_DeleteBy INT NULL,                               						-- 刪除人員 (FK)

    /*CHECK 設定*/
    CONSTRAINT CK_ExecutivePerformanceRefund_Performance CHECK (EPRPerformance >= 0),
    CONSTRAINT CK_ExecutivePerformanceRefund_Tax CHECK (EPRTax >= 0),
    CONSTRAINT CK_ExecutivePerformanceRefund_Percentage CHECK (EPRPercentage >= 0 AND EPRPercentage <= 100),
    CONSTRAINT CK_ExecutivePerformanceRefund_Bonus CHECK (EPRBonus >= 0),
    CONSTRAINT CK_ExecutivePerformanceRefund_BonusRefund CHECK (EPRBonus_Refund >= 0),

    /*FK 設定*/
    CONSTRAINT FK_EPR_BonusRefundCalculation FOREIGN KEY (BRCID) REFERENCES BonusRefundCalculation(BRCID),
    CONSTRAINT FK_EPR_ExecutivePerformance FOREIGN KEY (EPID) REFERENCES ExecutivePerformance(EPID),
    CONSTRAINT FK_EPR_BonusStructureAssignment FOREIGN KEY (BSAID) REFERENCES BonusStructureAssignment(BSAID),
    CONSTRAINT FK_EPR_MonthlySettlement FOREIGN KEY (MSID) REFERENCES MonthlySettlement(MSID),
    CONSTRAINT FK_EPR_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_EPR_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_EPR_DeleteBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'店長績效獎金退還表', N'Schema', N'dbo', N'Table', N'ExecutivePerformanceRefund';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'店長績效獎金退還編號', N'Schema', N'dbo', N'Table', N'ExecutivePerformanceRefund', N'Column', N'EPRID';
EXEC sp_addextendedproperty N'MS_Description', N'獎金退還計算編號', N'Schema', N'dbo', N'Table', N'ExecutivePerformanceRefund', N'Column', N'BRCID';
EXEC sp_addextendedproperty N'MS_Description', N'店長績效獎金編號', N'Schema', N'dbo', N'Table', N'ExecutivePerformanceRefund', N'Column', N'EPID';
EXEC sp_addextendedproperty N'MS_Description', N'規章套用', N'Schema', N'dbo', N'Table', N'ExecutivePerformanceRefund', N'Column', N'BSAID';
EXEC sp_addextendedproperty N'MS_Description', N'業績(元)', N'Schema', N'dbo', N'Table', N'ExecutivePerformanceRefund', N'Column', N'EPRPerformance';
EXEC sp_addextendedproperty N'MS_Description', N'稅金(元)', N'Schema', N'dbo', N'Table', N'ExecutivePerformanceRefund', N'Column', N'EPRTax';
EXEC sp_addextendedproperty N'MS_Description', N'獎金比例(%)', N'Schema', N'dbo', N'Table', N'ExecutivePerformanceRefund', N'Column', N'EPRPercentage';
EXEC sp_addextendedproperty N'MS_Description', N'獎金(元)', N'Schema', N'dbo', N'Table', N'ExecutivePerformanceRefund', N'Column', N'EPRBonus';
EXEC sp_addextendedproperty N'MS_Description', N'退還獎金(元)', N'Schema', N'dbo', N'Table', N'ExecutivePerformanceRefund', N'Column', N'EPRBonus_Refund';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'ExecutivePerformanceRefund', N'Column', N'EPRNote';
EXEC sp_addextendedproperty N'MS_Description', N'結算年月', N'Schema', N'dbo', N'Table', N'ExecutivePerformanceRefund', N'Column', N'MSID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'ExecutivePerformanceRefund', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'ExecutivePerformanceRefund', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'ExecutivePerformanceRefund', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'ExecutivePerformanceRefund', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'ExecutivePerformanceRefund', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'ExecutivePerformanceRefund', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'ExecutivePerformanceRefund', N'Column', N'Sys_DeleteBy';
GO



/*【132. 薪資發放狀態 PaySlipStatus】*/
CREATE TABLE PaySlipStatus (
    PSSID INT IDENTITY(1,1) PRIMARY KEY,          	-- 薪資發放狀態編號
    PSSName NVARCHAR(20) NOT NULL,     		-- 薪資發放狀態
    PSSIsActive BIT NOT NULL DEFAULT 1   		-- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    CONSTRAINT CK_PaySlipStatus_PSSIsActive CHECK (PSSIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'薪資發放狀態表', N'Schema', N'dbo', N'Table', N'PaySlipStatus';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'薪資發放狀態編號', N'Schema', N'dbo', N'Table', N'PaySlipStatus', N'Column', N'PSSID';
EXEC sp_addextendedproperty N'MS_Description', N'薪資發放狀態', N'Schema', N'dbo', N'Table', N'PaySlipStatus', N'Column', N'PSSName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'PaySlipStatus', N'Column', N'PSSIsActive';
GO




/*【133. 個人薪資單 PaySlips】*/
CREATE TABLE PaySlips (
    PSID INT IDENTITY(1,1) PRIMARY KEY,                			-- 個人薪資單編號
    COID INT NOT NULL,                                 					-- 公司編號 (FK)
    EEID INT NOT NULL,                                 					-- 員工編號 (FK)
    PSPrevious DECIMAL(15,2) NOT NULL DEFAULT 0,       		-- 上期餘額(元)
    PSNetPay DECIMAL(15,2) NOT NULL DEFAULT 0,         		-- 本期實領薪資(元)
    PSNote NVARCHAR(250) NULL,                         				-- 備註
    MSID INT NOT NULL,                                 					-- 月度結算編號 (FK)
    PSSID INT NOT NULL,                                					-- 薪資發放狀態編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                        					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                        				-- 修改時間
    Sys_UpdateBy INT NULL,                             						-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,               				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,                        					-- 刪除時間
    Sys_DeleteBy INT NULL,                             						-- 刪除人員 (FK)

    /*CHECK 設定*/
    CONSTRAINT CK_PaySlips_PSPrevious CHECK (PSPrevious >= 0),
    CONSTRAINT CK_PaySlips_PSNetPay CHECK (PSNetPay >= 0),
    CONSTRAINT CK_PaySlips_IsDelete CHECK (Sys_IsDelete IN (0,1)),

    /*FK 設定*/
    CONSTRAINT FK_PaySlips_Company FOREIGN KEY (COID) REFERENCES Company(COID),
    CONSTRAINT FK_PaySlips_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_PaySlips_MonthlySettlement FOREIGN KEY (MSID) REFERENCES MonthlySettlement(MSID),
    CONSTRAINT FK_PaySlips_PaySlipStatus FOREIGN KEY (PSSID) REFERENCES PaySlipStatus(PSSID),
    CONSTRAINT FK_PaySlips_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_PaySlips_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_PaySlips_DeleteBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'個人薪資單表', N'Schema', N'dbo', N'Table', N'PaySlips';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'個人薪資單編號', N'Schema', N'dbo', N'Table', N'PaySlips', N'Column', N'PSID';
EXEC sp_addextendedproperty N'MS_Description', N'公司', N'Schema', N'dbo', N'Table', N'PaySlips', N'Column', N'COID';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'PaySlips', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'上期餘額(元)', N'Schema', N'dbo', N'Table', N'PaySlips', N'Column', N'PSPrevious';
EXEC sp_addextendedproperty N'MS_Description', N'本期實領薪資(元)', N'Schema', N'dbo', N'Table', N'PaySlips', N'Column', N'PSNetPay';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'PaySlips', N'Column', N'PSNote';
EXEC sp_addextendedproperty N'MS_Description', N'結算年月', N'Schema', N'dbo', N'Table', N'PaySlips', N'Column', N'MSID';
EXEC sp_addextendedproperty N'MS_Description', N'薪資發放狀態', N'Schema', N'dbo', N'Table', N'PaySlips', N'Column', N'PSSID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'PaySlips', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'PaySlips', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'PaySlips', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'PaySlips', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'PaySlips', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'PaySlips', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'PaySlips', N'Column', N'Sys_DeleteBy';
GO



/*【134. 薪資加項明細 PaySlipEarnings】*/
CREATE TABLE PaySlipEarnings (
    PSEID INT IDENTITY(1,1) PRIMARY KEY,                 			-- 薪資加項明細編號
    PSID INT NOT NULL,                                   					-- 個人薪資單編號 (FK)
    ESID INT NOT NULL,                                   					-- 員工薪資結構明細編號 (FK)
    PSEAmount DECIMAL(15,2) NOT NULL DEFAULT 0,          	-- 金額(元)
    PSENote NVARCHAR(250) NULL,                          			-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)

    /*CHECK 設定*/
    CONSTRAINT CK_PaySlipEarnings_Amount CHECK (PSEAmount >= 0),

    /*FK 設定*/
    CONSTRAINT FK_PaySlipEarnings_PaySlips FOREIGN KEY (PSID) REFERENCES PaySlips(PSID),
    CONSTRAINT FK_PaySlipEarnings_EmployeeCompensation FOREIGN KEY (ESID) REFERENCES EmployeeCompensation(ESID),
    CONSTRAINT FK_PaySlipEarnings_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_PaySlipEarnings_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'薪資加項明細表', N'Schema', N'dbo', N'Table', N'PaySlipEarnings';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'薪資加項明細編號', N'Schema', N'dbo', N'Table', N'PaySlipEarnings', N'Column', N'PSEID';
EXEC sp_addextendedproperty N'MS_Description', N'個人薪資單編號', N'Schema', N'dbo', N'Table', N'PaySlipEarnings', N'Column', N'PSID';
EXEC sp_addextendedproperty N'MS_Description', N'員工薪資結構明細', N'Schema', N'dbo', N'Table', N'PaySlipEarnings', N'Column', N'ESID';
EXEC sp_addextendedproperty N'MS_Description', N'金額(元)', N'Schema', N'dbo', N'Table', N'PaySlipEarnings', N'Column', N'PSEAmount';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'PaySlipEarnings', N'Column', N'PSENote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'PaySlipEarnings', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'PaySlipEarnings', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'PaySlipEarnings', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'PaySlipEarnings', N'Column', N'Sys_UpdateBy';
GO




/*【135. 薪資扣項明細 PaySlipDeductions】*/
CREATE TABLE PaySlipDeductions (
    PSDID INT IDENTITY(1,1) PRIMARY KEY,             			-- 薪資扣項明細編號
    PSID INT NOT NULL,                               					-- 個人薪資單編號 (FK)
    ESID INT NOT NULL,                               					-- 員工薪資結構明細編號 (FK)
    PSDAmount DECIMAL(15,2) NOT NULL DEFAULT 0,      	-- 金額(元)
    PSDNote NVARCHAR(250) NULL,                      				-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)

    /*CHECK 設定*/
    CONSTRAINT CK_PaySlipDeductions_PSDAmount CHECK (PSDAmount >= 0),

    /*FK 設定*/
    CONSTRAINT FK_PaySlipDeductions_PaySlips FOREIGN KEY (PSID) REFERENCES PaySlips(PSID),
    CONSTRAINT FK_PaySlipDeductions_EmployeeCompensation FOREIGN KEY (ESID) REFERENCES EmployeeCompensation(ESID),
    CONSTRAINT FK_PaySlipDeductions_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_PaySlipDeductions_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'薪資扣項明細', N'Schema', N'dbo', N'Table', N'PaySlipDeductions';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'薪資扣項明細編號', N'Schema', N'dbo', N'Table', N'PaySlipDeductions', N'Column', N'PSDID';
EXEC sp_addextendedproperty N'MS_Description', N'個人薪資單編號', N'Schema', N'dbo', N'Table', N'PaySlipDeductions', N'Column', N'PSID';
EXEC sp_addextendedproperty N'MS_Description', N'員工薪資結構明細編號', N'Schema', N'dbo', N'Table', N'PaySlipDeductions', N'Column', N'ESID';
EXEC sp_addextendedproperty N'MS_Description', N'金額(元)', N'Schema', N'dbo', N'Table', N'PaySlipDeductions', N'Column', N'PSDAmount';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'PaySlipDeductions', N'Column', N'PSDNote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'PaySlipDeductions', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'PaySlipDeductions', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'PaySlipDeductions', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'PaySlipDeductions', N'Column', N'Sys_UpdateBy';
GO




/*【136. 勞工福利制度類型 EmployeeBenefitTypes】*/
CREATE TABLE EmployeeBenefitTypes (
    EBTID INT IDENTITY(1,1) PRIMARY KEY,       	-- 勞工福利制度類型編號
    EBTName NVARCHAR(20) NOT NULL,             	-- 勞工福利制度類型
    EBTIsActive BIT NOT NULL DEFAULT 1         	-- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    ,CONSTRAINT CK_EmployeeBenefitTypes_IsActive CHECK (EBTIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'勞工福利制度類型表', N'Schema', N'dbo', N'Table', N'EmployeeBenefitTypes';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'勞工福利制度類型編號', N'Schema', N'dbo', N'Table', N'EmployeeBenefitTypes', N'Column', N'EBTID';
EXEC sp_addextendedproperty N'MS_Description', N'勞工福利制度類型', N'Schema', N'dbo', N'Table', N'EmployeeBenefitTypes', N'Column', N'EBTName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用 (0:false, 1:true)', N'Schema', N'dbo', N'Table', N'EmployeeBenefitTypes', N'Column', N'EBTIsActive';
GO



/*【137. 勞工福利制度主檔 EmployeeBenefitMain】*/
CREATE TABLE EmployeeBenefitMain (
    EBMID INT IDENTITY(1,1) PRIMARY KEY,        	-- 勞工福利制度主檔編號
    EBMYear CHAR(3) NOT NULL,                   		-- 頒布年度 (民國年度)
    EBMDate_S DATE NOT NULL,                    		-- 適用起始日
    EBMDate_E DATE NOT NULL,                    		-- 適用截止日
    EBMNote NVARCHAR(250) NULL,                 	-- 備註
    EBMIsActive BIT NOT NULL DEFAULT 1,         	-- 是否啟用 (0:false, 1:true)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)

    /*CHECK 設定*/
    CONSTRAINT CK_EmployeeBenefitMain_Year CHECK (EBMYear LIKE '[0-9][0-9][0-9]'),
    CONSTRAINT CK_EmployeeBenefitMain_Date CHECK (EBMDate_S <= EBMDate_E),

    /*FK 設定*/
    CONSTRAINT FK_EmployeeBenefitMain_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_EmployeeBenefitMain_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'勞工福利制度主檔', N'Schema', N'dbo', N'Table', N'EmployeeBenefitMain';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'勞工福利制度主檔編號', N'Schema', N'dbo', N'Table', N'EmployeeBenefitMain', N'Column', N'EBMID';
EXEC sp_addextendedproperty N'MS_Description', N'頒布年度 (民國)', N'Schema', N'dbo', N'Table', N'EmployeeBenefitMain', N'Column', N'EBMYear';
EXEC sp_addextendedproperty N'MS_Description', N'適用起始日', N'Schema', N'dbo', N'Table', N'EmployeeBenefitMain', N'Column', N'EBMDate_S';
EXEC sp_addextendedproperty N'MS_Description', N'適用截止日', N'Schema', N'dbo', N'Table', N'EmployeeBenefitMain', N'Column', N'EBMDate_E';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'EmployeeBenefitMain', N'Column', N'EBMNote';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用 (0:false, 1:true)', N'Schema', N'dbo', N'Table', N'EmployeeBenefitMain', N'Column', N'EBMIsActive';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'EmployeeBenefitMain', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'EmployeeBenefitMain', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'EmployeeBenefitMain', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'EmployeeBenefitMain', N'Column', N'Sys_UpdateBy';
GO





/*【138. 勞工福利制度明細 EmployeeBenefitRecoed】*/
CREATE TABLE EmployeeBenefitRecoed (
    EBRID INT IDENTITY(1,1) PRIMARY KEY,       					-- 勞工福利制度明細編號
    EBMID INT NOT NULL,                        							-- 勞工福利制度主檔編號 (FK)
    EBRBracket_S DECIMAL(7,0) NOT NULL DEFAULT 0,       		-- 投保薪資級距(起)
    EBRBracket_E DECIMAL(7,0) NULL DEFAULT 0,           			-- 投保薪資級距(止)
    EBRContribution_E DECIMAL(7,0) NOT NULL DEFAULT 0,  		-- 員工負擔金額(元)
    EBRContribution_C DECIMAL(7,0) NOT NULL DEFAULT 0,  		-- 雇主負擔金額(元)
    EBRContribution_Total DECIMAL(7,0) NOT NULL DEFAULT 0, 	-- 總負擔金額(元)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)

    /*CHECK 設定*/
    CONSTRAINT CK_EBR_Bracket CHECK (EBRBracket_S >= 0 AND (EBRBracket_E IS NULL OR EBRBracket_E >= EBRBracket_S)),
    CONSTRAINT CK_EBR_Contribution CHECK (EBRContribution_Total = EBRContribution_E + EBRContribution_C),

    /*FK 設定*/
    CONSTRAINT FK_EBR_EBM FOREIGN KEY (EBMID) REFERENCES EmployeeBenefitMain(EBMID),
    CONSTRAINT FK_EBR_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_EBR_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'勞工福利制度明細', N'Schema', N'dbo', N'Table', N'EmployeeBenefitRecoed';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'勞工福利制度明細編號', N'Schema', N'dbo', N'Table', N'EmployeeBenefitRecoed', N'Column', N'EBRID';
EXEC sp_addextendedproperty N'MS_Description', N'勞工福利制度主檔編號', N'Schema', N'dbo', N'Table', N'EmployeeBenefitRecoed', N'Column', N'EBMID';
EXEC sp_addextendedproperty N'MS_Description', N'投保薪資級距(起)', N'Schema', N'dbo', N'Table', N'EmployeeBenefitRecoed', N'Column', N'EBRBracket_S';
EXEC sp_addextendedproperty N'MS_Description', N'投保薪資級距(止)', N'Schema', N'dbo', N'Table', N'EmployeeBenefitRecoed', N'Column', N'EBRBracket_E';
EXEC sp_addextendedproperty N'MS_Description', N'員工負擔金額(元)', N'Schema', N'dbo', N'Table', N'EmployeeBenefitRecoed', N'Column', N'EBRContribution_E';
EXEC sp_addextendedproperty N'MS_Description', N'雇主負擔金額(元)', N'Schema', N'dbo', N'Table', N'EmployeeBenefitRecoed', N'Column', N'EBRContribution_C';
EXEC sp_addextendedproperty N'MS_Description', N'總負擔金額(元)', N'Schema', N'dbo', N'Table', N'EmployeeBenefitRecoed', N'Column', N'EBRContribution_Total';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'EmployeeBenefitRecoed', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'EmployeeBenefitRecoed', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'EmployeeBenefitRecoed', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'EmployeeBenefitRecoed', N'Column', N'Sys_UpdateBy';
GO



/*【139. 所得稅級距主檔 TaxBracketMain】*/
CREATE TABLE TaxBracketMain (
    TBMID INT IDENTITY(1,1) PRIMARY KEY,         	 -- 所得稅級距主檔編號
    TBMYear CHAR(3) NOT NULL,                     		-- 頒布年度 (民國年度)
    TBMDate_S DATE NOT NULL,                      		-- 適用起始日 (YYYY/MM/DD)
    TBMDate_E DATE NOT NULL,                      		-- 適用截止日 (YYYY/MM/DD)
    TBMNote NVARCHAR(250) NULL,                   		-- 備註
    TBMIsActive BIT NOT NULL DEFAULT 1,           	-- 是否啟用 (0:false, 1:true)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間 (YYYY/MM/DD hh:mm:ss)
    Sys_CreatedBy INT NOT NULL,                   							-- 新增人員 (FK) ref. Employee.EEID
    Sys_UpdateDT DATETIME NULL,                   						-- 修改時間 (YYYY/MM/DD hh:mm:ss)
    Sys_UpdateBy INT NULL,                        							-- 修改人員 (FK) ref. Employee.EEID

    /*CHECK 設定*/
    CONSTRAINT CK_TaxBracketMain_Year CHECK (TBMYear NOT LIKE '%[^0-9]%'), -- 年度必須為數字

    /*FK 設定*/
    CONSTRAINT FK_TaxBracketMain_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_TaxBracketMain_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'所得稅級距主檔', N'Schema', N'dbo', N'Table', N'TaxBracketMain';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'所得稅級距主檔編號', N'Schema', N'dbo', N'Table', N'TaxBracketMain', N'Column', N'TBMID';
EXEC sp_addextendedproperty N'MS_Description', N'頒布年度 (民國)', N'Schema', N'dbo', N'Table', N'TaxBracketMain', N'Column', N'TBMYear';
EXEC sp_addextendedproperty N'MS_Description', N'適用起始日 (YYYY/MM/DD)', N'Schema', N'dbo', N'Table', N'TaxBracketMain', N'Column', N'TBMDate_S';
EXEC sp_addextendedproperty N'MS_Description', N'適用截止日 (YYYY/MM/DD)', N'Schema', N'dbo', N'Table', N'TaxBracketMain', N'Column', N'TBMDate_E';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'TaxBracketMain', N'Column', N'TBMNote';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用 (0:false, 1:true)', N'Schema', N'dbo', N'Table', N'TaxBracketMain', N'Column', N'TBMIsActive';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間 (YYYY/MM/DD hh:mm:ss)', N'Schema', N'dbo', N'Table', N'TaxBracketMain', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員 (FK)', N'Schema', N'dbo', N'Table', N'TaxBracketMain', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間 (YYYY/MM/DD hh:mm:ss)', N'Schema', N'dbo', N'Table', N'TaxBracketMain', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員 (FK)', N'Schema', N'dbo', N'Table', N'TaxBracketMain', N'Column', N'Sys_UpdateBy';
GO



/*【140. 所得稅級距明細 TaxBracketDetail】*/
CREATE TABLE TaxBracketDetail (
    TBDID INT IDENTITY(1,1) PRIMARY KEY,              		-- 所得稅級距明細編號
    TBDBracket_S DECIMAL(7,0) NOT NULL,               		-- 所得稅級距(起)
    TBDBracket_E DECIMAL(7,0) NULL,                   			-- 所得稅級距(止)
    TBDRate DECIMAL(5,2) NOT NULL DEFAULT 0,          	-- 稅率(%)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)

    /*CHECK 設定*/
    CONSTRAINT CK_TaxBracketDetail_TBDBracket CHECK (TBDBracket_S >= 0 AND (TBDBracket_E IS NULL OR TBDBracket_E >= TBDBracket_S)),
    CONSTRAINT CK_TaxBracketDetail_TBDRate CHECK (TBDRate >= 0 AND TBDRate <= 100),

    /*FK 設定*/
    CONSTRAINT FK_TaxBracketDetail_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_TaxBracketDetail_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'所得稅級距明細表', N'Schema', N'dbo', N'Table', N'TaxBracketDetail';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'所得稅級距明細編號', N'Schema', N'dbo', N'Table', N'TaxBracketDetail', N'Column', N'TBDID';
EXEC sp_addextendedproperty N'MS_Description', N'所得稅級距(起)', N'Schema', N'dbo', N'Table', N'TaxBracketDetail', N'Column', N'TBDBracket_S';
EXEC sp_addextendedproperty N'MS_Description', N'所得稅級距(止)', N'Schema', N'dbo', N'Table', N'TaxBracketDetail', N'Column', N'TBDBracket_E';
EXEC sp_addextendedproperty N'MS_Description', N'稅率(%)', N'Schema', N'dbo', N'Table', N'TaxBracketDetail', N'Column', N'TBDRate';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'TaxBracketDetail', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'TaxBracketDetail', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'TaxBracketDetail', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'TaxBracketDetail', N'Column', N'Sys_UpdateBy';
GO
