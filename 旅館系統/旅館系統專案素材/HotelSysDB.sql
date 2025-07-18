
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'HotelSysDB')
begin
	use master
	DROP DATABASE HotelSysDB

end
go

Create database HotelSysDB
go

use HotelSysDB
go


-- �|����ƪ�
CREATE TABLE Member (
    MemberID nchar(5) PRIMARY KEY,
    Name nvarchar(40) NOT NULL,
    City nvarchar(10) NOT NULL,
    Address nvarchar(50) NOT NULL,
    Birthday datetime NOT NULL
);

INSERT INTO Member VALUES
(N'A0001', N'�L�p��', N'�x�_��', N'�x�_��1��', '1990-01-01'),
(N'A0002', N'�i�R�R', N'������', N'������5��', '1985-05-05');

-- �|���q��
CREATE TABLE MemberTel (
    SN bigint IDENTITY PRIMARY KEY,
    Tel nvarchar(20) NOT NULL,
    MemberID nchar(5) NOT NULL FOREIGN KEY REFERENCES Member(MemberID)
);

INSERT INTO MemberTel (Tel, MemberID) VALUES
(N'0912345678', N'A0001'),
(N'0987654321', N'A0002');

-- �|���b�K
CREATE TABLE MemberAccount (
    Account nvarchar(30) COLLATE Latin1_General_CS_AS NOT NULL PRIMARY KEY,
    Password nvarchar(200) NOT NULL,
    MemberID nchar(5) NOT NULL FOREIGN KEY REFERENCES Member(MemberID)
);

-- �K�X�H SHA256 HASH �غ�k�����K�X�� '12345678'
INSERT INTO MemberAccount VALUES
(N'lin001', N'ef797c8118f02d4c602d9f9b0e62d2493ca7f8efcf4789c4fa13a7aaf2d4fbb6', N'A0001'),
(N'chang002', N'ef797c8118f02d4c602d9f9b0e62d2493ca7f8efcf4789c4fa13a7aaf2d4fbb6', N'A0002');

-- �ж����A
CREATE TABLE RoomStatus (
    StatusCode nchar(1) PRIMARY KEY,
    Status nvarchar(10) NOT NULL
);

INSERT INTO RoomStatus VALUES
(N'1', N'���`'),
(N'2', N'�O�d'),
(N'3', N'�U�[');

-- �ж�
CREATE TABLE Room (
    RoomID nchar(5) PRIMARY KEY,
    RoomName nvarchar(40) NOT NULL,
    PeopleNum tinyint NOT NULL CHECK (PeopleNum >= 0),
    Price money NOT NULL CHECK (Price >= 0),
    Area nchar(1) NOT NULL,
    Floor tinyint NOT NULL,
    Introduction nvarchar(400) NOT NULL,
    Note nvarchar(max) NULL,
    CreatedDate datetime NOT NULL DEFAULT GETDATE(),
    StatusCode nchar(1) NOT NULL FOREIGN KEY REFERENCES RoomStatus(StatusCode)
);

INSERT INTO Room (RoomID, RoomName, PeopleNum, Price, Area, [Floor], Introduction, Note, CreatedDate, StatusCode) VALUES
(N'A2001', N'�з����H��', 2, 2500, N'A', 2, N'�ξA���H�ɡA���ïD', NULL, GETDATE(), N'1'),
(N'A3001', N'���[���H��', 2, 2700, N'A', 3, N'���H�ɡA�����[��', NULL, GETDATE(), N'1'),
(N'A3002', N'�������H��', 2, 3200, N'A', 3, N'���ظ��C�A���F�o', NULL, GETDATE(), N'1'),
(N'A2002', N'�a�x�T�H��', 3, 3500, N'A', 2, N'�T�i��H�ɡA�A�X�a�x', NULL, GETDATE(), N'1'),
(N'A2003', N'�зǥ|�H��', 4, 4000, N'A', 2, N'��i���H�ɡA�����U', NULL, GETDATE(), N'1'),
(N'A3003', N'���إ|�H��', 4, 4500, N'A', 3, N'�|�H�СA���j���x', NULL, GETDATE(), N'1'),
(N'A3004', N'���[�|�H��', 4, 4200, N'A', 3, N'�|�H�СA�����[��', NULL, GETDATE(), N'1'),
(N'A4001', N'�a�x���H��', 6, 8000, N'A', 4, N'�T�i���H�ɡA�A�X�j�a�x', NULL, GETDATE(), N'1'),
(N'A4002', N'�E�|�K�H��', 8, 6600, N'A', 4, N'�|�i���H�ɡA�A�X����', NULL, GETDATE(), N'1'),
(N'A3005', N'���ɥ|�H��', 4, 4300, N'A', 3, N'�|�H�СA���p��', NULL, GETDATE(), N'1');


-- �ж��Ӥ�
CREATE TABLE RoomPhoto (
    SN bigint IDENTITY(1,1) NOT NULL PRIMARY KEY,
    PhotoPath nvarchar(50) NOT NULL,
    RoomID nchar(5) NOT NULL,
    CONSTRAINT FK_RoomPhoto_Room FOREIGN KEY (RoomID) REFERENCES Room(RoomID)
);

