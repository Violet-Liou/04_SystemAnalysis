use DomusOneSysDB;

/*【40. 契據類別 ContractType】*/
CREATE TABLE ContractType (
    DS_CTID CHAR(2) PRIMARY KEY,           		-- 契據類別編號 (EX：AA、AG、BA、BG)
    DS_CTName NVARCHAR(30) NOT NULL,       	-- 契據類別名稱
    DS_CTIsActive BIT NOT NULL DEFAULT 1   	-- 是否啟用 (0:false, 1:true)
);
GO

/*【41. 契據訂購主檔 ContractOrderMain】*/
CREATE TABLE ContractOrderMain (
    DS_COMID INT IDENTITY(1,1) PRIMARY KEY,   	-- 契據訂購主檔編號
    DS_COID INT NOT NULL,                       			-- 公司編號 (FK)
    DS_EEID INT NOT NULL,                       			-- 員工編號 (FK)
    DS_COMOrderDT DATE NOT NULL,                	-- 訂購日期 (YYYY/MM/DD)
    DS_COMNote NVARCHAR(100) NULL,             	-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_ContractOrderMain_Company FOREIGN KEY (DS_COID) REFERENCES Company(DS_COID),
    CONSTRAINT FK_ContractOrderMain_Employee FOREIGN KEY (DS_EEID) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_ContractOrderMain_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_ContractOrderMain_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO

/*【42. 契據訂購明細 ContractOrderDetail】*/
CREATE TABLE ContractOrderDetail (
    DS_CODID INT IDENTITY(1,1) PRIMARY KEY,   	-- 契據訂購明細編號
    DS_COMID INT NOT NULL,                     			-- 契據訂購主檔編號 (FK)
    DS_CTID CHAR(2) NOT NULL,                  			-- 契據類別編號 (FK)
    DS_CODAmount INT NOT NULL,                 		-- 訂購數量
    DS_CODUnitPrice INT NOT NULL,              		-- 訂購單價
    DS_CODDiscount INT NOT NULL DEFAULT 0,     	-- 折扣

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_ContractOrderDetail_ContractOrderMain FOREIGN KEY (DS_COMID) REFERENCES ContractOrderMain(DS_COMID),
    CONSTRAINT FK_ContractOrderDetail_ContractType FOREIGN KEY (DS_CTID) REFERENCES ContractType(DS_CTID),
    CONSTRAINT FK_ContractOrderDetail_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_ContractOrderDetail_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO

/*【43. 契據入庫明細 ContractReceivingDetail】*/
CREATE TABLE ContractReceivingDetail (
    DS_CRDID INT IDENTITY(1,1) PRIMARY KEY,   	-- 契據入庫明細編號
    DS_CODID INT NOT NULL,                     			-- 契據訂購明細編號 (FK)
    DS_CRDReceiving DATE NOT NULL,             		-- 入庫日期 (YYYY/MM/DD)
    DS_CRDAmount INT NOT NULL,                 		-- 入庫數量
    DS_CRDNote NVARCHAR(100) NULL,            		-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_ContractReceivingDetail_ContractOrderDetail FOREIGN KEY (DS_CODID) REFERENCES ContractOrderDetail(DS_CODID),
    CONSTRAINT FK_ContractReceivingDetail_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_ContractReceivingDetail_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO

/*【44. 契據使用狀況 ContractUsageStatus】*/
CREATE TABLE ContractUsageStatus (
    DS_CUSID INT IDENTITY(1,1) PRIMARY KEY,     	-- 契據使用狀況編號
    DS_CUSName NVARCHAR(20) NOT NULL,           	-- 契據使用狀況
    DS_CUSIsActive BIT NOT NULL DEFAULT 1       	-- 是否啟用 (0:false, 1:true)
);
GO

/*【45. 契據主檔 ContractMain】*/
CREATE TABLE ContractMain (
    DS_CMID VARCHAR(15) PRIMARY KEY,           	-- 契據編號
    DS_COID INT NOT NULL,                       			-- 公司編號 (FK)
    DS_EEID INT NULL,                           				-- 員工編號 (FK)
    DS_CMDate DATE NOT NULL,                     		-- 領取日期
    DS_CUSID INT NOT NULL,                       			-- 契據使用狀況編號 (FK)
    DS_CMNote NVARCHAR(100) NULL,               	-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                                  					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_ContractMain_Company FOREIGN KEY (DS_COID) REFERENCES Company(DS_COID),
    CONSTRAINT FK_ContractMain_Employee FOREIGN KEY (DS_EEID) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_ContractMain_UsageStatus FOREIGN KEY (DS_CUSID) REFERENCES ContractUsageStatus(DS_CUSID),
    CONSTRAINT FK_ContractMain_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_ContractMain_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO

/*【45-1. 契據變更記錄檔 ContractRevisionLog】*/
CREATE TABLE ContractRevisionLog (
    DS_CRLID VARCHAR(15) PRIMARY KEY,		-- 契據變更記錄檔編號
    DS_CMID VARCHAR(15) NOT NULL,		-- 契據編號 (FK)
    DS_COID INT NOT NULL,					-- 公司編號 (FK)
    DS_EEID INT NULL,						-- 員工編號 (FK)
    DS_CUSID INT NOT NULL,					-- 契據使用狀況編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                             				-- 新增人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_ContractRevisionLog_ContractMain FOREIGN KEY (DS_CMID) REFERENCES ContractMain(DS_CMID),
    CONSTRAINT FK_ContractRevisionLog_Company FOREIGN KEY (DS_COID) REFERENCES Company(DS_COID),
    CONSTRAINT FK_ContractRevisionLog_Employee FOREIGN KEY (DS_EEID) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_ContractRevisionLog_UsageStatus FOREIGN KEY (DS_CUSID) REFERENCES ContractUsageStatus(DS_CUSID),
    CONSTRAINT FK_ContractRevisionLog_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID)
);
GO

/*【46. 契據申請主檔 ContractApplication】*/
CREATE TABLE ContractApplication (
    DS_CAID INT IDENTITY(1,1) PRIMARY KEY,      	-- 契據申請編號
    DS_EEID INT NOT NULL,                        			-- 員工編號 (FK)
    DS_CADate DATE NOT NULL,                     		-- 申請日期
    DS_APSID INT NOT NULL,                       			-- 申請狀態編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)
    Sys_ApprovalDT DATETIME NULL,                        				-- 審核時間
    Sys_ApprovedBy INT NULL                               				-- 審核人員 (FK)

    /*FK 設定*/
    ,CONSTRAINT FK_ContractApplication_Employee FOREIGN KEY (DS_EEID) REFERENCES Employee(DS_EEID)
    ,CONSTRAINT FK_ContractApplication_ApplyStatus FOREIGN KEY (DS_APSID) REFERENCES ApplyStatus(DS_APSID)
    ,CONSTRAINT FK_ContractApplication_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID)
    ,CONSTRAINT FK_ContractApplication_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
    ,CONSTRAINT FK_ContractApplication_ApprovedBy FOREIGN KEY (Sys_ApprovedBy) REFERENCES Employee(DS_EEID)
);
GO

/*【47. 契據申請明細 ContractApplicationDetail】*/
CREATE TABLE ContractApplicationDetail (
    DS_CADID INT IDENTITY(1,1) PRIMARY KEY,    	-- 契據申請明細編號
    DS_CAID INT NOT NULL,                        			-- 契據申請編號 (FK)
    DS_CTID CHAR(2) NOT NULL,                    		-- 契據類別編號 (FK)
    DS_CADAmount INT NOT NULL,                   		-- 申請數量

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL                               					-- 修改人員 (FK)

    /*FK 設定*/
    ,CONSTRAINT FK_ContractApplicationDetail_Application FOREIGN KEY (DS_CAID) REFERENCES ContractApplication(DS_CAID)
    ,CONSTRAINT FK_ContractApplicationDetail_ContractType FOREIGN KEY (DS_CTID) REFERENCES ContractType(DS_CTID)
    ,CONSTRAINT FK_ContractApplicationDetail_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID)
    ,CONSTRAINT FK_ContractApplicationDetail_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO

/*【48. 契據轉讓 ContractOwnershipChange】*/
CREATE TABLE ContractOwnershipChange (
    DS_COCID INT IDENTITY(1,1) PRIMARY KEY,       		-- 契據轉讓編號
    DS_CMID VARCHAR(15) NOT NULL,                  		-- 契據編號 (FK)
    DS_COCTransfer INT NOT NULL,                   			-- 轉讓員工編號 (FK)
    DS_COCTransferDate DATETIME NOT NULL,          	-- 轉讓日期
    DS_COCTransferSign NVARCHAR(500) NOT NULL,     	-- 轉讓簽章
    DS_COCReceiver INT NOT NULL,                   			-- 接收員工編號 (FK)
    DS_COCReceiverDate DATETIME NULL,              		-- 接收日期
    DS_COCReceiverSign NVARCHAR(500) NULL,        	-- 接收簽章
    DS_COCNote NVARCHAR(100) NULL,                		-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL                                					-- 修改人員 (FK)

    /*FK 設定*/
    ,CONSTRAINT FK_ContractOwnershipChange_ContractMain FOREIGN KEY (DS_CMID) REFERENCES ContractMain(DS_CMID)
    ,CONSTRAINT FK_ContractOwnershipChange_TransferEmployee FOREIGN KEY (DS_COCTransfer) REFERENCES Employee(DS_EEID)
    ,CONSTRAINT FK_ContractOwnershipChange_ReceiverEmployee FOREIGN KEY (DS_COCReceiver) REFERENCES Employee(DS_EEID)
    ,CONSTRAINT FK_ContractOwnershipChange_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID)
    ,CONSTRAINT FK_ContractOwnershipChange_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO

/*【51. 建物型態 PropertyType】*/
CREATE TABLE PropertyType (
    DS_PTID INT IDENTITY(1,1) PRIMARY KEY,        	-- 建物型態編號
    DS_PTName NVARCHAR(30) NOT NULL,              	-- 建物型態
    DS_PTIsActive BIT NOT NULL DEFAULT 1          	-- 是否啟用 (0:false, 1:true)
);
GO

/*【52. 社區 CommunityInfo】*/
CREATE TABLE CommunityInfo (
    DS_CIID INT IDENTITY(1,1) PRIMARY KEY,        	-- 社區編號
    DS_CIName NVARCHAR(100) NOT NULL,            	-- 社區名稱
    DS_RCDID INT NOT NULL,                        		-- 行政區編號 (FK)
    DS_CIStreet NVARCHAR(50) NOT NULL,           	-- 街道名稱
    DS_CINumber NVARCHAR(50) NOT NULL,           	-- 門牌範圍
    DS_PTID INT NOT NULL,                         			-- 建物型態編號 (FK)
    DS_CIBuilding INT NULL,                       			-- 社區內棟數
    DS_CIHouseholds INT NULL,                     		-- 總戶數
    DS_CIIsGated BIT NOT NULL DEFAULT 0,         	-- 是否為封閉型社區 (0:false, 1:true)
    DS_CIIsActive BIT NOT NULL DEFAULT 1,        	-- 是否啟用 (0:false, 1:true)
    DS_CILatitude DECIMAL(10,6) NOT NULL,        	-- 緯度
    DS_CILongitude DECIMAL(10,6) NOT NULL,       	-- 經度

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_CommunityInfo_RegionCityDistrict FOREIGN KEY (DS_RCDID) REFERENCES RegionCityDistrict(DS_RCDID),
    CONSTRAINT FK_CommunityInfo_PropertyType FOREIGN KEY (DS_PTID) REFERENCES PropertyType(DS_PTID),
    CONSTRAINT FK_CommunityInfo_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_CommunityInfo_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO

/*【53. 物件型態 PropertyAssetType】*/
CREATE TABLE PropertyAssetType (
    DS_PATID INT IDENTITY(1,1) PRIMARY KEY,       	-- 物件型態編號
    DS_PATName NVARCHAR(20) NOT NULL,             	-- 物件型態
    DS_PATIsActive BIT NOT NULL DEFAULT 1         	-- 是否啟用 (0:false, 1:true)
);
GO

/*【54. 物件狀態 PropertyAssetStatus】*/
CREATE TABLE PropertyAssetStatus (
    DS_PASID INT IDENTITY(1,1) PRIMARY KEY,       	-- 物件狀態編號
    DS_PASName NVARCHAR(30) NOT NULL,             	-- 物件狀態
    DS_PASIsActive BIT NOT NULL DEFAULT 1         	-- 是否啟用 (0:false, 1:true)
);
GO

/*【55. 不動產物件 PropertyAsset】*/
CREATE TABLE PropertyAsset (
    DS_PAID INT IDENTITY(1,1) PRIMARY KEY,        		-- 物件編號
    DS_CMID VARCHAR(15) NOT NULL,                 		-- 契據編號 (FK)
    DS_COID INT NOT NULL,                          			-- 公司編號 (FK)
    DS_PAStartDate DATE NOT NULL,                  			-- 合約起始日
    DS_PAEndDate DATE NOT NULL,                    			-- 合約結束日
    DS_PATID INT NOT NULL,                          			-- 物件型態編號 (FK)
    DS_RCDID INT NOT NULL,                          			-- 行政區編號 (FK)
    DS_PAAddress NVARCHAR(255) NOT NULL, 			-- 門牌地址
    DS_PAPrice DECIMAL(15,2) NOT NULL,             		-- 總價
    DS_PAIncludeParking BIT NOT NULL DEFAULT 0,    	-- 是否含車位費 (0:false, 1:true)
    DS_PAUnitPrice DECIMAL(7,2) NULL,              			-- 單價
    DS_CIID INT NULL,                               				-- 社區編號 (FK)
    DS_PASID INT NOT NULL,                          			-- 物件狀態編號 (FK)
    DS_PAMapPath NVARCHAR(500) NULL,               		-- 位置圖
    DS_PAPlanPath NVARCHAR(500) NULL,              		-- 平面圖
    DS_PADescription NVARCHAR(500) NULL,           		-- 物件介紹
    DS_PALatitude DECIMAL(10,6) NOT NULL,          		-- 緯度
    DS_PALongitude DECIMAL(10,6) NOT NULL,         		-- 經度

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),  	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,                				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,                          				-- 刪除時間
    Sys_DeleteBy INT NULL,                               					-- 刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_PropertyAsset_ContractMain FOREIGN KEY (DS_CMID) REFERENCES ContractMain(DS_CMID),
    CONSTRAINT FK_PropertyAsset_Company FOREIGN KEY (DS_COID) REFERENCES Company(DS_COID),
    CONSTRAINT FK_PropertyAsset_PropertyAssetType FOREIGN KEY (DS_PATID) REFERENCES PropertyAssetType(DS_PATID),
    CONSTRAINT FK_PropertyAsset_RegionCityDistrict FOREIGN KEY (DS_RCDID) REFERENCES RegionCityDistrict(DS_RCDID),
    CONSTRAINT FK_PropertyAsset_CommunityInfo FOREIGN KEY (DS_CIID) REFERENCES CommunityInfo(DS_CIID),
    CONSTRAINT FK_PropertyAsset_PropertyAssetStatus FOREIGN KEY (DS_PASID) REFERENCES PropertyAssetStatus(DS_PASID),
    CONSTRAINT FK_PropertyAsset_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_PropertyAsset_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_PropertyAsset_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(DS_EEID)
);
GO


/*【56. 不動產物件照片 PropertyAssetPhoto】*/
CREATE TABLE PropertyAssetPhoto (
    DS_PAPID INT IDENTITY(1,1) PRIMARY KEY,        	-- 不動產物件照片編號
    DS_PAID INT NOT NULL,                           		-- 物件編號 (FK)
    DS_PAPPath NVARCHAR(500) NOT NULL,             	-- 照片路徑
    DS_PAPDescription NVARCHAR(30) NULL,           	-- 照片介紹
    DS_PAPSort INT NOT NULL,                        		-- 顯示順序

    /*FK 設定*/
    CONSTRAINT FK_PropertyAssetPhoto_PropertyAsset FOREIGN KEY (DS_PAID) REFERENCES PropertyAsset(DS_PAID)
);
GO



/*【57. 土地使用分區 ZoningType】*/
CREATE TABLE ZoningType (
    DS_ZTID INT IDENTITY(1,1) PRIMARY KEY,     		-- 土地使用分區編號
    DS_ZTName NVARCHAR(30) NOT NULL,           	-- 土地使用分區
    DS_ZTDescription NVARCHAR(500) NULL,       	-- 分區用途說明
    DS_ZTIsActive BIT NOT NULL DEFAULT 1       		-- 是否啟用 (0:false, 1:true)
);
GO


/*【58. 不動產物件土地資料 PropertyAssetLand】*/
CREATE TABLE PropertyAssetLand (
    DS_PALID INT IDENTITY(1,1) PRIMARY KEY,    	-- 物件土地資料編號
    DS_PAID INT NOT NULL,                      			-- 物件編號 (FK)
    DS_PALSiteArea DECIMAL(15,2) NOT NULL,     	-- 地坪
    DS_ZTID INT NULL,                          				-- 土地使用分區編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,               						-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,               					-- 修改時間
    Sys_UpdateBy INT NULL,                    						-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_PropertyAssetLand_PropertyAsset FOREIGN KEY (DS_PAID) REFERENCES PropertyAsset(DS_PAID),
    CONSTRAINT FK_PropertyAssetLand_ZoningType FOREIGN KEY (DS_ZTID) REFERENCES ZoningType(DS_ZTID),
    CONSTRAINT FK_PropertyAssetLand_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_PropertyAssetLand_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO


/*【59. 土地使用 LandUseInfo】*/
CREATE TABLE LandUseInfo (
    DS_LUIID INT IDENTITY(1,1) PRIMARY KEY,    		-- 土地使用編號
    DS_LUIName NVARCHAR(30) NOT NULL,          	-- 土地使用名稱
    DS_LUIIsActive BIT NOT NULL DEFAULT 1      		-- 是否啟用 (0:false, 1:true)
);
GO


/*【60. 土地使用明細 LandUseDetail】*/
CREATE TABLE LandUseDetail (
    DS_LUDID INT IDENTITY(1,1) PRIMARY KEY,    	-- 土地使用明細編號
    DS_LUIID INT NOT NULL,                     			-- 土地使用編號 (FK)
    DS_PALID INT NOT NULL,                     			-- 物件土地資料編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,               						-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,               					-- 修改時間
    Sys_UpdateBy INT NULL,                    						-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_LandUseDetail_LandUseInfo FOREIGN KEY (DS_LUIID) REFERENCES LandUseInfo(DS_LUIID),
    CONSTRAINT FK_LandUseDetail_PropertyAssetLand FOREIGN KEY (DS_PALID) REFERENCES PropertyAssetLand(DS_PALID),
    CONSTRAINT FK_LandUseDetail_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_LandUseDetail_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO


/*【61. 建造材質 BuildingMaterial】*/
CREATE TABLE BuildingMaterial (
    DS_BMID INT IDENTITY(1,1) PRIMARY KEY,         	-- 建造材質編號
    DS_BMName NVARCHAR(30) NOT NULL,		-- 建造材質
    DS_BMIsActive BIT NOT NULL DEFAULT 1,          	-- 是否啟用 (0:false, 1:true)
);
GO


/*【62. 不動產物件建物資料 PropertyAssetBuilding】*/
CREATE TABLE PropertyAssetBuilding (
    DS_PABID INT IDENTITY(1,1) PRIMARY KEY,        	-- 物件建物資料編號
    DS_PAID INT NOT NULL,                          			-- 物件編號 (FK)
    DS_PABFloor INT NOT NULL,                      		-- 樓層
    DS_PABConfiguration INT NOT NULL,              	-- 建物格局
    DS_PTID INT NOT NULL,                          			-- 建物型態編號 (FK)
    DS_PABUsage NVARCHAR(50) NOT NULL, 		-- 建物登記用途
    DS_BMID INT NOT NULL,                          		-- 建造材質編號 (FK)
    DS_PABCompletionDate DATE NOT NULL, 		-- 建造完成日
    DS_PABCharge INT NULL,                         		-- 管理費
    DS_CUID INT NULL,                              			-- 計算單位編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                      					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                      					-- 修改時間
    Sys_UpdateBy INT NULL,                           					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_PropertyAssetBuilding_PropertyAsset FOREIGN KEY (DS_PAID) REFERENCES PropertyAsset(DS_PAID),
    CONSTRAINT FK_PropertyAssetBuilding_PropertyType FOREIGN KEY (DS_PTID) REFERENCES PropertyType(DS_PTID),
    CONSTRAINT FK_PropertyAssetBuilding_BuildingMaterial FOREIGN KEY (DS_BMID) REFERENCES BuildingMaterial(DS_BMID),
    CONSTRAINT FK_PropertyAssetBuilding_CalculationUnits FOREIGN KEY (DS_CUID) REFERENCES CalculationUnits(DS_CUID),
    CONSTRAINT FK_PropertyAssetBuilding_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_PropertyAssetBuilding_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO


/*【62-1. 不動產物件建物建坪 PropertyAssetBuildingArea】*/
CREATE TABLE PropertyAssetBuildingArea (
    DS_PABAID INT IDENTITY(1,1) PRIMARY KEY,           	-- 不動產物件建物建坪編號
    DS_PABID INT NOT NULL,                              			-- 物件建物資料編號 (FK)
    DS_PABAItem NVARCHAR(50) NOT NULL,                 	-- 建坪明細
    DS_PABAFloorArea DECIMAL(15,2) NOT NULL,           	-- 建坪

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                        					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                        				-- 修改時間
    Sys_UpdateBy INT NULL,                             					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_PropertyAssetBuildingArea_PAB FOREIGN KEY (DS_PABID) REFERENCES PropertyAssetBuilding(DS_PABID),
    CONSTRAINT FK_PropertyAssetBuildingArea_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_PropertyAssetBuildingArea_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO


/*【63. 車位類型 CarParkType】*/
CREATE TABLE CarParkType (
    DS_CPTID INT IDENTITY(1,1) PRIMARY KEY,        	-- 車位類型編號
    DS_CPTName NVARCHAR(30) NOT NULL,		-- 車位類型
    DS_CPTIsActive BIT NOT NULL DEFAULT 1          	-- 是否啟用 (0:false, 1:true)
);
GO


/*【64. 車位明細 CarParkDetail】*/
CREATE TABLE CarParkDetail (
    DS_CPDID INT IDENTITY(1,1) PRIMARY KEY,        	-- 車位明細編號
    DS_PABID INT NOT NULL,                         		-- 物件建物資料編號 (FK)
    DS_CPDNumber NVARCHAR(30) NOT NULL, 	-- 車位編號
    DS_CPTID INT NOT NULL,                         		-- 車位類型編號 (FK)
    DS_CPDFloorArea DECIMAL(12,2)  NULL,          	-- 車位坪數
    DS_CPDPrice DECIMAL(12,2) NULL,       			-- 售價
    DS_CPDServiceCharge INT NULL,                  		-- 管理費
    DS_CUID INT NULL,                              			-- 計算單位編號 (FK)
    DS_CPDNote NVARCHAR(100) NULL,                 	-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                      					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                      					-- 修改時間
    Sys_UpdateBy INT NULL,                           					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_CarParkDetail_PropertyAssetBuilding FOREIGN KEY (DS_PABID) REFERENCES PropertyAssetBuilding(DS_PABID),
    CONSTRAINT FK_CarParkDetail_CarParkType FOREIGN KEY (DS_CPTID) REFERENCES CarParkType(DS_CPTID),
    CONSTRAINT FK_CarParkDetail_CalculationUnits FOREIGN KEY (DS_CUID) REFERENCES CalculationUnits(DS_CUID),
    CONSTRAINT FK_CarParkDetail_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_CarParkDetail_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO


/*【65. 物件鑰匙 PropertyAssetKey】*/
CREATE TABLE PropertyAssetKey (
    DS_PAKID INT IDENTITY(1,1) PRIMARY KEY,        	-- 物件鑰匙編號
    DS_PAID INT NOT NULL,                          			-- 物件編號 (FK)
    DS_PAKCode NVARCHAR(30) NOT NULL,              -- 鑰匙實體編號
    DS_PAKHolder NVARCHAR(30) NOT NULL,		-- 保管方
    DS_PAKNote INT NULL,                           			-- 備註
    DS_PAKIsActive BIT NOT NULL DEFAULT 1,         	-- 是否啟用 (0:false, 1:true)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                      					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                      					-- 修改時間
    Sys_UpdateBy INT NULL,                           					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_PropertyAssetKey_PropertyAsset FOREIGN KEY (DS_PAID) REFERENCES PropertyAsset(DS_PAID),
    CONSTRAINT FK_PropertyAssetKey_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_PropertyAssetKey_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO


/*【66. 物件簽約專員明細 PropertyAssetExecutive】*/
CREATE TABLE PropertyAssetExecutive (
    DS_PAEID INT IDENTITY(1,1) PRIMARY KEY,      	-- 物件簽約專員明細編號
    DS_PAID INT NOT NULL,                        			-- 物件編號 (FK)
    DS_EEID INT NOT NULL,                        			-- 員工編號 (FK)
    DS_PAEPercent INT NOT NULL,                  		-- 物件比重
    DS_JAID INT NOT NULL,                        			-- 任職記錄編號 (FK)
    DS_PAEIsActive BIT NOT NULL DEFAULT 1,       	-- 是否啟用 (0:false, 1:true)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_PAE_PropertyAsset FOREIGN KEY (DS_PAID) REFERENCES PropertyAsset(DS_PAID),
    CONSTRAINT FK_PAE_Employee FOREIGN KEY (DS_EEID) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_PAE_JobAssignments FOREIGN KEY (DS_JAID) REFERENCES JobAssignments(DS_JAID),
    CONSTRAINT FK_PAE_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_PAE_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO


/*【67. 客戶稱謂 CustomerSalutation】*/
CREATE TABLE CustomerSalutation (
    DS_CSID INT IDENTITY(1,1) PRIMARY KEY,      	-- 客戶稱謂編號
    DS_CSName NVARCHAR(20) NOT NULL,            	-- 客戶稱謂
    DS_CSIsActive BIT NOT NULL DEFAULT 1        	-- 是否啟用 (0:false, 1:true)
);
GO


/*【68. 客戶資料 CustomerProfileMain】*/
CREATE TABLE CustomerProfileMain (
    DS_CPMID INT IDENTITY(1,1) PRIMARY KEY,     		-- 客戶資料編號
    DS_CPMFamilyName NVARCHAR(20) NOT NULL,     	-- 姓氏
    DS_CPMName NVARCHAR(50) NULL,               		-- 名字
    DS_CSID INT NOT NULL,                       				-- 客戶稱謂編號 (FK)
    DS_CPMIDNumber CHAR(10) NOT NULL,           		-- 身分證字號
    DS_RCDID INT NOT NULL,                      				-- 行政區編號 (FK)
    DS_CPMAddress NVARCHAR(255) NOT NULL,       	-- 門牌地址
    DS_CPMNote NVARCHAR(500) NULL,              		-- 備註
    DS_CPMMayMarket BIT NOT NULL DEFAULT 1,     		-- 可否行銷 (0:false, 1:true)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,                				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,                         				-- 刪除時間
    Sys_DeleteBy INT NULL,                              					-- 刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_CPM_CustomerSalutation FOREIGN KEY (DS_CSID) REFERENCES CustomerSalutation(DS_CSID),
    CONSTRAINT FK_CPM_RegionCityDistrict FOREIGN KEY (DS_RCDID) REFERENCES RegionCityDistrict(DS_RCDID),
    CONSTRAINT FK_CPM_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_CPM_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_CPM_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(DS_EEID)
);
GO


/*【69. 客戶連絡電話 CustomerProfilePhone】*/
CREATE TABLE CustomerProfilePhone (
    DS_CPPID INT IDENTITY(1,1) PRIMARY KEY,     	-- 客戶連絡電話編號
    DS_CPMID INT NOT NULL,                      			-- 客戶資料編號 (FK)
    DS_CPPPhone VARCHAR(30) NOT NULL,           	-- 連絡電話

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_CPP_CustomerProfileMain FOREIGN KEY (DS_CPMID) REFERENCES CustomerProfileMain(DS_CPMID),
    CONSTRAINT FK_CPP_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_CPP_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO


/*【70. 委託客戶明細 PropertyAssetCustomer】*/
CREATE TABLE PropertyAssetCustomer (
    DS_PACID INT IDENTITY(1,1) PRIMARY KEY,     	-- 委託客戶明細編號
    DS_CPMID INT NOT NULL,                   	   		-- 客戶資料編號 (FK)
    DS_PAID INT NOT NULL,                       			-- 物件編號 (FK)
    DS_PACIsPrimary BIT NOT NULL DEFAULT 0,     	-- 是否為主要聯繫人 (0:false, 1:true)
    DS_PACNote NVARCHAR(100) NULL,              	-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                         				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                         				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_PAC_CustomerProfileMain FOREIGN KEY (DS_CPMID) REFERENCES CustomerProfileMain(DS_CPMID),
    CONSTRAINT FK_PAC_PropertyAsset FOREIGN KEY (DS_PAID) REFERENCES PropertyAsset(DS_PAID),
    CONSTRAINT FK_PAC_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_PAC_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO


/*【71. 物件契變明細 AssetChanegeLog】*/
CREATE TABLE AssetChanegeLog (
    DS_ACLID INT IDENTITY(1,1) PRIMARY KEY,            	-- 物件契變明細編號
    DS_CMID VARCHAR(15) NOT NULL,                      		-- 契據編號 (FK)
    DS_PAID INT NOT NULL,                              			-- 物件編號 (FK)
    DS_ACLStartDate DATE NOT NULL,                     		-- 合約起始日
    DS_ACLEndDate DATE NOT NULL,                       		-- 合約截止日
    DS_ACLPrice_min DECIMAL(12,2) NULL,                		-- 底價
    DS_ACLPrice_total DECIMAL(12,2) NULL,              		-- 總價
    DS_ACLNote NVARCHAR(500) NULL,                     		-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                        					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                        				-- 修改時間
    Sys_UpdateBy INT NULL,                             					-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,               				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,                        				-- 刪除時間
    Sys_DeleteBy INT NULL,                            	 					-- 刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_AssetChanegeLog_ContractMain FOREIGN KEY (DS_CMID) REFERENCES ContractMain(DS_CMID),
    CONSTRAINT FK_AssetChanegeLog_PropertyAsset FOREIGN KEY (DS_PAID) REFERENCES PropertyAsset(DS_PAID),
    CONSTRAINT FK_AssetChanegeLog_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_AssetChanegeLog_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_AssetChanegeLog_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(DS_EEID)
);
GO


/*【73. 斡旋單 AssetPurchaseOffer】*/
CREATE TABLE AssetPurchaseOffer (
    DS_APOID INT IDENTITY(1,1) PRIMARY KEY,          	-- 斡旋單編號
    DS_CMID VARCHAR(15) NOT NULL,                    	-- 契據編號 (FK)
    DS_PAID INT NOT NULL,                            		-- 物件編號 (FK)
    DS_CPMID INT NOT NULL,                           		-- 客戶資料編號 (FK)
    DS_APOOfferDate DATE NOT NULL,                   	-- 下斡日期
    DS_APOExpiration DATE NOT NULL,                  	-- 有效日期
    DS_APOOfferPrice DECIMAL(12,2) NOT NULL,      	-- 下斡金額
    DS_APOOfferType INT NOT NULL,                    	-- 斡金類型 (FK)
    DS_APOAmount DECIMAL(12,2) NOT NULL,		-- 斡旋金
    DS_APODeposit DATETIME NULL,               		-- 存入時間
    DS_APORefundDT DATETIME NULL,                    	-- 退還時間
    DS_APORefundReason NVARCHAR(50) NULL,  	-- 退還原因
    DS_APORefundType INT NULL,            			-- 退還方式 (FK)
    DS_APONote NVARCHAR(500) NULL,  			-- 備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),   	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                          				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                          				-- 修改時間
    Sys_UpdateBy INT NULL,                               					-- 修改人員 (FK)
    Sys_IsDelete BIT NOT NULL DEFAULT 0,                 				-- 是否刪除 (0:false, 1:true)
    Sys_DeleteDT DATETIME NULL,                          				-- 刪除時間
    Sys_DeleteBy INT NULL,                               					-- 刪除人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_AssetPurchaseOffer_ContractMain FOREIGN KEY (DS_CMID) REFERENCES ContractMain(DS_CMID),
    CONSTRAINT FK_AssetPurchaseOffer_PropertyAsset FOREIGN KEY (DS_PAID) REFERENCES PropertyAsset(DS_PAID),
    CONSTRAINT FK_AssetPurchaseOffer_CustomerProfileMain FOREIGN KEY (DS_CPMID) REFERENCES CustomerProfileMain(DS_CPMID),
    CONSTRAINT FK_AssetPurchaseOffer_OfferType FOREIGN KEY (DS_APOOfferType) REFERENCES Payment(DS_PID),
    CONSTRAINT FK_AssetPurchaseOffer_RefundType FOREIGN KEY (DS_APORefundType) REFERENCES Payment(DS_PID),
    CONSTRAINT FK_AssetPurchaseOffer_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_AssetPurchaseOffer_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_AssetPurchaseOffer_DeletedBy FOREIGN KEY (Sys_DeleteBy) REFERENCES Employee(DS_EEID)
);
GO


/*【74. 帆布類型 CanvasSizeType】*/
CREATE TABLE CanvasSizeType (
    DS_CSTID INT IDENTITY(1,1) PRIMARY KEY,            	-- 帆布類型編號
    DS_CSTName NVARCHAR(50) NOT NULL,                  	-- 帆布類型
    DS_CSTCode CHAR(2) NOT NULL,                       		-- 帆布代號
    DS_CSTPhotoPath NVARCHAR(500) NULL,                	-- 帆布範例照片
    DS_ACLNote BIT NOT NULL DEFAULT 1,                 	-- 是否啟用 (0:false, 1:true)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                        					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                        				-- 修改時間
    Sys_UpdateBy INT NULL,                             					-- 修改人員 (FK)

    /*FK 設定*/
    CONSTRAINT FK_CanvasSizeType_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID),
    CONSTRAINT FK_CanvasSizeType_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO


/*【75. 帆布廠商 CanvasSupplierList】*/
CREATE TABLE CanvasSupplierList (
    DS_CSLID INT IDENTITY(1,1) PRIMARY KEY,    	-- 帆布廠商編號
    DS_CSLName NVARCHAR(20) NOT NULL,          	-- 廠商名稱
    DS_CSLNote NVARCHAR(200) NULL,             		-- 備註
    DS_CSLIsActive BIT NOT NULL DEFAULT 1      	-- 是否有效 (0:false, 1:true)
);
GO


/*【76. 帆布訂購 CanvasPurchaseLog】*/
CREATE TABLE CanvasPurchaseLog (
    DS_CPLID INT IDENTITY(1,1) PRIMARY KEY,               	-- 帆布訂購編號
    DS_COID INT NOT NULL,                                  		-- 公司編號 (FK)
    DS_EEID INT NOT NULL,                                  			-- 員工編號 (FK)
    DS_CPLDate DATE NOT NULL,                               		-- 帆布訂購日期
    DS_CSLID INT NOT NULL,                                 		-- 帆布廠商編號 (FK)
    DS_CSTID INT NOT NULL,                                 		-- 帆布類型編號 (FK)
    DS_CPLAmount INT NOT NULL,                              		-- 訂購數量
    DS_CPLUnitPrice DECIMAL(10,2) NOT NULL,               	-- 訂購單價
    DS_CPLDiscount INT NOT NULL DEFAULT 0,                	-- 折扣

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(),     	-- 新增時間
    Sys_CreatedBy INT NOT NULL,                            				-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                            				-- 修改時間
    Sys_UpdateBy INT NULL                                  					 -- 修改人員 (FK)

    /*FK 設定*/
    ,CONSTRAINT FK_CanvasPurchaseLog_Company FOREIGN KEY (DS_COID) REFERENCES Company(DS_COID)
    ,CONSTRAINT FK_CanvasPurchaseLog_Employee FOREIGN KEY (DS_EEID) REFERENCES Employee(DS_EEID)
    ,CONSTRAINT FK_CanvasPurchaseLog_Supplier FOREIGN KEY (DS_CSLID) REFERENCES CanvasSupplierList(DS_CSLID)
    ,CONSTRAINT FK_CanvasPurchaseLog_CanvasType FOREIGN KEY (DS_CSTID) REFERENCES CanvasSizeType(DS_CSTID)
    ,CONSTRAINT FK_CanvasPurchaseLog_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID)
    ,CONSTRAINT FK_CanvasPurchaseLog_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO


/*【77. 帆布狀態 CanvasStatusCode】*/
CREATE TABLE CanvasStatusCode (
    DS_CSCID INT IDENTITY(1,1) PRIMARY KEY,  		-- 帆布狀態編號
    DS_CSCName NVARCHAR(20) NOT NULL, 		-- 帆布狀態
    DS_CSCIsActive BIT NOT NULL DEFAULT 1   		-- 是否有效 (0:false, 1:true)
);
GO

/*【78. 帆布主檔 CanvasMainList】*/
CREATE TABLE CanvasMainList (
    DS_CMLID INT IDENTITY(1,1) PRIMARY KEY,        	-- 帆布主檔編號
    DS_CSTID INT NOT NULL,                          		-- 帆布類型編號 (FK)
    DS_CMLCode INT NOT NULL,                        		-- 帆布代號
    DS_PAID INT NOT NULL,                            		-- 物件編號 (FK)
    DS_CMLDate DATE NOT NULL,                        		-- 日期
    DS_CSCID INT NOT NULL,                          		-- 帆布狀態編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                        					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                        				-- 修改時間
    Sys_UpdateBy INT NULL                              					-- 修改人員 (FK)

    /*FK 設定*/
    ,CONSTRAINT FK_CanvasMainList_CanvasType FOREIGN KEY (DS_CSTID) REFERENCES CanvasSizeType(DS_CSTID)
    ,CONSTRAINT FK_CanvasMainList_PropertyAsset FOREIGN KEY (DS_PAID) REFERENCES PropertyAsset(DS_PAID)
    ,CONSTRAINT FK_CanvasMainList_CanvasStatus FOREIGN KEY (DS_CSCID) REFERENCES CanvasStatusCode(DS_CSCID)
    ,CONSTRAINT FK_CanvasMainList_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID)
    ,CONSTRAINT FK_CanvasMainList_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO

/*【79. 帆布申請類型 CanvasApplicationType】*/
CREATE TABLE CanvasApplicationType (
    DS_CATID INT IDENTITY(1,1) PRIMARY KEY,        	-- 帆布申請類型編號
    DS_CATType NVARCHAR(20) NOT NULL,              	-- 帆布申請類型
    DS_CATIsActive BIT NOT NULL DEFAULT 1          	-- 是否有效 (0:false, 1:true)
);
GO


/*【80. 帆布拆掛申請 CanvasRequest】*/
CREATE TABLE CanvasRequest (
    DS_CRID INT IDENTITY(1,1) PRIMARY KEY,        		-- 帆布拆掛申請編號
    DS_CATID INT NOT NULL,                         			-- 帆布申請類型編號 (FK)
    DS_EEID INT NOT NULL,                           				-- 員工編號 (FK)
    DS_PAID INT NOT NULL,                           			-- 物件編號 (FK)
    DS_CSTID INT NOT NULL,                          			-- 帆布類型編號 (FK)
    DS_CRAddress NVARCHAR(100) NOT NULL,           	-- 拆掛地址簡述
    DS_CRDescription NVARCHAR(500) NOT NULL,       	-- 拆掛詳情描述
    DS_CSLID INT NOT NULL,                          			-- 帆布廠商編號 (FK)
    DS_CRChargeRate_C DECIMAL(5,2) NOT NULL,       	-- 公司拆算比例
    DS_CRChargeRate_E DECIMAL(5,2) NOT NULL,       	-- 人員拆算比例
    DS_APSID INT NOT NULL,                          			-- 申請狀態編號 (FK)
    DS_CRNote_admin NVARCHAR(500) NULL,            	-- 行政備註

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                        					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                        				-- 修改時間
    Sys_UpdateBy INT NULL,                              					-- 修改人員 (FK)
    Sys_ApprovalDT DATETIME NULL,                       				-- 審核時間
    Sys_ApprovedBy INT NULL                             					-- 審核人員 (FK)

    /*FK 設定*/
    ,CONSTRAINT FK_CanvasRequest_ApplicationType FOREIGN KEY (DS_CATID) REFERENCES CanvasApplicationType(DS_CATID)
    ,CONSTRAINT FK_CanvasRequest_Employee FOREIGN KEY (DS_EEID) REFERENCES Employee(DS_EEID)
    ,CONSTRAINT FK_CanvasRequest_PropertyAsset FOREIGN KEY (DS_PAID) REFERENCES PropertyAsset(DS_PAID)
    ,CONSTRAINT FK_CanvasRequest_CanvasType FOREIGN KEY (DS_CSTID) REFERENCES CanvasSizeType(DS_CSTID)
    ,CONSTRAINT FK_CanvasRequest_Supplier FOREIGN KEY (DS_CSLID) REFERENCES CanvasSupplierList(DS_CSLID)
    ,CONSTRAINT FK_CanvasRequest_ApplyStatus FOREIGN KEY (DS_APSID) REFERENCES ApplyStatus(DS_APSID)
    ,CONSTRAINT FK_CanvasRequest_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID)
    ,CONSTRAINT FK_CanvasRequest_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
    ,CONSTRAINT FK_CanvasRequest_ApprovedBy FOREIGN KEY (Sys_ApprovedBy) REFERENCES Employee(DS_EEID)
);
GO

/*【81. 帆布拆掛明細 CanvasMountDetail】*/
CREATE TABLE CanvasMountDetail (
    DS_CMDID INT IDENTITY(1,1) PRIMARY KEY,        	-- 帆布拆掛明細編號
    DS_CRID INT NOT NULL,                           		-- 帆布拆掛申請編號 (FK)
    DS_CMLID INT NOT NULL,                          		-- 帆布主檔編號 (FK)
    DS_CMDDate DATE NOT NULL,                        	-- 拆掛日期
    DS_CMDPhoto NVARCHAR(500) NULL,                 	-- 吊掛照片路徑
    DS_CRNote_admin NVARCHAR(500) NULL,     	-- 備註
    DS_CSCID INT NOT NULL,                           		-- 帆布狀態編號 (FK)

    /*系統欄位*/
    Sys_CreatedDT DATETIME NOT NULL DEFAULT GETDATE(), 		-- 新增時間
    Sys_CreatedBy INT NOT NULL,                        					-- 新增人員 (FK)
    Sys_UpdateDT DATETIME NULL,                        				-- 修改時間
    Sys_UpdateBy INT NULL                               					-- 修改人員 (FK)

    /*FK 設定*/
    ,CONSTRAINT FK_CanvasMountDetail_CanvasRequest FOREIGN KEY (DS_CRID) REFERENCES CanvasRequest(DS_CRID)
    ,CONSTRAINT FK_CanvasMountDetail_CanvasMain FOREIGN KEY (DS_CMLID) REFERENCES CanvasMainList(DS_CMLID)
    ,CONSTRAINT FK_CanvasMountDetail_CanvasStatus FOREIGN KEY (DS_CSCID) REFERENCES CanvasStatusCode(DS_CSCID)
    ,CONSTRAINT FK_CanvasMountDetail_CreatedBy FOREIGN KEY (Sys_CreatedBy) REFERENCES Employee(DS_EEID)
    ,CONSTRAINT FK_CanvasMountDetail_UpdatedBy FOREIGN KEY (Sys_UpdateBy) REFERENCES Employee(DS_EEID)
);
GO

