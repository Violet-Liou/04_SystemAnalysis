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
    EEID INT IDENTITY(1,1) PRIMARY KEY,		-- 員工編號
    EEAccount CHAR(10) NOT NULL,			-- 身分證字號
    EEPassword NVARCHAR(255) NOT NULL,	--密碼 (使用【雜湊 (SHA256 的 hash)】)
    EEName NVARCHAR(50) NOT NULL,		--姓名
    EEBirth DATE NOT NULL,					--生日
    EEMail NVARCHAR(255) NOT NULL,		--電子信箱
    EERegAddr NVARCHAR(255) NOT NULL,	--戶籍地址
    EEMailAddr NVARCHAR(255) NOT NULL,	--通訊地址
    EEIsActive BIT NOT NULL DEFAULT 1,		--狀態
    EENote NVARCHAR(500) NULL,			--備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),		--新增時間
    Sys_CreatedBy INT NULL,   								--新增人員 (先允許 NULL，避免 FK 錯誤)
    Sys_UpdateDT DATETIME NULL,							--修改時間
    Sys_UpdateBy INT NULL									--修改人員 (FK)
);
GO

-- 為表格新增描述
EXEC sp_addextendedproperty N'MS_Description', N'員工表', N'Schema', N'dbo', N'Table', N'Employee';
-- 為欄位新增描述
EXEC sp_addextendedproperty N'MS_Description', N'員工編號', N'Schema', N'dbo', N'Table', N'Employee', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'身分證字號', N'Schema', N'dbo', N'Table', N'Employee', N'Column', N'EEAccount';
EXEC sp_addextendedproperty N'MS_Description', N'密碼', N'Schema', N'dbo', N'Table', N'Employee', N'Column', N'EEPassword';
EXEC sp_addextendedproperty N'MS_Description', N'姓名', N'Schema', N'dbo', N'Table', N'Employee', N'Column', N'EEName';
EXEC sp_addextendedproperty N'MS_Description', N'生日', N'Schema', N'dbo', N'Table', N'Employee', N'Column', N'EEBirth';
EXEC sp_addextendedproperty N'MS_Description', N'電子信箱', N'Schema', N'dbo', N'Table', N'Employee', N'Column', N'EEMail';
EXEC sp_addextendedproperty N'MS_Description', N'戶籍地址', N'Schema', N'dbo', N'Table', N'Employee', N'Column', N'EERegAddr';
EXEC sp_addextendedproperty N'MS_Description', N'通訊地址', N'Schema', N'dbo', N'Table', N'Employee', N'Column', N'EEMailAddr';
EXEC sp_addextendedproperty N'MS_Description', N'狀態', N'Schema', N'dbo', N'Table', N'Employee', N'Column', N'EEIsActive';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'Employee', N'Column', N'EENote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'Employee', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'Employee', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'Employee', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'Employee', N'Column', N'Sys_UpdateBy';
GO


-- Step 2: 插入第一筆員工資料（系統管理員）
INSERT INTO Employee (
    EEAccount, EEPassword, EEName, EEBirth,
    EEMail, EERegAddr, EEMailAddr
)
VALUES (
    'ADMIN001', 'admin@123', '系統管理員', '1980-01-01',
    'admin@example.com', '高雄市', '高雄市'
);
GO

-- Step 3: 將 Sys_CreatedBy 設定為自己的 ID（這筆資料會是 ID = 1）
UPDATE Employee
SET Sys_CreatedBy = EEID
WHERE EEAccount = 'ADMIN001';
GO

-- Step 4: 將 Sys_CreatedBy 欄位改為 NOT NULL（因為已有資料且合法）
ALTER TABLE Employee
ALTER COLUMN Sys_CreatedBy INT NOT NULL;
GO

-- Step 5: 補上 FOREIGN KEY 約束（現在資料已合法）
ALTER TABLE Employee
ADD CONSTRAINT FK_Employee_CreatedBy
FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID);
GO

ALTER TABLE Employee
ADD CONSTRAINT FK_Employee_UpdatedBy
FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID);
GO

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

/*【2. 員工連絡電話】*/
CREATE TABLE EmployeeTel (
    EETID INT IDENTITY(1,1) PRIMARY KEY,    	-- 員工連絡電話編號
    EEID INT NOT NULL,                        			-- 員工編號 (FK)
    EETNO VARCHAR(30) NOT NULL,             	-- 連絡電話

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),		--新增時間
    Sys_CreatedBy INT NOT NULL,								--新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,							--修改時間
    Sys_UpdateBy INT NULL,									--修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,						--是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,							--刪除時間
    Sys_DeleteBy INT NULL,									--刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_EmployeeTel_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_EmployeeTel_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_EmployeeTel_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_EmployeeTel_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID)
);
GO
-- 為表格新增描述
EXEC sp_addextendedproperty N'MS_Description', N'員工連絡電話表', N'Schema', N'dbo', N'Table', N'EmployeeTel';
-- 為欄位新增描述
EXEC sp_addextendedproperty N'MS_Description', N'員工連絡電話編號', N'Schema', N'dbo', N'Table', N'EmployeeTel', N'Column', N'EETID';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'EmployeeTel', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'連絡電話', N'Schema', N'dbo', N'Table', N'EmployeeTel', N'Column', N'EETNO';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'EmployeeTel', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'EmployeeTel', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'EmployeeTel', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'EmployeeTel', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'EmployeeTel', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'EmployeeTel', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'EmployeeTel', N'Column', N'Sys_DeleteBy';
GO




