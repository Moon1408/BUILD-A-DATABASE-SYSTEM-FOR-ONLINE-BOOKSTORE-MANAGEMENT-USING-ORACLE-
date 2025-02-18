CREATE TABLE THELOAI (
            MaTL    VARCHAR(10)      NOT NULL, 
            TenTL   NVARCHAR2(50)    NOT NULL UNIQUE 
);
CREATE TABLE NHAXUATBAN( 
            MaNXB   VARCHAR(10)      NOT NULL, 
            TenNXB  NVARCHAR2(50)    NOT NULL UNIQUE 
);
CREATE TABLE KHO (
            MaK   VARCHAR(10)      NOT NULL, 
            TenK  NVARCHAR2(50)    NOT NULL UNIQUE
);
CREATE TABLE SACH (
            MaISBN    CHAR(13)        NOT NULL, 
            TuaSach   NVARCHAR2(50)   NOT NULL, 
            TacGia    NVARCHAR2(50)   ,
            MoTa      NVARCHAR2(2000) , 
            Gia       INT             ,
            NgonNgu   NVARCHAR2(50)   ,
            SLTon     INT             ,
            SLDaBan   INT             ,
            MaTL     VARCHAR(10)      NOT NULL, 
            MaNXB    VARCHAR(10)      NOT NULL,
            MaK      VARCHAR(10)      NOT NULL
);
CREATE TABLE NHANVIEN (
            MaNV        VARCHAR(10)     NOT NULL, 
            HoTenNV	    NVARCHAR2(50)   NOT NULL,
            NgaySinhNV	DATE			 ,
            GioiTinhNV	NVARCHAR2(3)	 ,
            SDTNV		VARCHAR(20)		 ,
            MaPB        VARCHAR(10)     NOT NULL
);
CREATE TABLE PHONGBAN ( 
            MaPB        VARCHAR(10)     NOT NULL,
            TenPB		NVARCHAR2(50)	NOT NULL UNIQUE       
); 
CREATE TABLE NHACUNGCAP( 
            MaNCC       VARCHAR(10)     NOT NULL,
            TenNCC		NVARCHAR2(50)	NOT NULL  UNIQUE ,
            Email_NCC	NVARCHAR2(50)	,
            SDT_NCC		VARCHAR(20)		,
            DiaChi_NCC	NVARCHAR2(100)	 
            
);
CREATE TABLE KHACHHANG (
            MaKH        VARCHAR(10)     NOT NULL, 
            HoTenKH		NVARCHAR2(50)	NOT NULL,
            NgaySinhKH	DATE			,
            GioiTinhKH	NVARCHAR2(3)	,
            SDTKH		VARCHAR(20)		,
            DiaChiKH	NVARCHAR2(100)	,
            EmailKH		NVARCHAR2(50)	,
            CongNoKH    INT				
);

CREATE TABLE PHIEUNHAP ( 
            MaPN                VARCHAR(10)     NOT NULL, 
            NgayNhap		    DATE			,
            TongTienPN		    INT				,
            TongSachNhap	    INT				,
            TrangThaiPN         NVARCHAR2(50)   ,
            TrangThaiTT_PN      NVARCHAR2(50)   ,
            MaNV                VARCHAR(10)     NOT NULL, 
            MaNCC               VARCHAR(10)     NOT NULL
);
CREATE TABLE CHITIETPHIEUNHAP ( 
            MaISBN      CHAR(13)        NOT NULL,
            MaPN        VARCHAR(10)     NOT NULL, 
            SoLuongPN	INT			  ,
            DonGiaPN	INT			  
); 
CREATE TABLE DONHANG ( 
            MaDH                VARCHAR(10)       NOT NULL,
            NgayDH		        DATE			,
            TongSachMua	        INT				,
            TongTienDH	        INT			    ,
            TrangThaiDH         NVARCHAR2(50)   ,
            TrangThaiTT         NVARCHAR2(50)   ,
            MaNV                VARCHAR(10)     NOT NULL, 
            MaKH                VARCHAR(10)     NOT NULL
);  
CREATE TABLE CHITIETDONHANG (
            MaISBN      CHAR(13)        NOT NULL,
            MaDH        VARCHAR(10)     NOT NULL, 
            SoLuongDH	INT			    
);
CREATE TABLE PHIEUTHU ( 
            MaPT            VARCHAR(10)     NOT NULL, 
            HinhThucThu     NVARCHAR2(50)   ,
            TongTienThu     INT             ,
            NgayThu         DATE            , 
            MaDH            VARCHAR(10)     NOT NULL
);
CREATE TABLE PHIEUCHI ( 
            MaPC            VARCHAR(10)     NOT NULL, 
            HinhThucChi     NVARCHAR2(50)    ,
            TongTienChi     INT              ,
            NgayChi         DATE             , 
            MaPN            VARCHAR(10)     NOT NULL 
); 
CREATE TABLE PHIEUGIAOHANG (
            MaVanDon	        VARCHAR(10)          NOT NULL,
            DonViVC		        NVARCHAR2(50)		 ,
            NgayDuKienGH		DATE				 ,
            TienShip	        INT					 ,
            MaDH                VARCHAR(10)     NOT NULL
); 

    
-- Khóa chính 
ALTER TABLE THELOAI ADD
    CONSTRAINT PK_THELOAI PRIMARY KEY
    (
        MaTL
    ); 
