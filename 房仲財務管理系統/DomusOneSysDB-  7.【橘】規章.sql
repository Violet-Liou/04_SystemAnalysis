use DomusOneSysDB;

/*【113. 規章類型 BonusStructureCategories】*/
CREATE TABLE BonusStructureCategories (
    BSCID CHAR(2) PRIMARY KEY,                   	-- 規章類型編號
    BSCName NVARCHAR(20) NOT NULL,   		-- 規章類型
    BSCIsActive BIT NOT NULL DEFAULT 1           	-- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    ,CONSTRAINT CK_BonusStructureCategories_BSCIsActive CHECK (BSCIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'規章類型表', N'Schema', N'dbo', N'Table', N'BonusStructureCategories';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'規章類型編號', N'Schema', N'dbo', N'Table', N'BonusStructureCategories', N'Column', N'BSCID';
EXEC sp_addextendedproperty N'MS_Description', N'規章類型', N'Schema', N'dbo', N'Table', N'BonusStructureCategories', N'Column', N'BSCName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'BonusStructureCategories', N'Column', N'BSCIsActive';
GO



/*【114. 獎金計算方式 BonusCalculationMethods】*/
CREATE TABLE BonusCalculationMethods (
    BCMID INT IDENTITY(1,1) PRIMARY KEY,        	 	-- 獎金計算方式編號
    BCMName NVARCHAR(20) NOT NULL,             	-- 獎金計算方式
    BCMDescruption NVARCHAR(100) NULL,           	-- 說明
    BCMIsActive BIT NOT NULL DEFAULT 1           	-- 是否啟用 (0:false, 1:true)

    /*CHECK 設定*/
    ,CONSTRAINT CK_BonusCalculationMethods_BCMIsActive CHECK (BCMIsActive IN (0,1))
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'獎金計算方式表', N'Schema', N'dbo', N'Table', N'BonusCalculationMethods';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'獎金計算方式編號', N'Schema', N'dbo', N'Table', N'BonusCalculationMethods', N'Column', N'BCMID';
EXEC sp_addextendedproperty N'MS_Description', N'獎金計算方式', N'Schema', N'dbo', N'Table', N'BonusCalculationMethods', N'Column', N'BCMName';
EXEC sp_addextendedproperty N'MS_Description', N'說明', N'Schema', N'dbo', N'Table', N'BonusCalculationMethods', N'Column', N'BCMDescruption';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'BonusCalculationMethods', N'Column', N'BCMIsActive';
GO




/*【115. 獎金規章 BonusStructure】*/
CREATE TABLE BonusStructure (
    BSID NVARCHAR(7) PRIMARY KEY,                	-- 獎金規章編號
    BSCID CHAR(2) NOT NULL,                      		-- 規章類型編號 (FK)
    BSTitle NVARCHAR(50) NOT NULL,               	-- 規章名稱
    BCMID INT NOT NULL,                          		-- 獎金計算方式編號 (FK)
    BSDate_S DATE NOT NULL,                      		-- 適用起始日
    BSDate_E DATE NOT NULL,                      		-- 適用截止日
    BSDescription NVARCHAR(500) NULL,        	-- 規章說明
    BSPriority CHAR(1) NOT NULL DEFAULT '0', 	-- 優先級別
    BSIsActive BIT NOT NULL DEFAULT 1,           	-- 是否啟用 (0:false, 1:true)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                  					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                  					-- 修改時間
    Sys_UpdateBy INT NULL,                       						-- 修改人員 (FK)

    /*CHECK 設定*/
    ,CONSTRAINT CK_BonusStructure_BSIsActive CHECK (BSIsActive IN (0,1))
    ,CONSTRAINT CK_BonusStructure_BSPriority CHECK (BSPriority IN ('0','1','2','3','4','5','6','7','8','9'))

    /*FK 設定*/
    ,CONSTRAINT FK_BonusStructure_BSC FOREIGN KEY (BSCID) REFERENCES BonusStructureCategories(BSCID)
    ,CONSTRAINT FK_BonusStructure_BCM FOREIGN KEY (BCMID) REFERENCES BonusCalculationMethods(BCMID)
    ,CONSTRAINT FK_BonusStructure_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_BonusStructure_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'獎金規章表', N'Schema', N'dbo', N'Table', N'BonusStructure';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'獎金規章編號', N'Schema', N'dbo', N'Table', N'BonusStructure', N'Column', N'BSID';
EXEC sp_addextendedproperty N'MS_Description', N'規章類型', N'Schema', N'dbo', N'Table', N'BonusStructure', N'Column', N'BSCID';
EXEC sp_addextendedproperty N'MS_Description', N'規章名稱', N'Schema', N'dbo', N'Table', N'BonusStructure', N'Column', N'BSTitle';
EXEC sp_addextendedproperty N'MS_Description', N'獎金計算方式', N'Schema', N'dbo', N'Table', N'BonusStructure', N'Column', N'BCMID';
EXEC sp_addextendedproperty N'MS_Description', N'適用起始日', N'Schema', N'dbo', N'Table', N'BonusStructure', N'Column', N'BSDate_S';
EXEC sp_addextendedproperty N'MS_Description', N'適用截止日', N'Schema', N'dbo', N'Table', N'BonusStructure', N'Column', N'BSDate_E';
EXEC sp_addextendedproperty N'MS_Description', N'規章說明', N'Schema', N'dbo', N'Table', N'BonusStructure', N'Column', N'BSDescription';
EXEC sp_addextendedproperty N'MS_Description', N'優先級別', N'Schema', N'dbo', N'Table', N'BonusStructure', N'Column', N'BSPriority';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'BonusStructure', N'Column', N'BSIsActive';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'BonusStructure', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'BonusStructure', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'BonusStructure', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'BonusStructure', N'Column', N'Sys_UpdateBy';
GO




/*【116. 獎金規章明細 BonusStructureDetails】*/
CREATE TABLE BonusStructureDetails (
    BSDID INT PRIMARY KEY,                       		-- 獎金規章明細編號
    BSID NVARCHAR(7) NOT NULL,                   	-- 獎金規章編號 (FK)
    BSDRange_S DECIMAL(15,2) NOT NULL,   	-- 級距(起)
    BSDRange_E DECIMAL(15,2) NULL,               	-- 級距(止)
    BSDPercentage DECIMAL(5,2) NULL,             	-- 獎金比例(%)
    BSDFixedAmount DECIMAL(15,2) NULL,      	-- 固定獎金(元)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                  					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                  					-- 修改時間
    Sys_UpdateBy INT NULL,                       						-- 修改人員 (FK)

    /*CHECK 設定*/
    ,CONSTRAINT CK_BonusStructureDetails_Range CHECK (BSDRange_S >= 0 AND (BSDRange_E IS NULL OR BSDRange_E >= BSDRange_S))
    ,CONSTRAINT CK_BonusStructureDetails_Percentage CHECK (BSDPercentage IS NULL OR (BSDPercentage >= 0 AND BSDPercentage <= 100))
    ,CONSTRAINT CK_BonusStructureDetails_FixedAmount CHECK (BSDFixedAmount IS NULL OR BSDFixedAmount >= 0)

    /*FK 設定*/
    ,CONSTRAINT FK_BonusStructureDetails_BS FOREIGN KEY (BSID) REFERENCES BonusStructure(BSID)
    ,CONSTRAINT FK_BonusStructureDetails_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_BonusStructureDetails_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'獎金規章明細表', N'Schema', N'dbo', N'Table', N'BonusStructureDetails';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'獎金規章明細編號', N'Schema', N'dbo', N'Table', N'BonusStructureDetails', N'Column', N'BSDID';
EXEC sp_addextendedproperty N'MS_Description', N'獎金規章編號', N'Schema', N'dbo', N'Table', N'BonusStructureDetails', N'Column', N'BSID';
EXEC sp_addextendedproperty N'MS_Description', N'級距(起)', N'Schema', N'dbo', N'Table', N'BonusStructureDetails', N'Column', N'BSDRange_S';
EXEC sp_addextendedproperty N'MS_Description', N'級距(止)', N'Schema', N'dbo', N'Table', N'BonusStructureDetails', N'Column', N'BSDRange_E';
EXEC sp_addextendedproperty N'MS_Description', N'獎金比例(%)', N'Schema', N'dbo', N'Table', N'BonusStructureDetails', N'Column', N'BSDPercentage';
EXEC sp_addextendedproperty N'MS_Description', N'固定獎金(元)', N'Schema', N'dbo', N'Table', N'BonusStructureDetails', N'Column', N'BSDFixedAmount';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'BonusStructureDetails', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'BonusStructureDetails', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'BonusStructureDetails', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'BonusStructureDetails', N'Column', N'Sys_UpdateBy';
GO
