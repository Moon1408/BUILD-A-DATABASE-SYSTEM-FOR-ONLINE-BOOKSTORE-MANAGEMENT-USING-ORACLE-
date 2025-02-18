--Câu 1. Trigger- kiểm tra khóa ngoại khi Delete ( Kiểu là Khi xóa dữ liệu trong bảng sản phẩm, nếu mã sản phẩm bị xóa có trong bảng đơn hàng thì không cho xóa ) 
CREATE OR REPLACE TRIGGER trg_Cau1 
BEFORE DELETE ON SACH
FOR EACH ROW
DECLARE
    v_count int := 0 ; 
BEGIN
    -- Kiểm tra xem mã sách bị xóa có tồn tại trong bảng đơn hàng hay không
    SELECT  COUNT(*) INTO v_count
    FROM    CHITIETDONHANG C, DONHANG D 
    WHERE   MaISBN = :OLD.MaISBN
    and     c.MaDH = d.MaDH; 
    
    -- Nếu tồn tại bản ghi trong bảng đơn hàng, không cho phép xóa
    IF v_count > 0 THEN
        raise_application_error(-20001, 'Khóa ngoại không hợp lệ: Sách có trong đơn hàng.');
    else 
        DBMS_OUTPUT.PUT_LINE('Xóa sách thành công'); 
    END IF;
END;
-- TEST ĐÚNG 
DELETE FROM SACH
WHERE MaISBN =  '5649899714008'; 
-- TEST SAI 
DELETE FROM SACH
WHERE MaISBN = '8935212361750';
--
alter trigger trg_Cau1 disable;   
alter trigger trg_Cau1 ENABLE;
--------------------------------------------------------------------------------
-- Câu 2.1. Trigger - Kiểm tra trùng giá trị ( EmailKH, EmailNcc )
CREATE OR REPLACE TRIGGER trg_Cau2_1
BEFORE INSERT ON NHACUNGCAP
FOR EACH ROW
DECLARE
    v_count int := 0 ; 

BEGIN
    SELECT COUNT(*) INTO v_count
    FROM NHACUNGCAP
    WHERE Email_NCC = :new.Email_NCC;

    IF v_count > 0 THEN
        raise_application_error(-20001, 'Email nhà cung cấp đã tồn tại.');
    else 
        DBMS_OUTPUT.PUT_LINE('Thêm nhà cung cấp thành công.'); 
    END IF;

END;
-- TEST SAI 
INSERT INTO NHACUNGCAP (MaNCC, TenNCC, Email_NCC, SDT_NCC, DiaChi_NCC) VALUES ('NCC04', N' Việt Nam', 'azvn@gmail.com', '0862034696', N' Sư Vạn Hạnh, phường 10, quận 1, Thành phố Hồ Chí Minh');
-- TEST ĐÚNG 
INSERT INTO NHACUNGCAP (MaNCC, TenNCC, Email_NCC, SDT_NCC, DiaChi_NCC) VALUES ('NCC05', N' Việt Nam', 'azvn1@gmail.com', '0862034696', N' Sư Vạn Hạnh, phường 10, quận 1, Thành phố Hồ Chí Minh');
--
alter trigger trg_Cau2_1 disable;   
alter trigger trg_Cau2_1 ENABLE;
-- Câu 2.2. Kiểm tra email trùng khách hàng
CREATE OR REPLACE TRIGGER trg_Cau2_2
BEFORE INSERT ON KHACHHANG
FOR EACH ROW
DECLARE
    v_count int := 0 ; 

BEGIN
    SELECT COUNT(*) INTO v_count
    FROM KHACHHANG
    WHERE EmailKH = :new.EmailKH;

    IF v_count > 0 THEN
        raise_application_error(-20001, 'Email khách hàng đã tồn tại.');
    else 
        DBMS_OUTPUT.PUT_LINE('Thêm khách hàng thành công.'); 
    END IF;

END;
-- TEST SAI 
INSERT INTO KHACHHANG (MaKH, HoTenKH, NgaySinhKH, GioiTinhKH, SDTKH, DiaChiKH, EmailKH, CongNoKH) VALUES ('KH05', N'Lê Mai', TO_DATE('2004-03-15', 'YYYY-MM-DD'), N'Nữ', '0912305679', N'456 Nguyễn Trãi, Quận 1', 'maile@gmail.com', 0);
-- TEST ĐÚNG
INSERT INTO KHACHHANG (MaKH, HoTenKH, NgaySinhKH, GioiTinhKH, SDTKH, DiaChiKH, EmailKH, CongNoKH) VALUES ('KH06', N'Lê Mai', TO_DATE('2004-03-15', 'YYYY-MM-DD'), N'Nữ', '0912305679', N'456 Nguyễn Trãi, Quận 1', 'maile@gmail1.com', 0);
-- 
alter trigger trg_Cau2_2 disable;   
alter trigger trg_Cau2_2 ENABLE;
--------------------------------------------------------------------------------
-- Câu 3. Trigger - Kiểm tra không vượt quá ngưỡng cho phép( Khách hàng chỉ được mua tối đa 30 cuốn sách trong một lần mua hàng ) 
CREATE OR REPLACE TRIGGER trg_Cau3
BEFORE INSERT ON DONHANG
FOR EACH ROW
DECLARE
    total_amount  int ;
    max_threshold int := 30;

BEGIN
    SELECT NVL(SUM(SoLuongDH), 0) INTO total_amount
    FROM CHITIETDONHANG
    WHERE MaDH = :new.MaDH;

    IF total_amount + :new.TongSachMua > max_threshold THEN
        raise_application_error(-20001, 'Số lượng sách đặt hàng vượt quá giới hạn cho phép.');
    else 
        DBMS_OUTPUT.PUT_LINE('Thêm đơn hàng thành công.'); 
    END IF;

END;
-- drop trigger trg_Cau3;
-- TEST SAI 
INSERT INTO DONHANG (MaDH, NgayDH, TongSachMua, TongTienDH, TrangThaiDH, TrangThaiTT, MaNV, MaKH) VALUES ('DH0010', TO_DATE('2024-02-3','YYYY-MM-DD'), 31, 100, N'Đã giao',N'Đã thanh toán','NV02', 'KH02');
-- TEST ĐÚNG 
INSERT INTO DONHANG (MaDH, NgayDH, TongSachMua, TongTienDH, TrangThaiDH, TrangThaiTT, MaNV, MaKH) VALUES ('DH0010', TO_DATE('2024-02-3','YYYY-MM-DD'), 30, 100, N'Đã giao',N'Đã thanh toán','NV02', 'KH02');
--
alter trigger trg_Cau3 disable;   
alter trigger trg_Cau3 ENABLE;
-------------------------------------------------------------------------------
-- Câu 4. Khi thêm, sửa, xóa dữ liệu bảng CTDH, TongSachMua và TongTienDH trong bảng DH giảm hoặc tăng
// drop TRIGGER trg_Cau4
CREATE OR REPLACE TRIGGER trg_Cau4
AFTER INSERT OR DELETE OR UPDATE ON CHITIETDONHANG FOR EACH ROW
DECLARE    
    soluongdhT  int;
    soluongdhX  int; 
    v_GiaT       int; 
    v_GiaX       int; 