ALTER TABLE NHAXUATBAN ADD
    CONSTRAINT PK_NHAXUATBAN PRIMARY KEY
    (
        MaNXB 
    );
ALTER TABLE KHO ADD
    CONSTRAINT PK_KHO PRIMARY KEY
    (
        MaK
    );
ALTER TABLE SACH ADD
    CONSTRAINT PK_SACH PRIMARY KEY
    (
        MaISBN
    ); 
ALTER TABLE NHANVIEN ADD
    CONSTRAINT PK_NHANVIEN PRIMARY KEY
    (
        MaNV
    );
ALTER TABLE PHONGBAN ADD
    CONSTRAINT PK_PHONGBAN PRIMARY KEY
    (
        MaPB
    ); 
ALTER TABLE KHACHHANG ADD
    CONSTRAINT PK_KHACHHANG PRIMARY KEY
    (
        MaKH
    ); 
ALTER TABLE PHIEUNHAP ADD
    CONSTRAINT PK_PHIEUNHAP PRIMARY KEY
    (
        MaPN 
    ); 
ALTER TABLE CHITIETPHIEUNHAP ADD
    CONSTRAINT PK_CHITIETPHIEUNHAP PRIMARY KEY
    (
        MaPN, 
        MaISBN 
    ); 
ALTER TABLE  DONHANG ADD
    CONSTRAINT PK_DONHANG PRIMARY KEY
    (
        MaDH
    ); 
ALTER TABLE  CHITIETDONHANG ADD
    CONSTRAINT PK_CHITIETDONHANG PRIMARY KEY
    (
        MaDH, 
        MaISBN 
    );  
ALTER TABLE NHACUNGCAP ADD 
    CONSTRAINT PK_NHACUNGCAP PRIMARY KEY 
    (
        MaNCC
    );
ALTER TABLE PHIEUTHU ADD 
    CONSTRAINT PK_PHIEUTHU PRIMARY KEY 
    (
         MaPT   
    );
ALTER TABLE PHIEUCHI ADD 
    CONSTRAINT PK_PHIEUCHI PRIMARY KEY 
    (
       MaPC
    );
ALTER TABLE PHIEUGIAOHANG ADD 
    CONSTRAINT PK_PHIEUGIAOHANG PRIMARY KEY 
    (
       MaVanDon
    );  

-- Khóa ngo?i
-- SACH 
ALTER TABLE SACH ADD

    CONSTRAINT FK_SACH_THELOAI FOREIGN KEY
    (
        MaTL
    ) REFERENCES THELOAI (MaTL);

ALTER TABLE SACH ADD

    CONSTRAINT FK_SACH_NHAXUATBAN FOREIGN KEY
    (
        MaNXB
    ) REFERENCES NHAXUATBAN (MaNXB);
    
ALTER TABLE SACH ADD

    CONSTRAINT FK_SACH_KHO FOREIGN KEY
    (
        MaK
    ) REFERENCES KHO (MaK);   
-- NHANVIEN 
ALTER TABLE NHANVIEN ADD

    CONSTRAINT FK_NHANVIEN_PHONGBAN FOREIGN KEY
    (
        MaPB
    ) REFERENCES PHONGBAN (MaPB);   
ALTER TABLE PHIEUNHAP ADD

    CONSTRAINT FK_PHIEUNHAP_NHACUNGCAP FOREIGN KEY
    (
        MaNCC
    ) REFERENCES NHACUNGCAP (MaNCC); 
 
