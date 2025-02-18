-- PHIEUNHAP
insert into PHIEUNHAP values ('PN01',TO_DATE('2023-07-25','YYYY-MM-DD'),30750000,300,N'Đã giao', N'Đã thanh toán','NV05','NCC01');
insert into PHIEUNHAP values ('PN02',TO_DATE('2023-07-25','YYYY-MM-DD'),44700000,300,N'Đã giao', N'Đã thanh toán','NV06','NCC02');
insert into PHIEUNHAP values ('PN03',TO_DATE('2023-07-26','YYYY-MM-DD'),26250000,300,N'Đã giao', N'Đã thanh toán','NV07','NCC03');

-- Thêm check trg_Cau9
insert into PHIEUNHAP values ('PN06',TO_DATE('2023-07-25','YYYY-MM-DD'),0,0,N'Đã giao', N'Đã thanh toán','NV05','NCC01');
-- Thêm check trg_Cau10
insert into PHIEUNHAP values ('PN04',TO_DATE('2023-07-26','YYYY-MM-DD'),0,0,N'Đã giao', N'Đã thanh toán','NV07','NCC03'); 

select * from PHIEUNHAP ORDER BY MAPN;
-- CHITIETPHIEUNHAP 
insert into CHITIETPHIEUNHAP values	('8935212361750','PN01',150,80000);
insert into CHITIETPHIEUNHAP values ('9786045629437','PN01',150,125000);
insert into CHITIETPHIEUNHAP values ('9786049994968','PN02',150,180000);
insert into CHITIETPHIEUNHAP values ('8935236421287','PN02',150,118000);
insert into CHITIETPHIEUNHAP values ('8935251419863','PN03',150,100000);
insert into CHITIETPHIEUNHAP values ('8935235228351','PN03',150,75000);
select * from CHITIETPHIEUNHAP ORDER BY MAPN;
-- PHIEUCHI 
insert into PHIEUCHI values ('PC01',N'Chuyển khoản',30750000,TO_DATE('2023-07-25','YYYY-MM-DD'),'PN01'); 
insert into PHIEUCHI values ('PC02',N'Chuyển khoản',44700000,TO_DATE('2023-07-25','YYYY-MM-DD'),'PN02');
insert into PHIEUCHI values ('PC03',N'Tiền mặt',26250000,TO_DATE('2023-07-30','YYYY-MM-DD'),'PN03');
select * from PHIEUCHI ORDER BY MAPC; 
-- DONHANG 
insert into DONHANG values ('DH01', TO_DATE('2023-07-30','YYYY-MM-DD'),10, 1250000,N'Đã giao',N'Đã thanh toán','NV02', 'KH01');
insert into DONHANG values ('DH02', TO_DATE('2023-07-30','YYYY-MM-DD'),10, 840000,N'Đã giao',N'Đã thanh toán', 'NV02', 'KH02');
insert into DONHANG values ('DH03', TO_DATE('2023-07-31','YYYY-MM-DD'),10, 920000,N'Đã giao',N'Đã thanh toán', 'NV02', 'KH03');

insert into DONHANG values ('DH04', TO_DATE('2023-07-31','YYYY-MM-DD'),10, 1250000, N'Đã giao',N'Đã thanh toán', 'NV03', 'KH01');
insert into DONHANG values ('DH05', TO_DATE('2023-08-02','YYYY-MM-DD'),10, 840000,N'Đã giao',N'Đã thanh toán',  'NV03', 'KH02');
insert into DONHANG values ('DH06', TO_DATE('2023-08-14','YYYY-MM-DD'),10, 920000, N'Đã giao',N'Đã thanh toán', 'NV04', 'KH03'); 

insert into DONHANG values ('DH07', TO_DATE('2024-02-26','YYYY-MM-DD'),1, 107000,N'Chưa giao hàng',N'Chưa thanh toán','NV02', 'KH01');
insert into DONHANG values ('DH08', TO_DATE('2024-02-26','YYYY-MM-DD'),1, 77000,N'Chưa xác nhận',N'Chưa thanh toán', 'NV02', 'KH02'); 

