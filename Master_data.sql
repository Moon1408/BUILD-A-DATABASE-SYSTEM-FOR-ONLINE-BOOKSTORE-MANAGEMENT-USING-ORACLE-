-- Thêm dữ liệu 
INSERT INTO THELOAI VALUES  ('TL01', N'Thiếu nhi');
INSERT INTO THELOAI VALUES  ('TL02', N'Ngoại văn');
INSERT INTO THELOAI VALUES  ('TL03', N'Tác phẩm kinh điển');
Select * From THELOAI ORDER BY MATL; 
--  NHAXUATBAN 
INSERT INTO NHAXUATBAN  VALUES  ('XB01',N'Thanh Niên ');
INSERT INTO NHAXUATBAN  VALUES  ('XB02',N'Phụ Nữ ');
INSERT INTO NHAXUATBAN  VALUES  ('XB03',N'Văn Học ');
INSERT INTO NHAXUATBAN  VALUES  ('XB04',N'Thời Đại');
SELECT * FROM NHAXUATBAN ORDER BY MANXB;
--  KHO 
INSERT INTO KHO VALUES  ('K01',N'Kho Sư Vạn Hạnh');
INSERT INTO KHO VALUES  ('K02',N'Kho Hóc Môn');
INSERT INTO KHO VALUES  ('K03',N'Kho Trường Sơn');
Select * from KHO ORDER BY MAK;
--  SACH 
-- Thể loại 01 
insert into SACH values ('8935212361750',N'Ngôi Sao May Mắn Sâu Bắp Cải',N'Nguyễn Thị Việt Nga',N'Phiêu lưu cùng chú bọ ngựa dũng cảm , đi tìm kiếm ông ốc sên già bị mất tích',
		100000,N'Tiếng Việt',100,10,'TL01','XB01','K01');  
insert into SACH values ('9786045629437',N'Ông Biết Tuốt Đầu Bò Và Tự Kỷ',N'Vũ Lan Anh',N'Với cuốn sách này, chúng ta không khỏi day dứt bởi vấn đề lớn chưa được giải quyết',
        150000,N'Tiếng Việt',100,10,'TL01','XB01','K01'); 
-- Thể loại 02 
INSERT INTO SACH VALUES ('9786049994968',N'Chưa Kịp Lớn Đã Phải Trưởng Thành',N'Nguyễn Kim Ngọc',N'Cuốn sách The Journey of Youth là những lá thư được viết bằng 2 thứ tiếng Anh - Việt, nhắn nhủ tới bạn trên đoạn đường gập ghềnh nhất của tuổi trẻ', 
        200000,N'Anh-Việt',100,10,'TL02','XB02','K02');
insert into SACH values ('8935236421287',N'Tiếng Trung Thương Mại',N'Trần Mai Loan',N'Cuốn sách gồm 60 bài, với những mẫu câu giao tiếp kèm theo hướng dẫn chi tiết',
        148000,N'Trung-Việt',100,10,'TL02','XB03','K02');
-- Thể loại 03 
insert into SACH values('8935251419863',N'Phương Pháp Đọc Sách Hiệu Quả',N'Vũ Hoàng Linh',null,
        107000,N'Tiếng Việt',100,10,'TL03','XB04','K03'); 