/*【3. 緊急聯絡人】*/
CREATE TABLE EmergencyContact (
    EECID INT IDENTITY(1,1) PRIMARY KEY,	-- 緊急聯絡人編號
    EEID INT NOT NULL, 					-- 員工編號 (FK)
    EECName NVARCHAR(50) NOT NULL, 	-- 緊急聯絡人
    EECRel NVARCHAR(20) NOT NULL,		-- 關係
    EECMail NVARCHAR(255) NULL, 		-- 電子郵件
    EECNote NVARCHAR(500) NULL,		-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),		--新增時間
    Sys_CreatedBy INT NOT NULL,								--新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,							--修改時間
    Sys_UpdateBy INT NULL,									--修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,						--是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,							--刪除時間
    Sys_DeleteBy INT NULL,									--刪除人員 (FK)


    /*FK 設定*/
    CONSTRAINT FK_EmergencyContact_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_EmergencyContact_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_EmergencyContact_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_EmergencyContact_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID)
);
GO
-- 為表格新增描述
EXEC sp_addextendedproperty N'MS_Description', N'緊急聯絡人表', N'Schema', N'dbo', N'Table', N'EmergencyContact';
-- 為欄位新增描述
EXEC sp_addextendedproperty N'MS_Description', N'緊急聯絡人編號', N'Schema', N'dbo', N'Table', N'EmergencyContact', N'Column', N'EECID';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'EmergencyContact', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'緊急聯絡人', N'Schema', N'dbo', N'Table', N'EmergencyContact', N'Column', N'EECName';
EXEC sp_addextendedproperty N'MS_Description', N'關係', N'Schema', N'dbo', N'Table', N'EmergencyContact', N'Column', N'EECRel';
EXEC sp_addextendedproperty N'MS_Description', N'電子郵件', N'Schema', N'dbo', N'Table', N'EmergencyContact', N'Column', N'EECMail';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'EmergencyContact', N'Column', N'EECNote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'EmergencyContact', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'EmergencyContact', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'EmergencyContact', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'EmergencyContact', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'EmergencyContact', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'EmergencyContact', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'EmergencyContact', N'Column', N'Sys_DeleteBy';
GO




/*【4. 緊急聯絡人連絡電話】*/
CREATE TABLE EmergencyContactTel (
    ECTID INT IDENTITY(1,1) PRIMARY KEY,		-- 緊急連絡電話編號
    EECID INT NOT NULL,                       		-- 緊急聯絡人編號 (FK)
    ECTPhone VARCHAR(30) NOT NULL,		-- 連絡電話

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),		--新增時間
    Sys_CreatedBy INT NOT NULL,								--新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,							--修改時間
    Sys_UpdateBy INT NULL,									--修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,						--是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,							--刪除時間
    Sys_DeleteBy INT NULL,									--刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_EmergencyContactTel_EmergencyContact FOREIGN KEY (EECID) REFERENCES EmergencyContact(EECID),
    CONSTRAINT FK_EmergencyContactTel_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_EmergencyContactTel_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_EmergencyContactTel_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID)
);
GO
-- 為表格新增描述
EXEC sp_addextendedproperty N'MS_Description', N'緊急聯絡人連絡電話表', N'Schema', N'dbo', N'Table', N'EmergencyContactTel';
-- 為欄位新增描述
EXEC sp_addextendedproperty N'MS_Description', N'緊急連絡電話編號', N'Schema', N'dbo', N'Table', N'EmergencyContactTel', N'Column', N'ECTID';
EXEC sp_addextendedproperty N'MS_Description', N'緊急聯絡人', N'Schema', N'dbo', N'Table', N'EmergencyContactTel', N'Column', N'EECID';
EXEC sp_addextendedproperty N'MS_Description', N'連絡電話', N'Schema', N'dbo', N'Table', N'EmergencyContactTel', N'Column', N'ECTPhone';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'EmergencyContactTel', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'EmergencyContactTel', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'EmergencyContactTel', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'EmergencyContactTel', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'EmergencyContactTel', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'EmergencyContactTel', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'EmergencyContactTel', N'Column', N'Sys_DeleteBy';
GO




/*【5. 公司資料表】*/ 
CREATE TABLE Company (
    COID INT IDENTITY(1,1) PRIMARY KEY,          		-- 公司編號
    COName NVARCHAR(50) NOT NULL,                	-- 公司登記名稱
    COShortName NVARCHAR(2) NOT NULL,            	-- 公司簡稱
    COFranchise NVARCHAR(20) NOT NULL,           	-- 加盟名稱
    COFranchiseShort NVARCHAR(2) NOT NULL,       	-- 加盟簡稱
    COTaxID VARCHAR(8) NOT NULL,                 		-- 統編
    CORegDate DATE NOT NULL,                     		-- 登記日期
    COAddress NVARCHAR(255) NOT NULL,            	-- 地址
    COPhone VARCHAR(30) NOT NULL,  			-- 公司電話
    COPrincipal NVARCHAR(50) NOT NULL,           	-- 負責人
    COEstDate DATE NOT NULL, 					-- 成立日期

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),		--新增時間
    Sys_CreatedBy INT NOT NULL,								--新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,							--修改時間
    Sys_UpdateBy INT NULL,									--修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,						--是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,							--刪除時間
    Sys_DeleteBy INT NULL,									--刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_Company_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_Company_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_Company_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID)
);
GO
-- 為表格新增描述
EXEC sp_addextendedproperty N'MS_Description', N'公司資料表', N'Schema', N'dbo', N'Table', N'Company';
-- 為欄位新增描述
EXEC sp_addextendedproperty N'MS_Description', N'公司編號', N'Schema', N'dbo', N'Table', N'Company', N'Column', N'COID';
EXEC sp_addextendedproperty N'MS_Description', N'公司登記名稱', N'Schema', N'dbo', N'Table', N'Company', N'Column', N'COName';
EXEC sp_addextendedproperty N'MS_Description', N'公司簡稱', N'Schema', N'dbo', N'Table', N'Company', N'Column', N'COShortName';
EXEC sp_addextendedproperty N'MS_Description', N'加盟名稱', N'Schema', N'dbo', N'Table', N'Company', N'Column', N'COFranchise';
EXEC sp_addextendedproperty N'MS_Description', N'加盟簡稱', N'Schema', N'dbo', N'Table', N'Company', N'Column', N'COFranchiseShort';
EXEC sp_addextendedproperty N'MS_Description', N'統編', N'Schema', N'dbo', N'Table', N'Company', N'Column', N'COTaxID';
EXEC sp_addextendedproperty N'MS_Description', N'登記日期', N'Schema', N'dbo', N'Table', N'Company', N'Column', N'CORegDate';
EXEC sp_addextendedproperty N'MS_Description', N'地址', N'Schema', N'dbo', N'Table', N'Company', N'Column', N'COAddress';
EXEC sp_addextendedproperty N'MS_Description', N'公司電話', N'Schema', N'dbo', N'Table', N'Company', N'Column', N'COPhone';
EXEC sp_addextendedproperty N'MS_Description', N'負責人', N'Schema', N'dbo', N'Table', N'Company', N'Column', N'COPrincipal';
EXEC sp_addextendedproperty N'MS_Description', N'成立日期', N'Schema', N'dbo', N'Table', N'Company', N'Column', N'COEstDate';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'Company', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'Company', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'Company', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'Company', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'Company', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'Company', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'Company', N'Column', N'Sys_DeleteBy';
GO