BEGIN     
    soluongdhT := :NEW.SoLuongDH; 
    soluongdhX := :OLD.SoLuongDH; 
    
    IF INSERTING THEN
        UPDATE DONHANG 
        SET TongSachMua = TongSachMua + soluongdhT
        WHERE MaDH = :NEW.MaDH;
        
        SELECT  Gia INTO  v_GiaT
        FROM    SACH
        WHERE   MaISBN = :NEW.MaISBN;   
          -- Cập nhật tổng tiền đơn hàng (TongTienDH) trong bảng DonHang
        UPDATE DonHang
        SET TongTienDH = TongTienDH + (v_GiaT * :NEW.SoLuongDH)
        WHERE MaDH = :NEW.MaDH;  
    ELSIF DELETING THEN
        UPDATE DONHANG 
        SET TongSachMua = TongSachMua - soluongdhX
        WHERE MaDH = :OLD.MaDH;
         -- KHI XÓA DỮ LIỆU 
        SELECT  Gia INTO  v_GiaX
        FROM    SACH
        WHERE   MaISBN = :OLD.MaISBN;
          -- Cập nhật tổng tiền đơn hàng (TongTienDH) trong bảng DonHang
        UPDATE  DONHANG 
        SET     TongTienDH = TongTienDH - (v_GiaX * :OLD.SoLuongDH)
        WHERE   MaDH = :OLD.MaDH; 
    ELSIF UPDATING THEN
        UPDATE DONHANG 
        SET TongSachMua = TongSachMua - soluongdhX + soluongdhT
        WHERE MaDH = :NEW.MaDH;
         -- KHI THÊM DỮ LIỆU 
         SELECT  Gia INTO  v_GiaT
         FROM    SACH
         WHERE   MaISBN = :NEW.MaISBN;
        -- KHI XÓA DỮ LIỆU 
        SELECT  Gia INTO  v_GiaX
        FROM    SACH
        WHERE   MaISBN = :OLD.MaISBN; 
        -- 
        UPDATE  DONHANG 
        SET     TongTienDH = TongTienDH - (v_GiaX * :OLD.SoLuongDH) + (v_GiaT * :NEW.SoLuongDH)
        WHERE   MaDH = :NEW.MaDH;  
    END IF;
END;    
--  TRƯỚC KHI GỌI TRIGGER 
SELECT TongSachMua as "Tổng sách mua trước", TongTienDH as "Tổng tiền đơn hàng trước" FROM DONHANG WHERE MADH ='DH09';
-- TEST THÊM 
insert into CHITIETDONHANG values ('8935251419863','DH09',1);
insert into CHITIETDONHANG values ('8935235228351','DH09',1); 
-- TEST SỬA 
UPDATE  CHITIETDONHANG
SET     SoLuongDH = 3
WHERE   MADH='DH09'
AND     maisbn = '8935235228351';  
-- TEST XÓA  
delete from CHITIETDONHANG where MADH='DH09' and MAISBN = '8935251419863'; 
--  TRƯỚC SAU GỌI TRIGGER 
SELECT TongSachMua as "Tổng sách mua sau", TongTienDH as "Tổng tiền đơn hàng sau" FROM DONHANG WHERE MADH ='DH09';
--
alter trigger trg_Cau4 disable;   
alter trigger trg_Cau4 ENABLE;
--------------------------------------------------------------------------------
-- Câu 5. Khi thêm, sửa, xóa dữ liệu bảng CHITIETDONHANG,  DaBan và SoLuong trong bảng SACH giảm hoặc tăng
--- DROP TRIGGER TRG_CAU5;
CREATE OR REPLACE TRIGGER trg_Cau5
AFTER INSERT OR UPDATE OR DELETE ON CHITIETDONHANG
FOR EACH ROW
DECLARE     
    SoLuongDHT int;
    SoLuongDHX int; 
BEGIN
    IF INSERTING THEN
        SoLuongDHT :=  :NEW.SoLuongDH ;
        UPDATE SACH
        SET SLDaBan = SLDaBan + SoLuongDHT,
            SLTon = SLTon - SoLuongDHT
        WHERE MaISBN = :NEW.MaISBN;
    ELSIF UPDATING THEN
         SoLuongDHX :=  :OLD.SoLuongDH;
          SoLuongDHT :=  :NEW.SoLuongDH ;
        -- Xóa ảnh hưởng của dòng cũ
        UPDATE SACH
        SET SLDaBan = SLDaBan - SoLuongDHX + SoLuongDHT,
            SLTon = SLTon + SoLuongDHX - SoLuongDHT
         WHERE MaISBN = :NEW.MaISBN;
    ELSIF DELETING THEN
        SoLuongDHX :=  :OLD.SoLuongDH ;
        UPDATE SACH
        SET SLDaBan = SLDaBan - :OLD.SoLuongDH,
            SLTon = SLTon + :OLD.SoLuongDH
        WHERE MaISBN = :OLD.MaISBN;
    END IF;
END;

-- TRƯỚC KHI GỌI TRIGGER  
SELECT SLDaBan as "Số lượng đã bán trước ",  SLTon as "Số lượng tồn trước" from Sach Where MaISBN = '5649899761408'; 
-- TEST THÊM
insert into CHITIETDONHANG values ('5649899761408','DH15',10);
-- TEST SỬA
Update CHITIETDONHANG 
Set     SoLuongDH = 8 
Where   maisbn = '5649899761408'
and     madh = 'DH15'; 
-- TEST XÓA 
delete from CHITIETDONHANG Where   maisbn = '5649899761408' and     madh = 'DH15';
--  SAU KHI GỌI TRIGGER   
SELECT SLDaBan as "Số lượng đã bán sau ",  SLTon as "Số lượng tồn sau" from Sach Where MaISBN = '5649899761408'; 
-- Thầy đừng hạ câu trg_Cau5 xuống ạ 
-- Này bật trg_Cau5 thì trg_Cau6 mới đúng ạ 
-- alter trigger trg_Cau5 disable;   
-- alter trigger trg_Cau5 ENABLE;
--------------------------------------------------------------------------------
-- Câu 6.  Trigger - Kiểm tra không vượt quá ngưỡng cho phép( Số lượng tồn kho nhỏ hơn 2 thì không bán và in ra là Nhập thêm sách vào kho) 
-- drop TRIGGER trg_Cau6
CREATE OR REPLACE TRIGGER trg_Cau6
BEFORE INSERT OR UPDATE ON CHITIETDONHANG
FOR EACH ROW
DECLARE
    SLTonM INT;
    SoLuongDHT int;
    SoLuongDHX int; 
    v_SLTon int; 
