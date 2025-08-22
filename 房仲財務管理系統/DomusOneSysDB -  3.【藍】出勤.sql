use DomusOneSysDB;

/*【27. 年度工時設定表 WorkTimePolicy】*/
CREATE TABLE WorkTimePolicy (
    DS_WTPID INT IDENTITY(1,1) PRIMARY KEY,           	-- 年度工時設定編號
    DS_COID INT NOT NULL,                             			-- 公司編號 (FK)
    DS_WTPYear CHAR(4) NOT NULL,                      		-- 年份
    DS_WTPStart TIME NOT NULL,                        			-- 上班時間
    DS_WTPEnd TIME NOT NULL,                          		-- 下班時間
    DS_WTPWorkDays CHAR(1) NOT NULL,                  	-- 工作日 1:周一; 2:周二; 3:周三; 4:週四 …..
    DS_WTPNote NVARCHAR(100) NULL,                    		-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                        					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                        				-- 修改時間
    Sys_UpdateBy INT NULL,                             					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_WorkTimePolicy_Company FOREIGN KEY (DS_COID) REFERENCES Company(DS_COID),
    CONSTRAINT FK_WorkTimePolicy_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_WorkTimePolicy_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO


/*【28. 特殊工時調整原因 SpecialWorkTimeReason】*/
CREATE TABLE SpecialWorkTimeReason (
    DS_SWTRID INT IDENTITY(1,1) PRIMARY KEY,          	-- 特殊工時調整原因編號
    DS_SWTReason NVARCHAR(100) NOT NULL,		-- 特殊工時調整原因
    DS_SWTRIsActive BIT NOT NULL DEFAULT 1            	-- 是否啟用 (0:false, 1:true)
);
GO


/*【29. 特殊工時設定表 SpecialWorkTime】*/
CREATE TABLE SpecialWorkTime (
    DS_SWTID INT IDENTITY(1,1) PRIMARY KEY,           	-- 特殊工時設定編號
    DS_COID INT NOT NULL,                             			-- 公司編號 (FK)
    DS_SWTDate DATE NOT NULL,                         		-- 特殊日期
    DS_SWTStart DATETIME NOT NULL,                    		-- 上班時間
    DS_SWTEnd DATETIME NOT NULL,                      		-- 下班時間
    DS_SWTRID INT NOT NULL,                           			-- 特殊工時調整原因編號 (FK)
    DS_SWTIsOverride BIT NOT NULL DEFAULT 1,          	-- 是否覆蓋常規設定 (0:false, 1:true)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                        					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                        				-- 修改時間
    Sys_UpdateBy INT NULL,                             					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_SpecialWorkTime_Company FOREIGN KEY (DS_COID) REFERENCES Company(DS_COID),
    CONSTRAINT FK_SpecialWorkTime_Reason FOREIGN KEY (DS_SWTRID) REFERENCES SpecialWorkTimeReason(DS_SWTRID),
    CONSTRAINT FK_SpecialWorkTime_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_SpecialWorkTime_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO



/*【30. 出勤狀態 AttendanceStatus】*/
CREATE TABLE AttendanceStatus (
    DS_ASID INT IDENTITY(1,1) PRIMARY KEY,          	-- 出勤狀態編號
    DS_ASName NVARCHAR(30) NOT NULL	, 		-- 狀態名稱
    DS_ASIsActive BIT NOT NULL DEFAULT 1,           	-- 是否啟用 (0:false, 1:true)
);
GO


/*【31. 出勤紀錄 AttendanceRecord】*/
CREATE TABLE AttendanceRecord (
    DS_ARID INT IDENTITY(1,1) PRIMARY KEY,		-- 出勤紀錄編號
    DS_EEID INT NOT NULL,						-- 員工編號 (FK)
    DS_ARDate DATE NOT NULL,					-- 出勤日期
    DS_ARCheckIn DATETIME NOT NULL,			-- 上班時間
    DS_ARCheckOut DATETIME NULL,				-- 下班時間
    DS_ASID INT NOT NULL, 						-- 出勤狀態編號 (FK)
    DS_ARNote NVARCHAR(100) NULL,                   	-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                     					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                     					-- 修改時間
    Sys_UpdateBy INT NULL,                          						-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_AttendanceRecord_Employee FOREIGN KEY (DS_EEID) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_AttendanceRecord_Status FOREIGN KEY (DS_ASID) REFERENCES AttendanceStatus(DS_ASID),
    CONSTRAINT FK_AttendanceRecord_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_AttendanceRecord_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO


/*【32. 班表設定 ShiftSchedule】*/
CREATE TABLE ShiftSchedule (
    DS_SSID INT IDENTITY(1,1) PRIMARY KEY, 		-- 班表設定編號
    DS_EEID INT NOT NULL,						-- 員工編號 (FK)
    DS_SSDate DATE NOT NULL,					-- 排班日期
    DS_SSStart DATETIME NOT NULL, 				-- 開始時間
    DS_SSEnd DATETIME NOT NULL,				-- 結束時間
    DS_SSNote NVARCHAR(100) NULL,				-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                     					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                     					-- 修改時間
    Sys_UpdateBy INT NULL,                          						-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_ShiftSchedule_Employee FOREIGN KEY (DS_EEID) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_ShiftSchedule_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_ShiftSchedule_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO

/*【34. 請假類別 LeaveType】*/
CREATE TABLE LeaveType (
    DS_LTID INT IDENTITY(1,1) PRIMARY KEY,         	-- 請假類別編號
    DS_LTName NVARCHAR(30) NOT NULL,               	-- 假別名稱
    DS_LTDescription NVARCHAR(100) NOT NULL, 	-- 假別說明
    DS_LTIsPaid BIT NOT NULL,					-- 是否為有薪假 (0:false, 1:true)
    DS_LTIsAnnual BIT NOT NULL,					-- 是否計入年度特休 (0:false, 1:true)
    DS_LTIsActive BIT NOT NULL DEFAULT 1,		-- 是否啟用 (0:false, 1:true)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_LeaveType_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_LeaveType_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO

/*【35. 請假申請 LeaveRequest】*/
CREATE TABLE LeaveRequest (
    DS_LRID INT IDENTITY(1,1) PRIMARY KEY,		-- 請假申請編號
    DS_EEID INT NOT NULL,                            		-- 員工編號 (FK)
    DS_LTID INT NOT NULL,                            		-- 請假類別編號 (FK)
    DS_LRStartDT DATETIME NOT NULL,                  	-- 開始時間
    DS_LREndDT DATETIME NOT NULL,                    	-- 結束時間
    DS_LRReason NVARCHAR(50) NULL,                  	-- 請假原因
    DS_APSID INT NOT NULL,                           		-- 申請狀態編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)
    Sys_ApprovalDT DATETIME NULL,                       				-- 審核時間
    Sys_ApprovedBy INT NULL,                             					-- 審核人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_LeaveRequest_Employee FOREIGN KEY (DS_EEID) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_LeaveRequest_LeaveType FOREIGN KEY (DS_LTID) REFERENCES LeaveType(DS_LTID),
    CONSTRAINT FK_LeaveRequest_ApplyStatus FOREIGN KEY (DS_APSID) REFERENCES ApplyStatus(DS_APSID),
    CONSTRAINT FK_LeaveRequest_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_LeaveRequest_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_LeaveRequest_ApprovedBy FOREIGN KEY (Sys_ApprovedBy) REFERENCES Employee(DS_EEID)
);
GO

/*【36. 加班申請 OvertimeRequest】*/
CREATE TABLE OvertimeRequest (
    DS_ORID INT IDENTITY(1,1) PRIMARY KEY,          	-- 加班申請編號
    DS_EEID INT NOT NULL,                            		-- 員工編號 (FK)
    DS_ORDate DATE NOT NULL,                          		-- 加班日期
    DS_ORStart DATETIME NOT NULL,                    	-- 開始時間
    DS_OREnd DATETIME NOT NULL,                      	-- 結束時間
    DS_ORReason NVARCHAR(50) NULL,                  	-- 加班原因
    DS_APSID INT NOT NULL,                          		 -- 申請狀態編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)
    Sys_ApprovalDT DATETIME NULL,                       				-- 審核時間
    Sys_ApprovedBy INT NULL,                             					-- 審核人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_OvertimeRequest_Employee FOREIGN KEY (DS_EEID) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_OvertimeRequest_ApplyStatus FOREIGN KEY (DS_APSID) REFERENCES ApplyStatus(DS_APSID),
    CONSTRAINT FK_OvertimeRequest_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_OvertimeRequest_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_OvertimeRequest_ApprovedBy FOREIGN KEY (Sys_ApprovedBy) REFERENCES Employee(DS_EEID)
);
GO

/*【37. 出勤異常原因 ATExceptionReason】*/
CREATE TABLE ATExceptionReason (
    DS_AERID INT IDENTITY(1,1) PRIMARY KEY,        	-- 出勤異常原因編號
    DS_AERReason NVARCHAR(20) NOT NULL,		-- 出勤異常原因
    DS_AERIsActive BIT NOT NULL DEFAULT 1,         	-- 是否啟用 (0:false, 1:true)
);
GO

/*【38. 出勤異常紀錄 ATExceptionLog】*/
CREATE TABLE ATExceptionLog (
    DS_AELID INT IDENTITY(1,1) PRIMARY KEY,       	-- 出勤異常紀錄編號
    DS_EEID INT NOT NULL,                          			-- 員工編號 (FK)
    DS_AELDate DATE NOT NULL,                      		-- 異常日期
    DS_AERID INT NOT NULL,                         		-- 出勤異常原因編號 (FK)
    DS_AELNote NVARCHAR(100) NOT NULL,            	-- 說明

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_ATExceptionLog_Employee FOREIGN KEY (DS_EEID) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_ATExceptionLog_ATExceptionReason FOREIGN KEY (DS_AERID) REFERENCES ATExceptionReason(DS_AERID),
    CONSTRAINT FK_ATExceptionLog_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_ATExceptionLog_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO

/*【39. 每月出勤統計 ATMonthlySummary】*/
CREATE TABLE ATMonthlySummary (
    DS_AMSID INT IDENTITY(1,1) PRIMARY KEY,       	-- 每月出勤統計編號
    DS_EEID INT NOT NULL,                          			-- 員工編號 (FK)
    DS_AMSMonth CHAR(7) NOT NULL,                  	-- 統計月份 (EX：2025/07)
    DS_AMSDays INT NOT NULL DEFAULT 0,             	-- 出勤天數
    DS_AMSLate INT NOT NULL DEFAULT 0,             	-- 遲到次數
    DS_AMSLeave INT NOT NULL DEFAULT 0,            	-- 請假時數
    DS_AMSOvertime INT NOT NULL DEFAULT 0,	-- 加班時數

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_ATMonthlySummary_Employee FOREIGN KEY (DS_EEID) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_ATMonthlySummary_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_ATMonthlySummary_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO



