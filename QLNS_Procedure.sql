-- Câu 1_1. Tạo bảng thể loại
CREATE OR REPLACE PROCEDURE pc_Cau1_1_TaoTL
(
    p_MaTL IN VARCHAR2,
    p_TenTL IN NVARCHAR2
)
AS
BEGIN
    INSERT INTO THELOAI (MaTL, TenTL)
    VALUES (p_MaTL, p_TenTL);
    DBMS_OUTPUT.PUT_LINE('Thêm dữ liệu thành công.');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Thêm dữ liệu thất bại. Lỗi: ' || SQLERRM);
END;
-- TEST 
EXEC pc_Cau1_1_TaoTL('TL07', N'Tâm');
SELECT * FROM THELOAI;
-- Câu 1_2. Sửa bảng thể loại
CREATE OR REPLACE PROCEDURE pc_Cau1_2_SuaTL
(
    p_MaTL IN VARCHAR2,
    p_TenTL IN NVARCHAR2
)
AS
    v_UpdatedCount NUMBER;
BEGIN
    v_UpdatedCount := 0;

    UPDATE THELOAI
    SET TenTL = p_TenTL
    WHERE MaTL = p_MaTL
    RETURNING 1 INTO v_UpdatedCount;

    IF v_UpdatedCount = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Sửa dữ liệu thất bại. Không tìm thấy bản ghi cần cập nhật.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Sửa dữ liệu thành công.');
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Sửa dữ liệu thất bại. Lỗi: ' || SQLERRM);
END;
-- TEST 
EXEC pc_Cau1_2_SuaTL('TL03', N'Trinh Thám');
SELECT * FROM THELOAI;
-- Câu 1_3. Xóa bảng thể loại
CREATE OR REPLACE PROCEDURE pc_Cau1_3_XoaTL(p_MaTL IN VARCHAR2)
IS
  v_SACH_COUNT NUMBER;
  v_Success BOOLEAN := FALSE;
BEGIN
  -- Kiểm tra xem có bản ghi con trong bảng SACH phụ thuộc vào thể loại này hay không
  SELECT COUNT(*) INTO v_SACH_COUNT FROM SACH WHERE MaTL = p_MaTL;

  IF v_SACH_COUNT > 0 THEN
    -- Nếu có bản ghi con, hiển thị thông báo lỗi và thoát khỏi procedure
    DBMS_OUTPUT.PUT_LINE('Không thể xóa thể loại. Có sách phụ thuộc vào thể loại này.');
    RETURN;
  END IF;

  -- Xóa thể loại trong bảng THELOAI
  DELETE FROM THELOAI WHERE MaTL = p_MaTL;

  v_Success := TRUE;
  COMMIT;

  IF v_Success THEN
    DBMS_OUTPUT.PUT_LINE('Xóa thành công.');
  END IF;
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Xóa dữ liệu thất bại. Lỗi: ' || SQLERRM);
END;
-- TEST 
EXEC pc_Cau1_3_XoaTL('TL07');
SELECT * FROM TheLoai;
-- Câu 1_4. Xem bảng thể loại
CREATE OR REPLACE PROCEDURE pc_Cau1_4_XemThongTinTL(p_MaTL IN VARCHAR2)
IS
  v_TL_COUNT NUMBER;
  v_ThongTinTL THELOAI%ROWTYPE; -- Biến để lưu trữ thông tin thể loại
BEGIN
  -- Kiểm tra xem thể loại có tồn tại hay không
  SELECT COUNT(*) INTO v_TL_COUNT FROM THELOAI WHERE MaTL = p_MaTL;
  
  IF v_TL_COUNT > 0 THEN
    -- Nếu thể loại tồn tại, lấy thông tin thể loại
    FOR v_ThongTinTL IN (SELECT * FROM THELOAI WHERE MaTL = p_MaTL)
    LOOP
      -- In thông tin thể loại
      DBMS_OUTPUT.PUT_LINE('Mã thể loại: ' || v_ThongTinTL.MaTL);
      DBMS_OUTPUT.PUT_LINE('Tên thể loại: ' || v_ThongTinTL.TenTL);
    END LOOP;
  ELSE
    -- Nếu thể loại không tồn tại, in thông báo
    DBMS_OUTPUT.PUT_LINE('Thể loại không tồn tại');
  END IF;
  COMMIT;