BEGIN
    IF INSERTING THEN
        -- Thực hiện kiểm tra số lượng tồn khi thêm mới dòng vào bảng CHITIETDONHANG
        SELECT  SLTon INTO SLTonM
        FROM    SACH s, DONHANG d
        WHERE   s.MaISBN = :NEW.MaISBN
        AND     d.MaDH = :NEW.MaDH;
        
        IF SLTonM -:NEW.SoLuongDH  <= 2 THEN
            raise_application_error(-20001, 'Không thể bán sách. Số lượng tồn kho ít hơn ngưỡng cho phép ' );
        ELSE
            DBMS_OUTPUT.PUT_LINE('Số lượng chưa vượt ngưỡng'); 
        END IF;
    ELSIF UPDATING THEN
         SoLuongDHX :=  :OLD.SoLuongDH;
         SoLuongDHT :=  :NEW.SoLuongDH ;
        -- Thực hiện kiểm tra số lượng tồn khi cập nhật dòng trong bảng CHITIETDONHANG
        SELECT  SLTon + SoLuongDHX - SoLuongDHT  INTO v_SLTon
        FROM    SACH s, DONHANG d
        WHERE   s.MaISBN = :NEW.MaISBN
        AND     d.MaDH = :NEW.MaDH;           
        IF v_SLTon  <= 2 THEN
            raise_application_error(-20001, 'Không thể bán sách. Số lượng tồn kho ít hơn ngưỡng cho phép. Số lượng tồn nếu thêm tiếp là : ' || v_SLTon  );
        ELSE
            DBMS_OUTPUT.PUT_LINE('Số lượng chưa vượt ngưỡng'); 
        END IF;
    END IF;
END;

-- BẮT BUỘC PHẢI CHẠY TRIGGER CÂU 5 KHÔNG SẼ BỊ LỖI VỀ DỮ LIỆU 
-- TRƯỚC KHI GỌI XEM SOLUONGTONLABAONHIEU TRIGGER  
SELECT SLTon as "Số lượng tồn trước", SLDaBan as "Số lượng đã bán trước " from Sach Where MaISBN = '5649899140082'; 
-- TEST ĐÚNG 
INSERT INTO CHITIETDONHANG VALUES ('5649899140082', 'DH16', 10);
-- TEST SAI 
INSERT INTO CHITIETDONHANG VALUES ('5649899140082', 'DH16', 99);
-- TEST UPDATE ĐÚNG 
UPDATE  CHITIETDONHANG 
SET     SOLUONGDH = 11
Where   MaISBN = '5649899140082'
and     MaDH = 'DH16';
-- TEST  UPDATE SAI 
UPDATE  CHITIETDONHANG 
SET     SOLUONGDH = 98
Where   MaISBN = '5649899140082'
and     MaDH = 'DH16';
-- SAU KHI GỌI XEM SOLUONGTONLABAONHIEU TRIGGER   
SELECT SLTon as "Số lượng tồn SAU", SLDaBan as "Số lượng đã bán sau " from Sach Where MaISBN = '5649899140082'; 
-- delete from CHITIETDONHANG where maisbn = '5649899140082' 
-- update sach set SLTon = 100 where maisbn = '5649899140082'
alter trigger trg_Cau6 disable;   
alter trigger trg_Cau6 ENABLE;
--------------------------------------------------------------------------------
-- Câu 7. Cập nhật CôngNoKH 
// Drop trigger trg_Cau7																
CREATE OR REPLACE TRIGGER trg_Cau7
AFTER INSERT OR UPDATE OR DELETE ON DONHANG
FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
    trangthaitt         DONHANG.TrangThaiTT%TYPE;  
    v_CongNoKH           int; 
    v_CongNoKHc           int; 
BEGIN  
    
    
   trangthaitt := :NEW.TrangThaiTT; 
   IF INSERTING THEN 
    -- Gán công nợ 
    SELECT  CongNoKH into v_CongNoKH 
    from    KhachHang 
    where   MaKH = :New.MaKH; 
    IF v_CongNoKH >= 0 then 
      IF trangthaitt = N'Chưa thanh toán' THEN  
         UPDATE KHACHHANG 
         SET CongNoKH = CongNoKH + :NEW.TongTienDH
         WHERE MAKH = :NEW.MAKH;
      ELSIF trangthaitt = N'Đã thanh toán' THEN 
         NULL; 
      END IF;
   END IF;  
    END IF; 
  IF UPDATING THEN 
  -- Gán công nợ 
    SELECT  CongNoKH into v_CongNoKH 
    from    KhachHang 
    where   MaKH = :New.MaKH; 
   IF v_CongNoKH >= 0 then 
      IF (:OLD.TrangThaiTT = N'Đã thanh toán' AND :NEW.TrangThaiTT = N'Chưa thanh toán') THEN
         -- Cập nhật lại CongNoKH khi đổi từ 'Đã thanh toán' sang 'Chưa thanh toán'
         UPDATE KHACHHANG 
         SET    CongNoKH = CongNoKH + :NEW.TongTienDH
         WHERE  MAKH = :NEW.MAKH; 
      ELSIF (:OLD.TrangThaiTT = N'Chưa thanh toán' AND :NEW.TrangThaiTT = N'Đã thanh toán') THEN            
           -- Cập nhật công nợ mới cho khách hàng
           UPDATE   khachhang
           SET      CongNoKH = CongNoKH - :NEw.TongTienDH 
           WHERE    MAKH = :NEW.MAKH;   
    END IF; 
     END IF;
    END IF;
    
    
  IF DELETING  THEN 
    SELECT  CongNoKH into v_CongNoKHc 
    from    KhachHang 
    where   MaKH = :old.MaKH; 
     IF v_CongNoKHc  >= 0 then 
      IF :OLD.TrangThaiTT = N'Chưa thanh toán' THEN  
         UPDATE     KHACHHANG 
         SET        CongNoKH = CongNoKH - :OLD.TongTienDH
         WHERE      MAKH = :OLD.MAKH;
      ELSIF  :OLD.TrangThaiTT = N'Đã thanh toán' THEN 
         NULL; 
      END IF;
   END IF;  
       END IF; 
    -- COMMIT để lưu các thay đổi trong transaction độc lập
   COMMIT; 
