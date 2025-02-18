CREATE OR REPLACE PROCEDURE sp_ThemChiTietDonHang
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
    
   
    -- Cập nhật DONHANG 
    SELECT  SUM(p_SoLuongDH * Gia) INTO  v_TongTienDH   
    FROM    CHITIETDONHANG C, SACH S, DONHANG D , KHACHHANG K  
    WHERE   C.MaISBN = S.MaISBN 
    AND     C.MaDH = p_MaDH 
    AND     D.MADH = C.MADH
    AND     D.MAKH = K.MAKH ;
    COMMIT; 
    SET TRANSACTION NAME 'T1';
    BEGIN 
        -- Cập nhật SACH 
        UPDATE  SACH 
        SET     SLTon =  v_TonKho - p_SoLuongDH, SLDaBan = SLDaBan +  p_SoLuongDH 
        WHERE   MaISBN = p_MaISBN;       
      
         -- Cập nhật DONHANG 
        UPDATE  DONHANG 
        SET     TongSachMua = ( SELECT SUM(p_SoLuongDH) 
                                FROM   CHITIETDONHANG c 
                                WHERE  MaDH = p_MaDH),
                TongTienDH = v_TongTienDH   
        WHERE   MADH = p_MaDH;  
        END;
    COMMIT;    
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
    -- COMMIT;
END;

-- THÊM ĐƠN HÀNG  
EXECUTE pc_Cau2_LapDonHang('DH0014', TO_DATE('2024-02-03', 'YYYY-MM-DD'), 0, 0, N'Chưa xác nhận', N'Chưa thanh toán', 'NV01', 'KH07');
-- TRƯỚC KHI CHẠY PROC 
SELECT SLDaBan as "Số lượng đã bán trước",  SLTon as "Số lượng tồn sau" from Sach Where MaISBN = '5649899714008'; 
SELECT SLDaBan as "Số lượng đã bán trước ",  SLTon as "Số lượng tồn sau" from Sach Where MaISBN = '5649899140082'; 
SELECT TongSachMua as "Tổng sách mua trước", TongTienDH as " Tổng tiền đơn hàng trước" FROM DONHANG WHERE MADH ='DH0014';
SELECT CongNoKH as "Công nợ khách hàng trước" from KHACHHANG WHERE  MAKH = 'KH07';  
-- TEST THÊM CHI TIẾT ĐƠN HÀNG 
BEGIN 
        sp_ThemChiTietDonHang('5649899714008','DH0014',8);
END; 
BEGIN 
      sp_ThemChiTietDonHang ('5649899140082','DH0014',8);
END;  
--  SAU KHI CHẠY PROC 
SELECT SLDaBan as "Số lượng đã bán sau ",  SLTon as "Số lượng tồn sau" from Sach Where MaISBN = '5649899714008'; 
SELECT SLDaBan as "Số lượng đã bán sau ",  SLTon as "Số lượng tồn sau" from Sach Where MaISBN = '5649899140082'; 
SELECT TongSachMua as "Tổng sách mua sau", TongTienDH as " Tổng tiền đơn hàng sau" FROM DONHANG WHERE MADH ='DH0014';
SELECT CongNoKH as "Công nợ khách hàng sau" from KHACHHANG WHERE  MAKH = 'KH07'; 