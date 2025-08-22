use DomusOneSysDB;

--建立資料表

/*【1. 員工（Employee）】*/
-- Step 0: 如果資料表已存在，先刪除（測試環境用）
IF OBJECT_ID('dbo.Employee', 'U') IS NOT NULL
BEGIN
    DROP TABLE Employee;
END
GO

-- Step 1: 建立 Employee 資料表（尚未加 FK）
CREATE TABLE Employee (
    DS_EEID INT IDENTITY(1,1) PRIMARY KEY,		-- 員工編號
    DS_EEAccount CHAR(10) NOT NULL,			-- 身分證字號
    DS_EEPassword NVARCHAR(255) NOT NULL,	--密碼 (使用【雜湊 (SHA256 的 hash)】)
    DS_EEName NVARCHAR(50) NOT NULL,		--姓名
    DS_EEBirth DATE NOT NULL,					--生日
    DS_EEMail NVARCHAR(255) NOT NULL,			--電子信箱
    DS_EERegAddr NVARCHAR(255) NOT NULL,		--戶籍地址
    DS_EEMailAddr NVARCHAR(255) NOT NULL,	--通訊地址
    DS_EEIsActive BIT NOT NULL DEFAULT 1,		--狀態
    DS_EENote NVARCHAR(500) NULL,				--備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),		--新增時間
    Sys_CreatedBy INT NULL,   								--新增人員 (先允許 NULL，避免 FK 錯誤)
    Sys_UpdateDT DATETIME NULL,							--修改時間
    Sys_UpdateBy INT NULL									--修改人員 (FK)
);
GO

-- Step 2: 插入第一筆員工資料（系統管理員）
INSERT INTO Employee (
    DS_EEAccount, DS_EEPassword, DS_EEName, DS_EEBirth,
    DS_EEMail, DS_EERegAddr, DS_EEMailAddr
)
VALUES (
    'ADMIN001', 'admin@123', '系統管理員', '1980-01-01',
    'admin@example.com', '高雄市', '高雄市'
);
GO

-- Step 3: 將 Sys_CreatedBy 設定為自己的 ID（這筆資料會是 ID = 1）
UPDATE Employee
SET Sys_CreatedBy = DS_EEID
WHERE DS_EEAccount = 'ADMIN001';
GO

-- Step 4: 將 Sys_CreatedBy 欄位改為 NOT NULL（因為已有資料且合法）
ALTER TABLE Employee
ALTER COLUMN Sys_CreatedBy INT NOT NULL;
GO

-- Step 5: 補上 FOREIGN KEY 約束（現在資料已合法）
ALTER TABLE Employee
ADD CONSTRAINT FK_Employee_CreatedBy
FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID);
GO

ALTER TABLE Employee
ADD CONSTRAINT FK_Employee_UpdatedBy
FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID);
GO

---------------------------------------------------------------------------------------------------

/*【2. 員工連絡電話】*/
CREATE TABLE EmployeeTel (
    DS_EETID INT IDENTITY(1,1) PRIMARY KEY,    -- 員工連絡電話編號
    DS_EEID INT NOT NULL,                        		-- 員工編號 (FK)
    DS_EETNO VARCHAR(30) NOT NULL,             -- 連絡電話

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),		--新增時間
    Sys_CreatedBy INT NOT NULL,								--新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,							--修改時間
    Sys_UpdateBy INT NULL,									--修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,						--是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,							--刪除時間
    Sys_DeleteBy INT NULL,									--刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_EmployeeTel_Employee FOREIGN KEY (DS_EEID) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_EmployeeTel_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_EmployeeTel_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_EmployeeTel_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(DS_EEID)
);
GO