END;
-- TRƯỚC KHI GỌI TRIGGER 
SELECT CONGNOKH AS "Công nợ khách hàng trước" FROM KHACHHANG WHERE MAKH = 'KH04';
-- TEST THÊM 
insert into DONHANG values ('DH11', TO_DATE('2024-02-26','YYYY-MM-DD'),1, 107000,N'Chưa giao hàng',N'Chưa thanh toán','NV02', 'KH04');
insert into DONHANG values ('DH12', TO_DATE('2024-02-26','YYYY-MM-DD'),1, 107000,N'Chưa giao hàng',N'Đã thanh toán','NV02', 'KH04');
-- Sau khi thêm công nợ sẽ là 107000
-- TEST SỬA
-- Sửa lần 1 công nợ là 214000 
UPDATE  DONHANG 
SET     TrangThaiTT = N'Chưa thanh toán'
WHERE   MADH = 'DH12';  
-- Sửa lần 2 công nợ là 107000
UPDATE  DONHANG 
SET     TrangThaiTT = N'Đã thanh toán'
WHERE   MADH = 'DH12';  
-- TEST XÓA 
-- DELETE FROM DONHANG WHERE MADH = 'DH11';  
DELETE FROM DONHANG WHERE MADH = 'DH12';  
-- SAU KHI GỌI TRIGGER  
SELECT CONGNOKH AS "Công nợ khách hàng sau" FROM KHACHHANG WHERE MAKH = 'KH04';
--  SET SERVEROUTPUT ON;
alter trigger trg_Cau7 disable;   
alter trigger trg_Cau7 ENABLE;
-- update  KHACHHANG set CongNoKH = 0 WHERE MAKH = 'KH04';
--------------------------------------------------------------------------------
-- SAU KHI GỌI TRIGGER   
-- Câu 8. Kiểm tra không vượt quá ngưỡng cho phép ( Tổng số tiền nợ của khách hàng không được vượt quá 10 triệu)  
CREATE OR REPLACE TRIGGER trg_Cau8
AFTER INSERT or UPDATE ON DONHANG 
FOR EACH ROW
Declare     
    CongNoKH1 int;
BEGIN
        SELECT  CongNoKH into CongNoKH1 
        From    Khachhang 
        where   MaKH= :New.MaKH; 
        
        if :NEW.TongTienDH + CongNoKH1  >= 10000000 THEN 
                raise_application_error(-20001,N'Số tiền công nợ khách hàng đã vượt quá 10 triệu. Không thể mua hàng tiếp được' );
        ELSE
            DBMS_OUTPUT.PUT_LINE('Số tiền công nợ khách hàng chưa vượt quá 10 triệu'); 
        END IF;  
END;  
-- Test Insert sai
insert into DONHANG values ('DH13', TO_DATE('2024-02-27','YYYY-MM-DD'),80,16000000,N'Chưa xác nhận',N'Chưa thanh toán', 'NV02', 'KH03'); 
-- Tes Update SAI
UPDATE  DONHANG
SET     TongSachMua	 = 81,    
        TongTienDH	= 16000000
WHERE   MADH= 'DH14'; 
-- Test Insert ĐÚNG 
insert into DONHANG values ('DH13', TO_DATE('2024-02-27','YYYY-MM-DD'),1,160000,N'Chưa xác nhận',N'Chưa thanh toán', 'NV02', 'KH03'); 
-- Tes Update ĐÚNG
UPDATE  DONHANG
SET     TongSachMua	 = 2   ,    
        TongTienDH	= 320000
WHERE   MADH= 'DH14'; 
--
alter trigger trg_Cau8 disable;   
alter trigger trg_Cau8 ENABLE;
--------------------------------------------------------------------------------
/*
-- THÊM DONHANG 
insert into DONHANG
values ('DH09', TO_DATE('2024-02-27','YYYY-MM-DD'),0,0,N'Chưa xác nhận',N'Chưa thanh toán', 'NV02', 'KH02'); 
-- TEST THÊM CHI TIẾT DONHANG THÌ TongSachMua VA TongTienDH TĂNG LÊN 
insert into CHITIETDONHANG values ('8935251419863','DH09',1);
insert into CHITIETDONHANG values ('8935235228351','DH09',1); 
-- TEST XÓA CHI TIẾT DONHANG THÌ TongSachMua VA TongTienDH GIAM LÊN  
delete from CHITIETDONHANG where MADH='DH09' and MAISBN = '8935251419863'; 
-- TEST SỬA 
UPDATE  CHITIETDONHANG
SET     SoLuongDH = 10
WHERE   MADH='DH09'
AND     maisbn = '8935235228351';  
-- TEST CONGNOKH UPDATE 
UPDATE  DONHANG 
SET     TrangThaiTT = N'Đã thanh toán'
WHERE   MADH = 'DH09';   

UPDATE  DONHANG 
SET     TrangThaiTT = N'Chưa thanh toán'
WHERE   MADH = 'DH09';   
-- TEST TONGNO KHAHCH HANG VUOT NGUONG 10 TRIỆU 

-- COI KẾT QUẢ 
select * from DONHANG;
select * from CHITIETDONHANG; 
select * from KHACHHANG; 
-- 
/*
delete from CHITIETDONHANG where MADH='DH10';
delete from DONHANG where MADH='DH10';
*/
--------------------------------------------------------------------------------
-- Câu 9. Khi thêm, sửa, xóa dữ liệu bảng CTPN, SoLuong trong bảng SACH giảm hoặc tăng
CREATE OR REPLACE TRIGGER trg_Cau9
AFTER INSERT OR UPDATE OR DELETE ON CHITIETPHIEUNHAP
FOR EACH ROW
BEGIN
    -- Giảm hoặc tăng số lượng sách trong bảng SACH khi có thay đổi trong bảng CHITIETPHIEUNHAP
    IF INSERTING THEN
        UPDATE  SACH
        SET     SLTon = SLTon + :NEW.SoLuongPN
        WHERE   MaISBN = :NEW.MaISBN;
    ELSIF UPDATING THEN
        UPDATE  SACH
        SET     SLTon = SLTon + :NEW.SoLuongPN - :OLD.SoLuongPN
        WHERE   MaISBN = :NEW.MaISBN;
    ELSIF DELETING THEN
        UPDATE  SACH
        SET     SLTon = SLTon - :OLD.SoLuongPN
        WHERE   MaISBN = :OLD.MaISBN;
    END IF;
END;
--- TRƯỚC KHI GỌI TRIGGER 
SELECT SLTon as "Số lượng tồn trước" from SACH WHERE MAISBN = '5649899763421';
--  TEST THÊM 
INSERT INTO CHITIETPHIEUNHAP (MaISBN, MaPN, SoLuongPN, DonGiaPN)
VALUES ('5649899763421', 'PN06', 150, 15000000);
-- TEST CẬP NHẬT
UPDATE CHITIETPHIEUNHAP SET SoLuongPN = 160 WHERE MaISBN = '5649899763421' AND MaPN = 'PN06';
-- TEST XÓA 
DELETE FROM CHITIETPHIEUNHAP WHERE MaISBN = '5649899763421' AND MaPN = 'PN06';
--- SAU KHI GỌI TRIGGER   
SELECT SLTon as "Số lượng tồn sau" from SACH WHERE MAISBN = '5649899763421';
--
alter trigger trg_Cau9 disable;   
alter trigger trg_Cau9 ENABLE;
--------------------------------------------------------------------------------
-- Câu 10. Khi thêm, sửa, xóa dữ liệu bảng CTPN, tongcongpn và tongsachpn trong bảng PN giảm hoặc tăng
CREATE OR REPLACE TRIGGER trg_Cau10 
AFTER INSERT OR DELETE OR UPDATE ON CHITIETPHIEUNHAP FOR EACH ROW
DECLARE 
    v_SoLuongPNT int;
    v_SoLuongPNX    int ; 