--Thêm check trg_Cau4
insert into DONHANG values ('DH09', TO_DATE('2024-02-27','YYYY-MM-DD'),0,0,N'Chưa xác nhận',N'Chưa thanh toán', 'NV02', 'KH02'); 
select * from  DONHANG ORDER BY MADH; 
-- Thêm check trg_Cau8 
insert into DONHANG values ('DH14', TO_DATE('2024-02-27','YYYY-MM-DD'),1, 107000,N'Chưa xác nhận',N'Chưa thanh toán', 'NV02', 'KH03'); 
-- Thêm check trg_Cau5 
insert into DONHANG values ('DH15', TO_DATE('2024-02-27','YYYY-MM-DD'),1, 107000,N'Chưa xác nhận',N'Chưa thanh toán', 'NV02', 'KH03'); 
-- Thêm check trg_Cau4 
-- INSERT INTO DONHANG (MaDH, NgayDH, TongSachMua, TongTienDH, TrangThaiDH, TrangThaiTT, MaNV, MaKH)
-- VALUES ('DH009', TO_DATE('2024-02-3','YYYY-MM-DD'), 0, 0, N'Đã giao',N'Đã thanh toán','NV02', 'KH01');
-- Thêm check trg_Cau6
insert into DONHANG values ('DH16', TO_DATE('2024-02-27','YYYY-MM-DD'),1, 107000,N'Chưa xác nhận',N'Chưa thanh toán', 'NV02', 'KH03'); 
-- CHITIETDH 
insert into CHITIETDONHANG values ('8935212361750','DH01',5);
insert into CHITIETDONHANG values ('9786045629437','DH01',5);
insert into CHITIETDONHANG values ('9786049994968','DH02',5);
insert into CHITIETDONHANG values ('8935236421287','DH02',5);
insert into CHITIETDONHANG values ('8935251419863','DH03',5);
insert into CHITIETDONHANG values ('8935235228351','DH03',5);

insert into CHITIETDONHANG values ('8935212361750','DH04',5);
insert into CHITIETDONHANG values ('9786045629437','DH04',5);
insert into CHITIETDONHANG values ('9786049994968','DH05',5);
insert into CHITIETDONHANG values ('8935236421287','DH05',5);
insert into CHITIETDONHANG values ('8935251419863','DH06',5);
insert into CHITIETDONHANG values ('8935235228351','DH06',5); 

insert into CHITIETDONHANG values ('8935251419863','DH07',1);
insert into CHITIETDONHANG values ('8935235228351','DH08',1); 


select * from  CHITIETDONHANG ORDER BY MADH; 
-- PHIEUTHU 
insert into PHIEUTHU values ('PT01',N'Chuyển khoản',1250000,TO_DATE('2023-07-30','YYYY-MM-DD'),'DH01');
insert into PHIEUTHU values ('PT02',N'Tiền mặt',840000,TO_DATE('2023-08-02','YYYY-MM-DD'),'DH02');
insert into PHIEUTHU values ('PT03',N'Chuyển khoản',920000,TO_DATE('2023-07-31','YYYY-MM-DD'),'DH03');
insert into PHIEUTHU values ('PT04',N'Tiền mặt',1250000,TO_DATE('2023-08-02','YYYY-MM-DD'),'DH04');
insert into PHIEUTHU values ('PT05',N'Tiền mặt',840000,TO_DATE('2023-08-08','YYYY-MM-DD'),'DH05');
insert into PHIEUTHU values ('PT06',N'Chuyển khoản',920000,TO_DATE('2023-08-14','YYYY-MM-DD'),'DH06');

select * from  PHIEUTHU ORDER BY MAPT; 
-- PHIEUGIAOHANG 
insert into PHIEUGIAOHANG values ('VD01', 'Viettel Post', TO_DATE('2023-08-01','YYYY-MM-DD'), 15000, 'DH01');
insert into PHIEUGIAOHANG values ('VD02', 'SPX', TO_DATE('2023-08-02','YYYY-MM-DD'), 15000, 'DH02');
insert into PHIEUGIAOHANG values ('VD03', 'Viettel Post',  TO_DATE('2023-08-03','YYYY-MM-DD'), 0, 'DH03'); 

insert into PHIEUGIAOHANG values ('VD04', 'SPX',  TO_DATE('2023-08-02','YYYY-MM-DD'), 0,  'DH04');
insert into PHIEUGIAOHANG values ('VD05', 'Viettel Post',  TO_DATE('2023-08-08','YYYY-MM-DD'), 15000, 'DH05'); 
insert into PHIEUGIAOHANG values ('VD06', 'SPX',  TO_DATE('2023-08-18','YYYY-MM-DD'), 15000,  'DH06');

select * from  PHIEUGIAOHANG ORDER BY MaVanDon; 

 SET SERVEROUTPUT ON;
 