use DomusOneSysDB;

/*【27. 年度工時設定表 WorkTimePolicy】*/
CREATE TABLE WorkTimePolicy (
    WTPID INT IDENTITY(1,1) PRIMARY KEY,           	-- 年度工時設定編號
    COID INT NOT NULL,                             			-- 公司編號 (FK)
    WTPYear CHAR(4) NOT NULL,                      		-- 年份
    WTPStart TIME NOT NULL,                        		-- 上班時間
    WTPEnd TIME NOT NULL,                          		-- 下班時間
    WTPWorkDays CHAR(1) NOT NULL,                  	-- 工作日 1:周一; 2:周二; 3:周三; 4:週四 …..
    WTPNote NVARCHAR(100) NULL,                   	-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                        					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                        				-- 修改時間
    Sys_UpdateBy INT NULL,                             					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_WorkTimePolicy_Company FOREIGN KEY (COID) REFERENCES Company(COID),
    CONSTRAINT FK_WorkTimePolicy_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_WorkTimePolicy_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'年度工時設定表', N'Schema', N'dbo', N'Table', N'WorkTimePolicy';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'年度工時設定編號', N'Schema', N'dbo', N'Table', N'WorkTimePolicy', N'Column', N'WTPID';
EXEC sp_addextendedproperty N'MS_Description', N'公司', N'Schema', N'dbo', N'Table', N'WorkTimePolicy', N'Column', N'COID';
EXEC sp_addextendedproperty N'MS_Description', N'年份', N'Schema', N'dbo', N'Table', N'WorkTimePolicy', N'Column', N'WTPYear';
EXEC sp_addextendedproperty N'MS_Description', N'上班時間', N'Schema', N'dbo', N'Table', N'WorkTimePolicy', N'Column', N'WTPStart';
EXEC sp_addextendedproperty N'MS_Description', N'下班時間', N'Schema', N'dbo', N'Table', N'WorkTimePolicy', N'Column', N'WTPEnd';
EXEC sp_addextendedproperty N'MS_Description', N'工作日', N'Schema', N'dbo', N'Table', N'WorkTimePolicy', N'Column', N'WTPWorkDays';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'WorkTimePolicy', N'Column', N'WTPNote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'WorkTimePolicy', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'WorkTimePolicy', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'WorkTimePolicy', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'WorkTimePolicy', N'Column', N'Sys_UpdateBy';
GO



/*【28. 特殊工時調整原因 SpecialWorkTimeReason】*/
CREATE TABLE SpecialWorkTimeReason (
    SWTRID INT IDENTITY(1,1) PRIMARY KEY,          	-- 特殊工時調整原因編號
    SWTReason NVARCHAR(50) NOT NULL,			-- 特殊工時調整原因
    SWTRIsActive BIT NOT NULL DEFAULT 1            	-- 是否啟用 (0:false, 1:true)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'特殊工時調整原因表', N'Schema', N'dbo', N'Table', N'SpecialWorkTimeReason';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'特殊工時調整原因編號', N'Schema', N'dbo', N'Table', N'SpecialWorkTimeReason', N'Column', N'SWTRID';
EXEC sp_addextendedproperty N'MS_Description', N'特殊工時調整原因', N'Schema', N'dbo', N'Table', N'SpecialWorkTimeReason', N'Column', N'SWTReason';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'SpecialWorkTimeReason', N'Column', N'SWTRIsActive';
GO



/*【29. 特殊工時設定表 SpecialWorkTime】*/
CREATE TABLE SpecialWorkTime (
    SWTID INT IDENTITY(1,1) PRIMARY KEY,            	-- 特殊工時設定編號
    COID INT NOT NULL,                              			-- 公司編號 (FK)
    SWTDate DATE NOT NULL,                           		-- 特殊日期
    SWTStart DATETIME NOT NULL,                     		-- 上班時間
    SWTEnd DATETIME NOT NULL,                       		-- 下班時間
    SWTRID INT NOT NULL,                            		-- 特殊工時調整原因編號 (FK)
    SWTIsOverride BIT NOT NULL DEFAULT 1,           	-- 是否覆蓋常規設定 (0:false, 1:true)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                       					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                       				-- 修改時間
    Sys_UpdateBy INT NULL,                             					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_SpecialWorkTime_Company FOREIGN KEY (COID) REFERENCES Company(COID),
    CONSTRAINT FK_SpecialWorkTime_Reason FOREIGN KEY (SWTRID) REFERENCES SpecialWorkTimeReason(SWTRID),
    CONSTRAINT FK_SpecialWorkTime_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_SpecialWorkTime_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO

-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'特殊工時設定表', N'Schema', N'dbo', N'Table', N'SpecialWorkTime';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'特殊工時設定編號', N'Schema', N'dbo', N'Table', N'SpecialWorkTime', N'Column', N'SWTID';
EXEC sp_addextendedproperty N'MS_Description', N'公司', N'Schema', N'dbo', N'Table', N'SpecialWorkTime', N'Column', N'COID';
EXEC sp_addextendedproperty N'MS_Description', N'特殊日期', N'Schema', N'dbo', N'Table', N'SpecialWorkTime', N'Column', N'SWTDate';
EXEC sp_addextendedproperty N'MS_Description', N'上班時間', N'Schema', N'dbo', N'Table', N'SpecialWorkTime', N'Column', N'SWTStart';
EXEC sp_addextendedproperty N'MS_Description', N'下班時間', N'Schema', N'dbo', N'Table', N'SpecialWorkTime', N'Column', N'SWTEnd';
EXEC sp_addextendedproperty N'MS_Description', N'特殊工時條調整原因', N'Schema', N'dbo', N'Table', N'SpecialWorkTime', N'Column', N'SWTRID';
EXEC sp_addextendedproperty N'MS_Description', N'是否覆蓋常規設定', N'Schema', N'dbo', N'Table', N'SpecialWorkTime', N'Column', N'SWTIsOverride';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'SpecialWorkTime', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'SpecialWorkTime', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'SpecialWorkTime', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'SpecialWorkTime', N'Column', N'Sys_UpdateBy';
GO




/*【30. 出勤狀態 AttendanceStatus】*/
CREATE TABLE AttendanceStatus (
    ASID INT IDENTITY(1,1) PRIMARY KEY,          	-- 出勤狀態編號
    ASName NVARCHAR(30) NOT NULL	, 	-- 狀態名稱
    ASIsActive BIT NOT NULL DEFAULT 1,           	-- 是否啟用 (0:false, 1:true)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'出勤狀態表', N'Schema', N'dbo', N'Table', N'AttendanceStatus';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'出勤狀態編號', N'Schema', N'dbo', N'Table', N'AttendanceStatus', N'Column', N'ASID';
EXEC sp_addextendedproperty N'MS_Description', N'狀態名稱', N'Schema', N'dbo', N'Table', N'AttendanceStatus', N'Column', N'ASName';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'AttendanceStatus', N'Column', N'ASIsActive';
GO



/*【31. 出勤紀錄 AttendanceRecord】*/
CREATE TABLE AttendanceRecord (
    ARID INT IDENTITY(1,1) PRIMARY KEY,		-- 出勤紀錄編號
    EEID INT NOT NULL,						-- 員工編號 (FK)
    ARDate DATE NOT NULL,					-- 出勤日期
    ARCheckIn DATETIME NOT NULL,			-- 上班時間
    ARCheckOut DATETIME NULL,				-- 下班時間
    ASID INT NOT NULL, 					-- 出勤狀態編號 (FK)
    ARNote NVARCHAR(100) NULL,                   	-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                     					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                     					-- 修改時間
    Sys_UpdateBy INT NULL,                          						-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_AttendanceRecord_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_AttendanceRecord_Status FOREIGN KEY (ASID) REFERENCES AttendanceStatus(ASID),
    CONSTRAINT FK_AttendanceRecord_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_AttendanceRecord_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'出勤紀錄表', N'Schema', N'dbo', N'Table', N'AttendanceRecord';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'出勤紀錄編號', N'Schema', N'dbo', N'Table', N'AttendanceRecord', N'Column', N'ARID';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'AttendanceRecord', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'出勤日期', N'Schema', N'dbo', N'Table', N'AttendanceRecord', N'Column', N'ARDate';
EXEC sp_addextendedproperty N'MS_Description', N'上班時間', N'Schema', N'dbo', N'Table', N'AttendanceRecord', N'Column', N'ARCheckIn';
EXEC sp_addextendedproperty N'MS_Description', N'下班時間', N'Schema', N'dbo', N'Table', N'AttendanceRecord', N'Column', N'ARCheckOut';
EXEC sp_addextendedproperty N'MS_Description', N'出勤狀態', N'Schema', N'dbo', N'Table', N'AttendanceRecord', N'Column', N'ASID';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'AttendanceRecord', N'Column', N'ARNote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'AttendanceRecord', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'AttendanceRecord', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'AttendanceRecord', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'AttendanceRecord', N'Column', N'Sys_UpdateBy';
GO



/*【32. 班表設定 ShiftSchedule】*/
CREATE TABLE ShiftSchedule (
    SSID INT IDENTITY(1,1) PRIMARY KEY, 		-- 班表設定編號
    EEID INT NOT NULL,						-- 員工編號 (FK)
    SSDate DATE NOT NULL,					-- 排班日期
    SSStart DATETIME NOT NULL, 				-- 開始時間
    SSEnd DATETIME NOT NULL,				-- 結束時間
    SSNote NVARCHAR(100) NULL,			-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                     					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                     					-- 修改時間
    Sys_UpdateBy INT NULL,                          						-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_ShiftSchedule_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_ShiftSchedule_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_ShiftSchedule_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'班表設定表', N'Schema', N'dbo', N'Table', N'ShiftSchedule';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'班表設定編號', N'Schema', N'dbo', N'Table', N'ShiftSchedule', N'Column', N'SSID';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'ShiftSchedule', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'排班日期', N'Schema', N'dbo', N'Table', N'ShiftSchedule', N'Column', N'SSDate';
EXEC sp_addextendedproperty N'MS_Description', N'開始時間', N'Schema', N'dbo', N'Table', N'ShiftSchedule', N'Column', N'SSStart';
EXEC sp_addextendedproperty N'MS_Description', N'結束時間', N'Schema', N'dbo', N'Table', N'ShiftSchedule', N'Column', N'SSEnd';
EXEC sp_addextendedproperty N'MS_Description', N'備註', N'Schema', N'dbo', N'Table', N'ShiftSchedule', N'Column', N'SSNote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'ShiftSchedule', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'ShiftSchedule', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'ShiftSchedule', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'ShiftSchedule', N'Column', N'Sys_UpdateBy';
GO



/*【34. 請假類別 LeaveType】*/
CREATE TABLE LeaveType (
    LTID INT IDENTITY(1,1) PRIMARY KEY,         		-- 請假類別編號
    LTName NVARCHAR(30) NOT NULL,               	-- 假別名稱
    LTDescription NVARCHAR(100) NOT NULL, 		-- 假別說明
    LTIsPaid BIT NOT NULL,						-- 是否為有薪假 (0:false, 1:true)
    LTIsAnnual BIT NOT NULL,					-- 是否計入年度特休 (0:false, 1:true)
    LTIsActive BIT NOT NULL DEFAULT 1,			-- 是否啟用 (0:false, 1:true)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_LeaveType_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_LeaveType_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'請假類別表', N'Schema', N'dbo', N'Table', N'LeaveType';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'請假類別編號', N'Schema', N'dbo', N'Table', N'LeaveType', N'Column', N'LTID';
EXEC sp_addextendedproperty N'MS_Description', N'假別名稱', N'Schema', N'dbo', N'Table', N'LeaveType', N'Column', N'LTName';
EXEC sp_addextendedproperty N'MS_Description', N'假別說明', N'Schema', N'dbo', N'Table', N'LeaveType', N'Column', N'LTDescription';
EXEC sp_addextendedproperty N'MS_Description', N'是否為有薪假', N'Schema', N'dbo', N'Table', N'LeaveType', N'Column', N'LTIsPaid';
EXEC sp_addextendedproperty N'MS_Description', N'是否計入年度特休', N'Schema', N'dbo', N'Table', N'LeaveType', N'Column', N'LTIsAnnual';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'LeaveType', N'Column', N'LTIsActive';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'LeaveType', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'LeaveType', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'LeaveType', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'LeaveType', N'Column', N'Sys_UpdateBy';
GO



/*【35. 請假申請 LeaveRequest】*/
CREATE TABLE LeaveRequest (
    LRID INT IDENTITY(1,1) PRIMARY KEY,		-- 請假申請編號
    EEID INT NOT NULL,                            		-- 員工編號 (FK)
    LTID INT NOT NULL,                            		-- 請假類別編號 (FK)
    LRStartDT DATETIME NOT NULL,                  	-- 開始時間
    LREndDT DATETIME NOT NULL,                    	-- 結束時間
    LRReason NVARCHAR(50) NULL,                  	-- 請假原因
    APSID INT NOT NULL,                           		-- 申請狀態編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)
    Sys_ApprovalDT DATETIME NULL,                       				-- 審核時間
    Sys_ApprovedBy INT NULL,                             					-- 審核人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_LeaveRequest_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_LeaveRequest_LeaveType FOREIGN KEY (LTID) REFERENCES LeaveType(LTID),
    CONSTRAINT FK_LeaveRequest_ApplyStatus FOREIGN KEY (APSID) REFERENCES ApplyStatus(APSID),
    CONSTRAINT FK_LeaveRequest_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_LeaveRequest_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_LeaveRequest_ApprovedBy FOREIGN KEY (Sys_ApprovedBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'請假申請表', N'Schema', N'dbo', N'Table', N'LeaveRequest';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'請假申請編號', N'Schema', N'dbo', N'Table', N'LeaveRequest', N'Column', N'LRID';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'LeaveRequest', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'請假類別', N'Schema', N'dbo', N'Table', N'LeaveRequest', N'Column', N'LTID';
EXEC sp_addextendedproperty N'MS_Description', N'開始時間', N'Schema', N'dbo', N'Table', N'LeaveRequest', N'Column', N'LRStartDT';
EXEC sp_addextendedproperty N'MS_Description', N'結束時間', N'Schema', N'dbo', N'Table', N'LeaveRequest', N'Column', N'LREndDT';
EXEC sp_addextendedproperty N'MS_Description', N'請假原因', N'Schema', N'dbo', N'Table', N'LeaveRequest', N'Column', N'LRReason';
EXEC sp_addextendedproperty N'MS_Description', N'申請狀態', N'Schema', N'dbo', N'Table', N'LeaveRequest', N'Column', N'APSID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'LeaveRequest', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'LeaveRequest', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'LeaveRequest', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'LeaveRequest', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'審核時間', N'Schema', N'dbo', N'Table', N'LeaveRequest', N'Column', N'Sys_ApprovalDT';
EXEC sp_addextendedproperty N'MS_Description', N'審核人員', N'Schema', N'dbo', N'Table', N'LeaveRequest', N'Column', N'Sys_ApprovedBy';
GO



/*【36. 加班申請 OvertimeRequest】*/
CREATE TABLE OvertimeRequest (
    ORID INT IDENTITY(1,1) PRIMARY KEY,          	-- 加班申請編號
    EEID INT NOT NULL,                            		-- 員工編號 (FK)
    ORDate DATE NOT NULL,                          	-- 加班日期
    ORStart DATETIME NOT NULL,                    	-- 開始時間
    OREnd DATETIME NOT NULL,                      	-- 結束時間
    ORReason NVARCHAR(50) NULL,                  	-- 加班原因
    APSID INT NOT NULL,                          		 -- 申請狀態編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)
    Sys_ApprovalDT DATETIME NULL,                       				-- 審核時間
    Sys_ApprovedBy INT NULL,                             					-- 審核人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_OvertimeRequest_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_OvertimeRequest_ApplyStatus FOREIGN KEY (APSID) REFERENCES ApplyStatus(APSID),
    CONSTRAINT FK_OvertimeRequest_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_OvertimeRequest_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_OvertimeRequest_ApprovedBy FOREIGN KEY (Sys_ApprovedBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'加班申請表', N'Schema', N'dbo', N'Table', N'OvertimeRequest';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'加班申請編號', N'Schema', N'dbo', N'Table', N'OvertimeRequest', N'Column', N'ORID';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'OvertimeRequest', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'加班日期', N'Schema', N'dbo', N'Table', N'OvertimeRequest', N'Column', N'ORDate';
EXEC sp_addextendedproperty N'MS_Description', N'開始時間', N'Schema', N'dbo', N'Table', N'OvertimeRequest', N'Column', N'ORStart';
EXEC sp_addextendedproperty N'MS_Description', N'結束時間', N'Schema', N'dbo', N'Table', N'OvertimeRequest', N'Column', N'OREnd';
EXEC sp_addextendedproperty N'MS_Description', N'加班原因', N'Schema', N'dbo', N'Table', N'OvertimeRequest', N'Column', N'ORReason';
EXEC sp_addextendedproperty N'MS_Description', N'申請狀態', N'Schema', N'dbo', N'Table', N'OvertimeRequest', N'Column', N'APSID';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'OvertimeRequest', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'OvertimeRequest', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'OvertimeRequest', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'OvertimeRequest', N'Column', N'Sys_UpdateBy';
EXEC sp_addextendedproperty N'MS_Description', N'審核時間', N'Schema', N'dbo', N'Table', N'OvertimeRequest', N'Column', N'Sys_ApprovalDT';
EXEC sp_addextendedproperty N'MS_Description', N'審核人員', N'Schema', N'dbo', N'Table', N'OvertimeRequest', N'Column', N'Sys_ApprovedBy';
GO



/*【37. 出勤異常原因 ATExceptionReason】*/
CREATE TABLE ATExceptionReason (
    AERID INT IDENTITY(1,1) PRIMARY KEY,        	-- 出勤異常原因編號
    AERReason NVARCHAR(20) NOT NULL,		-- 出勤異常原因
    AERIsActive BIT NOT NULL DEFAULT 1,         	-- 是否啟用 (0:false, 1:true)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'出勤異常原因表', N'Schema', N'dbo', N'Table', N'ATExceptionReason';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'出勤異常原因編號', N'Schema', N'dbo', N'Table', N'ATExceptionReason', N'Column', N'AERID';
EXEC sp_addextendedproperty N'MS_Description', N'出勤異常原因', N'Schema', N'dbo', N'Table', N'ATExceptionReason', N'Column', N'AERReason';
EXEC sp_addextendedproperty N'MS_Description', N'是否啟用', N'Schema', N'dbo', N'Table', N'ATExceptionReason', N'Column', N'AERIsActive';
GO


/*【38. 出勤異常紀錄 ATExceptionLog】*/
CREATE TABLE ATExceptionLog (
    AELID INT IDENTITY(1,1) PRIMARY KEY,       	-- 出勤異常紀錄編號
    EEID INT NOT NULL,                          		-- 員工編號 (FK)
    AELDate DATE NOT NULL,                      		-- 異常日期
    AERID INT NOT NULL,                         		-- 出勤異常原因編號 (FK)
    AELNote NVARCHAR(100) NOT NULL,      	-- 說明

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_ATExceptionLog_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_ATExceptionLog_ATExceptionReason FOREIGN KEY (AERID) REFERENCES ATExceptionReason(AERID),
    CONSTRAINT FK_ATExceptionLog_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_ATExceptionLog_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'出勤異常紀錄表', N'Schema', N'dbo', N'Table', N'ATExceptionLog';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'出勤異常紀錄編號', N'Schema', N'dbo', N'Table', N'ATExceptionLog', N'Column', N'AELID';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'ATExceptionLog', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'異常日期', N'Schema', N'dbo', N'Table', N'ATExceptionLog', N'Column', N'AELDate';
EXEC sp_addextendedproperty N'MS_Description', N'出勤異常原因', N'Schema', N'dbo', N'Table', N'ATExceptionLog', N'Column', N'AERID';
EXEC sp_addextendedproperty N'MS_Description', N'說明', N'Schema', N'dbo', N'Table', N'ATExceptionLog', N'Column', N'AELNote';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'ATExceptionLog', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'ATExceptionLog', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'ATExceptionLog', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'ATExceptionLog', N'Column', N'Sys_UpdateBy';
GO


/*【39. 每月出勤統計 ATMonthlySummary】*/
CREATE TABLE ATMonthlySummary (
    AMSID INT IDENTITY(1,1) PRIMARY KEY,       	-- 每月出勤統計編號
    EEID INT NOT NULL,                          		-- 員工編號 (FK)
    AMSMonth CHAR(7) NOT NULL,                  	-- 統計月份 (EX：2025/07)
    AMSDays INT NOT NULL DEFAULT 0,             	-- 出勤天數
    AMSLate INT NOT NULL DEFAULT 0,             	-- 遲到次數
    AMSLeave INT NOT NULL DEFAULT 0,		-- 請假時數
    AMSOvertime INT NOT NULL DEFAULT 0,	-- 加班時數

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_ATMonthlySummary_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_ATMonthlySummary_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_ATMonthlySummary_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO
-- 表格描述
EXEC sp_addextendedproperty N'MS_Description', N'每月出勤統計表', N'Schema', N'dbo', N'Table', N'ATMonthlySummary';
-- 欄位描述
EXEC sp_addextendedproperty N'MS_Description', N'每月出勤統計編號', N'Schema', N'dbo', N'Table', N'ATMonthlySummary', N'Column', N'AMSID';
EXEC sp_addextendedproperty N'MS_Description', N'人員', N'Schema', N'dbo', N'Table', N'ATMonthlySummary', N'Column', N'EEID';
EXEC sp_addextendedproperty N'MS_Description', N'統計月份', N'Schema', N'dbo', N'Table', N'ATMonthlySummary', N'Column', N'AMSMonth';
EXEC sp_addextendedproperty N'MS_Description', N'出勤天數', N'Schema', N'dbo', N'Table', N'ATMonthlySummary', N'Column', N'AMSDays';
EXEC sp_addextendedproperty N'MS_Description', N'遲到次數', N'Schema', N'dbo', N'Table', N'ATMonthlySummary', N'Column', N'AMSLate';
EXEC sp_addextendedproperty N'MS_Description', N'請假時數', N'Schema', N'dbo', N'Table', N'ATMonthlySummary', N'Column', N'AMSLeave';
EXEC sp_addextendedproperty N'MS_Description', N'加班時數', N'Schema', N'dbo', N'Table', N'ATMonthlySummary', N'Column', N'AMSOvertime';
EXEC sp_addextendedproperty N'MS_Description', N'新增時間', N'Schema', N'dbo', N'Table', N'ATMonthlySummary', N'Column', N'Sys_CreatedDT';
EXEC sp_addextendedproperty N'MS_Description', N'新增人員', N'Schema', N'dbo', N'Table', N'ATMonthlySummary', N'Column', N'Sys_CreatedBy';
EXEC sp_addextendedproperty N'MS_Description', N'修改時間', N'Schema', N'dbo', N'Table', N'ATMonthlySummary', N'Column', N'Sys_UpdateDT';
EXEC sp_addextendedproperty N'MS_Description', N'修改人員', N'Schema', N'dbo', N'Table', N'ATMonthlySummary', N'Column', N'Sys_UpdateBy';
GO