/*【3. 緊急聯絡人】*/
CREATE TABLE EmergencyContact (
    DS_EECID INT IDENTITY(1,1) PRIMARY KEY,	-- 緊急聯絡人編號
    DS_EEID INT NOT NULL, 					-- 員工編號 (FK)
    DS_EECName NVARCHAR(50) NOT NULL, 	-- 緊急聯絡人
    DS_EECRel NVARCHAR(20) NOT NULL,		-- 關係
    DS_EECMail NVARCHAR(255) NULL, 		-- 電子郵件
    DS_EECNote NVARCHAR(500) NULL,		-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),		--新增時間
    Sys_CreatedBy INT NOT NULL,								--新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,							--修改時間
    Sys_UpdateBy INT NULL,									--修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,						--是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,							--刪除時間
    Sys_DeleteBy INT NULL,									--刪除人員 (FK)


    /*FK 設定*/
    CONSTRAINT FK_EmergencyContact_Employee FOREIGN KEY (DS_EEID) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_EmergencyContact_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_EmergencyContact_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_EmergencyContact_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(DS_EEID)
);
GO



/*【4. 緊急聯絡人連絡電話】*/
CREATE TABLE EmergencyContactTel (
    DS_ECTID INT IDENTITY(1,1) PRIMARY KEY,	-- 緊急連絡電話編號
    DS_EECID INT NOT NULL,                       		-- 緊急聯絡人編號 (FK)
    DS_ECTPhone VARCHAR(30) NOT NULL,	-- 連絡電話

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),		--新增時間
    Sys_CreatedBy INT NOT NULL,								--新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,							--修改時間
    Sys_UpdateBy INT NULL,									--修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,						--是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,							--刪除時間
    Sys_DeleteBy INT NULL,									--刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_EmergencyContactTel_EmergencyContact FOREIGN KEY (DS_EECID) REFERENCES EmergencyContact(DS_EECID),
    CONSTRAINT FK_EmergencyContactTel_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_EmergencyContactTel_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_EmergencyContactTel_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(DS_EEID)
);
GO



/*【5. 公司資料表】*/ 
CREATE TABLE Company (
    DS_COID INT IDENTITY(1,1) PRIMARY KEY,          		-- 公司編號
    DS_COName NVARCHAR(50) NOT NULL,                	-- 公司登記名稱
    DS_COShortName NVARCHAR(2) NOT NULL,            	-- 公司簡稱
    DS_COFranchise NVARCHAR(20) NOT NULL,           	-- 加盟名稱
    DS_COFranchiseShort NVARCHAR(2) NOT NULL,       	-- 加盟簡稱
    DS_COTaxID VARCHAR(8) NOT NULL,                 		-- 統編
    DS_CORegDate DATE NOT NULL,                     		-- 登記日期
    DS_COAddress NVARCHAR(255) NOT NULL,            	-- 地址
    DS_COPhone VARCHAR(30) NOT NULL,                		-- 公司電話
    DS_COPrincipal NVARCHAR(50) NOT NULL,           	-- 負責人
    DE_COEstDate DATE NOT NULL,                     			-- 成立日期

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),		--新增時間
    Sys_CreatedBy INT NOT NULL,								--新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,							--修改時間
    Sys_UpdateBy INT NULL,									--修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,						--是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,							--刪除時間
    Sys_DeleteBy INT NULL,									--刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_Company_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_Company_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_Company_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(DS_EEID)
);
GO



/*【6. 公司內部資訊項目】*/
CREATE TABLE CompanyProfileItem (
    DS_CPIID INT IDENTITY(1,1) PRIMARY KEY,         -- 公司內部資訊項目編號
    DS_CPIName NVARCHAR(30) NOT NULL,           -- 公司內部資訊項目名稱
    DF_CPIIsActive BIT NOT NULL DEFAULT 1           -- 是否啟用 (0:false, 1:true)
);
GO



/*【7. 公司內部資訊】*/
CREATE TABLE CompanyProfile (
    DS_CPID INT IDENTITY(1,1) PRIMARY KEY,		-- 公司內部資訊編號
    DS_COID INT NOT NULL,                           		-- 公司編號 (FK)
    DS_CPIID INT NOT NULL,                          		-- 公司內部資訊項目編號 (FK)
    DS_CPDetails NVARCHAR(100) NOT NULL,            -- 明細

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),		--新增時間
    Sys_CreatedBy INT NOT NULL,								--新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,							--修改時間
    Sys_UpdateBy INT NULL,									--修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,						--是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,							--刪除時間
    Sys_DeleteBy INT NULL,									--刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_CompanyProfile_Company FOREIGN KEY (DS_COID) REFERENCES Company(DS_COID),
    CONSTRAINT FK_CompanyProfile_CPI FOREIGN KEY (DS_CPIID) REFERENCES CompanyProfileItem(DS_CPIID),
    CONSTRAINT FK_CompanyProfile_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_CompanyProfile_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_CompanyProfile_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(DS_EEID)
);
GO



