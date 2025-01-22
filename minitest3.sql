CREATE DATABASE minitest03_db;
USE minitest03_db;

CREATE TABLE VatTu (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ma_vat_tu VARCHAR(50) UNIQUE NOT NULL,
    ten_vat_tu VARCHAR(100) NOT NULL,
    don_vi_tinh VARCHAR(50) NOT NULL,
    gia_tien DECIMAL(10 , 2 ) NOT NULL
);

-- Tạo bảng Tồn kho
CREATE TABLE TonKho (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vat_tu_id INT NOT NULL,
    so_luong_dau INT NOT NULL,
    tong_so_luong_nhap INT NOT NULL,
    tong_so_luong_xuat INT NOT NULL,
    FOREIGN KEY (vat_tu_id)
        REFERENCES VatTu (id)
); 
CREATE TABLE NhaCungCap (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ma_nha_cung_cap VARCHAR(50) NOT NULL,
    ten_nha_cung_cap VARCHAR(100) NOT NULL,
    dia_chi VARCHAR(255) NOT NULL,
    so_dien_thoai VARCHAR(15) NOT NULL
);

-- Tạo bảng Đơn đặt hàng
CREATE TABLE DonDatHang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ma_don VARCHAR(50) NOT NULL,
    ngay_dat_hang DATE NOT NULL,
    nha_cung_cap_id INT NOT NULL,
    FOREIGN KEY (nha_cung_cap_id) REFERENCES NhaCungCap(id)
);
alter table dondathang
	MODIFY COLUMN nha_cung_cap_id INT NULL;

-- Tạo bảng Phiếu nhập
CREATE TABLE PhieuNhap (
    id INT AUTO_INCREMENT PRIMARY KEY,
    so_phieu_nhap VARCHAR(50) NOT NULL,
    ngay_nhap DATE NOT NULL,
    don_hang_id INT NOT NULL,
    FOREIGN KEY (don_hang_id) REFERENCES DonDatHang(id)
);

-- Tạo bảng Phiếu xuất
CREATE TABLE PhieuXuat (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ngay_xuat DATE NOT NULL,
    ten_khach_hang VARCHAR(100) NOT NULL
);

-- Tạo bảng Chi tiết đơn hàng
CREATE TABLE CTDonHang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    don_hang_id INT NOT NULL,
    vat_tu_id INT NOT NULL,
    so_luong_dat INT NOT NULL,
    FOREIGN KEY (don_hang_id) REFERENCES DonDatHang(id),
    FOREIGN KEY (vat_tu_id) REFERENCES VatTu(id)
);

-- Tạo bảng Chi tiết phiếu nhập
CREATE TABLE CTPhieuNhap (
    id INT AUTO_INCREMENT PRIMARY KEY,
    phieu_nhap_id INT NOT NULL,
    vat_tu_id INT NOT NULL,
    so_luong_nhap INT NOT NULL,
    don_gia_nhap DECIMAL(10, 2) NOT NULL,
    ghi_chu VARCHAR(255),
    FOREIGN KEY (phieu_nhap_id) REFERENCES PhieuNhap(id),
    FOREIGN KEY (vat_tu_id) REFERENCES VatTu(id)
);

-- Tạo bảng Chi tiết phiếu xuất
CREATE TABLE CTPhieuXuat (
    id INT AUTO_INCREMENT PRIMARY KEY,
    phieu_xuat_id INT NOT NULL,
    vat_tu_id INT NOT NULL,
    so_luong_xuat INT NOT NULL,
    don_gia_xuat DECIMAL(10, 2) NOT NULL,
    ghi_chu VARCHAR(255),
    FOREIGN KEY (phieu_xuat_id) REFERENCES PhieuXuat(id),
    FOREIGN KEY (vat_tu_id) REFERENCES VatTu(id)
);

CREATE VIEW vw_CTPNHAP AS
SELECT 
    pn.so_phieu_nhap, 
    vt.ma_vat_tu, 
    ctpn.so_luong_nhap, 
    ctpn.don_gia_nhap, 
    (ctpn.so_luong_nhap * ctpn.don_gia_nhap) AS thanh_tien_nhap
FROM 
    PhieuNhap pn
JOIN 
    CTPhieuNhap ctpn ON pn.id = ctpn.phieu_nhap_id
JOIN 
    VatTu vt ON ctpn.vat_tu_id = vt.id;
