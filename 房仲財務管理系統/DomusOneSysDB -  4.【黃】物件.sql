use DomusOneSysDB;

/*【40. 契據類別 ContractType】*/
CREATE TABLE ContractType (
    CTID CHAR(2) PRIMARY KEY,           			-- 契據類別編號 (EX：AA、AG、BA、BG)
    CTName NVARCHAR(30) NOT NULL,       	-- 契據類別名稱
    CTIsActive BIT NOT NULL DEFAULT 1   		-- 是否啟用 (0:false, 1:true)
);
GO

/*【41. 契據訂購主檔 ContractOrderMain】*/
CREATE TABLE ContractOrderMain (
    COMID INT IDENTITY(1,1) PRIMARY KEY,   	-- 契據訂購主檔編號
    COID INT NOT NULL,                       			-- 公司編號 (FK)
    EEID INT NOT NULL,                       			-- 員工編號 (FK)
    COMOrderDT DATE NOT NULL,                	-- 訂購日期 (YYYY/MM/DD)
    COMNote NVARCHAR(100) NULL,             	-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_ContractOrderMain_Company FOREIGN KEY (COID) REFERENCES Company(COID),
    CONSTRAINT FK_ContractOrderMain_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_ContractOrderMain_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_ContractOrderMain_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
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
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_ContractOrderDetail_ContractOrderMain FOREIGN KEY (COMID) REFERENCES ContractOrderMain(COMID),
    CONSTRAINT FK_ContractOrderDetail_ContractType FOREIGN KEY (CTID) REFERENCES ContractType(CTID),
    CONSTRAINT FK_ContractOrderDetail_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_ContractOrderDetail_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO

/*【43. 契據入庫明細 ContractReceivingDetail】*/
CREATE TABLE ContractReceivingDetail (
    CRDID INT IDENTITY(1,1) PRIMARY KEY,   	-- 契據入庫明細編號
    CODID INT NOT NULL,                     			-- 契據訂購明細編號 (FK)
    CRDReceiving DATE NOT NULL,             		-- 入庫日期 (YYYY/MM/DD)
    CRDAmount INT NOT NULL,                 		-- 入庫數量
    CRDNote NVARCHAR(100) NULL,        		-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_ContractReceivingDetail_ContractOrderDetail FOREIGN KEY (CODID) REFERENCES ContractOrderDetail(CODID),
    CONSTRAINT FK_ContractReceivingDetail_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_ContractReceivingDetail_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO

/*【44. 契據使用狀況 ContractUsageStatus】*/
CREATE TABLE ContractUsageStatus (
    CUSID INT IDENTITY(1,1) PRIMARY KEY,     	-- 契據使用狀況編號
    CUSName NVARCHAR(20) NOT NULL,           	-- 契據使用狀況
    CUSIsActive BIT NOT NULL DEFAULT 1       	-- 是否啟用 (0:false, 1:true)
);
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
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                                  					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_ContractMain_Company FOREIGN KEY (COID) REFERENCES Company(COID),
    CONSTRAINT FK_ContractMain_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_ContractMain_UsageStatus FOREIGN KEY (CUSID) REFERENCES ContractUsageStatus(CUSID),
    CONSTRAINT FK_ContractMain_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_ContractMain_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO

/*【45-1. 契據變更記錄檔 ContractRevisionLog】*/
CREATE TABLE ContractRevisionLog (
    CRLID VARCHAR(15) PRIMARY KEY,	-- 契據變更記錄檔編號
    CMID VARCHAR(15) NOT NULL,		-- 契據編號 (FK)
    COID INT NOT NULL,				-- 公司編號 (FK)
    EEID INT NULL,						-- 員工編號 (FK)
    CUSID INT NOT NULL,				-- 契據使用狀況編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                             				-- 新增人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_ContractRevisionLog_ContractMain FOREIGN KEY (CMID) REFERENCES ContractMain(CMID),
    CONSTRAINT FK_ContractRevisionLog_Company FOREIGN KEY (COID) REFERENCES Company(COID),
    CONSTRAINT FK_ContractRevisionLog_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_ContractRevisionLog_UsageStatus FOREIGN KEY (CUSID) REFERENCES ContractUsageStatus(CUSID),
    CONSTRAINT FK_ContractRevisionLog_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
);
GO

/*【46. 契據申請主檔 ContractApplication】*/
CREATE TABLE ContractApplication (
    CAID INT IDENTITY(1,1) PRIMARY KEY,      	-- 契據申請編號
    EEID INT NOT NULL,                        			-- 員工編號 (FK)
    CADate DATE NOT NULL,                     		-- 申請日期
    APSID INT NOT NULL,                       		-- 申請狀態編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)
    Sys_ApprovalDT DATETIME NULL,                        				-- 審核時間
    Sys_ApprovedBy INT NULL                               				-- 審核人員 (FK)

    /*FK 設定*/
    ,CONSTRAINT FK_ContractApplication_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_ContractApplication_ApplyStatus FOREIGN KEY (APSID) REFERENCES ApplyStatus(APSID)
    ,CONSTRAINT FK_ContractApplication_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_ContractApplication_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_ContractApplication_ApprovedBy FOREIGN KEY (Sys_ApprovedBy) REFERENCES Employee(EEID)
);
GO

/*【47. 契據申請明細 ContractApplicationDetail】*/
CREATE TABLE ContractApplicationDetail (
    CADID INT IDENTITY(1,1) PRIMARY KEY,    	-- 契據申請明細編號
    CAID INT NOT NULL,                        			-- 契據申請編號 (FK)
    CTID CHAR(2) NOT NULL,                    		-- 契據類別編號 (FK)
    CADAmount INT NOT NULL,                   		-- 申請數量

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL                               					-- 修改人員 (FK)

    /*FK 設定*/
    ,CONSTRAINT FK_ContractApplicationDetail_Application FOREIGN KEY (CAID) REFERENCES ContractApplication(CAID)
    ,CONSTRAINT FK_ContractApplicationDetail_ContractType FOREIGN KEY (CTID) REFERENCES ContractType(CTID)
    ,CONSTRAINT FK_ContractApplicationDetail_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_ContractApplicationDetail_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO

/*【48. 契據轉讓 ContractOwnershipChange】*/
CREATE TABLE ContractOwnershipChange (
    COCID INT IDENTITY(1,1) PRIMARY KEY,       		-- 契據轉讓編號
    CMID VARCHAR(15) NOT NULL,                  		-- 契據編號 (FK)
    COCTransfer INT NOT NULL,                   			-- 轉讓員工編號 (FK)
    COCTransferDate DATETIME NOT NULL,          	-- 轉讓日期
    COCTransferSign NVARCHAR(500) NOT NULL,     	-- 轉讓簽章
    COCReceiver INT NOT NULL,                   		-- 接收員工編號 (FK)
    COCReceiverDate DATETIME NULL,              		-- 接收日期
    COCReceiverSign NVARCHAR(500) NULL,        	-- 接收簽章
    COCNote NVARCHAR(100) NULL,                		-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL                                					-- 修改人員 (FK)

    /*FK 設定*/
    ,CONSTRAINT FK_ContractOwnershipChange_ContractMain FOREIGN KEY (CMID) REFERENCES ContractMain(CMID)
    ,CONSTRAINT FK_ContractOwnershipChange_TransferEmployee FOREIGN KEY (COCTransfer) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_ContractOwnershipChange_ReceiverEmployee FOREIGN KEY (COCReceiver) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_ContractOwnershipChange_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID)
    ,CONSTRAINT FK_ContractOwnershipChange_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO

/*【51. 建物型態 PropertyType】*/
CREATE TABLE PropertyType (
    PTID INT IDENTITY(1,1) PRIMARY KEY,        	-- 建物型態編號
    PTName NVARCHAR(30) NOT NULL,     		-- 建物型態
    PTIsActive BIT NOT NULL DEFAULT 1          	-- 是否啟用 (0:false, 1:true)
);
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
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_CommunityInfo_RegionCityDistrict FOREIGN KEY (RCDID) REFERENCES RegionCityDistrict(RCDID),
    CONSTRAINT FK_CommunityInfo_PropertyType FOREIGN KEY (PTID) REFERENCES PropertyType(PTID),
    CONSTRAINT FK_CommunityInfo_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_CommunityInfo_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO

/*【53. 物件型態 PropertyAssetType】*/
CREATE TABLE PropertyAssetType (
    PATID INT IDENTITY(1,1) PRIMARY KEY,       	-- 物件型態編號
    PATName NVARCHAR(20) NOT NULL,       	-- 物件型態
    PATIsActive BIT NOT NULL DEFAULT 1         	-- 是否啟用 (0:false, 1:true)
);
GO

/*【54. 物件狀態 PropertyAssetStatus】*/
CREATE TABLE PropertyAssetStatus (
    PASID INT IDENTITY(1,1) PRIMARY KEY,       	-- 物件狀態編號
    PASName NVARCHAR(30) NOT NULL,      	-- 物件狀態
    PASIsActive BIT NOT NULL DEFAULT 1         	-- 是否啟用 (0:false, 1:true)
);
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
    CIID INT NULL,                               				-- 社區編號 (FK)
    PASID INT NOT NULL,                          			-- 物件狀態編號 (FK)
    PAMapPath NVARCHAR(500) NULL,               		-- 位置圖
    PAPlanPath NVARCHAR(500) NULL,              		-- 平面圖
    PADescription NVARCHAR(500) NULL,           	-- 物件介紹
    PALatitude DECIMAL(10,6) NOT NULL,          		-- 緯度
    PALongitude DECIMAL(10,6) NOT NULL,         	-- 經度

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,                				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,                          				-- 刪除時間
    Sys_DeleteBy INT NULL,                               					-- 刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_PropertyAsset_ContractMain FOREIGN KEY (CMID) REFERENCES ContractMain(CMID),
    CONSTRAINT FK_PropertyAsset_Company FOREIGN KEY (COID) REFERENCES Company(COID),
    CONSTRAINT FK_PropertyAsset_PropertyAssetType FOREIGN KEY (PATID) REFERENCES PropertyAssetType(PATID),
    CONSTRAINT FK_PropertyAsset_RegionCityDistrict FOREIGN KEY (RCDID) REFERENCES RegionCityDistrict(RCDID),
    CONSTRAINT FK_PropertyAsset_CommunityInfo FOREIGN KEY (CIID) REFERENCES CommunityInfo(CIID),
    CONSTRAINT FK_PropertyAsset_PropertyAssetStatus FOREIGN KEY (PASID) REFERENCES PropertyAssetStatus(PASID),
    CONSTRAINT FK_PropertyAsset_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_PropertyAsset_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_PropertyAsset_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID)
);
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