/*【8. 部門 Departments】*/
CREATE TABLE Departments (
    DS_DPTID INT IDENTITY(1,1) PRIMARY KEY,        	-- 部門編號
    DS_COID INT NOT NULL,                          		-- 公司編號 (FK)
    DS_DPTName NVARCHAR(50) NOT NULL, 		-- 部門名稱

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),		--新增時間
    Sys_CreatedBy INT NOT NULL,								--新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,							--修改時間
    Sys_UpdateBy INT NULL,									--修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,						--是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,							--刪除時間
    Sys_DeleteBy INT NULL,									--刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_Departments_Company FOREIGN KEY (DS_COID) REFERENCES Company(DS_COID),
    CONSTRAINT FK_Departments_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_Departments_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_Departments_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(DS_EEID)
);
GO



/*【9. 部門組別 DepartmentGroups】*/
CREATE TABLE DepartmentGroups (
    DS_DGID INT IDENTITY(1,1) PRIMARY KEY,         	-- 部門組別編號
    DS_DPTID INT NOT NULL,                         		-- 部門編號 (FK)
    DS_DGName NVARCHAR(50) NOT NULL,               -- 部門組別名稱

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),		--新增時間
    Sys_CreatedBy INT NOT NULL,								--新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,							--修改時間
    Sys_UpdateBy INT NULL,									--修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,						--是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,							--刪除時間
    Sys_DeleteBy INT NULL,									--刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_DepartmentGroups_Departments FOREIGN KEY (DS_DPTID) REFERENCES Departments(DS_DPTID),
    CONSTRAINT FK_DepartmentGroups_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_DepartmentGroups_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_DepartmentGroups_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(DS_EEID)
);
GO



/*【10. 職務名稱 JobTitles】*/
CREATE TABLE JobTitles (
    DS_JTID INT IDENTITY(1,1) PRIMARY KEY, 	-- 職稱編號
    DS_DPTID INT NOT NULL,                         	-- 部門編號 (FK)
    DS_JTName NVARCHAR(50) NOT NULL,		-- 職稱名稱

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),		--新增時間
    Sys_CreatedBy INT NOT NULL,								--新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,							--修改時間
    Sys_UpdateBy INT NULL,									--修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,						--是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,							--刪除時間
    Sys_DeleteBy INT NULL,									--刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_JobTitles_Departments FOREIGN KEY (DS_DPTID) REFERENCES Departments(DS_DPTID),
    CONSTRAINT FK_JobTitles_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_JobTitles_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_JobTitles_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(DS_EEID)
);
GO