END;
-- TEST 
EXEC pc_Cau1_4_XemThongTinTL('TL02');
--------------------------------------------------------------------------------
-- Câu 2. Tạo đơn hàng 
CREATE OR REPLACE PROCEDURE pc_Cau2_LapDonHang(
    p_MaDH IN VARCHAR2,
    p_NgayDH IN DATE,
    p_TongSachMua IN INT,
    p_TongTienDH IN INT,
    p_TrangThaiDH IN NVARCHAR2,
    p_TrangThaiTT IN NVARCHAR2,
    p_MaNV IN VARCHAR2,
    p_MaKH IN VARCHAR2
)
IS
    v_KhachHangTonTai INT;
BEGIN
    -- Kiểm tra xem khách hàng có tồn tại hay không
    SELECT COUNT(*) INTO v_KhachHangTonTai
    FROM KhachHang
    WHERE MaKH = p_MaKH;
    IF v_KhachHangTonTai = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Đây là khách hàng mới. Vui lòng thêm thông tin khách hàng trước khi lập đơn hàng.');
        RETURN;
    END IF;
    -- Kiểm tra ngày đặt hàng phải nhỏ hơn hoặc bằng ngày hiện tại
    IF p_NgayDH >= SYSDATE THEN
        DBMS_OUTPUT.PUT_LINE('Ngày đặt hàng phải nhỏ hơn hoặc bằng ngày hiện tại.');
        RETURN;
    END IF;  
    -- Thêm dữ liệu vào bảng DONHANG
    INSERT INTO DONHANG (MaDH, NgayDH, TongSachMua, TongTienDH, TrangThaiDH, TrangThaiTT, MaNV, MaKH)
    VALUES (p_MaDH, p_NgayDH, p_TongSachMua, p_TongTienDH, p_TrangThaiDH, p_TrangThaiTT, p_MaNV, p_MaKH);   
    DBMS_OUTPUT.PUT_LINE('Đơn hàng đã được lập thành công.');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Đã xảy ra lỗi khi lập đơn hàng: ' || SQLERRM);
END;
-- drop procedure LapDonHang2;
-- TEST SAI 
-- Test lập đơn hàng với khách hàng mới 
EXECUTE pc_Cau2_LapDonHang('DH0013', TO_DATE('2024-02-03', 'YYYY-MM-DD'), 5, 100, N'Chưa xác nhận', N'Chưa thanh toán', 'NV01', 'KH07');

-- TEạy câu pc_Cau3_ThemKhachHang ở dưới để thêm KH mới 
-- Thêm khách hàng mới
BEGST ĐÚNG 
-- ChIN
   pc_Cau3_ThemKhachHang('KH08', N'Nguyễn Văn B', TO_DATE('1990-01-01', 'YYYY-MM-DD'), N'Nam', '012345719', N'Hà Nội', 'nguyenvaa@exmple.com', 0);
END;
EXECUTE pc_Cau2_LapDonHang('DH016', TO_DATE('2024-02-03', 'YYYY-MM-DD'), 0, 0, N'Chưa xác nhận', N'Chưa thanh toán', 'NV01', 'KH08');

select * from DONHANG;
select * from KHACHHANG;