ALTER TABLE PHIEUNHAP ADD

    CONSTRAINT FK_PHIEUNHAP_NHANVIEN FOREIGN KEY
    (
        MaNV
    ) REFERENCES NHANVIEN (MaNV);   
ALTER TABLE  DONHANG ADD

    CONSTRAINT FK_DONHANG_NHANVIEN FOREIGN KEY
    (
        MaNV
    ) REFERENCES NHANVIEN (MaNV);  
-- KHACHHANG 
ALTER TABLE  DONHANG ADD

    CONSTRAINT FK_DONHANG_KHACHHANG FOREIGN KEY
    (
        MaKH
    ) REFERENCES KHACHHANG (MaKH); 
-- CHITIETPN 
ALTER TABLE  CHITIETPHIEUNHAP ADD

    CONSTRAINT FK_CHITIETPHIEUNHAP_SACH FOREIGN KEY
    (
        MaISBN
    ) REFERENCES SACH (MaISBN); 
ALTER TABLE  CHITIETPHIEUNHAP ADD

    CONSTRAINT FK_CHITIETPHIEUNHAP_PHIEUNHAP FOREIGN KEY
    (
        MaPN
    ) REFERENCES PHIEUNHAP(MaPN); 
-- CHITIETDONHANG 
ALTER TABLE   CHITIETDONHANG  ADD

    CONSTRAINT FK_CHITIETDONHANG_SACH FOREIGN KEY
    (
        MaISBN
    ) REFERENCES SACH (MaISBN); 
ALTER TABLE  CHITIETDONHANG ADD

    CONSTRAINT FK_CHITIETDONHANG_DONHANG FOREIGN KEY
    (
        MaDH
    ) REFERENCES  DONHANG(MaDH); 
-- PHIEUTHU 
ALTER TABLE  PHIEUTHU ADD

    CONSTRAINT FK_PHIEUTHU_DONHANG FOREIGN KEY
    (
        MaDH
    ) REFERENCES  DONHANG(MaDH);  
-- PHIEUCHI 
ALTER TABLE   PHIEUCHI  ADD

    CONSTRAINT FK_PHIEUCHI_PHIEUNHAP FOREIGN KEY
    (
        MaPN
    ) REFERENCES PHIEUNHAP(MaPN); 
-- PHIEUGIAOHANG 
ALTER TABLE PHIEUGIAOHANG  ADD

    CONSTRAINT FK_PHIEUGIAOHANG_DONHANG FOREIGN KEY
    (
        MaDH
    ) REFERENCES  DONHANG(MaDH);   
-- Ràng buộc check 
-- Trạng thái DH, PN  
ALTER TABLE DONHANG ADD
CONSTRAINT TrangThaiDH_Check CHECK (TrangThaiDH IN (N'Chưa xác nhận', N'Chưa giao hàng', N'Đang giao', N'Đã giao'));
ALTER TABLE DONHANG ADD
CONSTRAINT TrangThaiTT_Check CHECK (TrangThaiTT IN (N'Chưa thanh toán', N'Đã thanh toán'));

ALTER TABLE PHIEUNHAP ADD
CONSTRAINT TrangThaiPN_Check CHECK (TrangThaiPN IN ( N'Chưa giao hàng', N'Đã giao'));
ALTER TABLE PHIEUNHAP ADD
CONSTRAINT TrangThaiTT_PN_Check CHECK (TrangThaiTT_PN IN (N'Chưa thanh toán', N'Đã thanh toán')); 
-- Giới tính NV, KH
ALTER TABLE KHACHHANG ADD
CONSTRAINT GT_KH_Check CHECK (GioiTinhKH IN ('Nam',N'Nữ'));
ALTER TABLE NHANVIEN ADD
CONSTRAINT GT_NV_Check CHECK (GioiTinhNV IN ('Nam',N'Nữ'));
-- HinhThucThu, Chi 
ALTER TABLE PHIEUCHI ADD
CONSTRAINT HTC_Check CHECK (HinhThucChi IN (N'Tiền mặt', N'Chuyển khoản'));
ALTER TABLE PHIEUTHU ADD
CONSTRAINT HTT_Check CHECK (HinhThucThu IN (N'Tiền mặt', N'Chuyển khoản'));


 SET SERVEROUTPUT ON; 
 