/*【11. 員工識別證 EmployeeIDCard】*/
CREATE TABLE EmployeeIDCard (
    DS_EICID VARCHAR(16) PRIMARY KEY,              			-- 卡片號碼 (PK, unique)
    DS_EEID INT NOT NULL,                          					-- 員工編號 (FK)
    DS_EICRegDT DATETIME NOT NULL DEFAULT GETDATE(),	-- 登錄日期
    DS_COID INT NOT NULL,                          				-- 公司編號 (FK 打卡地點)
    DS_EICExpiryDT DATETIME NULL,                  				-- 失效日期

    /*系統欄位*/
    Sys_CreatedBy INT NOT NULL, 		-- 新增人員 (FK)
    Sys_UpdateBy INT NULL, 				-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_EmployeeIDCard_Employee FOREIGN KEY (DS_EEID) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_EmployeeIDCard_Company FOREIGN KEY (DS_COID) REFERENCES Company(DS_COID),
    CONSTRAINT FK_EmployeeIDCard_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_EmployeeIDCard_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO



/*【12. 任職原因 JobAssignmentReason】*/
CREATE TABLE JobAssignmentReason (
    DS_JARID INT IDENTITY(1,1) PRIMARY KEY, 		-- 任職原因編號
    DS_JARName NVARCHAR(20) NOT NULL, 		-- 任職原因名稱
    DS_JARIsActive BIT NOT NULL DEFAULT 1		-- 是否啟用 (0:false, 1:true)

);
GO



/*【13. 員工任職紀錄 JobAssignments】*/
CREATE TABLE JobAssignments (
    DS_JAID INT IDENTITY(1,1) PRIMARY KEY, 		-- 任職記錄編號
    DS_EEID INT NOT NULL,						-- 員工編號 (FK)
    DS_DGID INT NOT NULL,						-- 部門組別編號 (FK)
    DS_JADirector INT NOT NULL, 				-- 帶組主管 (FK Employee)
    DS_JTID INT NOT NULL,						-- 職稱編號 (FK)
    DS_JARID INT NOT NULL,						-- 任職原因 (FK)
    DS_JAStartDate DATE NOT NULL,				-- 起始日期
    DS_JAEndDate DATE NULL, 					-- 結束日期
    DS_JANote NVARCHAR(500) NULL,				-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),		--新增時間
    Sys_CreatedBy INT NOT NULL,								--新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,							--修改時間
    Sys_UpdateBy INT NULL,									--修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_JobAssignments_Employee FOREIGN KEY (DS_EEID) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_JobAssignments_DepartmentGroups FOREIGN KEY (DS_DGID) REFERENCES DepartmentGroups(DS_DGID),
    CONSTRAINT FK_JobAssignments_Director FOREIGN KEY (DS_JADirector) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_JobAssignments_JobTitles FOREIGN KEY (DS_JTID) REFERENCES JobTitles(DS_JTID),
    CONSTRAINT FK_JobAssignments_Reason FOREIGN KEY (DS_JARID) REFERENCES JobAssignmentReason(DS_JARID),
    CONSTRAINT FK_JobAssignments_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_JobAssignments_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO



/*【14. 薪資結構類別 SalaryStructureType】*/
CREATE TABLE SalaryStructureType (
    DS_SSTID CHAR(1) PRIMARY KEY,                  		-- 薪資結構類別編號 (Ex：A、B、C....)
    DS_SSTName NVARCHAR(20) NOT NULL,              -- 薪資結構類別名稱

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                   					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                 				  	-- 修改時間
    Sys_UpdateBy INT NULL,                     					   	-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_SalaryStructureType_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_SalaryStructureType_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO


/*【15. 薪資結構明細 SalaryStructureDetail】*/
CREATE TABLE SalaryStructureDetail (
    DS_SSDID CHAR(4) PRIMARY KEY,                 	-- 薪資結構明細編號 (Ex：A001、A002、B001、C001....)
    DS_SSTID CHAR(1) NOT NULL,                    	-- 薪資結構類別編號 (FK)
    DS_SSDName NVARCHAR(30) NOT NULL, 	-- 薪資結構明細名稱

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                   					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,               				    	-- 修改時間
    Sys_UpdateBy INT NULL,                        						-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_SalaryStructureDetail_Type FOREIGN KEY (DS_SSTID) REFERENCES SalaryStructureType(DS_SSTID),
    CONSTRAINT FK_SalaryStructureDetail_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_SalaryStructureDetail_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO


/*【17. 公司薪資結構預設 CompanySalaryStructure】*/
CREATE TABLE CompanySalaryStructure (
    DS_CSSID CHAR(6) PRIMARY KEY,                   				 -- 公司薪資結構預設編號
    DS_COID INT NOT NULL,                           				 -- 公司編號 (FK)
    DS_SSDID CHAR(4) NOT NULL, 						-- 薪資結構明細編號 (FK)
    DS_CUID INT NOT NULL,								-- 計算單位編號 (FK)
    DS_CSSDefault DECIMAL(10,2) NOT NULL DEFAULT 0,		-- 預設值
    DS_CSSNote NVARCHAR(100) NULL,					-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,                 				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,                          				-- 刪除時間
    Sys_DeleteBy INT NULL,                               					-- 刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_CompanySalaryStructure_Company FOREIGN KEY (DS_COID) REFERENCES Company(DS_COID),
    CONSTRAINT FK_CompanySalaryStructure_SalaryStructureDetail FOREIGN KEY (DS_SSDID) REFERENCES SalaryStructureDetail(DS_SSDID),
    CONSTRAINT FK_CompanySalaryStructure_CalculationUnits FOREIGN KEY (DS_CUID) REFERENCES CalculationUnits(DS_CUID),
    CONSTRAINT FK_CompanySalaryStructure_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_CompanySalaryStructure_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_CompanySalaryStructure_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(DS_EEID)
);
GO


/*【18. 員工薪資狀態資料 EmployeeProfile】*/
CREATE TABLE EmployeeProfile (
    DS_EPID INT IDENTITY(1,1) PRIMARY KEY,          			-- 員工薪資狀態資料編號
    DS_EEID INT NOT NULL,                           					-- 員工編號 (FK)
    DS_EPAdminTotal DECIMAL(9,2) NOT NULL DEFAULT 0,	-- 行政薪資總額
    DS_EPOnBoard DATE NOT NULL,                     			-- 到職日
    DS_EPConfirm DATE NULL,                         				-- 轉正日
    DS_EPTerminate DATE NULL,                       				-- 離職日
    DS_EPNote NVARCHAR(500) NULL,                   			-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_EmployeeProfile_Employee FOREIGN KEY (DS_EEID) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_EmployeeProfile_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_EmployeeProfile_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO


/*【19. 員工薪資結構明細 EmployeeCompensation】*/
CREATE TABLE EmployeeCompensation (
    DS_ESID INT IDENTITY(1,1) PRIMARY KEY,          		-- 雇員薪資結構明細編號
    DS_EPID INT NOT NULL,                           			-- 員工薪資狀態資料編號 (FK)
    DS_SSDID CHAR(4) NOT NULL,                      			-- 薪資結構明細編號 (FK)
    DS_CUID INT NOT NULL,                           			-- 計算單位編號 (FK)
    DS_ESAmount DECIMAL(9,2) NOT NULL DEFAULT 0, 	-- 明細金額

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,                 				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,                          				-- 刪除時間
    Sys_DeleteBy INT NULL,                               					-- 刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_EmployeeCompensation_EmployeeProfile FOREIGN KEY (DS_EPID) REFERENCES EmployeeProfile(DS_EPID),
    CONSTRAINT FK_EmployeeCompensation_SalaryStructureDetail FOREIGN KEY (DS_SSDID) REFERENCES SalaryStructureDetail(DS_SSDID),
    CONSTRAINT FK_EmployeeCompensation_CalculationUnits FOREIGN KEY (DS_CUID) REFERENCES CalculationUnits(DS_CUID),
    CONSTRAINT FK_EmployeeCompensation_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_EmployeeCompensation_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_EmployeeCompensation_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(DS_EEID)
);
GO


/*【20. 銀行代碼 BankBranches】*/
CREATE TABLE BankBranches (
    DS_BBID INT IDENTITY(1,1) PRIMARY KEY,           	-- 銀行代碼編號
    DS_BBBankCode CHAR(3) NOT NULL,                 	-- 銀行代碼
    DS_BBBankName NVARCHAR(50) NOT NULL,	-- 銀行名稱
    DS_BBBranchCode CHAR(7) NOT NULL,			-- 分行代碼
    DS_BBBranchName NVARCHAR(50) NOT NULL,	-- 分行名稱
    DS_BBIsActive BIT NOT NULL DEFAULT 1,		-- 是否啟用 (0:false, 1:true)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE() 	-- 新增時間
);
GO


/*【21. 員工銀行帳戶 EmployeeBankAccounts】*/
CREATE TABLE EmployeeBankAccounts (
    DS_EBAID INT IDENTITY(1,1) PRIMARY KEY,         	-- 員工銀行帳戶編號
    DS_EEID INT NOT NULL,                           			-- 員工編號 (FK)
    DS_BBID INT NOT NULL,                      			-- 銀行代碼編號 (FK)
    DS_EBAOwner NVARCHAR(50) NOT NULL, 		-- 帳戶所有人
    DS_EBABankNum NVARCHAR(70) NOT NULL, 	-- 銀行號碼
    DS_EBANote NVARCHAR(100) NULL,			-- 備註
    DS_EBAIsActive BIT NOT NULL DEFAULT 1,		-- 是否啟用 (0:false, 1:true)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                     					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                     					-- 修改時間
    Sys_UpdateBy INT NULL,                          						-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_EBA_Employee FOREIGN KEY (DS_EEID) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_EBA_BankBranches FOREIGN KEY (DS_BBID) REFERENCES BankBranches(DS_BBID),
    CONSTRAINT FK_EBA_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_EBA_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO


/*【22. 權限類別 AuthorizationType】*/
CREATE TABLE AuthorizationType (
    DS_ATID INT IDENTITY(1,1) PRIMARY KEY,          	-- 權限類別編號
    DS_ATName NVARCHAR(100) NOT NULL,		-- 權限類別名稱
    DS_ATIsActive BIT NOT NULL DEFAULT 1            	-- 是否啟用 (0:false, 1:true)
);
GO


/*【23. 權限項目 AuthorizationItem】*/
CREATE TABLE AuthorizationItem (
    DS_AIID INT IDENTITY(1,1) PRIMARY KEY,          	-- 權限項目編號
    DS_ATID INT NOT NULL,                           		-- 權限類別編號 (FK)
    DS_ATName NVARCHAR(100) NOT NULL,		-- 權限項目名稱
    DS_ATIsActive BIT NOT NULL DEFAULT 1,		-- 是否有效 (0:false, 1:true)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                     					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                     					-- 修改時間
    Sys_UpdateBy INT NULL,                          						-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_AI_AuthorizationType FOREIGN KEY (DS_ATID) REFERENCES AuthorizationType(DS_ATID),
    CONSTRAINT FK_AI_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_AI_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO


/*【24. 員工權限明細 EmployeeAUTHPermission】*/
CREATE TABLE EmployeeAUTHPermission (
    DS_EAPID INT IDENTITY(1,1) PRIMARY KEY,         	-- 員工權限明細編號
    DS_EEID INT NOT NULL,                           			-- 員工編號 (FK)
    DS_AIID INT NOT NULL,                           			-- 權限項目編號 (FK)

    /*FK 設定*/
    CONSTRAINT FK_EAP_Employee FOREIGN KEY (DS_EEID) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_EAP_AuthorizationItem FOREIGN KEY (DS_AIID) REFERENCES AuthorizationItem(DS_AIID)
);
GO


/*【25. 系統登(出)入原因 SysLoginReason】*/
CREATE TABLE SysLoginReason (
    DS_SLRID INT IDENTITY(1,1) PRIMARY KEY,    	-- 原因編號
    DS_SLRReason NVARCHAR(20) NOT NULL,         	-- 原因
    DS_SLRIsActive BIT NOT NULL DEFAULT 1            	-- 是否啟用 (0:false, 1:true)
);
GO


/*【26. 系統登(出)入紀錄 SysLoginLog】*/
CREATE TABLE SysLoginLog (
    DS_SLLID INT IDENTITY(1,1) PRIMARY KEY,   	-- 紀錄編號
    DS_EEID INT NOT NULL,                      		-- 員工編號 (FK)
    DS_SLRID INT NOT NULL,                     		-- 原因編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),   -- 發生時間

    /*FK 設定*/
    CONSTRAINT FK_SysLoginLog_Employee FOREIGN KEY (DS_EEID) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_SysLoginLog_SysLoginReason FOREIGN KEY (DS_SLRID) REFERENCES SysLoginReason(DS_SLRID)
);
GO