-- TEST SAI 
-- Lập đơn hàng khi ngày đặt hàng lớn hơn ngày hiện tại
EXECUTE pc_Cau2_LapDonHang('DH0019', TO_DATE('2025-05-03', 'YYYY-MM-DD'), 5, 100, N'Chưa xác nhận', N'Chưa thanh toán', 'NV01', 'KH08');
-- TEST ĐÚNG 
EXECUTE pc_Cau2_LapDonHang('DH0019', TO_DATE('2024-03-08', 'YYYY-MM-DD'), 5, 100, N'Chưa xác nhận', N'Chưa thanh toán', 'NV01', 'KH08');
--------------------------------------------------------------------------------
-- Câu 3. tạo chi tiết đơn hàng 
CREATE OR REPLACE PROCEDURE sp_Cau3_ThemChiTietDonHang 
(
    p_MaISBN            IN CHAR,
    p_MaDH              IN VARCHAR,
    p_SoLuongDH         IN INT
) AS
    v_TonKho            INT; 
    v_CongNoKH          INT;   
    v_TongTienDH        INT;
    v_TongSachMua30     INT; 
    v_trangthaitt       NVARCHAR2(50);
BEGIN
     -- Kiểm tra công nợ
    SELECT  CongNoKH INTO   v_CongNoKH 
    FROM    KHACHHANG K, DONHANG D 
    WHERE   K.MaKH = D.MaKH 
    AND     D.MADH = p_MaDH; 
    
    IF    v_CongNoKH  >= 10000000 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Công nợ khách hàng vượt quá ngưỡng cho phép');
    END IF; 
    
    -- Kiểm tra tồn kho
    SELECT  SLTon INTO v_TonKho 
    FROM    SACH
    WHERE   MaISBN = p_MaISBN;
    
    IF  v_TonKho - p_SoLuongDH <= 2 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Số lượng tồn kho không đủ.');
    END IF;
    
    -- Kiểm tra không mua quá 30 
    SELECT  TongSachMua into v_TongSachMua30   
    from    DonHang 
    where   MaDH = p_MaDH ; 
    
    IF  v_TongSachMua30   >= 30 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Một đơn hàng chỉ đặt tối đa được 30 cuốn');
    END IF;
    
    -- Thêm dữ liệu vào bảng CHITIETDONHANG
    INSERT INTO CHITIETDONHANG (MaISBN, MaDH, SoLuongDH) 
    VALUES (p_MaISBN, p_MaDH, p_SoLuongDH);
    
    -- Cập nhật SACH 
    UPDATE  SACH 
    SET     SLTon =  v_TonKho - p_SoLuongDH, SLDaBan = SLDaBan +  p_SoLuongDH 
    WHERE   MaISBN = p_MaISBN;
    
    -- Cập nhật DONHANG 
    SELECT  SUM(p_SoLuongDH * Gia) INTO  v_TongTienDH   
    FROM    CHITIETDONHANG C, SACH S, DONHANG D , KHACHHANG K  
    WHERE   C.MaISBN = S.MaISBN 
    AND     C.MaDH = p_MaDH 
    AND     D.MADH = C.MADH
    AND     D.MAKH = K.MAKH ;
    

    UPDATE  DONHANG 
    SET     TongSachMua = ( SELECT SUM(p_SoLuongDH) 
                            FROM   CHITIETDONHANG c 
                            WHERE  MaDH = p_MaDH),
            TongTienDH = v_TongTienDH   
    WHERE   MADH = p_MaDH;  
    
    -- Cập nhật công nợ khách hàng 
    SELECT  TrangThaiTT into v_trangthaitt 
    FROM    DONHANG 
    WHERE   MADH =  p_MaDH ; 
    
    IF v_trangthaitt  = N'Chưa thanh toán' THEN  
         UPDATE     KHACHHANG 
         SET        CongNoKH = v_TongTienDH ;
        
      ELSIF v_trangthaitt  = N'Đã thanh toán' THEN 
         NULL;   
    END IF; 
    COMMIT;
