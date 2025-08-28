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