BEGIN
    v_SoLuongPNT := :New.SoLuongPN;
    v_SoLuongPNX  := :OLD.SoLuongPN; 
    IF INSERTING THEN
        UPDATE PHIEUNHAP
        SET     TongSachNhap = TongSachNhap +  v_SoLuongPNT,
                TongTienPN	 = TongTienPN + ( v_SoLuongPNT * :new.DonGiaPN)
        WHERE   MaPN = :NEW.MaPN;
    ELSIF DELETING THEN
        UPDATE  PHIEUNHAP
        SET     TongSachNhap = TongSachNhap - v_SoLuongPNX ,
                TongTienPN	 = TongTienPN - (v_SoLuongPNX  * :OLD.DonGiaPN)
        WHERE   MaPN = :OLD.MaPN;
    ELSIF UPDATING THEN
        UPDATE  PHIEUNHAP
        SET     TongSachNhap = TongSachNhap - v_SoLuongPNX  + v_SoLuongPNT,
                TongTienPN = TongTienPN - (v_SoLuongPNX  * :OLD.DonGiaPN) + ( v_SoLuongPNT * :new.DonGiaPN)  
        WHERE MaPN = :NEW.MaPN;
    END IF;
END; 
--  TRƯỚC KHI GỌI TRIGGER 
SELECT TongSachNhap as "Tổng sách nhập trước",  TongTienPN as "Tổng tiền phiếu nhập trước" FROM PHIEUNHAP WHERE MAPN ='PN04';
-- TEST THÊM 
insert into CHITIETPHIEUNHAP values	('8935212361750','PN04',150,80000);
insert into CHITIETPHIEUNHAP values ('9786045629437','PN04',150,125000);
-- TEST UPDATE 
UPDATE  CHITIETPHIEUNHAP
SET     SOLUONGPN = 100
WHERE MAPN = 'PN04' AND MAISBN = '8935212361750' ; 
-- TEST XÓA 
DELETE FROM CHITIETPHIEUNHAP WHERE MAPN = 'PN04' AND MAISBN = '9786045629437' ;
-- SAU KHI GỌI TRIGGER 
SELECT TongSachNhap as "Tổng sách nhập sau",  TongTienPN as "Tổng tiền phiếu nhập sau" FROM PHIEUNHAP WHERE MAPN ='PN04';
-- 
alter trigger trg_Cau10 disable;   
alter trigger trg_Cau10 ENABLE;
--------------------------------------------------------------------------------
-- Câu 11. Trigger- ghi nhật ký  
CREATE TABLE LOG  
(
    MaNK                NUMBER GENERATED BY DEFAULT AS IDENTITY, 
    TenBang             NVARCHAR2(50),
    KhoaBang            CHAR(13) ,
    ThaoTac             VARCHAR2(10),
    NoiDungThayDoi      NVARCHAR2(255),
    NguoiDung           VARCHAR2(30),
    NgaySuaDoi          DATE
    

);  
-- DROP TABLE LOG
ALTER TABLE LOG ADD 
    CONSTRAINT PK_PHIEUTHUNHATKY PRIMARY KEY 
    (
         MaNK   
    ); 
-- Câu 11.1. Ghi nhật ký bảng SACH 
CREATE OR REPLACE TRIGGER trg_Cau11_1
AFTER INSERT OR UPDATE OR DELETE
ON SACH FOR EACH ROW
DECLARE
    tenthaotac         VARCHAR2(10);
    noidungthaydoi     NVARCHAR2(255);
    khoabang           CHAR(13);
BEGIN
    -- Thêm dữ liệu 
    IF INSERTING THEN 
        khoabang := :NEW.MaISBN;
         noidungthaydoi := noidungthaydoi ||
                  N'Tựa sách: '  || :NEW.TuaSach || '. '||
                  N'Tác giả: '  || :NEW.TacGia || '. '||
                  N'Mô tả: '  || :NEW.MoTa || '. '||
                  N'Giá: ' || :NEW.Gia || '. '||
                  N'Ngôn ngữ: '  || :NEW.NgonNgu || '. '||
                  N'Số lượng tồn: ' || :NEW.SLTon || '. '||
                  N'Số lượng đã bán: '|| :NEW.SLDaBan || '. '||
                  N'Mã thể loại: ' || :NEW.MaTL || '. '||
                  N'Mã NXB: ' ||  :NEW.MaNXB || '. '||
                  N'Mã Kho: ' ||  :NEW.MaK; 

    -- Xóa dữ liệu 
    ELSIF DELETING THEN
        khoabang        :=    :OLD.MaISBN;
        noidungthaydoi := noidungthaydoi ||
                  N'Tựa sách: '  || :OLD.TuaSach ||'. '||
                  N'Tác giả: '  || :OLD.TacGia ||'. '||
                  N'Mô tả: ' || :OLD.MoTa ||'. '||
                  N'Giá: '  || :OLD.Gia ||'. '||
                  N'Ngôn ngữ: '  || :OLD.NgonNgu ||'. '||
                  N'Số lượng tồn: ' || :OLD.SLTon ||'. '||
                  N'Số lượng đã bán: '  || :OLD.SLDaBan ||'. '||
                  N'Mã thể loại: ' || :OLD.MaTL ||'. '||
                  N'Mã NXB: '  || :OLD.MaNXB ||'. '||
                  N'Mã Kho: '  || :OLD.MaK;
    -- Cập nhật dữ liệu 
    ELSIF UPDATING THEN 
        khoabang := :NEW.MaISBN;
        -- TuaSach 
        IF :OLD.TuaSach != :NEW.TuaSach THEN
           noidungthaydoi := noidungthaydoi || N'Tựa sách cũ: ' || :OLD.TuaSach || N' đã được cập nhật thành ' 
                                            || N'Tựa sách mới: ' || :NEW.TuaSach;
        END IF;
        -- TacGia 
        IF :OLD.TacGia != :NEW.TacGia THEN
            noidungthaydoi := noidungthaydoi || N'Tác giả cũ: ' || :OLD.TacGia || ' đã được cập nhật thành ' 
                                             || N'Tác giả mới: ' || :NEW.TacGia ;
        END IF;
        -- MoTa
        IF :OLD.MoTa != :NEW.MoTa THEN
            noidungthaydoi := noidungthaydoi || N'Mô tả cũ: ' || :OLD.MoTa || ' đã được cập nhật thành ' 
                                             || N'Mô tả mới: ' || :NEW.MoTa ;
        END IF;      
        -- Gia
        IF :OLD.Gia != :NEW.Gia THEN
            noidungthaydoi := noidungthaydoi || N'Giá cũ: ' || :OLD.Gia || ' đã được cập nhật thành ' 
                                             || N'Giá mới: ' || :NEW.Gia ;
        END IF;        
        -- NgonNgu
        IF :OLD.NgonNgu != :NEW.NgonNgu THEN
            noidungthaydoi := noidungthaydoi || N'Ngôn ngữ cũ: ' || :OLD.NgonNgu || ' đã được cập nhật thành ' 
                                             || N'Ngôn ngữ mới: ' || :NEW.NgonNgu ;
        END IF;       
        -- SLTon
        IF :OLD.SLTon != :NEW.SLTon THEN
            noidungthaydoi := noidungthaydoi || N'Số lượng tồn cũ: ' || :OLD.SLTon || ' đã được cập nhật thành ' 
                                             || N'Số lượng tồn mới: ' || :NEW.SLTon ;
        END IF;       
        -- SLDaBan
        IF :OLD.SLDaBan != :NEW.SLDaBan THEN
            noidungthaydoi := noidungthaydoi || N'Số lượng đã bán cũ: ' || :OLD.SLDaBan || ' đã được cập nhật thành ' 
                                             || N'Số lượng đã bán mới: ' || :NEW.SLDaBan ;
        END IF;       
        -- MaTL
        IF :OLD.MaTL != :NEW.MaTL THEN
            noidungthaydoi := noidungthaydoi || N'Mã thể loại cũ: ' || :OLD.MaTL || ' đã được cậpnhật thành ' 
                                             || N'Mã thể loại mới: ' || :NEW.MaTL ;
        END IF;      
        -- MaNXB
        IF :OLD.MaNXB != :NEW.MaNXB THEN
            noidungthaydoi := noidungthaydoi || N'Mã nhà xuất bản cũ: ' || :OLD.MaNXB || ' đã được cập nhật thành ' 
                                             || N'Mã nhà xuất bản mới: ' || :NEW.MaNXB ;
        END IF;       
        -- MaK
        IF :OLD.MaK != :NEW.MaK THEN
            noidungthaydoi := noidungthaydoi || N'Mã khách hàng cũ: ' || :OLD.MaK || ' đã được cập nhật thành ' 
                                             || N'Mã khách hàng mới: ' || :NEW.MaK  ;
        END IF;
    END IF;
    
    -- ThaoTac 
    tenthaotac := CASE 
                    WHEN INSERTING THEN 'INSERT'
                    WHEN UPDATING THEN 'UPDATE'
                    WHEN DELETING THEN 'DELETE'
                 END; 
     
    INSERT INTO LOG(TenBang, KhoaBang, ThaoTac, NoiDungThayDoi, NguoiDung, NgaySuaDoi)
    VALUES('SACH', khoabang, tenthaotac, noidungthaydoi, USER, SYSDATE);