END;
-- THÊM ĐƠN HÀNG  
EXECUTE pc_Cau2_LapDonHang('DH0013', TO_DATE('2024-02-03', 'YYYY-MM-DD'), 0, 0, N'Chưa xác nhận', N'Chưa thanh toán', 'NV01', 'KH07');
-- TRƯỚC KHI CHẠY PROC 
SELECT SLDaBan as "Số lượng đã bán trước",  SLTon as "Số lượng tồn sau" from Sach Where MaISBN = '5649899714008'; 
SELECT SLDaBan as "Số lượng đã bán trước ",  SLTon as "Số lượng tồn sau" from Sach Where MaISBN = '5649899140082'; 
SELECT TongSachMua as "Tổng sách mua trước", TongTienDH as " Tổng tiền đơn hàng trước" FROM DONHANG WHERE MADH ='DH0013';
SELECT CongNoKH as "Công nợ khách hàng trước" from KHACHHANG WHERE  MAKH = 'KH07'; 
-- TEST THÊM CHI TIẾT ĐƠN HÀNG 
BEGIN 
        sp_Cau3_ThemChiTietDonHang('5649899714008','DH0013',8);
END; 
BEGIN 
      sp_Cau3_ThemChiTietDonHang ('5649899140082','DH0013',8);
END;  
--  SAU KHI CHẠY PROC 
SELECT SLDaBan as "Số lượng đã bán sau ",  SLTon as "Số lượng tồn sau" from Sach Where MaISBN = '5649899714008'; 
SELECT SLDaBan as "Số lượng đã bán sau ",  SLTon as "Số lượng tồn sau" from Sach Where MaISBN = '5649899140082'; 
SELECT TongSachMua as "Tổng sách mua sau", TongTienDH as " Tổng tiền đơn hàng sau" FROM DONHANG WHERE MADH ='DH0013';
SELECT CongNoKH as "Công nợ khách hàng sau" from KHACHHANG WHERE  MAKH = 'KH07';  
--------------------------------------------------------------------------------
-- Câu 4. Lập phiếu nhập 
-- proc Lập phiếu nhập
CREATE OR REPLACE PROCEDURE pc_Cau4_LapPhieuNhap (
    p_MaPN IN VARCHAR2,
    p_NgayNhap IN DATE,
    p_TongTienPN IN INT,
    p_TongSachNhap IN INT,
    p_TrangThaiPN IN NVARCHAR2,
    p_TrangThaiTT_PN IN NVARCHAR2,
    p_MaNV IN VARCHAR2,
    p_MaNCC IN VARCHAR2
)
AS
BEGIN
    -- Kiểm tra ngày lập phải nhỏ hơn hoặc bằng ngày hiện tại
    IF p_NgayNhap >= SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20001, 'Ngày lập phải nhỏ hơn hoặc bằng ngày hiện tại.');
    END IF;
    -- Kiểm tra tổng sách nhập không nhỏ hơn 50
    -- IF p_TongSachNhap < 50 THEN
    --     RAISE_APPLICATION_ERROR(-20002, 'Tổng sách nhập không được nhỏ hơn 50.');
    -- END IF;
    -- Thêm phiếu nhập vào bảng PHIEUNHAP
    INSERT INTO PHIEUNHAP (MaPN, NgayNhap, TongTienPN, TongSachNhap, TrangThaiPN, TrangThaiTT_PN, MaNV, MaNCC)
    VALUES (p_MaPN, p_NgayNhap, p_TongTienPN, p_TongSachNhap, p_TrangThaiPN , p_TrangThaiTT_PN, p_MaNV, p_MaNCC);    
    -- Nếu không có lỗi, in ra thông báo thành công
    DBMS_OUTPUT.PUT_LINE('Phiếu nhập đã được lập thành công.');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- In ra thông báo lỗi nếu có ngoại lệ xảy ra
        DBMS_OUTPUT.PUT_LINE('Lỗi: ' || SQLERRM);
        ROLLBACK;