/*【57. 土地使用分區 ZoningType】*/
CREATE TABLE ZoningType (
    ZTID INT IDENTITY(1,1) PRIMARY KEY,     	-- 土地使用分區編號
    ZTName NVARCHAR(30) NOT NULL,           	-- 土地使用分區
    ZTDescription NVARCHAR(500) NULL,       	-- 分區用途說明
    ZTIsActive BIT NOT NULL DEFAULT 1       	-- 是否啟用 (0:false, 1:true)
);
GO


/*【58. 不動產物件土地資料 PropertyAssetLand】*/
CREATE TABLE PropertyAssetLand (
    PALID INT IDENTITY(1,1) PRIMARY KEY,    	-- 物件土地資料編號
    PAID INT NOT NULL,                      			-- 物件編號 (FK)
    PALSiteArea DECIMAL(15,2) NOT NULL,     	-- 地坪
    ZTID INT NULL,                          				-- 土地使用分區編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,               						-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,               					-- 修改時間
    Sys_UpdateBy INT NULL,                    						-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_PropertyAssetLand_PropertyAsset FOREIGN KEY (PAID) REFERENCES PropertyAsset(PAID),
    CONSTRAINT FK_PropertyAssetLand_ZoningType FOREIGN KEY (ZTID) REFERENCES ZoningType(ZTID),
    CONSTRAINT FK_PropertyAssetLand_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_PropertyAssetLand_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO


/*【59. 土地使用 LandUseInfo】*/
CREATE TABLE LandUseInfo (
    LUIID INT IDENTITY(1,1) PRIMARY KEY,   	-- 土地使用編號
    LUIName NVARCHAR(30) NOT NULL,          	-- 土地使用名稱
    LUIIsActive BIT NOT NULL DEFAULT 1      	-- 是否啟用 (0:false, 1:true)
);
GO


/*【60. 土地使用明細 LandUseDetail】*/
CREATE TABLE LandUseDetail (
    LUDID INT IDENTITY(1,1) PRIMARY KEY,    	-- 土地使用明細編號
    LUIID INT NOT NULL,                     			-- 土地使用編號 (FK)
    PALID INT NOT NULL,                     			-- 物件土地資料編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,               						-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,               					-- 修改時間
    Sys_UpdateBy INT NULL,                    						-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_LandUseDetail_LandUseInfo FOREIGN KEY (LUIID) REFERENCES LandUseInfo(LUIID),
    CONSTRAINT FK_LandUseDetail_PropertyAssetLand FOREIGN KEY (PALID) REFERENCES PropertyAssetLand(PALID),
    CONSTRAINT FK_LandUseDetail_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_LandUseDetail_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO


/*【61. 建造材質 BuildingMaterial】*/
CREATE TABLE BuildingMaterial (
    BMID INT IDENTITY(1,1) PRIMARY KEY,         	-- 建造材質編號
    BMName NVARCHAR(30) NOT NULL,		-- 建造材質
    BMIsActive BIT NOT NULL DEFAULT 1,          	-- 是否啟用 (0:false, 1:true)
);
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
    PABCharge INT NULL,                         		-- 管理費
    CUID INT NULL,                              			-- 計算單位編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                      					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                      					-- 修改時間
    Sys_UpdateBy INT NULL,                           					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_PropertyAssetBuilding_PropertyAsset FOREIGN KEY (PAID) REFERENCES PropertyAsset(PAID),
    CONSTRAINT FK_PropertyAssetBuilding_PropertyType FOREIGN KEY (PTID) REFERENCES PropertyType(PTID),
    CONSTRAINT FK_PropertyAssetBuilding_BuildingMaterial FOREIGN KEY (BMID) REFERENCES BuildingMaterial(BMID),
    CONSTRAINT FK_PropertyAssetBuilding_CalculationUnits FOREIGN KEY (CUID) REFERENCES CalculationUnits(CUID),
    CONSTRAINT FK_PropertyAssetBuilding_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_PropertyAssetBuilding_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO


/*【62-1. 不動產物件建物建坪 PropertyAssetBuildingArea】*/
CREATE TABLE PropertyAssetBuildingArea (
    PABAID INT IDENTITY(1,1) PRIMARY KEY,           	-- 不動產物件建物建坪編號
    PABID INT NOT NULL,                              			-- 物件建物資料編號 (FK)
    PABAItem NVARCHAR(50) NOT NULL,                 	-- 建坪明細
    PABAFloorArea DECIMAL(15,2) NOT NULL,           	-- 建坪

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                        					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                        				-- 修改時間
    Sys_UpdateBy INT NULL,                             					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_PropertyAssetBuildingArea_PAB FOREIGN KEY (PABID) REFERENCES PropertyAssetBuilding(PABID),
    CONSTRAINT FK_PropertyAssetBuildingArea_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_PropertyAssetBuildingArea_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO


/*【63. 車位類型 CarParkType】*/
CREATE TABLE CarParkType (
    CPTID INT IDENTITY(1,1) PRIMARY KEY,        	-- 車位類型編號
    CPTName NVARCHAR(30) NOT NULL,		-- 車位類型
    CPTIsActive BIT NOT NULL DEFAULT 1          	-- 是否啟用 (0:false, 1:true)
);
GO


/*【64. 車位明細 CarParkDetail】*/
CREATE TABLE CarParkDetail (
    CPDID INT IDENTITY(1,1) PRIMARY KEY,        	-- 車位明細編號
    PABID INT NOT NULL,                         		-- 物件建物資料編號 (FK)
    CPDNumber NVARCHAR(30) NOT NULL, 	-- 車位編號
    CPTID INT NOT NULL,                         		-- 車位類型編號 (FK)
    CPDFloorArea DECIMAL(12,2)  NULL,          	-- 車位坪數
    CPDPrice DECIMAL(12,2) NULL,       			-- 售價
    CPDServiceCharge INT NULL,                  		-- 管理費
    CUID INT NULL,                              			-- 計算單位編號 (FK)
    CPDNote NVARCHAR(100) NULL,                 	-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                      					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                      					-- 修改時間
    Sys_UpdateBy INT NULL,                           					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_CarParkDetail_PropertyAssetBuilding FOREIGN KEY (PABID) REFERENCES PropertyAssetBuilding(PABID),
    CONSTRAINT FK_CarParkDetail_CarParkType FOREIGN KEY (CPTID) REFERENCES CarParkType(CPTID),
    CONSTRAINT FK_CarParkDetail_CalculationUnits FOREIGN KEY (CUID) REFERENCES CalculationUnits(CUID),
    CONSTRAINT FK_CarParkDetail_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_CarParkDetail_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO


/*【65. 物件鑰匙 PropertyAssetKey】*/
CREATE TABLE PropertyAssetKey (
    PAKID INT IDENTITY(1,1) PRIMARY KEY,        	-- 物件鑰匙編號
    PAID INT NOT NULL,                          		-- 物件編號 (FK)
    PAKCode NVARCHAR(30) NOT NULL,      	-- 鑰匙實體編號
    PAKHolder NVARCHAR(30) NOT NULL,		-- 保管方
    PAKNote INT NULL,                           		-- 備註
    PAKIsActive BIT NOT NULL DEFAULT 1,         	-- 是否啟用 (0:false, 1:true)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                      					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                      					-- 修改時間
    Sys_UpdateBy INT NULL,                           					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_PropertyAssetKey_PropertyAsset FOREIGN KEY (PAID) REFERENCES PropertyAsset(PAID),
    CONSTRAINT FK_PropertyAssetKey_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_PropertyAssetKey_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
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
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_PAE_PropertyAsset FOREIGN KEY (PAID) REFERENCES PropertyAsset(PAID),
    CONSTRAINT FK_PAE_Employee FOREIGN KEY (EEID) REFERENCES Employee(EEID),
    CONSTRAINT FK_PAE_JobAssignments FOREIGN KEY (JAID) REFERENCES JobAssignments(JAID),
    CONSTRAINT FK_PAE_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_PAE_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO


/*【67. 客戶稱謂 CustomerSalutation】*/
CREATE TABLE CustomerSalutation (
    CSID INT IDENTITY(1,1) PRIMARY KEY,      	-- 客戶稱謂編號
    CSName NVARCHAR(20) NOT NULL,            	-- 客戶稱謂
    CSIsActive BIT NOT NULL DEFAULT 1        	-- 是否啟用 (0:false, 1:true)
);
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
    CPMMayMarket BIT NOT NULL DEFAULT 1,     		-- 可否行銷 (0:false, 1:true)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,                				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,                         				-- 刪除時間
    Sys_DeleteBy INT NULL,                              					-- 刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_CPM_CustomerSalutation FOREIGN KEY (CSID) REFERENCES CustomerSalutation(CSID),
    CONSTRAINT FK_CPM_RegionCityDistrict FOREIGN KEY (RCDID) REFERENCES RegionCityDistrict(RCDID),
    CONSTRAINT FK_CPM_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_CPM_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_CPM_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID)
);
GO


/*【69. 客戶連絡電話 CustomerProfilePhone】*/
CREATE TABLE CustomerProfilePhone (
    CPPID INT IDENTITY(1,1) PRIMARY KEY,     	-- 客戶連絡電話編號
    CPMID INT NOT NULL,                      		-- 客戶資料編號 (FK)
    CPPPhone VARCHAR(30) NOT NULL,           	-- 連絡電話

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_CPP_CustomerProfileMain FOREIGN KEY (CPMID) REFERENCES CustomerProfileMain(CPMID),
    CONSTRAINT FK_CPP_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_CPP_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
GO


/*【70. 委託客戶明細 PropertyAssetCustomer】*/
CREATE TABLE PropertyAssetCustomer (
    PACID INT IDENTITY(1,1) PRIMARY KEY,     	-- 委託客戶明細編號
    CPMID INT NOT NULL,                   	   		-- 客戶資料編號 (FK)
    PAID INT NOT NULL,                       			-- 物件編號 (FK)
    PACIsPrimary BIT NOT NULL DEFAULT 0,     	-- 是否為主要聯繫人 (0:false, 1:true)
    PACNote NVARCHAR(100) NULL,              	-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_PAC_CustomerProfileMain FOREIGN KEY (CPMID) REFERENCES CustomerProfileMain(CPMID),
    CONSTRAINT FK_PAC_PropertyAsset FOREIGN KEY (PAID) REFERENCES PropertyAsset(PAID),
    CONSTRAINT FK_PAC_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_PAC_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID)
);
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
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                        					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                        				-- 修改時間
    Sys_UpdateBy INT NULL,                             					-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,               				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,                        				-- 刪除時間
    Sys_DeleteBy INT NULL,                            	 					-- 刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_AssetChanegeLog_ContractMain FOREIGN KEY (CMID) REFERENCES ContractMain(CMID),
    CONSTRAINT FK_AssetChanegeLog_PropertyAsset FOREIGN KEY (PAID) REFERENCES PropertyAsset(PAID),
    CONSTRAINT FK_AssetChanegeLog_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_AssetChanegeLog_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_AssetChanegeLog_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID)
);
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
    APODeposit DATETIME NULL,               		-- 存入時間
    APORefundDT DATETIME NULL,                    	-- 退還時間
    APORefundReason NVARCHAR(50) NULL,  	-- 退還原因
    APORefundType INT NULL,            			-- 退還方式 (FK)
    APONote NVARCHAR(500) NULL,  			-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,                 				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,                          				-- 刪除時間
    Sys_DeleteBy INT NULL,                               					-- 刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_AssetPurchaseOffer_ContractMain FOREIGN KEY (CMID) REFERENCES ContractMain(CMID),
    CONSTRAINT FK_AssetPurchaseOffer_PropertyAsset FOREIGN KEY (PAID) REFERENCES PropertyAsset(PAID),
    CONSTRAINT FK_AssetPurchaseOffer_CustomerProfileMain FOREIGN KEY (CPMID) REFERENCES CustomerProfileMain(CPMID),
    CONSTRAINT FK_AssetPurchaseOffer_OfferType FOREIGN KEY (APOOfferType) REFERENCES Payment(PID),
    CONSTRAINT FK_AssetPurchaseOffer_RefundType FOREIGN KEY (APORefundType) REFERENCES Payment(PID),
    CONSTRAINT FK_AssetPurchaseOffer_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_AssetPurchaseOffer_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(EEID),
    CONSTRAINT FK_AssetPurchaseOffer_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(EEID)
);
GO


