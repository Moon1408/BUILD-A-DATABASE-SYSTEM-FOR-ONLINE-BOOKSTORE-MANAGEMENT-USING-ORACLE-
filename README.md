# BUILD-A-DATABASE-SYSTEM-FOR-ONLINE-BOOKSTORE-MANAGEMENT-USING-ORACLE-
**1. Giới thiệu về dự án:**
- Hệ thống quản lý nhà sách là một giải pháp công nghệ được thiết kế để hỗ trợ và tối ưu hóa các nghiệp vụ doanh nghiệp trong lĩnh vực bán lẻ sách. Các chức năng chính bao gồm quản lý hàng tồn kho, quản lý sách, quản lý đơn hàng, theo dõi doanh thu, và quản lý thông tin khách hàng... Phát triển Hệ thống quản lý nhà sách giúp đảm bảo dữ liệu thống nhất, dễ dàng truy cập và hoạt động hiệu quả.

**2. Mục tiêu:**
**3. Công cụ:** Oracle Database, StarUML  

**4. Các bước thực hiện:**

B1: Thiết kế quy trình hoạt động nghiệp vụ 

B2: Thiết kế sơ đồ cơ cấu tổ chức của doanh nghiệp

B3: Phân tích hệ thống 

   B3.1: Phân tích chức năng 
    B3.1.1: Thiết kế mô hình phân cấp chức năng của hệ thống (sơ đồ BFD)
    B3.1.2: Mô tả chi tiết từng chức năng và các quy định nghiệp vụ/các ràng buộc toàn vẹn dữ liệu có liên quan
  B3.2: Phân tích dữ liệu 
   B3.2.1: Mô hình thực thể kết hợp (ERD)
   B3.2.2: Thiết kế các sơ đồ luồng dữ liệu (DFD)
B4: Thiết kế và cài đặt hệ thống 
 B4.1: Mô hình dữ liệu quan hệ (Relational Data model) 
 B4.2: Mô tả các bảng và các thuộc tính
 B4.3: Cài đặt CSDL bằng Oracle 
  B4.3.1: Tạo bảng, khóa chính, khóa ngoại 
  B4.3.2: Thêm dữ liệu demo 
  B4.3.3: Thiết kế và cài đặt các Stored Procedure/Function 
    B4.3.3.1: Dùng để thực hiện các lệnh CRUD cơ bản cho các Table 
    B4.3.3.2: Đáp ứng các chức năng nghiệp vụ 
B4.3.3.3: Kết xuất dữ liệu báo cáo 
B4.3.4: Thiết kế và cài đặt các Trigger
Kiểm tra các ràng buộc toàn vẹn dữ liệu  
Kiểm tra trùng giá trị 
Trigger bảo vệ dữ liệu  
B4.4: Thiết kế và cài đặt các giao tác (Transaction)
.
**5. Kết quả:**
Quy trình hoạt động nghiệp vụ: Được thiết kế rõ ràng, giúp xác định cách thức hoạt động của doanh nghiệp.
Sơ đồ cơ cấu tổ chức: Cung cấp cái nhìn tổng quan về cấu trúc tổ chức của doanh nghiệp.
Phân tích hệ thống:
Chức năng hệ thống: Các chức năng được mô tả chi tiết và ràng buộc dữ liệu được xác định.
Dữ liệu: Mô hình thực thể kết hợp (ERD) và sơ đồ luồng dữ liệu (DFD) thể hiện mối quan hệ giữa các thực thể và quy trình dữ liệu.
Thiết kế và cài đặt hệ thống:
Mô hình dữ liệu quan hệ: Được xây dựng để đảm bảo dữ liệu có cấu trúc rõ ràng.
Các bảng và thuộc tính: Được mô tả để dễ dàng quản lý và truy vấn.
Cài đặt cơ sở dữ liệu: Sử dụng Oracle để tạo bảng, khóa chính, khóa ngoại và thêm dữ liệu mẫu.
Stored Procedure/Function: Được thiết kế để thực hiện các thao tác CRUD và hỗ trợ các chức năng nghiệp vụ.
Trigger: Được cài đặt để kiểm tra ràng buộc toàn vẹn dữ liệu và bảo vệ dữ liệu.
Giao tác (Transaction): Đảm bảo rằng các thao tác trên cơ sở dữ liệu được thực hiện một cách an toàn và nhất quán.