INSERT INTO RoomPhoto (PhotoPath, RoomID) VALUES
(N'A2001/1.jpg', N'A2001'), (N'A2001/2.jpg', N'A2001'),
(N'A3001/1.jpg', N'A3001'), (N'A3001/2.jpg', N'A3001'),
(N'A3002/1.jpg', N'A3002'), (N'A3002/2.jpg', N'A3002'),
(N'A2002/1.jpg', N'A2002'), (N'A2002/2.jpg', N'A2002'),
(N'A2003/1.jpg', N'A2003'), (N'A2003/2.jpg', N'A2003'),
(N'A3003/1.jpg', N'A3003'), (N'A3003/2.jpg', N'A3003'), 
(N'A3004/1.jpg', N'A3004'), (N'A3004/2.jpg', N'A3004'),
(N'A4001/1.jpg', N'A4001'), (N'A4001/2.jpg', N'A4001'),
(N'A4002/1.jpg', N'A4002'), (N'A4002/2.jpg', N'A4002'),
(N'A3005/1.jpg', N'A3005'), (N'A3005/2.jpg', N'A3005')

-- ���u����
CREATE TABLE EmployeeRole (
    RoleCode nchar(1) PRIMARY KEY,
    RoleName nvarchar(15) NOT NULL
);

INSERT INTO EmployeeRole VALUES
(N'A', N'�d�x'),
(N'B', N'�а�'),
(N'C', N'�D��');

-- ���u
CREATE TABLE Employee (
    EmployeeID nchar(4) PRIMARY KEY,
    Name nvarchar(40) NOT NULL,
    HireDate datetime NOT NULL,
    Address nvarchar(50) NOT NULL,
    Birthday datetime NOT NULL,
    Tel nvarchar(20) NOT NULL,
    Account nvarchar(30) COLLATE Latin1_General_CS_AS NOT NULL UNIQUE,
    Password nvarchar(200) NOT NULL,
    RoleCode nchar(1) NOT NULL FOREIGN KEY REFERENCES EmployeeRole(RoleCode)
);

INSERT INTO Employee VALUES
(N'1001', N'���d�x', '2020-05-01', N'�x�_���H�q��', '1990-05-05', N'0223456789', N'wang01', N'ef797c8118f02d4c602d9f9b0e62d2493ca7f8efcf4789c4fa13a7aaf2d4fbb6', N'A'),
(N'1002', N'���а�', '2021-03-10', N'�s�_���O����', '1992-08-12', N'0223456790', N'li02', N'ef797c8118f02d4c602d9f9b0e62d2493ca7f8efcf4789c4fa13a7aaf2d4fbb6', N'B'),
(N'1003', N'���D��', '2018-07-20', N'��饫���c��', '1985-11-23', N'0334567890', N'chen03', N'ef797c8118f02d4c602d9f9b0e62d2493ca7f8efcf4789c4fa13a7aaf2d4fbb6', N'C'),
(N'1004', N'�i�d�x', '2022-01-15', N'�x������ٰ�', '1995-02-14', N'0423456789', N'zhang04', N'ef797c8118f02d4c602d9f9b0e62d2493ca7f8efcf4789c4fa13a7aaf2d4fbb6', N'A'),
(N'1005', N'�L�а�', '2023-04-18', N'�����������', '1993-06-30', N'0723456789', N'lin05', N'ef797c8118f02d4c602d9f9b0e62d2493ca7f8efcf4789c4fa13a7aaf2d4fbb6', N'B'),
(N'1006', N'�d�D��', '2019-09-05', N'�x�n���F��', '1988-09-09', N'0623456789', N'wu06', N'ef797c8118f02d4c602d9f9b0e62d2493ca7f8efcf4789c4fa13a7aaf2d4fbb6', N'C'),
(N'1007', N'�P�d�x', '2020-11-11', N'�s�˥��_��', '1991-12-01', N'0356789123', N'zhou07', N'ef797c8118f02d4c602d9f9b0e62d2493ca7f8efcf4789c4fa13a7aaf2d4fbb6', N'A'),
(N'1008', N'�G�а�', '2021-06-25', N'�Ÿq�����', '1994-03-18', N'0523456789', N'zheng08', N'ef797c8118f02d4c602d9f9b0e62d2493ca7f8efcf4789c4fa13a7aaf2d4fbb6', N'B'),
(N'1009', N'�\�d�x', '2017-12-30', N'�򶩥����R��', '1983-07-07', N'0223456791', N'xu09', N'ef797c8118f02d4c602d9f9b0e62d2493ca7f8efcf4789c4fa13a7aaf2d4fbb6', N'A'),
(N'1010', N'���а�', '2023-02-20', N'���ƥ�', '1996-10-10', N'0478912345', N'huang10', N'ef797c8118f02d4c602d9f9b0e62d2493ca7f8efcf4789c4fa13a7aaf2d4fbb6', N'B');