insert into SACH values('8935235228351',N'Cây Cam Ngọt Của Tôi',N'Trần Hồng Thắng',N'Mở đầu bằng những thanh âm trong sáng và kết thúc lắng lại trong những nốt trầm hoài niệm, Cây cam ngọt của tôi khiến ta nhận ra vẻ đẹp thực sự của cuộc sống đến từ những 
`       điều giản dị như bông hoa trắng của cái cây sau nhà, và rằng cuộc đời thật khốn khổ nếu thiếu đi lòng yêu thương và niềm trắc ẩn ', 
        77000,N'Tiếng Việt',100,10,'TL03','XB01','K03'); 
        
-- Thêm check trg_Cau7 
insert into SACH values ('5649899763421',N'Người Tính Không Bằng Drama Tính',N'Pương Pương',N'Văn học',
		100000,N'Tiếng Việt',0,0,'TL01','XB01','K01'); 
-- Thêm check trg_Cau5 
insert into SACH values ('5649899761408',N'Trưởng Thành Là Khi Nỗi Buồn Cũng Có Deadline',N'Pương Pương',N'Văn học',
		100000,N'Tiếng Việt',100,0,'TL01','XB01','K01');
-- Thêm check trg_Cau6
insert into SACH values ('5649899140082',N'Drama Nuôi Tôi Lớn Loài Người Dạy Tôi Khôn',N'Pương Pương',N'Văn học',
		100000,N'Tiếng Việt',100,0,'TL01','XB01','K01');
Select * from SACH ORDER BY MAISBN;
-- Thêm check trg_Cau1
insert into SACH values ('5649899714008',N'Tối Không Chạy Deadline Sáng Không Ngại Đi Làm',N'Pương Pương',N'Văn học',
		100000,N'Tiếng Việt',100,0,'TL01','XB01','K01');
-- Thêm check prc_Cau4_CTPN
insert into SACH values ('8935614082003',N'  Không Kịp Deadline Thì Bay Tiền Thưởng',N'Pương Pương',N'Văn học',
		100000,N'Tiếng Việt',100,0,'TL01','XB01','K01');      
        
      
-- PHONGBAN 
insert into PHONGBAN values ('PB01',N'Phòng nhập hàng');
insert into PHONGBAN values ('PB02',n'Phòng kinh doanh');
insert into PHONGBAN values ('PB03',N'Phòng quản lý kho'); 
Select * from PHONGBAN ORDER BY MAPB;
-- NHANVIEN 
-- PB01
insert into NHANVIEN values ('NV01',N'Huỳnh Triệu Quyễn Lam',TO_DATE('2003-4-25','YYYY-MM-DD'),N'Nữ','0893420069','PB01');
-- PB02
insert into NHANVIEN values	('NV02',N'Võ Thị Kiều Oanh',TO_DATE('2003-4-2','YYYY-MM-DD'),N'Nữ','0893650069','PB02');
insert into NHANVIEN values	('NV03',N'Trần Truyết Nhi',TO_DATE('2003-3-2','YYYY-MM-DD'),N'Nữ','0913288161','PB02');
insert into NHANVIEN values ('NV04',N'Nguyễn Gia Hào',TO_DATE('2003-08-20','YYYY-MM-DD'),N'Nam','0912345680','PB02');
-- PB03
insert into NHANVIEN values	('NV05',N'Trần Nguyễn Minh Phương',TO_DATE('2003-5-2','YYYY-MM-DD'),N'Nữ','0913288164','PB03'); 
insert into NHANVIEN values ('NV06',N'Nguyễn Tuấn Phát',TO_DATE('2003-06-10','YYYY-MM-DD'),N'Nam','0912345678','PB03');
insert into NHANVIEN values ('NV07',N'Cao Thế Anh',TO_DATE('2003-07-15','YYYY-MM-DD'),N'Nam','0912345679','PB03'); 

Select * from NHANVIEN ORDER BY MANV;
-- NHACUNGCAP
insert into NHACUNGCAP values   ('NCC01',N'AZ Việt Nam','azvn@gmail.com','0862934696',N'585/2A Sư Vạn Hạnh, phường 13, quận 10, Thành phố Hồ Chí Minh'); 
insert into NHACUNGCAP values	('NCC02',N'Nhã Nam ','nhanam@gmail.com','0903244248',N'59 - Đỗ Quang - Trung Hòa - Cầu Giấy - Hà Nội');
insert into NHACUNGCAP values	('NCC03',N'Skybooks','skybooks@gmail.com','0803244248',N'Số 83 Lý Nam Đế, Phường Cửa Đông, Quận Hoàn Kiếm, Hà Nội');
select * from NHACUNGCAP ORDER BY MANCC; 
-- KHACHHANG 
insert into KHACHHANG values ('KH01',N'Nguyễn Thị Thu Hằng',TO_DATE('2003-01-17','YYYY-MM-DD'),N'Nữ','0917277196',N'828 Sư Vạn Hạnh, Phường 13 Quận 10','hang123@gmail.ocm',107000);
insert into KHACHHANG values ('KH02',N'An Đoàn Kim Khuê',TO_DATE('2003-01-01','YYYY-MM-DD'),N'Nữ','0913477196',N'162 Nguyễn Văn Lượng, Gò Vấp','khue123@gmail.com',77000);
insert into KHACHHANG values ('KH03',N'Nguyễn Hoàng Duyên',TO_DATE('2003-11-17','YYYY-MM-DD'),N'Nữ','0917677196',N'20 Hà Huy Giáp, Quận 12','duyen@gmail.com',0);
insert into KHACHHANG values ('KH04',N'Lê Thị Mai',TO_DATE('2004-03-15','YYYY-MM-DD'),N'Nữ','0912345679',N'456 Nguyễn Huệ, Quận 11','maile@gmail.com',0);

-- Thêm check proc_Cau3 
insert into KHACHHANG values ('KH07',N'Huỳnh Thị Lan',TO_DATE('2004-09-10','YYYY-MM-DD'),N'Nữ','0912345682',N'987 Văn Tần, Quận 3','lanhuynh@gmail.com',0);
/*
insert into KHACHHANG values ('KH05',N'Nguyễn Thị Anh',TO_DATE('2000-07-20','YYYY-MM-DD'),N'Nữ','0912345680',N'789 Lê Lợi, Quận 1','anhnguyen@gmail.com',0);
insert into KHACHHANG values ('KH06',N'Phạm Văn Bình',TO_DATE('1977-12-05','YYYY-MM-DD'),N'Nam','0912345681',N'321 Trần Hưng Đạo, Quận 5','binhpham@gmail.com',0);
insert into KHACHHANG values ('KH08',N'Huỳnh Anh Tuấn',TO_DATE('1980-05-28','YYYY-MM-DD'),N'Nam','0912345683',N'654 Phạm Ngũ Lão, Quận 1','tuan@gmail.com',0); 
*/
select * from KHACHHANG ORDER BY MAKH;

 SET SERVEROUTPUT ON; 