/*【6. 公司內部資訊項目】*/
CREATE TABLE CompanyProfileItem (
    CPIID INT IDENTITY(1,1) PRIMARY KEY,         -- 公司內部資訊項目編號
    CPIName NVARCHAR(30) NOT NULL,           -- 公司內部資訊項目名稱
    CPIIsActive BIT NOT NULL DEFAULT 1           -- 是否啟用 (0:false, 1:true)
);
GO
-- 為表格新增描述
EXEC sp_addextendedproperty N'MS_Description', N'公司內部資訊項目表', N'Schema', N'dbo', N'Table', N'CompanyProfileItem';
-- 為欄位新增描述
EXEC sp_addextendedproperty N'MS_Description', N'公司內部資訊項目編號', N'Schema', N'dbo', N'Table', N'CompanyProfileItem', N'Column', N'CPIID';
EXEC sp_addextendedproperty N'MS_Description', N'公司內部資訊項目名稱', N'Schema', N'dbo', N'Table', N'CompanyProfileItem', N'Column', N'CPIName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'CompanyProfileItem', N'Column', N'CPIIsActive';
GO




/*【7. 公司內部資訊】*/
CREATE TABLE CompanyProfile (
    CPID INT IDENTITY(1,1) PRIMARY KEY,		-- 公司內部資訊編號
    COID INT NOT NULL,                           		-- 公司編號 (FK)
    CPIID INT NOT NULL,                          		-- 公司內部資訊項目編號 (FK)
    CPDetails NVARCHAR(100) NOT NULL,            -- 明細

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),		--新增時間
    Sys_CreatedBy INT NOT NULL,								--新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,							--修改時間
    Sys_UpdateBy INT NULL,									--修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,						--是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,							--刪除時間
    Sys_DeleteBy INT NULL,									--刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_CompanyProfile_Company FOREIGN KEY (COID) REFERENCES Company(COID),
    CONSTRAINT FK_CompanyProfile_CPI FOREIGN KEY (CPIID) REFERENCES CompanyProfileItem(CPIID),
    CONSTRAINT FK_CompanyProfile_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_CompanyProfile_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_CompanyProfile_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID)
);
GO
-- 為表格新增描述
EXEC sp_addextendedproperty N'MS_Description', N'公司內部資訊表', N'Schema', N'dbo', N'Table', N'CompanyProfile';
-- 為欄位新增描述
EXEC sp_addextendedproperty N'MS_Description', N'公司內部資訊編號', N'Schema', N'dbo', N'Table', N'CompanyProfile', N'Column', N'CPID';
EXEC sp_addextendedproperty N'MS_Description', N'公司', N'Schema', N'dbo', N'Table', N'CompanyProfile', N'Column', N'COID';
EXEC sp_addextendedproperty N'MS_Description', N'公司內部資訊項目編號', N'Schema', N'dbo', N'Table', N'CompanyProfile', N'Column', N'CPIID';
EXEC sp_addextendedproperty N'MS_Description', N'明細', N'Schema', N'dbo', N'Table', N'CompanyProfile', N'Column', N'CPDetails';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'CompanyProfile', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'CompanyProfile', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'CompanyProfile', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'CompanyProfile', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'CompanyProfile', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'CompanyProfile', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'CompanyProfile', N'Column', N'Sys_DeleteBy';
GO



/*【8. 部門 Departments】*/
CREATE TABLE Departments (
    DPTID INT IDENTITY(1,1) PRIMARY KEY,        	-- 部門編號
    COID INT NOT NULL,                          		-- 公司編號 (FK)
    DPTName NVARCHAR(50) NOT NULL, 		-- 部門名稱

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),		--新增時間
    Sys_CreatedBy INT NOT NULL,								--新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,							--修改時間
    Sys_UpdateBy INT NULL,									--修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,						--是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,							--刪除時間
    Sys_DeleteBy INT NULL,									--刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_Departments_Company FOREIGN KEY (COID) REFERENCES Company(COID),
    CONSTRAINT FK_Departments_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_Departments_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_Departments_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID)
);
GO
-- 為表格新增描述
EXEC sp_addextendedproperty N'MS_Description', N'部門表', N'Schema', N'dbo', N'Table', N'Departments';
-- 為欄位新增描述
EXEC sp_addextendedproperty N'MS_Description', N'部門編號', N'Schema', N'dbo', N'Table', N'Departments', N'Column', N'DPTID';
EXEC sp_addextendedproperty N'MS_Description', N'公司', N'Schema', N'dbo', N'Table', N'Departments', N'Column', N'COID';
EXEC sp_addextendedproperty N'MS_Description', N'部門名稱', N'Schema', N'dbo', N'Table', N'Departments', N'Column', N'DPTName';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'Departments', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'Departments', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'Departments', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'Departments', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'Departments', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'Departments', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'Departments', N'Column', N'Sys_DeleteBy';
GO