END;
-- drop trigger trg_LOG_SACH
--  TRƯỚC KHI GỌI TRIGGER  
SELECT * FROM LOG;
-- TEST THÊM 
insert into SACH values ('8935212361751',N'Ngôi Sao May Mắn Sâu Bắp Cải',N'Nguyễn Thị Việt Nga',N'Phiêu lưu',
		100000,N'Tiếng Việt',100,10,'TL01','XB01','K01'); 
-- TEST SỬA 
UPDATE  SACH 
SET     TUASACH = N'Ngôi Sao May Mắn Sâu Bắp Cải 1'
WHERE   MAISBN ='8935212361751'; 
-- TEST XÓA 
Delete from SACH WHERE MAISBN ='8935212361751';  
--  SAU KHI GỌI TRIGGER  
SELECT * FROM LOG;
--
alter trigger trg_Cau11_1 disable;   
alter trigger trg_Cau11_1 ENABLE;
-- Câu 11.2. Ghi nhật ký bảng DONHANG 
CREATE OR REPLACE TRIGGER trg_trg_Cau11_2
AFTER INSERT OR UPDATE OR DELETE
ON DONHANG FOR EACH ROW
DECLARE
    tenthaotac         VARCHAR2(10);
    noidungthaydoi     NVARCHAR2(255);
    khoabang           VARCHAR2(10);
BEGIN
    -- Thêm dữ liệu 
    IF INSERTING THEN 
        khoabang := :NEW.MaDH;
        noidungthaydoi := noidungthaydoi ||
                  N'Ngày đặt hàng: '  || TO_CHAR(:NEW.NgayDH, 'DD/MM/YYYY') || '. '||
                  N'Tổng số sách mua: '  || :NEW.TongSachMua || '. '||
                  N'Tổng tiền đặt hàng: '  || :NEW.TongTienDH || '. '||
                  N'Trạng thái đơn hàng: ' || :NEW.TrangThaiDH || '. '||
                  N'Trạng thái thanh toán: '  || :NEW.TrangThaiTT || '. '||
                  N'Mã nhân viên: ' || :NEW.MaNV || '. '||
                  N'Mã khách hàng: ' ||  :NEW.MaKH; 

    -- Xóa dữ liệu 
    ELSIF DELETING THEN
        khoabang        :=    :OLD.MaDH;
        noidungthaydoi := noidungthaydoi ||
                  N'Ngày đặt hàng: '  || TO_CHAR(:OLD.NgayDH, 'DD/MM/YYYY') || '. '||
                  N'Tổng số sách mua: '  || :OLD.TongSachMua || '. '||
                  N'Tổng tiền đặt hàng: '  || :OLD.TongTienDH || '. '||
                  N'Trạng thái đơn hàng: ' || :OLD.TrangThaiDH || '. '||
                  N'Trạng thái thanh toán: '  || :OLD.TrangThaiTT || '. '||
                  N'Mã nhân viên: ' || :OLD.MaNV || '. '||
                  N'Mã khách hàng: ' ||  :OLD.MaKH;
    -- Cập nhật dữ liệu 
    ELSIF UPDATING THEN 
        khoabang := :NEW.MaDH;
        -- NgayDH
        IF :OLD.NgayDH != :NEW.NgayDH THEN
           noidungthaydoi := noidungthaydoi || N'Ngày đặt hàng cũ: ' || TO_CHAR(:OLD.NgayDH, 'DD/MM/YYYY') 
                                            || N' đã được cập nhật thành ' 
                                            || N'Ngày đặt hàng mới: ' || TO_CHAR(:NEW.NgayDH, 'DD/MM/YYYY');
        END IF;
        -- TongSachMua
        IF :OLD.TongSachMua != :NEW.TongSachMua THEN
            noidungthaydoi := noidungthaydoi || N'Tổng số sách mua cũ: ' || :OLD.TongSachMua 
                                             || N' đã được cập nhật thành ' 
                                             || N'Tổng số sách mua mới: ' || :NEW.TongSachMua ;
        END IF;
        -- TongTienDH
        IF :OLD.TongTienDH != :NEW.TongTienDH THEN
            noidungthaydoi := noidungthaydoi || N'Tổng tiền đặt hàng cũ: ' || :OLD.TongTienDH 
                                             || N' đã được cập nhật thành ' 
                                             || N'Tổng tiền đặt hàng mới: ' || :NEW.TongTienDH ;
        END IF;      
        -- TrangThaiDH
        IF :OLD.TrangThaiDH != :NEW.TrangThaiDH THEN
            noidungthaydoi := noidungthaydoi || N'Trạng thái đơn hàng cũ: ' || :OLD.TrangThaiDH 
                                             || N' đã được cập nhật thành ' 
                                             || N'Trạng thái đơn hàng mới: ' || :NEW.TrangThaiDH ;
        END IF;        
        -- TrangThaiTT
        IF :OLD.TrangThaiTT != :NEW.TrangThaiTT THEN
            noidungthaydoi := noidungthaydoi || N'Trạng thái thanh toán cũ: ' || :OLD.TrangThaiDH 
                                             || N' đã được cập nhật thành ' 
                                             || N'Trạng thái thanh toán mới: ' || :NEW.TrangThaiDH ;
        END IF;   
        IF :OLD.MaNV!= :NEW.MaNV THEN
            noidungthaydoi := noidungthaydoi || N'Mã nhân viên cũ: ' || :OLD.MaNV
                                             || N' đã được cập nhật thành ' 
                                             || N'Mã nhân viên mới: ' || :NEW.MaNV ;
        END IF; 
        IF :OLD.MaKH != :NEW.MaKH THEN
            noidungthaydoi := noidungthaydoi || N'Mã khách hàng cũ: ' || :OLD.MaKH 
                                             || N' đã được cập nhật thành ' 
                                             || N'Mã khách hàng mới: ' || :NEW.MaKH ;
        END IF;
      END IF; 
         -- ThaoTac 
        tenthaotac := CASE 
                        WHEN INSERTING THEN 'INSERT'
                        WHEN UPDATING THEN 'UPDATE'
                        WHEN DELETING THEN 'DELETE'
                     END; 
         
        INSERT INTO LOG(TenBang, KhoaBang, ThaoTac, NoiDungThayDoi, NguoiDung, NgaySuaDoi)
        VALUES('DONHANG', khoabang, tenthaotac, noidungthaydoi, USER, SYSDATE); 
