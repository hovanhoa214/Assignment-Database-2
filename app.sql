use assignment2;
/*==============================
có thêm (select *from thong_ke;) vào proceduce trong ThongKeLuotNguoi
===============================*/
DROP Procedure IF EXISTS Search;
DELIMITER $$
CREATE  PROCEDURE Search (id varchar(20) , CMND varchar(20), job varchar(20), phone varchar(20), Sex varchar(20), email varchar(40), dob varchar(40))
begin
        set @sqlQuery1 = 'select * from Assignment2.Khach_hang where 1=1 ';
        if (char_length(id) != 0) then set @sqlQuery1 = concat(@sqlQuery1, " and Ma_khach_hang = ? "); 
        else set @sqlQuery1 = concat(@sqlQuery1, " and Ma_khach_hang != ? "); 
		set id = "4gfd65g4df6s54";
        end if;
        if (char_length(CMND) != 0) then set @sqlQuery1 = concat(@sqlQuery1, " and CMND_CCCD = ? "); 
        else set @sqlQuery1 = concat(@sqlQuery1, " and CMND_CCCD != ? "); 
		set CMND = "4gfd65g4df6s54";
        end if;
        if (char_length(job) != 0) then set @sqlQuery1 = concat(@sqlQuery1, " and Nghe_nghiep = ? "); 
	else	set @sqlQuery1 = concat(@sqlQuery1, " and Nghe_nghiep != ? "); 
		set job = "4gfd65g4df6s54";
        end if;
        if (char_length(phone) != 0) then set @sqlQuery1 = concat(@sqlQuery1, " and Dien_thoai = ? ");
	else	set @sqlQuery1 = concat(@sqlQuery1, " and Dien_thoai != ? ");
		set phone = "4gfd65g4df6s54";
        end if;
        if (char_length(Sex) != 0) then set @sqlQuery1 = concat(@sqlQuery1, " and Gioi_tinh = ? ");
        else	set @sqlQuery1 = concat(@sqlQuery1, " and Gioi_tinh != ? ");
		set Sex = "4gfd65g4df6s54";
        end if;
        if (char_length(email) != 0) then set @sqlQuery1 = concat(@sqlQuery1, " and Email = ? ");
        else	set @sqlQuery1 = concat(@sqlQuery1, " and Email != ? ");
		set email = "4gfd65g4df6s54";
        end if;
        if (char_length(dob) != 0) then set @sqlQuery1 = concat(@sqlQuery1, " and Ngay_sinh = ? ");
        else	set @sqlQuery1 = concat(@sqlQuery1, " and Ngay_sinh != ? ");
		set dob = "0/0/0";
        end if;
        
        set @sqlQuery1 = concat(@sqlQuery1, ';');
        -- id varchar(20), CMND varchar(20), job varchar(20), phone varchar(20), Sex varchar(20), email varchar(40), dob varchar(20)
        set @id = id;
        set @CMND = CMND;
        set @job = job;
        set @phone = phone;
        set @Sex = Sex;
        set @email = email;
        set @dob = dob;
        PREPARE myquery FROM @sqlQuery1;
	EXECUTE myquery using @id, @CMND, @job, @phone, @Sex, @email, @dob;
end$$
DELIMITER ;
-- call Search(null,null,null,null,null,null,null);

-- drop procedure if exists AddOrExit;
-- DELIMITER $$
-- CREATE  PROCEDURE AddOrExit( ma_tuyen ,ma_tuyen_tau ,ten_tuyen,don_gia,stt , ma_ga_tram ,stt_ga_tram ,gio_ghe ,gio_den)
-- BEGIN
--     

-- END$$
-- DELIMITER ;


drop procedure if exists getAll_TuyenTauDien;
DELIMITER $$
CREATE  PROCEDURE getAll_TuyenTauDien()
BEGIN
    
SELECT Ma_tuyen_tau_xe as Ma_tuyen, Ma_tuyen as ma_tuyen_tau, ten_tuyen, don_gia
	FROM tuyen_tau_dien;
    