/*【9. 部門組別 DepartmentGroups】*/
CREATE TABLE DepartmentGroups (
    DGID INT IDENTITY(1,1) PRIMARY KEY,         	-- 部門組別編號
    DPTID INT NOT NULL,                         		-- 部門編號 (FK)
    DGName NVARCHAR(50) NOT NULL,       	-- 部門組別名稱

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),		--新增時間
    Sys_CreatedBy INT NOT NULL,								--新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,							--修改時間
    Sys_UpdateBy INT NULL,									--修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,						--是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,							--刪除時間
    Sys_DeleteBy INT NULL,									--刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_DepartmentGroups_Departments FOREIGN KEY (DPTID) REFERENCES Departments(DPTID),
    CONSTRAINT FK_DepartmentGroups_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_DepartmentGroups_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_DepartmentGroups_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID)
);
GO
-- 為表格新增描述
EXEC sp_addextendedproperty N'MS_Description', N'部門組別表', N'Schema', N'dbo', N'Table', N'DepartmentGroups';
-- 為欄位新增描述
EXEC sp_addextendedproperty N'MS_Description', N'部門組別編號', N'Schema', N'dbo', N'Table', N'DepartmentGroups', N'Column', N'DGID';
EXEC sp_addextendedproperty N'MS_Description', N'部門', N'Schema', N'dbo', N'Table', N'DepartmentGroups', N'Column', N'DPTID';
EXEC sp_addextendedproperty N'MS_Description', N'部門組別名稱', N'Schema', N'dbo', N'Table', N'DepartmentGroups', N'Column', N'DGName';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'DepartmentGroups', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'DepartmentGroups', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'DepartmentGroups', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'DepartmentGroups', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'DepartmentGroups', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'DepartmentGroups', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'DepartmentGroups', N'Column', N'Sys_DeleteBy';
GO



/*【10. 職務名稱 JobTitles】*/
CREATE TABLE JobTitles (
    JTID INT IDENTITY(1,1) PRIMARY KEY, 		-- 職稱編號
    DPTID INT NOT NULL,                         		-- 部門編號 (FK)
    JTName NVARCHAR(50) NOT NULL,		-- 職稱名稱

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),		--新增時間
    Sys_CreatedBy INT NOT NULL,								--新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,							--修改時間
    Sys_UpdateBy INT NULL,									--修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,						--是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,							--刪除時間
    Sys_DeleteBy INT NULL,									--刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_JobTitles_Departments FOREIGN KEY (DPTID) REFERENCES Departments(DPTID),
    CONSTRAINT FK_JobTitles_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_JobTitles_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_JobTitles_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID)
);
GO
-- 為表格新增描述
EXEC sp_addextendedproperty N'MS_Description', N'職務名稱表', N'Schema', N'dbo', N'Table', N'JobTitles';
-- 為欄位新增描述
EXEC sp_addextendedproperty N'MS_Description', N'職稱編號', N'Schema', N'dbo', N'Table', N'JobTitles', N'Column', N'JTID';
EXEC sp_addextendedproperty N'MS_Description', N'部門', N'Schema', N'dbo', N'Table', N'JobTitles', N'Column', N'DPTID';
EXEC sp_addextendedproperty N'MS_Description', N'職稱名稱', N'Schema', N'dbo', N'Table', N'JobTitles', N'Column', N'JTName';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'JobTitles', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'JobTitles', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'JobTitles', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'JobTitles', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'JobTitles', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'JobTitles', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'JobTitles', N'Column', N'Sys_DeleteBy';
GO






