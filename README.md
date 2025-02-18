# BUILD-A-DATABASE-SYSTEM-FOR-ONLINE-BOOKSTORE-MANAGEMENT-USING-ORACLE-
**1. Giới thiệu về dự án:**
- Hệ thống quản lý nhà sách là một giải pháp công nghệ được thiết kế để hỗ trợ và tối ưu hóa các nghiệp vụ doanh nghiệp trong lĩnh vực bán lẻ sách. Các chức năng chính bao gồm quản lý hàng tồn kho, quản lý sách, quản lý đơn hàng, theo dõi doanh thu, và quản lý thông tin khách hàng... Phát triển Hệ thống quản lý nhà sách giúp đảm bảo dữ liệu thống nhất, dễ dàng truy cập và hoạt động hiệu quả.

**2. Mục tiêu:**

- Thiết kế cơ sơ dữ liệu để lưu trữ thông tin về các dữ liệu của nhà sách.

- Thiết kế các stored procedure/function và trigger để quản lý dữ liệu, đảm bảo tính toàn vẹn dữ liệu, cập nhật thông tin tự động, hỗ trợ quyết định kinh doanh, bảo vệ dữ liệu

**3. Công cụ:** Oracle Database, StarUML, Draw.io  

**4. Các bước thực hiện:**

B1: Thiết kế quy trình hoạt động nghiệp vụ 

B2: Thiết kế sơ đồ cơ cấu tổ chức của doanh nghiệp

B3: Phân tích hệ thống 

   B3.1: Phân tích chức năng 

      + Thiết kế mô hình phân cấp chức năng của hệ thống (sơ đồ BFD)
    
      + Mô tả chi tiết từng chức năng và các quy định nghiệp vụ/các ràng buộc toàn vẹn dữ liệu có liên quan
    
  B3.2: Phân tích dữ liệu 
  
      + Mô hình thực thể kết hợp (ERD)
   
      + Thiết kế các sơ đồ luồng dữ liệu (DFD)
   
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

         B4.3.4.1: Kiểm tra các ràng buộc toàn vẹn dữ liệu  

         B4.3.4.2: Kiểm tra trùng giá trị 

         B4.3.4.3: Trigger bảo vệ dữ liệu  

   B4.4: Thiết kế và cài đặt các giao tác (Transaction)

**6. Kết luận:**
- Dự án này đã giúp tôi rèn luyện về: 

   + Cấu trúc Hệ thống: Hiểu cách thức hoạt động và tổ chức của hệ thống, từ quy trình nghiệp vụ đến sơ đồ tổ chức.
    
   + Chức năng và Dữ liệu: Biết được các chức năng chính của hệ thống và cách các thực thể dữ liệu liên kết với nhau, thông qua ERD và DFD.
    
   + Mô hình Dữ liệu: Nắm vững cách thiết kế mô hình dữ liệu quan hệ, từ đó xây dựng các bảng và thuộc tính cần thiết để quản lý thông tin.
    
   + Thao tác Dữ liệu: Hiểu về các thao tác CRUD (Create, Read, Update, Delete) và cách sử dụng Stored Procedures để thực hiện các chức năng này.
    
   + Toàn vẹn Dữ liệu: Nhận thức được tầm quan trọng của các ràng buộc toàn vẹn và cách sử dụng Trigger để bảo vệ dữ liệu.
     
   + Quản lý Giao dịch: Nắm bắt quy trình quản lý giao dịch, đảm bảo tính nhất quán và an toàn cho dữ liệu trong hệ thống.