select *from vw_ctpnhap;
CREATE VIEW vw_CTPNHAP_VT AS
SELECT 
    pn.so_phieu_nhap, 
    vt.ma_vat_tu, 
    vt.ten_vat_tu,
    ctpn.so_luong_nhap, 
    ctpn.don_gia_nhap, 
    (ctpn.so_luong_nhap * ctpn.don_gia_nhap) AS thanh_tien_nhap
FROM 
    PhieuNhap pn
JOIN 
    CTPhieuNhap ctpn ON pn.id = ctpn.phieu_nhap_id
JOIN 
    VatTu vt ON ctpn.vat_tu_id = vt.id;

CREATE VIEW vw_CTPNHAP_VT_PN AS
SELECT 
    pn.so_phieu_nhap, 
    pn.ngay_nhap,
    dh.ma_don AS so_don_dat_hang,
    vt.ma_vat_tu, 
    vt.ten_vat_tu,
    ctpn.so_luong_nhap, 
    ctpn.don_gia_nhap, 
    (ctpn.so_luong_nhap * ctpn.don_gia_nhap) AS thanh_tien_nhap
FROM 
    PhieuNhap pn
JOIN 
    CTPhieuNhap ctpn ON pn.id = ctpn.phieu_nhap_id
JOIN 
    VatTu vt ON ctpn.vat_tu_id = vt.id
JOIN
    DonDatHang dh ON pn.don_hang_id = dh.id;
    
CREATE VIEW vw_CTPNHAP_VT_PN_DH AS
SELECT 
    pn.so_phieu_nhap, 
    pn.ngay_nhap,
    dh.ma_don AS so_don_dat_hang,
    ncc.ma_nha_cung_cap,
    vt.ma_vat_tu, 
    vt.ten_vat_tu,
    ctpn.so_luong_nhap, 
    ctpn.don_gia_nhap, 
    (ctpn.so_luong_nhap * ctpn.don_gia_nhap) AS thanh_tien_nhap
FROM 
    PhieuNhap pn
JOIN 
    CTPhieuNhap ctpn ON pn.id = ctpn.phieu_nhap_id
JOIN 
    VatTu vt ON ctpn.vat_tu_id = vt.id
JOIN
    DonDatHang dh ON pn.don_hang_id = dh.id
JOIN 
    NhaCungCap ncc ON dh.nha_cung_cap_id = ncc.id;

CREATE VIEW vw_CTPNHAP_loc AS
SELECT 
    pn.so_phieu_nhap, 
    vt.ma_vat_tu, 
    ctpn.so_luong_nhap, 
    ctpn.don_gia_nhap, 
    (ctpn.so_luong_nhap * ctpn.don_gia_nhap) AS thanh_tien_nhap
FROM 
    PhieuNhap pn
JOIN 
    CTPhieuNhap ctpn ON pn.id = ctpn.phieu_nhap_id
JOIN 
    VatTu vt ON ctpn.vat_tu_id = vt.id
WHERE 
    ctpn.so_luong_nhap > 5;
SELECT * from vw_ctpnhap_loc;

CREATE VIEW vw_CTPNHAP_VT_loc AS
SELECT 
    pn.so_phieu_nhap, 
    vt.ma_vat_tu, 
    vt.ten_vat_tu,
    ctpn.so_luong_nhap, 
    ctpn.don_gia_nhap, 
    (ctpn.so_luong_nhap * ctpn.don_gia_nhap) AS thanh_tien_nhap
FROM 
    PhieuNhap pn
JOIN 
    CTPhieuNhap ctpn ON pn.id = ctpn.phieu_nhap_id
JOIN 
    VatTu vt ON ctpn.vat_tu_id = vt.id
WHERE 
    vt.don_vi_tinh = 'Bộ';
    
CREATE VIEW vw_CTPXUAT AS
SELECT 
    px.id AS so_phieu_xuat,
    vt.ma_vat_tu, 
    ctpx.so_luong_xuat, 
    ctpx.don_gia_xuat, 
    (ctpx.so_luong_xuat * ctpx.don_gia_xuat) AS thanh_tien_xuat
FROM 
    PhieuXuat px
JOIN 
    CTPhieuXuat ctpx ON px.id = ctpx.phieu_xuat_id
JOIN 
    VatTu vt ON ctpx.vat_tu_id = vt.id;
    
CREATE VIEW vw_CTPXUAT_VT AS
SELECT 
    px.id AS so_phieu_xuat,
    vt.ma_vat_tu, 
    vt.ten_vat_tu,
    ctpx.so_luong_xuat, 
    ctpx.don_gia_xuat