/*【11. 員工識別證 EmployeeIDCard】*/
CREATE TABLE EmployeeIDCard (
    EICID VARCHAR(16) PRIMARY KEY,              				-- 卡片號碼 (PK, unique)
    EEID INT NOT NULL,                          					-- 員工編號 (FK)
    EICRegDT DATETIME NOT NULL DEFAULT GETDATE(),		-- 登錄日期
    COID INT NOT NULL,                          					-- 公司編號 (FK 打卡地點)
    EICExpiryDT DATETIME NULL,                  				-- 失效日期

    /*系統欄位*/
    Sys_CreatedBy INT NOT NULL, 		-- 新增人員 (FK)
    Sys_UpdateBy INT NULL, 				-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_EmployeeIDCard_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_EmployeeIDCard_Company FOREIGN KEY (COID) REFERENCES Company(COID),
    CONSTRAINT FK_EmployeeIDCard_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_EmployeeIDCard_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 為表格新增描述
EXEC sp_addextendedproperty N'MS_Description', N'員工識別證表', N'Schema', N'dbo', N'Table', N'EmployeeIDCard';
-- 為欄位新增描述
EXEC sp_addextendedproperty N'MS_Description', N'卡片號碼', N'Schema', N'dbo', N'Table', N'EmployeeIDCard', N'Column', N'EICID';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'EmployeeIDCard', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'登錄日期', N'Schema', N'dbo', N'Table', N'EmployeeIDCard', N'Column', N'EICRegDT';
EXEC sp_addextendedproperty N'MS_Description', N'打卡地點', N'Schema', N'dbo', N'Table', N'EmployeeIDCard', N'Column', N'COID';
EXEC sp_addextendedproperty N'MS_Description', N'失效日期', N'Schema', N'dbo', N'Table', N'EmployeeIDCard', N'Column', N'EICExpiryDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'EmployeeIDCard', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'EmployeeIDCard', N'Column', N'Sys_UpdateBy';
GO





/*【12. 任職原因 JobAssignmentReason】*/
CREATE TABLE JobAssignmentReason (
    JARID INT IDENTITY(1,1) PRIMARY KEY, 		-- 任職原因編號
    JARName NVARCHAR(20) NOT NULL, 		-- 任職原因名稱
    JARIsActive BIT NOT NULL DEFAULT 1		-- 是否啟用 (0:false, 1:true)

);
GO
-- 為表格新增描述
EXEC sp_addextendedproperty N'MS_Description', N'任職原因表', N'Schema', N'dbo', N'Table', N'JobAssignmentReason';

-- 為欄位新增描述，每個欄位單行
EXEC sp_addextendedproperty N'MS_Description', N'任職原因編號', N'Schema', N'dbo', N'Table', N'JobAssignmentReason', N'Column', N'JARID';
EXEC sp_addextendedproperty N'MS_Description', N'任職原因', N'Schema', N'dbo', N'Table', N'JobAssignmentReason', N'Column', N'JARName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'JobAssignmentReason', N'Column', N'JARIsActive';
GO




/*【13. 員工任職紀錄 JobAssignments】*/
CREATE TABLE JobAssignments (
    JAID INT IDENTITY(1,1) PRIMARY KEY, 		-- 任職記錄編號
    EEID INT NOT NULL,						-- 員工編號 (FK)
    DGID INT NOT NULL,						-- 部門組別編號 (FK)
    JADirector INT NOT NULL, 				-- 帶組主管 (FK Employee)
    JTID INT NOT NULL,						-- 職稱編號 (FK)
    JARID INT NOT NULL,					-- 任職原因 (FK)
    JAStartDate DATE NOT NULL,				-- 起始日期
    JAEndDate DATE NULL, 					-- 結束日期
    JANote NVARCHAR(500) NULL,			-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),		--新增時間
    Sys_CreatedBy INT NOT NULL,								--新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,							--修改時間
    Sys_UpdateBy INT NULL,									--修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_JobAssignments_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_JobAssignments_DepartmentGroups FOREIGN KEY (DGID) REFERENCES DepartmentGroups(DGID),
    CONSTRAINT FK_JobAssignments_Director FOREIGN KEY (JADirector) REFERENCES Employee(EEID),
    CONSTRAINT FK_JobAssignments_JobTitles FOREIGN KEY (JTID) REFERENCES JobTitles(JTID),
    CONSTRAINT FK_JobAssignments_Reason FOREIGN KEY (JARID) REFERENCES JobAssignmentReason(JARID),
    CONSTRAINT FK_JobAssignments_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_JobAssignments_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 為表格新增描述
EXEC sp_addextendedproperty N'MS_Description', N'員工任職紀錄表', N'Schema', N'dbo', N'Table', N'JobAssignments';
-- 為欄位新增描述
EXEC sp_addextendedproperty N'MS_Description', N'任職記錄編號', N'Schema', N'dbo', N'Table', N'JobAssignments', N'Column', N'JAID';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'JobAssignments', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'部門組別', N'Schema', N'dbo', N'Table', N'JobAssignments', N'Column', N'DGID';
EXEC sp_addextendedproperty N'MS_Description', N'帶組主管', N'Schema', N'dbo', N'Table', N'JobAssignments', N'Column', N'JADirector';
EXEC sp_addextendedproperty N'MS_Description', N'職稱', N'Schema', N'dbo', N'Table', N'JobAssignments', N'Column', N'JTID';
EXEC sp_addextendedproperty N'MS_Description', N'任職原因', N'Schema', N'dbo', N'Table', N'JobAssignments', N'Column', N'JARID';
EXEC sp_addextendedproperty N'MS_Description', N'起始日期', N'Schema', N'dbo', N'Table', N'JobAssignments', N'Column', N'JAStartDate';
EXEC sp_addextendedproperty N'MS_Description', N'結束日期', N'Schema', N'dbo', N'Table', N'JobAssignments', N'Column', N'JAEndDate';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'JobAssignments', N'Column', N'JANote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'JobAssignments', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'JobAssignments', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'JobAssignments', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'JobAssignments', N'Column', N'Sys_UpdateBy';
GO





/*【14. 薪資結構類別 SalaryStructureType】*/
CREATE TABLE SalaryStructureType (
    SSTID CHAR(1) PRIMARY KEY,                 			-- 薪資結構類別編號 (Ex：A、B、C....)
    SSTName NVARCHAR(20) NOT NULL,              	-- 薪資結構類別名稱

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                   					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                 				  	-- 修改時間
    Sys_UpdateBy INT NULL,                     					   	-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_SalaryStructureType_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_SalaryStructureType_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 為表格新增描述
EXEC sp_addextendedproperty N'MS_Description', N'薪資結構類別表', N'Schema', N'dbo', N'Table', N'SalaryStructureType';
-- 為欄位新增描述
EXEC sp_addextendedproperty N'MS_Description', N'薪資結構類別編號', N'Schema', N'dbo', N'Table', N'SalaryStructureType', N'Column', N'SSTID';
EXEC sp_addextendedproperty N'MS_Description', N'薪資結構類別', N'Schema', N'dbo', N'Table', N'SalaryStructureType', N'Column', N'SSTName';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'SalaryStructureType', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'SalaryStructureType', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'SalaryStructureType', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'SalaryStructureType', N'Column', N'Sys_UpdateBy';
GO



/*【15. 薪資結構明細 SalaryStructureDetail】*/
CREATE TABLE SalaryStructureDetail (
    SSDID CHAR(4) PRIMARY KEY,                 	-- 薪資結構明細編號 (Ex：A001、A002、B001、C001....)
    SSTID CHAR(1) NOT NULL,                    	-- 薪資結構類別編號 (FK)
    SSDName NVARCHAR(30) NOT NULL, 	-- 薪資結構明細名稱

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                   					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,               				    	-- 修改時間
    Sys_UpdateBy INT NULL,                        						-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_SalaryStructureDetail_Type FOREIGN KEY (SSTID) REFERENCES SalaryStructureType(SSTID),
    CONSTRAINT FK_SalaryStructureDetail_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_SalaryStructureDetail_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 為表格新增描述
EXEC sp_addextendedproperty N'MS_Description', N'薪資結構明細表', N'Schema', N'dbo', N'Table', N'SalaryStructureDetail';
-- 為欄位新增描述
EXEC sp_addextendedproperty N'MS_Description', N'薪資結構明細編號', N'Schema', N'dbo', N'Table', N'SalaryStructureDetail', N'Column', N'SSDID';
EXEC sp_addextendedproperty N'MS_Description', N'薪資結構類別', N'Schema', N'dbo', N'Table', N'SalaryStructureDetail', N'Column', N'SSTID';
EXEC sp_addextendedproperty N'MS_Description', N'薪資結構明細', N'Schema', N'dbo', N'Table', N'SalaryStructureDetail', N'Column', N'SSDName';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'SalaryStructureDetail', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'SalaryStructureDetail', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'SalaryStructureDetail', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'SalaryStructureDetail', N'Column', N'Sys_UpdateBy';
GO




/*【17. 公司薪資結構預設 CompanySalaryStructure】*/
CREATE TABLE CompanySalaryStructure (
    CSSID CHAR(6) PRIMARY KEY,                   			 -- 公司薪資結構預設編號
    COID INT NOT NULL,                           				 -- 公司編號 (FK)
    SSDID CHAR(4) NOT NULL, 						-- 薪資結構明細編號 (FK)
    CUID INT NOT NULL,								-- 計算單位編號 (FK)
    CSSDefault DECIMAL(10,2) NOT NULL DEFAULT 0,		-- 預設值
    CSSNote NVARCHAR(100) NULL,					-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,                 				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,                          				-- 刪除時間
    Sys_DeleteBy INT NULL,                               					-- 刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_CompanySalaryStructure_Company FOREIGN KEY (COID) REFERENCES Company(COID),
    CONSTRAINT FK_CompanySalaryStructure_SalaryStructureDetail FOREIGN KEY (SSDID) REFERENCES SalaryStructureDetail(SSDID),
    CONSTRAINT FK_CompanySalaryStructure_CalculationUnits FOREIGN KEY (CUID) REFERENCES CalculationUnits(CUID),
    CONSTRAINT FK_CompanySalaryStructure_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_CompanySalaryStructure_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_CompanySalaryStructure_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID)
);
GO
-- 為表格新增描述
EXEC sp_addextendedproperty N'MS_Description', N'公司薪資結構預設表', N'Schema', N'dbo', N'Table', N'CompanySalaryStructure';
-- 為欄位新增描述
EXEC sp_addextendedproperty N'MS_Description', N'公司薪資結構預設編號', N'Schema', N'dbo', N'Table', N'CompanySalaryStructure', N'Column', N'CSSID';
EXEC sp_addextendedproperty N'MS_Description', N'公司', N'Schema', N'dbo', N'Table', N'CompanySalaryStructure', N'Column', N'COID';
EXEC sp_addextendedproperty N'MS_Description', N'薪資結構明細', N'Schema', N'dbo', N'Table', N'CompanySalaryStructure', N'Column', N'SSDID';
EXEC sp_addextendedproperty N'MS_Description', N'計算單位', N'Schema', N'dbo', N'Table', N'CompanySalaryStructure', N'Column', N'CUID';
EXEC sp_addextendedproperty N'MS_Description', N'預設值', N'Schema', N'dbo', N'Table', N'CompanySalaryStructure', N'Column', N'CSSDefault';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'CompanySalaryStructure', N'Column', N'CSSNote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'CompanySalaryStructure', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'CompanySalaryStructure', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'CompanySalaryStructure', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'CompanySalaryStructure', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'CompanySalaryStructure', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'CompanySalaryStructure', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'CompanySalaryStructure', N'Column', N'Sys_DeleteBy';
GO





/*【18. 員工薪資狀態資料 EmployeePayrollProfile】*/
CREATE TABLE EmployeePayrollProfile (
    EPPID INT IDENTITY(1,1) PRIMARY KEY,            			-- 員工薪資狀態資料編號
    EEID INT NOT NULL,                               					-- 員工編號 (FK)
    EPPAdminTotal DECIMAL(9,2) NOT NULL DEFAULT 0,  		-- 行政薪資總額
    EPPOnBoard DATE NOT NULL,                        			-- 到職日
    EPPConfirm DATE NULL,                            				-- 轉正日
    EPPTerminate DATE NULL,                          				-- 離職日
    EPPNote NVARCHAR(500) NULL,                      			-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_EmployeePayrollProfile_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_EmployeePayrollProfile_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_EmployeePayrollProfile_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 為表格新增描述
EXEC sp_addextendedproperty N'MS_Description', N'員工薪資狀態資料表', N'Schema', N'dbo', N'Table', N'EmployeePayrollProfile';
-- 為欄位新增描述
EXEC sp_addextendedproperty N'MS_Description', N'員工薪資狀態資料編號', N'Schema', N'dbo', N'Table', N'EmployeePayrollProfile', N'Column', N'EPPID';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'EmployeePayrollProfile', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'行政薪資總額', N'Schema', N'dbo', N'Table', N'EmployeePayrollProfile', N'Column', N'EPPAdminTotal';
EXEC sp_addextendedproperty N'MS_Description', N'到職日', N'Schema', N'dbo', N'Table', N'EmployeePayrollProfile', N'Column', N'EPPOnBoard';
EXEC sp_addextendedproperty N'MS_Description', N'轉正日', N'Schema', N'dbo', N'Table', N'EmployeePayrollProfile', N'Column', N'EPPConfirm';
EXEC sp_addextendedproperty N'MS_Description', N'離職日', N'Schema', N'dbo', N'Table', N'EmployeePayrollProfile', N'Column', N'EPPTerminate';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'EmployeePayrollProfile', N'Column', N'EPPNote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'EmployeePayrollProfile', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'EmployeePayrollProfile', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'EmployeePayrollProfile', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'EmployeePayrollProfile', N'Column', N'Sys_UpdateBy';
GO



/*【19. 員工薪資結構明細 EmployeeCompensation】*/
CREATE TABLE EmployeeCompensation (
    ESID INT IDENTITY(1,1) PRIMARY KEY,           			-- 員工薪資結構明細編號
    EPPID INT NOT NULL,                            				-- 員工薪資狀態資料編號 (FK)
    SSDID CHAR(4) NOT NULL,                       			-- 薪資結構明細編號 (FK)
    CUID INT NOT NULL,                            				-- 計算單位編號 (FK)
    ESAmount DECIMAL(9,2) NOT NULL DEFAULT 0,    	-- 明細金額

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,                				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,                          				-- 刪除時間
    Sys_DeleteBy INT NULL,                               					-- 刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_EmployeeCompensation_EmployeePayroll FOREIGN KEY (EPPID) REFERENCES EmployeePayrollProfile(EPPID),
    CONSTRAINT FK_EmployeeCompensation_SalaryStructureDetail FOREIGN KEY (SSDID) REFERENCES SalaryStructureDetail(SSDID),
    CONSTRAINT FK_EmployeeCompensation_CalculationUnits FOREIGN KEY (CUID) REFERENCES CalculationUnits(CUID),
    CONSTRAINT FK_EmployeeCompensation_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_EmployeeCompensation_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_EmployeeCompensation_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID)
);
GO
-- 為表格新增描述
EXEC sp_addextendedproperty N'MS_Description', N'員工薪資結構明細表', N'Schema', N'dbo', N'Table', N'EmployeeCompensation';
-- 為欄位新增描述
EXEC sp_addextendedproperty N'MS_Description', N'員工薪資結構明細編號', N'Schema', N'dbo', N'Table', N'EmployeeCompensation', N'Column', N'ESID';
EXEC sp_addextendedproperty N'MS_Description', N'員工薪資狀態資料', N'Schema', N'dbo', N'Table', N'EmployeeCompensation', N'Column', N'EPPID';
EXEC sp_addextendedproperty N'MS_Description', N'薪資結構明細', N'Schema', N'dbo', N'Table', N'EmployeeCompensation', N'Column', N'SSDID';
EXEC sp_addextendedproperty N'MS_Description', N'計算單位', N'Schema', N'dbo', N'Table', N'EmployeeCompensation', N'Column', N'CUID';
EXEC sp_addextendedproperty N'MS_Description', N'明細金額', N'Schema', N'dbo', N'Table', N'EmployeeCompensation', N'Column', N'ESAmount';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'EmployeeCompensation', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'EmployeeCompensation', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'EmployeeCompensation', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'EmployeeCompensation', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'是否刪除', N'Schema', N'dbo', N'Table', N'EmployeeCompensation', N'Column', N'Sys_IsDelete';
EXEC sp_addextendedproperty N'MS_Description', N'刪除時間', N'Schema', N'dbo', N'Table', N'EmployeeCompensation', N'Column', N'Sys_DeleteDT';
EXEC sp_addextendedproperty N'MS_Description', N'刪除人員', N'Schema', N'dbo', N'Table', N'EmployeeCompensation', N'Column', N'Sys_DeleteBy';
GO



/*【20. 銀行代碼 BankBranches】*/
CREATE TABLE BankBranches (
    BBID INT IDENTITY(1,1) PRIMARY KEY,           		-- 銀行代碼編號
    BBBankCode CHAR(3) NOT NULL,                 		-- 銀行代碼
    BBBankName NVARCHAR(50) NOT NULL,		-- 銀行名稱
    BBBranchCode CHAR(7) NOT NULL,			-- 分行代碼
    BBBranchName NVARCHAR(50) NOT NULL,		-- 分行名稱
    BBIsActive BIT NOT NULL DEFAULT 1,			-- 是否啟用 (0:false, 1:true)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE() 	-- 新增時間
);
GO
-- 為表格新增描述
EXEC sp_addextendedproperty N'MS_Description', N'銀行代碼表', N'Schema', N'dbo', N'Table', N'BankBranches';
-- 為欄位新增描述
EXEC sp_addextendedproperty N'MS_Description', N'銀行代碼編號', N'Schema', N'dbo', N'Table', N'BankBranches', N'Column', N'BBID';
EXEC sp_addextendedproperty N'MS_Description', N'銀行代碼', N'Schema', N'dbo', N'Table', N'BankBranches', N'Column', N'BBBankCode';
EXEC sp_addextendedproperty N'MS_Description', N'銀行名稱', N'Schema', N'dbo', N'Table', N'BankBranches', N'Column', N'BBBankName';
EXEC sp_addextendedproperty N'MS_Description', N'分行代碼', N'Schema', N'dbo', N'Table', N'BankBranches', N'Column', N'BBBranchCode';
EXEC sp_addextendedproperty N'MS_Description', N'分行名稱', N'Schema', N'dbo', N'Table', N'BankBranches', N'Column', N'BBBranchName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'BankBranches', N'Column', N'BBIsActive';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'BankBranches', N'Column', N'Sys_CreatedDT';
GO



/*【21. 員工銀行帳戶 EmployeeBankAccounts】*/
CREATE TABLE EmployeeBankAccounts (
    EBAID INT IDENTITY(1,1) PRIMARY KEY,         	-- 員工銀行帳戶編號
    EEID INT NOT NULL,                           		-- 員工編號 (FK)
    BBID INT NOT NULL,                      			-- 銀行代碼編號 (FK)
    EBAOwner NVARCHAR(50) NOT NULL, 		-- 帳戶所有人
    EBABankNum NVARCHAR(70) NOT NULL, 	-- 銀行號碼
    EBANote NVARCHAR(100) NULL,			-- 備註
    EBAIsActive BIT NOT NULL DEFAULT 1,		-- 是否啟用 (0:false, 1:true)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                     					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                     					-- 修改時間
    Sys_UpdateBy INT NULL,                          						-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_EBA_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_EBA_BankBranches FOREIGN KEY (BBID) REFERENCES BankBranches(BBID),
    CONSTRAINT FK_EBA_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_EBA_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'員工銀行帳戶表', N'Schema', N'dbo', N'Table', N'EmployeeBankAccounts';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'員工銀行帳戶編號', N'Schema', N'dbo', N'Table', N'EmployeeBankAccounts', N'Column', N'EBAID';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'EmployeeBankAccounts', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'銀行代碼', N'Schema', N'dbo', N'Table', N'EmployeeBankAccounts', N'Column', N'BBID';
EXEC sp_addextendedproperty N'MS_Description', N'帳戶所有人', N'Schema', N'dbo', N'Table', N'EmployeeBankAccounts', N'Column', N'EBAOwner';
EXEC sp_addextendedproperty N'MS_Description', N'銀行號碼', N'Schema', N'dbo', N'Table', N'EmployeeBankAccounts', N'Column', N'EBABankNum';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'EmployeeBankAccounts', N'Column', N'EBANote';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'EmployeeBankAccounts', N'Column', N'EBAIsActive';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'EmployeeBankAccounts', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'EmployeeBankAccounts', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'EmployeeBankAccounts', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'EmployeeBankAccounts', N'Column', N'Sys_UpdateBy';
GO



/*【22. 權限類別 AuthorizationType】*/
CREATE TABLE AuthorizationType (
    ATID INT IDENTITY(1,1) PRIMARY KEY,          	-- 權限類別編號
    ATName NVARCHAR(100) NOT NULL,		-- 權限類別名稱
    ATIsActive BIT NOT NULL DEFAULT 1            	-- 是否啟用 (0:false, 1:true)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'權限類別表', N'Schema', N'dbo', N'Table', N'AuthorizationType';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'權限類別編號', N'Schema', N'dbo', N'Table', N'AuthorizationType', N'Column', N'ATID';
EXEC sp_addextendedproperty N'MS_Description', N'權限類別', N'Schema', N'dbo', N'Table', N'AuthorizationType', N'Column', N'ATName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'AuthorizationType', N'Column', N'ATIsActive';
GO



/*【23. 權限項目 AuthorizationItem】*/
CREATE TABLE AuthorizationItem (
    AIID INT IDENTITY(1,1) PRIMARY KEY,          	-- 權限項目編號
    ATID INT NOT NULL,                           		-- 權限類別編號 (FK)
    ATName NVARCHAR(100) NOT NULL,		-- 權限項目名稱
    ATIsActive BIT NOT NULL DEFAULT 1,		-- 是否有效 (0:false, 1:true)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                     					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                     					-- 修改時間
    Sys_UpdateBy INT NULL,                          						-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_AI_AuthorizationType FOREIGN KEY (ATID) REFERENCES AuthorizationType(ATID),
    CONSTRAINT FK_AI_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_AI_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'權限項目表', N'Schema', N'dbo', N'Table', N'AuthorizationItem';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'權限項目編號', N'Schema', N'dbo', N'Table', N'AuthorizationItem', N'Column', N'AIID';
EXEC sp_addextendedproperty N'MS_Description', N'權限類別', N'Schema', N'dbo', N'Table', N'AuthorizationItem', N'Column', N'ATID';
EXEC sp_addextendedproperty N'MS_Description', N'權限項目', N'Schema', N'dbo', N'Table', N'AuthorizationItem', N'Column', N'ATName';
EXEC sp_addextendedproperty N'MS_Description', N'是否有效', N'Schema', N'dbo', N'Table', N'AuthorizationItem', N'Column', N'ATIsActive';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'AuthorizationItem', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'AuthorizationItem', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'AuthorizationItem', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'AuthorizationItem', N'Column', N'Sys_UpdateBy';
GO



/*【24. 員工權限明細 EmployeeAUTHPermission】*/
CREATE TABLE EmployeeAUTHPermission (
    EAPID INT IDENTITY(1,1) PRIMARY KEY,         		-- 員工權限明細編號
    EEID INT NOT NULL,                           			-- 員工編號 (FK)
    AIID INT NOT NULL,                           			-- 權限項目編號 (FK)

    /*FK 設定*/
    CONSTRAINT FK_EAP_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_EAP_AuthorizationItem FOREIGN KEY (AIID) REFERENCES AuthorizationItem(AIID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'員工權限明細表', N'Schema', N'dbo', N'Table', N'EmployeeAUTHPermission';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'員工權限明細編號', N'Schema', N'dbo', N'Table', N'EmployeeAUTHPermission', N'Column', N'EAPID';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'EmployeeAUTHPermission', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'權限項目編號', N'Schema', N'dbo', N'Table', N'EmployeeAUTHPermission', N'Column', N'AIID';
GO



/*【25. 系統登(出)入原因 SysLoginReason】*/
CREATE TABLE SysLoginReason (
    SLRID INT IDENTITY(1,1) PRIMARY KEY,    	-- 原因編號
    SLRReason NVARCHAR(20) NOT NULL,         	-- 原因
    SLRIsActive BIT NOT NULL DEFAULT 1        	-- 是否啟用 (0:false, 1:true)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'系統登(出)入原因表', N'Schema', N'dbo', N'Table', N'SysLoginReason';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'原因編號', N'Schema', N'dbo', N'Table', N'SysLoginReason', N'Column', N'SLRID';
EXEC sp_addextendedproperty N'MS_Description', N'原因', N'Schema', N'dbo', N'Table', N'SysLoginReason', N'Column', N'SLRReason';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'SysLoginReason', N'Column', N'SLRIsActive';
GO



/*【26. 系統登(出)入紀錄 SysLoginLog】*/
CREATE TABLE SysLoginLog (
    SLLID INT IDENTITY(1,1) PRIMARY KEY,   	-- 紀錄編號
    EEID INT NOT NULL,                      			-- 員工編號 (FK)
    SLRID INT NOT NULL,                     			-- 原因編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),   -- 發生時間

    /*FK 設定*/
    CONSTRAINT FK_SysLoginLog_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_SysLoginLog_SysLoginReason FOREIGN KEY (SLRID) REFERENCES SysLoginReason(SLRID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'系統登(出)入紀錄表', N'Schema', N'dbo', N'Table', N'SysLoginLog';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'紀錄編號', N'Schema', N'dbo', N'Table', N'SysLoginLog', N'Column', N'SLLID';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'SysLoginLog', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'原因', N'Schema', N'dbo', N'Table', N'SysLoginLog', N'Column', N'SLRID';
EXEC sp_addextendedproperty N'MS_Description', N'發生時間', N'Schema', N'dbo', N'Table', N'SysLoginLog', N'Column', N'Sys_CreatedDT';
GO