END;
--  TRƯỚC KHI GỌI TRIGGER 
SELECT * FROM LOG;
-- TEST THÊM 
insert into DONHANG values ('DH20', TO_DATE('2023-07-30','YYYY-MM-DD'),0, 0,
                            N'Đã giao',N'Đã thanh toán','NV02', 'KH01');
-- TEST SỬA 
UPDATE  DONHANG
SET     MANV ='NV03'
WHERE   MADH ='DH20'; 
-- TEST XÓA 
Delete from DONHANG WHERE   MADH ='DH20'; 
--  SAU KHI GỌI TRIGGER  
SELECT * FROM LOG;
--
alter trigger trg_Cau11_2 disable;   
alter trigger trg_Cau11_2 ENABLE;
-- Câu 11.3. Ghi nhật ký bảng  PHIEUNHAP 
CREATE OR REPLACE TRIGGER trg_trg_Cau11_3
AFTER INSERT OR UPDATE OR DELETE
ON PHIEUNHAP FOR EACH ROW
DECLARE
    tenthaotac         VARCHAR2(10);
    noidungthaydoi     NVARCHAR2(255);
    khoabang           VARCHAR2(10);
BEGIN
    -- Thêm dữ liệu 
    IF INSERTING THEN 
        khoabang := :NEW.MaPN;
        noidungthaydoi := noidungthaydoi ||
                  N'Ngày nhập: '  || TO_CHAR(:NEW.NgayNhap, 'DD/MM/YYYY') || '. '||
                  N'Tổng tiền phiếu nhập: '  || :NEW.TongTienPN || '. '||
                  N'Tổng số sách nhập: '  || :NEW.TongSachNhap || '. '||
                  N'Trạng thái phiếu nhập: ' || :NEW.TrangThaiPN || '. '||
                  N'Trạng thái thanh toán phiếu nhập: '  || :NEW.TrangThaiTT_PN || '. '||
                  N'Mã nhân viên: ' || :NEW.MaNV || '. '||
                  N'Mã nhà cung cấp: ' ||  :NEW.MaNCC; 

    -- Xóa dữ liệu 
    ELSIF DELETING THEN
        khoabang        :=    :OLD.MaPN;
        noidungthaydoi := noidungthaydoi ||
                  N'Ngày nhập: '  || TO_CHAR(:OLD.NgayNhap, 'DD/MM/YYYY') || '. '||
                  N'Tổng tiền phiếu nhập: '  || :OLD.TongTienPN || '. '||
                  N'Tổng số sách nhập: '  || :OLD.TongSachNhap || '. '||
                  N'Trạng thái phiếu nhập: ' || :OLD.TrangThaiPN || '. '||
                  N'Trạng thái thanh toán phiếu nhập: '  || :OLD.TrangThaiTT_PN || '. '||
                  N'Mã nhân viên: ' || :OLD.MaNV || '. '||
                  N'Mã nhà cung cấp: ' ||  :OLD.MaNCC;
    -- Cập nhật dữ liệu 
    ELSIF UPDATING THEN 
        khoabang := :NEW.MaPN;
        -- NgayNhap
        IF :OLD.NgayNhap != :NEW.NgayNhap THEN
           noidungthaydoi := noidungthaydoi || N'Ngày nhập cũ: ' || TO_CHAR(:OLD.NgayNhap, 'DD/MM/YYYY') 
                                            || N' đã được cập nhật thành ' 
                                            || N'Ngày nhập mới: ' || TO_CHAR(:NEW.NgayNhap, 'DD/MM/YYYY');
        END IF;
        -- TongTienPN
        IF :OLD.TongTienPN != :NEW.TongTienPN THEN
            noidungthaydoi := noidungthaydoi || N'Tổng tiền phiếu nhập cũ: ' || :OLD.TongTienPN 
                                             || N' đã được cập nhật thành ' 
                                             || N'Tổng tiền phiếu nhập mới: ' || :NEW.TongTienPN ;
        END IF;
        -- TongSachNhap
        IF :OLD.TongSachNhap != :NEW.TongSachNhap THEN
            noidungthaydoi := noidungthaydoi || N'Tổng số sách nhập cũ: ' || :OLD.TongSachNhap 
                                             || N' đã được cập nhật thành ' 
                                             || N'Tổng số sách nhập mới: ' || :NEW.TongSachNhap ;
        END IF;      
        -- TrangThaiPN
        IF :OLD.TrangThaiPN != :NEW.TrangThaiPN THEN
            noidungthaydoi := noidungthaydoi || N'Trạng thái phiếu nhập cũ: ' || :OLD.TrangThaiPN 
                                             || N' đã được cập nhật thành ' 
                                             || N'Trạng thái phiếu nhập mới: ' || :NEW.TrangThaiPN ;
        END IF;        
        -- TrangThaiTT_PN
        IF :OLD.TrangThaiTT_PN != :NEW.TrangThaiTT_PN THEN
            noidungthaydoi := noidungthaydoi || N'Trạng thái thanh toán phiếu nhập cũ: ' || :OLD.TrangThaiTT_PN || N' đã được cập nhật thành ' 
                                             || N'Trạng thái thanh toán phiếu nhập mới: ' || :NEW.TrangThaiTT_PN ;
        END IF;        
        -- MaNV
        IF :OLD.MaNV != :NEW.MaNV THEN
            noidungthaydoi := noidungthaydoi || N'Mã nhân viên cũ: ' || :OLD.MaNV 
                                             || N' đã được cập nhật thành ' 
                                             || N'Mã nhân viên mới: ' || :NEW.MaNV ;
        END IF;        
        -- MaNCC
        IF :OLD.MaNCC != :NEW.MaNCC THEN
            noidungthaydoi := noidungthaydoi || N'Mã nhà cung cấp cũ: ' || :OLD.MaNCC 
                                             || N' đã được cập nhật thành ' 
                                             || N'Mã nhà cung cấp mới: ' || :NEW.MaNCC ;
        END IF;        
    END IF;
     -- ThaoTac 
        tenthaotac := CASE 
                        WHEN INSERTING THEN 'INSERT'
                        WHEN UPDATING THEN 'UPDATE'
                        WHEN DELETING THEN 'DELETE'
                     END; 
    -- Ghi log  
    INSERT INTO LOG(TenBang, KhoaBang, ThaoTac, NoiDungThayDoi, NguoiDung, NgaySuaDoi)
    VALUES('PHIEUNHAP', khoabang, tenthaotac, noidungthaydoi, USER, SYSDATE);  