-- �I�ڤ覡
CREATE TABLE PayType (
    PayCode nchar(2) PRIMARY KEY,
    PayType nvarchar(10) NOT NULL
);


INSERT INTO PayType VALUES
(N'01', N'�{��'),
(N'02', N'��d'),
(N'03', N'��b');


-- �q�檬�A��ƪ�
CREATE TABLE OrderStatus (
    StatusCode nchar(1) PRIMARY KEY,
    Status nvarchar(10) NOT NULL
);


INSERT INTO OrderStatus VALUES
(N'0', N'�ݽT�{'),
(N'1', N'�w�T�{'),
(N'2', N'�w����')

-- �q��
CREATE TABLE [Order] (
    OrderID nchar(12) PRIMARY KEY,
    OrderDate datetime NOT NULL DEFAULT GETDATE(),
    ExpectedCheckInDate datetime NOT NULL,
    ExpectedCheckOutDate datetime NOT NULL,
    Note nvarchar(200) NULL,
    MemberID nchar(5) NOT NULL FOREIGN KEY REFERENCES Member(MemberID),
    EmployeeID nchar(4)  NULL FOREIGN KEY REFERENCES Employee(EmployeeID),
    PayCode nchar(2) NOT NULL FOREIGN KEY REFERENCES PayType(PayCode),
    StatusCode nchar(1) NOT NULL FOREIGN KEY REFERENCES OrderStatus(StatusCode)
);

-- �q����
INSERT INTO [Order] (OrderID, OrderDate, ExpectedCheckInDate, ExpectedCheckOutDate, Note, MemberID, EmployeeID, PayCode,StatusCode) VALUES
(N'R20250715001', '2025-07-15', '2025-08-01', '2025-08-03', N'�����ȹC', N'A0001', N'1001', N'01', N'1'),
(N'R20250715002', '2025-07-15', '2025-08-05', '2025-08-07', N'���q�X�t', N'A0002', NULL, N'02', N'1');

-- �q�����
CREATE TABLE OrderDetail (
    OrderID nchar(12) NOT NULL,
    RoomID nchar(5) NOT NULL,
    Price money NOT NULL CHECK (Price >= 0),
    CheckInTime datetime NULL DEFAULT NULL,
    CheckOutTime datetime NULL DEFAULT NULL,
    PRIMARY KEY (OrderID, RoomID),
    FOREIGN KEY (OrderID) REFERENCES [Order](OrderID),
    FOREIGN KEY (RoomID) REFERENCES Room(RoomID)
);

-- �q����Ӹ��
INSERT INTO OrderDetail (OrderID, RoomID, Price, CheckInTime, CheckOutTime) VALUES
(N'R20250715001', N'A2001', 2500, NULL, NULL),
(N'R20250715001', N'A2002', 4200, NULL, NULL),
(N'R20250715002', N'A3001', 1800, NULL, NULL);


-- �аȳB�z���A
CREATE TABLE ProcessingStatus (
    PSCode nchar(1) PRIMARY KEY,
    ProcessingStatus nvarchar(20) NOT NULL
);

INSERT INTO ProcessingStatus VALUES
(N'0', N'�ݳB�z'),
(N'1', N'�B�z��'),
(N'2', N'�B�z����');

-- �а�
CREATE TABLE RoomService (
    RoomServiceID nchar(8) PRIMARY KEY,
    RoomID nchar(5) NOT NULL,
    Subject nvarchar(20) NOT NULL,
    ServiceContent nvarchar(500) NOT NULL,
    CreatedTime datetime NOT NULL DEFAULT GETDATE(),
    ProcessingDiscription nvarchar(1000) NULL,
    CompletionTime datetime NULL,
    MemberID nchar(5) NOT NULL FOREIGN KEY REFERENCES Member(MemberID),
    EmployeeID nchar(4) NULL FOREIGN KEY REFERENCES Employee(EmployeeID),
    PSCode nchar(1) NOT NULL FOREIGN KEY REFERENCES ProcessingStatus(PSCode)
);

-- �аȪA�ȸ�Ƽ���
INSERT INTO RoomService (RoomServiceID, RoomID, Subject, ServiceContent, CreatedTime, ProcessingDiscription, CompletionTime, MemberID, EmployeeID, PSCode) VALUES
(N'RS202501', N'B2001', N'�[�Q�l', N'�ж����N�A�Х[�@���Q�l', '2025-07-15 10:00:00', N'�w�e�ܫȩ�', '2025-07-15 11:00:00', N'A0001', N'1001', N'2'),
(N'RS202502', N'B2002', N'�M��', N'�ж��D�ǻݭn�A�M��', '2025-07-15 09:30:00', N'�аȤH���B�z��', NULL, N'A0002', N'1001', N'1'),
(N'RS202503', N'B2003', N'�ɥR�ƫ~', N'�иɥR�q�u���P��y', '2025-07-15 08:45:00', NULL, NULL, N'A0001', NULL, N'0');