END;
-- TEST SAI 
-- Lập phiếu nhập khi ngày lập > ngày hiện tại
BEGIN
    pc_Cau4_LapPhieuNhap ('PN007', TO_DATE('2024-07-25', 'YYYY-MM-DD'), 30750000, 300, N'Đã giao', N'Chưa thanh toán', 'NV05', 'NCC01');
END;
-- TEST ĐÚNG 
-- Lập phiếu nhập thành công
BEGIN
    pc_Cau4_LapPhieuNhap('PN007', TO_DATE('2024-02-25', 'YYYY-MM-DD'), 30750000, 300, N'Đã giao', N'Đã thanh toán','NV05', 'NCC01');
END;
-- 
select * from PHIEUNHAP;
-- Câu 5. Thêm chi tiết PN 
CREATE OR REPLACE PROCEDURE pc_Cau5_ThemChiTietPhieuNhap  
(
    p_MaISBN        CHAR,
     p_MaPN        VARCHAR,
    p_SoLuongPN     INT,
    p_DonGiaPN      INT
) AS 
    v_TongTienPN     INT;
    v_TongSachNhap  INT;
BEGIN
    -- Thêm dữ liệu vào bảng PHIEUNHAP
    INSERT INTO CHITIETPHIEUNHAP (MaISBN,  MaPN, SoLuongPN, DonGiaPN) 
    VALUES (p_MaISBN,  p_MaPN, p_SoLuongPN, p_DonGiaPN); 
    -- Cập nhật SACH 
    UPDATE  SACH 
    SET     SLTon =  SLTon + p_SoLuongPN
    WHERE   MaISBN = p_MaISBN;
    -- Cập nhật TongcongPN và TongSachPN tăng lên 
   -- SELECT  p_SoLuongPN * p_DonGiaPN INTO v_TongTienPN 
  --  FROM    CHITIETPHIEUNHAP C
   -- WHERE   C.MaPN = p_MaPN;   
   -- Lấy tổng tiền từ truy vấn SELECT
    v_TongTienPN := p_SoLuongPN * p_DonGiaPN;

    SELECT SUM(p_SoLuongPN)
    INTO v_TongSachNhap
    FROM CHITIETPHIEUNHAP c, PHIEUNHAP P
    WHERE c.MaPN = p_MaPN
    and   c.MaPN = P.MaPN; 

    UPDATE PHIEUNHAP
    SET TongTienPN = TongTienPN +   v_TongTienPN,
        TongSachNhap = v_TongSachNhap
    WHERE MaPN = p_MaPN;  
    COMMIT;
END ; 

-- THÊM PHIEUNHAP 
BEGIN
    pc_Cau4_LapPhieuNhap('PN008', TO_DATE('2024-03-12', 'YYYY-MM-DD'), 0,0, N'Đã giao', N'Chưa thanh toán', 'NV05', 'NCC01');
END;
-- TRƯỚC KHI CHẠY PROC 
SELECT SLTon as "Số lượng tồn trước" from SACH WHERE MAISBN = '8935614082003';
SELECT SLTon as "Số lượng tồn trước" from SACH WHERE MAISBN = '8935235228351';
SELECT TongTienPN as "Tổng tiền phiếu nhập trước" , TongSachNhap as "Tổng sách nhập trước " FROM PHIEUNHAP WHERE MAPN = 'PN008'; 
-- TEST THÊM CHI TIẾT PHIẾU NHẬP 
BEGIN 
         pc_Cau5_ThemChiTietPhieuNhap('8935614082003','PN008',150,80000);  
END ;
BEGIN 
         pc_Cau5_ThemChiTietPhieuNhap('8935235228351','PN008',150,75000);