FROM 
    PhieuXuat px
JOIN 
    CTPhieuXuat ctpx ON px.id = ctpx.phieu_xuat_id
JOIN 
    VatTu vt ON ctpx.vat_tu_id = vt.id;
    
DELIMITER //
CREATE PROCEDURE TongSoLuongCuoiVatTu (
    IN maVatTu VARCHAR(50),
    OUT tongSoLuongCuoi INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM VatTu WHERE ma_vat_tu = maVatTu) THEN
        SET tongSoLuongCuoi = -1;
    ELSE
        SELECT 
            tk.so_luong_dau + tk.tong_so_luong_nhap - tk.tong_so_luong_xuat 
        INTO tongSoLuongCuoi
        FROM 
            VatTu vt
        JOIN 
            TonKho tk ON vt.id = tk.vat_tu_id
        WHERE 
            vt.ma_vat_tu = maVatTu;
    END IF;
END //
DELIMITER ;

CALL TongSoLuongCuoiVatTu('VT001', @tong);
select @tong;

DELIMITER //
CREATE PROCEDURE TongTienXuatCuaVatTu(
	IN maVatTu varchar(50),
	OUT tongTienXuatCuoi DECIMAL(10,2)
)
BEGIN
	SELECT
		ctpx.so_luong_xuat * ctpx.don_gia_xuat
	INTO
		tongTienXuatCuoi
    FROM 
		vattu vt
	JOIN
		ctphieuxuat ctpx on vt.id = ctpx.vat_tu_id
	WHERE
		vt.ma_vat_tu = maVatTu;
END//
DELIMITER ;
 
use minitest03_db;
DROP PROCEDURE TongTienXuatCuaVatTu;
 
call TongTienXuatCuaVatTu('vt005', @tongTienXuatVatTu);
select @tongTienXuatVatTu;

Được rồi, nếu bạn không muốn kiểm tra sự tồn tại của đơn hàng trong Stored Procedure TongSoLuongDatTheoDonHang nữa, bạn có thể bỏ qua câu lệnh IF và thực hiện truy vấn trực tiếp.

Dưới đây là mã Stored Procedure sau khi đã bỏ kiểm tra tồn tại:

SQL

DELIMITER //

CREATE PROCEDURE TongSoLuongDatTheoDonHang (
    IN soDonHang VARCHAR(50),
    OUT tongSoLuongDat INT
)
BEGIN
    -- Tính tổng số lượng đặt của đơn hàng
    SELECT 
        SUM(ctdh.so_luong_dat)
    INTO tongSoLuongDat
    FROM 
        DonDatHang dh
    JOIN 
        CTDonHang ctdh ON dh.id = ctdh.don_hang_id
    WHERE 
        dh.ma_don = soDonHang;
END //

DELIMITER ;

call TongSoLuongDatTheoDonHang('DH001', @tsl);
select @tsl;

select * from dondathang;
 
DELIMITER //

CREATE PROCEDURE ThemDonDatHang (
    IN maDon VARCHAR(50),
    IN ngayDatHang DATE,
    IN nhaCungCapId INT,
    OUT ketQua VARCHAR(255)
)
BEGIN
    -- Thêm đơn đặt hàng
    INSERT INTO DonDatHang (ma_don, ngay_dat_hang, nha_cung_cap_id)
    VALUES (maDon, ngayDatHang, nhaCungCapId);

    SET ketQua = 'Thêm đơn đặt hàng thành công.';
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE ThemCTDonDatHang (
    IN donHangId INT,
    IN vatTuId INT,
    IN soLuongDat INT,
    OUT ketQua VARCHAR(255)
)
BEGIN
    -- Thêm chi tiết đơn hàng
    INSERT INTO CTDonHang (don_hang_id, vat_tu_id, so_luong_dat)
    VALUES (donHangId, vatTuId, soLuongDat);

    SET ketQua = 'Thêm chi tiết đơn hàng thành công.';
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE XoaNhaCungCap (
    IN nhaCungCapId INT,
    OUT ketQua VARCHAR(255)
)
BEGIN
    -- Cập nhật tất cả các khóa ngoại liên quan đến nhà cung cấp thành NULL
    UPDATE DonDatHang SET nha_cung_cap_id = NULL WHERE nha_cung_cap_id = nhaCungCapId;

    -- Xóa nhà cung cấp
    DELETE FROM NhaCungCap WHERE id = nhaCungCapId;

    SET ketQua = 'Xóa nhà cung cấp thành công.';
END //

DELIMITER ;

