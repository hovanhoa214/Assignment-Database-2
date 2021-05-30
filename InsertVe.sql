DROP Procedure IF EXISTS VeID;
DELIMITER $$
CREATE  PROCEDURE VeID (kind char, out VeID_Return varchar(15) ) -- kind is 'O' or 'M' or 'D'
begin
	declare count int default 1;
        SELECT CAST((SELECT DATE_FORMAT(CURDATE(), '%d%m%Y')) AS CHAR(8)) INTO @today;
	SET VeID_Return = concat('V' , kind , @today, LPAD( count, 5, '0'));
        while exists (select Ma_ve from Ve where Ma_ve = VeID_Return) do
		set count = count + 1;
                set VeID_Return = concat('V' , kind , @today, LPAD( count, 5, '0'));
        end while;
end$$
DELIMITER ;


-- -------------------------insert vé lẻ----------------------------- --

DROP Procedure IF EXISTS insertVeLe;
DELIMITER $$
CREATE PROCEDURE insertVeLe(Gia_ve int, Ngay_gio_mua datetime, Ma_khach_hang char(8),
			Ma_tuyen char(4), Ngay_su_dung date, Ma_ga_tram_len char(7), Gio_len time, Ma_ga_tram_xuong char(7), Gio_xuong time)
begin
	CALL VeID('O', @now_ID);
        Insert into ve values (@now_ID, 0, Gia_ve, Ngay_gio_mua, Ma_khach_hang);
        Insert into ve_le values (@now_ID, Ma_tuyen, Ngay_su_dung, Ma_ga_tram_len, Gio_len, Ma_ga_tram_xuong, Gio_xuong);
end$$
DELIMITER ;

-- -------------------------insert vé tháng----------------------------- --

DROP Procedure IF EXISTS insertVeThang;
DELIMITER $$
CREATE PROCEDURE insertVeThang(Gia_ve int, Ngay_gio_mua datetime, Ma_khach_hang char(8),
			Ma_tuyen char(4), Ma_ga_tram_1 char(7),	Ma_ga_tram_2 char(7))
begin
	CALL VeID('M', @now_ID);
        Insert into ve values (@now_ID, 1, Gia_ve, Ngay_gio_mua, Ma_khach_hang);
        Insert into Ve_thang values (@now_ID, Ma_tuyen, Ma_ga_tram_1, Ma_ga_tram_2);
end$$
DELIMITER ;

-- -------------------------insert vé một ngày----------------------------- --

DROP Procedure IF EXISTS insertVe1Ngay;
DELIMITER $$
CREATE PROCEDURE insertVe1Ngay(Gia_ve int, Ngay_gio_mua datetime, Ma_khach_hang char(8),
			Ngay_su_dung date)
begin
	CALL VeID('D', @now_ID);
        Insert into ve values (@now_ID, 2, Gia_ve, Ngay_gio_mua, Ma_khach_hang);
        Insert into Ve_1_ngay values (@now_ID, Ngay_su_dung);
end$$
DELIMITER ;