END ;
-- SAU KHI CHẠY PROC 
SELECT SLTon as "Số lượng tồn sau" from SACH WHERE MAISBN = '8935614082003';
SELECT SLTon as "Số lượng tồn sau" from SACH WHERE MAISBN = '8935235228351';
SELECT TongTienPN as "Tổng tiền phiếu nhập sau" , TongSachNhap as "Tổng sách nhập sau"  FROM PHIEUNHAP WHERE MAPN = 'PN008'; 
--------------------------------------------------------------------------------
-- Tạo bảng THONGKE cho câu 5 và 6 
CREATE TABLE THONGKE  
(
    MaTK                NUMBER GENERATED BY DEFAULT AS IDENTITY, 
    TongTienBanHang     INT,
    TongTienMuaHang     INT,
    LoiNhuan            INT,
    Tu                  DATE,
    Den                 DATE,
    MoTa                NVARCHAR2(50),
    NgayHienTai         DATE
); 
ALTER TABLE THONGKE ADD
    CONSTRAINT PK_THONGKE PRIMARY KEY
    (
        MaTK
    );
-- Câu 5. Tính doanh thu theo tháng 
CREATE OR REPLACE PROCEDURE pc_Cau5_DTThang(
  p_from_date DATE,
  p_to_date DATE
) AS
  v_total_sales INT;
  v_total_purchases INT;
  v_profit INT;
BEGIN
  -- Tính tổng tiền đã bán
  SELECT SUM(TongTienDH)
  INTO v_total_sales
  FROM DONHANG
  WHERE NgayDH BETWEEN p_from_date AND p_to_date
  AND TrangThaiDH = 'Đã giao'
  AND TrangThaiTT = 'Đã thanh toán';

  -- Tính tổng tiền phiếu nhập
  SELECT SUM(TongTienPN)
  INTO v_total_purchases
  FROM PHIEUNHAP
  WHERE NgayNhap BETWEEN p_from_date AND p_to_date
  AND TrangThaiPN = 'Đã giao'
  AND TrangThaiTT_PN = 'Đã thanh toán';

  -- Tính lợi nhuận
  v_profit := v_total_sales - v_total_purchases;

  -- Insert dữ liệu vào bảng THONGKE
  INSERT INTO THONGKE (TongTienBanHang, TongTienMuaHang, LoiNhuan, Tu, Den, MoTa, NgayHienTai)
  VALUES (v_total_sales, v_total_purchases, v_profit, p_from_date, p_to_date, 'Báo cáo từ ' || TO_CHAR(p_from_date, 'DD/MM/YYYY') || ' đến ' || TO_CHAR(p_to_date, 'DD/MM/YYYY'), SYSDATE);

  COMMIT;
END;
-- Test
BEGIN
  pc_Cau5_DTThang(DATE '2023-07-01', DATE '2023-07-31');
END;
select * from THONGKE;
--------------------------------------------------------------------------------
-- Câu 6. Tính doanh thu theo năm 
CREATE OR REPLACE PROCEDURE pc_Cau6_DTNam(p_year IN NUMBER) AS
    v_total_sales INT;
    v_total_purchases INT;
    v_start_date DATE;
    v_end_date DATE;