END$$
DELIMITER ;
-- call getAll_TuyenTauDien();

drop procedure if exists insert_TuyenTauDien;
DELIMITER $$
CREATE  PROCEDURE insert_TuyenTauDien(Ma_tuyen_tau_xe char(4),Ma_tuyen char,ten_tuyen varchar(15),don_gia int,STT int)
BEGIN
		Insert into tuyen_tau_xe values (Ma_tuyen_tau_xe);
		Insert into tuyen_tau_dien values (Ma_tuyen, ten_tuyen,don_gia, Ma_tuyen_tau_xe);
		Insert into chuyen_tau_xe values (Ma_tuyen_tau_xe, STT);
		-- Insert into ghe values (Ma_tuyen_tau_xe, STT,Ma_ga_tram, STT_, Gio_ghe, Gio_di);
		-- SELECT tuyen_tau_xe.Ma_tuyen, tuyen_tau_dien.Ma_tuyen as ma_tuyen_tau, ten_tuyen, don_gia, stt, ma_ga_tram, stt_ as stt_ga_tram, gio_ghe, gio_di FROM (tuyen_tau_xe  JOIN tuyen_tau_dien ON tuyen_tau_xe.Ma_tuyen = tuyen_tau_dien.Ma_tuyen_tau_xe) JOIN ghe on ghe.Ma_tuyen = tuyen_tau_xe.Ma_tuyen;
END$$
DELIMITER ;

drop procedure if exists getAll_TuyenBus;
DELIMITER $$
CREATE  PROCEDURE getAll_TuyenBus()
BEGIN
    
SELECT Ma_tuyen_tau_xe as Ma_tuyen, No FROM tuyen_xe_bus;
    
END$$
DELIMITER ;
-- call getAll_TuyenBus();

drop procedure if exists insert_TuyenBus;
DELIMITER $$
CREATE  PROCEDURE insert_TuyenBus(Ma_tuyen_tau_xe char(4),No int,STT int)
BEGIN
		Insert into tuyen_tau_xe values (Ma_tuyen_tau_xe);
		Insert into tuyen_xe_bus values (No, Ma_tuyen_tau_xe);
		Insert into chuyen_tau_xe values (Ma_tuyen_tau_xe, STT);
END$$
DELIMITER ;


drop procedure if exists getAll_Khachhang;
DELIMITER $$
CREATE  PROCEDURE getAll_Khachhang()
BEGIN
		SELECT *from khach_hang;
END$$
DELIMITER ;

drop procedure if exists getAllTuyen;
DELIMITER $$
CREATE  PROCEDURE getAllTuyen()
BEGIN
		select *from tuyen_tau_xe;
END$$
DELIMITER ;

-- select *from ga_tram where Ma_ga_tram like 'TT%';
drop procedure if exists getTram;
DELIMITER $$
CREATE  PROCEDURE getTram()
BEGIN
		select *from ga_tram where Ma_ga_tram like 'BT%';
END$$
DELIMITER ;
-- call getTRam();

drop procedure if exists getGa;
DELIMITER $$
CREATE  PROCEDURE getGa()
BEGIN
		select *from ga_tram where Ma_ga_tram like 'TT%';
END$$
DELIMITER ;

drop procedure if exists get_LoTrinh;
DELIMITER $$
CREATE  PROCEDURE get_LoTrinh(Ma_tuyen char(4))
BEGIN
		SELECT STT, Ma_ga_tram,STT_,Gio_ghe,Gio_di from ghe where ghe.Ma_tuyen=Ma_tuyen;
END$$
DELIMITER ;
-- call get_LoTrinh('T001');

drop procedure if exists insert_ghe;
DELIMITER $$
CREATE  PROCEDURE insert_ghe(Ma_tuyen char(4),STT int,Ma_ga_tram char(7), STT_ int, Gio_ghe time, Gio_di time)
BEGIN
		Insert into ghe values (Ma_tuyen, STT,Ma_ga_tram, STT_, Gio_ghe, Gio_di);
END$$
DELIMITER ;
-- call get_LoTrinh('T001',1);