END;
--  TRƯỚC KHI GỌI TRIGGER 
SELECT * FROM LOG;
-- TEST THÊM 
insert into PHIEUNHAP values ('PN20',TO_DATE('2023-07-26','YYYY-MM-DD'),0,0 
                                ,N'Đã giao', N'Đã thanh toán','NV07','NCC03'); 
-- TEST SỬA 
UPDATE  PHIEUNHAP
SET     MANV ='NV06'
WHERE   MAPN ='PN20'; 
-- TEST XÓA 
Delete from PHIEUNHAP WHERE   MAPN ='PN20';  
--  SAU KHI GỌI TRIGGER  
SELECT * FROM LOG;
--
alter trigger trg_Cau11_3 disable;   
alter trigger trg_Cau11_3 ENABLE;
--------------------------------------------------------------------------------
-- Câu 12. Trigger- Không cho Update 
-- Câu 12.1.  Bảng DONHANG 
CREATE OR REPLACE TRIGGER trg_Cau12_1
BEFORE UPDATE ON DONHANG FOR EACH ROW
DECLARE
    current_hour NUMBER;
BEGIN
    SELECT TO_NUMBER(to_char(systimestamp, 'HH24')) INTO current_hour FROM dual;
    IF current_hour <= 9 OR current_hour > 17 THEN
        raise_application_error(-20001, N'Không Thể Update bảng đơn hàng ngoài giờ hành chính ');
    END IF;
END; 
-- Test đúng nếu không nằm trong giờ hành chính 
-- Test sai nếu nằm trong giờ hành chính 
UPDATE  DONHANG 
SET     TrangThaiDH = N'Chưa giao hàng'
WHERE   MADH='DH09';
--
alter trigger trg_Cau12_1 disable;   
alter trigger trg_Cau12_1 ENABLE;
-- Câu 12.2. Bảng PHIEUNHAP 
CREATE OR REPLACE TRIGGER trg_Cau12_2
BEFORE UPDATE ON PHIEUNHAP  FOR EACH ROW
DECLARE
    current_hour NUMBER;
BEGIN
    SELECT TO_NUMBER(to_char(systimestamp, 'HH24')) INTO current_hour FROM dual;
    IF current_hour <= 9 OR current_hour > 17 THEN
        raise_application_error(-20001, N'Không Thể Update bảng phiếu nhập ngoài giờ hành chính ');
    END IF;
END;  
-- Test đúng nếu không nằm trong giờ hành chính 
-- Test sai nếu nằm trong giờ hành chính 
UPDATE  PHIEUNHAP 
SET     TrangThaiPN = N'Chưa giao hàng'
WHERE   MaPN ='PN03'; 
--
alter trigger trg_Cau11_2 disable;   
alter trigger trg_Cau11_2 ENABLE;
-- Câu 12.3. Bảng PHIEU CHI
CREATE OR REPLACE TRIGGER trg_Cau12_3
BEFORE UPDATE ON PHIEUCHI  FOR EACH ROW
DECLARE
    current_hour NUMBER;
BEGIN
    SELECT TO_NUMBER(to_char(systimestamp, 'HH24')) INTO current_hour FROM dual;
    IF current_hour <= 9 OR current_hour > 17 THEN
        raise_application_error(-20001, N'Không Thể Update bảng phiếu chi ngoài giờ hành chính ');
    END IF;
END;  
-- Test đúng nếu không nằm trong giờ hành chính 
-- Test sai nếu nằm trong giờ hành chính 
UPDATE  PHIEUCHI 
SET     HinhThucChi = N'Chuyển khoản'
WHERE   MAPC = 'PC03'; 
--
alter trigger trg_Cau12_3 disable;   
alter trigger trg_Cau12_3 ENABLE;
-- Câu 12.4. Bảng PHIEUTHU 
CREATE OR REPLACE TRIGGER trg_Cau12_4
BEFORE UPDATE ON PHIEUTHU FOR EACH ROW
DECLARE
    current_hour NUMBER;
BEGIN
    SELECT TO_NUMBER(TO_CHAR(SYSTIMESTAMP, 'HH24')) INTO current_hour FROM dual;
    IF current_hour <= 9 OR current_hour > 17 THEN
        raise_application_error(-20001, 'Không Thể Update bảng phiếu thu ngoài giờ hành chính');
    END IF;
END;
-- Test đúng nếu không nằm trong giờ hành chính 
-- Test sai nếu nằm trong giờ hành chính  
UPDATE  PHIEUTHU
SET     HinhThucThu = N'Chuyển khoản'
WHERE   MAPT = 'PT03'; 
--
alter trigger trg_Cau12_4 disable;   
alter trigger trg_Cau12_4 ENABLE;
-- Câu 12.5. Bảng PHIEUGIAOHANG 
CREATE OR REPLACE TRIGGER trg_Cau12_5
BEFORE UPDATE ON PHIEUGIAOHANG FOR EACH ROW
DECLARE
    current_hour NUMBER;
BEGIN
    SELECT TO_NUMBER(TO_CHAR(SYSTIMESTAMP, 'HH24')) INTO current_hour FROM dual;
    IF current_hour <= 9 OR current_hour > 17 THEN
        raise_application_error(-20001, 'Không Thể Update bảng phiếu giao hàng ngoài giờ hành chính');
    END IF;
END; 
-- Test đúng nếu không nằm trong giờ hành chính 
-- Test sai nếu nằm trong giờ hành chính 
UPDATE  PHIEUGIAOHANG 
SET     TienShip = 0
WHERE   MAVANDON = 'VD06'; 
-- 
alter trigger trg_Cau12_5 disable;   
alter trigger trg_Cau12_5 ENABLE;