BEGIN
    -- Tính tổng tiền đã bán trong năm từ bảng DonHang
    SELECT SUM(TongTienDH)
    INTO v_total_sales
    FROM DONHANG
    WHERE EXTRACT(YEAR FROM NgayDH) = p_year
    AND TrangThaiDH = 'Đã giao'
    AND TrangThaiTT = 'Đã thanh toán';

    -- Tính tổng tiền phiếu nhập trong năm từ bảng PHIEUNHAP
    SELECT SUM(TongTienPN)
    INTO v_total_purchases
    FROM PHIEUNHAP
    WHERE EXTRACT(YEAR FROM NgayNhap) = p_year
    AND TrangThaiPN = 'Đã giao'
    AND TrangThaiTT_PN = 'Đã thanh toán';

    -- Lấy ngày đầu tiên và cuối cùng của năm trong bảng DONHANG
    SELECT MIN(NgayDH), MAX(NgayDH)
    INTO v_start_date, v_end_date
    FROM DONHANG
    WHERE EXTRACT(YEAR FROM NgayDH) = p_year;

    -- Cập nhật tổng tiền đã bán và tổng tiền mua hàng trong bảng THONGKE
    UPDATE THONGKE
    SET TongTienBanHang = v_total_sales,
        TongTienMuaHang = v_total_purchases,
        LoiNhuan = v_total_sales - v_total_purchases,
        Tu = TO_DATE(p_year || '-01-01', 'YYYY-MM-DD'),
        Den = TO_DATE(p_year || '-12-31', 'YYYY-MM-DD')
    WHERE EXTRACT(YEAR FROM Tu) = p_year
    AND EXTRACT(YEAR FROM Den) = p_year;

    -- Thêm dòng dữ liệu mới vào bảng THONGKE
    INSERT INTO THONGKE (TongTienBanHang, TongTienMuaHang, LoiNhuan, Tu, Den, MoTa, NgayHienTai)
    VALUES (v_total_sales, v_total_purchases, v_total_sales - v_total_purchases, TO_DATE(p_year || '-01-01', 'YYYY-MM-DD'), TO_DATE(p_year || '-12-31', 'YYYY-MM-DD'), 'Báo cáo năm ' || p_year, SYSDATE);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Xử lý ngoại lệ nếu có
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END;
-- TEST 
BEGIN
     pc_Cau6_DTNam(2023);
END;
select * from THONGKE;
--------------------------------------------------------------------------------
-- Câu 7. Tính tổng tiền mua hàng khách hàng và tìm ra khách hàng mua nhiều nhất ( dùng con trỏ cập nhật) 
-- Thêm cột tổng tiền mua hàng của KH vào bảng KHACHHANG
ALTER TABLE KHACHHANG ADD TongTienMuaHang Int;
--
CREATE OR REPLACE PROCEDURE pc_Cau7_TinhTongTienMuaHang
IS
    v_MaKH      KHACHHANG.MaKH%TYPE;
    TongTien    KHACHHANG.TongTienMuaHang%TYPE;
    MaxTongTien KHACHHANG.TongTienMuaHang%TYPE := 0;
    MaxMaKH     KHACHHANG.MaKH%TYPE;
    CURSOR c_donhang IS
        SELECT  MaKH
        FROM    DONHANG
        WHERE   TrangThaiDH = N'Đã giao' AND TrangThaiTT = N'Đã thanh toán';
BEGIN
    FOR rec IN c_donhang
    LOOP
        v_MaKH := rec.MaKH;
        -- Tính tổng tiền mua hàng cho khách hàng
        SELECT  SUM(TongTienDH)
        INTO    TongTien
        FROM    DONHANG
        WHERE   MaKH = v_MaKH
            AND TrangThaiDH = N'Đã giao' AND TrangThaiTT = N'Đã thanh toán';
        -- Cập nhật tổng tiền mua hàng vào bảng KHACHHANG
        UPDATE  KHACHHANG
        SET     TongTienMuaHang = TongTien
        WHERE   MaKH = v_MaKH;
        -- Kiểm tra và cập nhật khách hàng có tổng tiền mua hàng lớn nhất
        IF TongTien > MaxTongTien THEN
            MaxTongTien := TongTien;
            MaxMaKH := v_MaKH;
        END IF;
    END LOOP;
    -- In ra thông tin khách hàng có tổng tiền mua hàng lớn nhất
    DBMS_OUTPUT.PUT_LINE('Khách hàng có tổng tiền mua hàng lớn nhất:');
    DBMS_OUTPUT.PUT_LINE('Mã khách hàng: ' || MaxMaKH);
    DBMS_OUTPUT.PUT_LINE('Tổng tiền mua hàng: ' || MaxTongTien);
    COMMIT;
END;
-- TEST 
BEGIN
    pc_Cau7_TinhTongTienMuaHang;
END; 
-- 
Select * from KHACHHANG;
Select * from DONHANG;




