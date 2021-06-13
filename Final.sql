DROP database IF EXISTS Assignment2;
CREATE DATABASE Assignment2;
USE Assignment2;

-- CREATE USER 'sManager'@'localhost' IDENTIFIED BY '1234';
-- GRANT ALL PRIVILEGES ON * . * TO 'sManager'@'localhost';

/* ----------------------------- Giao Lo -----------------------------*/
CREATE TABLE Giao_Lo
	(Ma_giao_lo			varchar(10)	primary key DEFAULT '0',
	`long`				varchar(30),
	lat 				varchar(30));

DELIMITER $$
CREATE TRIGGER GL_Insert
	BEFORE insert ON Giao_Lo
	FOR EACH ROW 
BEGIN
	declare count int default 1;
        declare GL_ID varchar(10);
        set GL_ID = 'GL1';
        while exists (select Ma_giao_lo from Giao_Lo where Ma_giao_lo = GL_ID) do
		set count = count + 1;
                set GL_ID = CONCAT('GL', count);
        end while;
        set NEW.Ma_giao_lo  = GL_ID;
end$$
DELIMITER ;

/* ----------------------------- Con Duong -----------------------------*/
CREATE TABLE Con_duong
	(Ma_con_duong		varchar(10) primary key DEFAULT '0',
	Ten_duong			varchar(30));

DELIMITER $$
CREATE TRIGGER CD_Insert
	BEFORE insert ON Con_duong
	FOR EACH ROW 
BEGIN
	declare count int default 1;
        declare CD_ID varchar(10);
        set CD_ID = 'CD1';
        while exists (select Ma_con_duong from Con_duong where Ma_con_duong = CD_ID) do
		set count = count + 1;
                set CD_ID = CONCAT('CD', count);
        end while;
        set NEW.Ma_con_duong  = CD_ID;
end$$
DELIMITER ;

/* ----------------------------- Doan Duong -----------------------------*/
CREATE TABLE Doan_duong
	(Ma_giao_lo_1		varchar(10),
	Ma_giao_lo_2 		varchar(10),
	Chieu_dai			int,
	Ma_con_duong		varchar(10),
	STT 				int,
	primary key(Ma_giao_lo_1, Ma_giao_lo_2),
	foreign key(Ma_con_duong) references Con_duong(Ma_con_duong),
	foreign key(Ma_giao_lo_1) references Giao_lo(Ma_giao_lo),
	foreign key(Ma_giao_lo_2) references Giao_lo(Ma_giao_lo));
     
/* ----------------------------- Tuyen Tau Xe -----------------------------*/
CREATE TABLE Tuyen_tau_xe
	(Ma_tuyen 			char(4),
	primary key(Ma_tuyen),
	constraint chk check ((Ma_tuyen like 'B___' or Ma_tuyen like 'T___') and (Ma_tuyen REGEXP '[0-9]{3,}')));

/* ----------------------------- Tuyen xe bus -----------------------------*/
CREATE TABLE Tuyen_xe_bus
	(No						int				AUTO_INCREMENT,
	Ma_tuyen_tau_xe			char(4),
	primary key(No),
	constraint chk_B check ((Ma_tuyen_tau_xe like 'B___')  and (Ma_tuyen_tau_xe REGEXP '[0-9]{3,}')),
	foreign key(Ma_tuyen_tau_xe) references Tuyen_tau_xe(Ma_tuyen));

/* ----------------------------- Tuyen tau dien -----------------------------*/
CREATE TABLE Tuyen_tau_dien
	(Ma_tuyen			char,
	ten_tuyen			varchar(15)			NOT NULL 	UNIQUE,
	don_gia				int,
	Ma_tuyen_tau_xe		char(4),
	primary key(Ma_tuyen),
	constraint chk_Ma check (Ma_tuyen RLIKE '^[A-Z]'),
	constraint chk_T check ((Ma_tuyen_tau_xe like 'T___')  and (Ma_tuyen_tau_xe REGEXP '[0-9]{3,}')),
	foreign key(Ma_tuyen_tau_xe) references Tuyen_tau_xe(Ma_tuyen));
     
/* ----------------------------- Chuyen tau xe -----------------------------*/
CREATE TABLE Chuyen_tau_xe
	(Ma_tuyen			char(4),
	STT					int,
	primary key(STT, Ma_tuyen),
	foreign key(Ma_tuyen) references Tuyen_tau_xe(Ma_tuyen));

/* ----------------------------- Ga tram -----------------------------*/
CREATE TABLE Ga_tram
	(Ma_ga_tram 			char(7),
	Dia_chi					varchar(40)			NOT NULL,
	Ten						varchar(30),
	Ga_tram 				int,
	Ma_giao_lo_1			varchar(10),
	Ma_giao_lo_2 			varchar(10),		
	primary key(Ma_ga_tram),
	constraint chk_gt check ((Ma_ga_tram like 'BT%' or Ma_ga_tram like 'TT%') and (Ma_ga_tram REGEXP '[0-9]{5,}')),
	constraint chk_gatram check (Ga_tram = 0 or Ga_tram = 1), 
	foreign key(Ma_giao_lo_1) references Doan_duong(Ma_giao_lo_1),
	foreign key(Ma_giao_lo_2) references Doan_duong(Ma_giao_lo_2));

/* ----------------------------- Chuyen tau xe ghe ga tram -----------------------------*/
CREATE TABLE Ghe
	(Ma_tuyen			char(4),
	STT					int,
	Ma_ga_tram			char(7),
	STT_				int,
	Gio_ghe				time,
	Gio_di				time,
	primary key(Ma_tuyen, STT, Ma_ga_tram),
	foreign key(Ma_tuyen) references Chuyen_tau_xe(Ma_tuyen),
	foreign key(STT) references Chuyen_tau_xe(STT),
	foreign key(Ma_ga_tram) references Ga_tram(Ma_ga_tram),
	constraint chk_time check (Gio_ghe < Gio_di));
       

/* ----------------------------- Khach hang -----------------------------*/
CREATE TABLE Khach_hang
	(Ma_khach_hang		char(8),
	CMND_CCCD			char(9)	 UNIQUE,
	Nghe_nghiep			varchar(30),
	Dien_thoai			varchar(11) UNIQUE,
	Gioi_tinh			char,
	Email				varchar(30),
	Ngay_sinh			date,
	primary key(Ma_khach_hang),
	constraint chk_sex check(Gioi_tinh = 'F' or Gioi_tinh = 'M'),
	constraint chk_kh check ((Ma_khach_hang like 'KH%') and (Ma_khach_hang REGEXP '[0-9]{6,}')));

/* ----------------------------- ve -----------------------------*/
CREATE TABLE Ve
	(Ma_ve 				char(15),
	Loai_ve				int,
	Gia_ve				int,
	Ngay_gio_mua		datetime,
	Ma_khach_hang		char(8),
	primary key(Ma_ve),
	constraint chk_lv check (Loai_ve = 0 or Loai_ve = 1 or Loai_ve = 2),
	constraint chk_ve check ((Ma_ve like 'VO%' or Ma_ve like 'VM%' or Ma_ve like 'VD%') and (Ma_ve REGEXP '[0-9]{13,}')),
	foreign key(Ma_khach_hang) references Khach_hang(Ma_khach_hang));
     

/* ----------------------------- Ve le -----------------------------*/
CREATE TABLE Ve_le
	(Ma_ve					char(15),
	Ma_tuyen				char(4),
	Ngay_su_dung			date,
	Ma_ga_tram_len			char(7),
	Gio_len					time,
	Ma_ga_tram_xuong		char(7),
	Gio_xuong				time,
	primary key(Ma_ve),
	constraint chk_vele check (Ma_ve like 'VO%' and Gio_xuong > Gio_len),
	foreign key(Ma_ve) references Ve(Ma_ve),
	foreign key(Ma_tuyen) references Tuyen_tau_xe(Ma_tuyen),
	foreign key(Ma_ga_tram_len) references Ga_tram(Ma_ga_tram),
	foreign key(Ma_ga_tram_xuong) references Ga_tram(Ma_ga_tram));


/*----------------------------- Ve_thang -----------------------------*/
CREATE TABLE Ve_thang	
	(Ma_ve					char(15),
	Ma_tuyen				char(4),
	Ma_ga_tram_1			char(7),
	Ma_ga_tram_2			char(7),
	primary key(Ma_ve),
	constraint chk_vethang check (Ma_ve like 'VM%'),
	foreign key(Ma_ve) references Ve(Ma_ve),
	foreign key(Ma_tuyen) references Tuyen_tau_xe(Ma_tuyen),
	foreign key(Ma_ga_tram_1) references Ga_tram(Ma_ga_tram),
	foreign key(Ma_ga_tram_2) references Ga_tram(Ma_ga_tram));
     
/* ----------------------------- Hoat_dong_ve_thang -----------------------------*/
CREATE TABLE Hoat_dong_ve_thang	
	(Ma_ve				char(15),
	Ngay_su_dung		date,
	Gio_len				time,
	Gio_xuong			time,
	Tram_len			char(7),
	Tram_xuong			char(7),
	primary key(Ma_ve, Ngay_su_dung, Gio_len),
	constraint chk_hdvt check (Gio_xuong > Gio_len),
	foreign key(Ma_ve) references Ve_thang(Ma_ve),
	foreign key(Tram_len) references Ga_tram(Ma_ga_tram),
	foreign key(Tram_xuong) references Ga_tram(Ma_ga_tram));
      

/*----------------------------- ve_1_ngay -----------------------------*/
CREATE TABLE Ve_1_ngay
	(Ma_ve					char(15),
	Ngay_su_dung			date,
	primary key(Ma_ve),
	constraint chk_vengay check (Ma_ve like 'VD%'),
	foreign key(Ma_ve) references Ve(Ma_ve));


/*----------------------------- Hoat_dong_ve_1_ngay -----------------------------*/
CREATE TABLE Hoat_dong_ve_1_ngay
	(Ma_ve				char(15),
	STT 				int,	
	Ma_tuyen			char(4),
	Ma_ga_tram_len		char(7),
	Ma_ga_tram_xuong	char(7),
	Gio_len				time,
	Gio_xuong			time,
	primary key(Ma_ve, STT),
	constraint chk_dh1n check (Gio_xuong > Gio_len),
	foreign key(Ma_ve) references Ve_1_ngay(Ma_ve),
	foreign key(Ma_tuyen) references Tuyen_tau_xe(Ma_tuyen),
	foreign key(Ma_ga_tram_len) references Ga_tram(Ma_ga_tram),
	foreign key(Ma_ga_tram_xuong) references Ga_tram(Ma_ga_tram));

/*----------------------------- The tu -----------------------------*/
CREATE TABLE The_tu
	(Ma_the_tu				char(8),
	Ngay_mua				datetime,
	Ma_khach_hang			char(8),
	primary key(Ma_the_tu),
	foreign key(Ma_khach_hang) references Khach_hang(Ma_khach_hang),
	constraint chk_tt check ((Ma_the_tu like 'TT%') and (Ma_the_tu REGEXP '[0-9]{6,}')));
     

/*----------------------------- Nhan_vien -----------------------------*/
CREATE TABLE Nhan_vien
	(Ma_nhan_vien			char(6),
	Loai_cong_viec			varchar(15),
	Ngay_sinh				date,
	Email					varchar(30),
	Gioi_tinh				char,
	Dien_thoai_di_dong 		varchar(11),
	Dien_thoai_noi_bo		varchar(11),
	primary key(Ma_nhan_vien),
    constraint chk_gioitinh check (Gioi_tinh = 'F' or Gioi_tinh = 'M'),
	constraint chk_nv check ((Ma_nhan_vien like 'NV%') and (Ma_nhan_vien REGEXP '[0-9]{4,}')));
     
     
/*----------------------------- Ga_Tram_lam_viec -----------------------------*/
CREATE TABLE Ga_Tram_lam_viec
	(Ma_nhan_vien			char(6),
	Ma_ga_tram				char(7),
	primary key(Ma_nhan_vien),
	foreign key(Ma_nhan_vien) references Nhan_vien(Ma_nhan_vien),
	foreign key(Ma_ga_tram) references Ga_tram(Ma_ga_tram));
     
     
/*----------------------------- Bang_gia -----------------------------*/
CREATE TABLE Bang_gia 
(
	don_gia_xe_bus 					int,
	gia_ve_1_ngay_trong_tuan 		int,
	gia_ve_1_ngay_cuoi_tuan 		int
);

/* Cau 1 */ 
drop trigger if exists bf_insert_hdvt ;
DELIMITER $$
create trigger bf_insert_hdvt 
	before insert 
	on Hoat_dong_ve_thang for each row
BEGIN
    -- statements
    DECLARE Mave char(15);
    declare custom_message varchar(256);
    set Mave = new.Ma_ve;
    if (new.Tram_len not in (select Ma_ga_tram_1 from Ve_thang where Ma_ve=Mave)
		or new.Tram_xuong not in (select Ma_ga_tram_2 from Ve_thang where Ma_ve=Mave))	
        and (new.Tram_len not in (select Ma_ga_tram_2 from Ve_thang where Ma_ve=Mave)
		or new.Tram_xuong not in (select Ma_ga_tram_1 from Ve_thang where Ma_ve=Mave))
		then 
			 set custom_message= "Ma tram len/xong khong trung voi thong tin trong ve thang";
             signal sqlstate '13500'
             set message_text= custom_message;
	END IF;
END$$
//
delimiter ; 

drop trigger if exists bf_update_hdvt ;
DELIMITER $$
create trigger bf_update_hdvt 
	before update 
	on Hoat_dong_ve_thang for each row
BEGIN
    -- statements
    DECLARE Mave char(15);
    declare custom_message varchar(256);
    set Mave = new.Ma_ve;
    if (new.Tram_len not in (select Ma_ga_tram_1 from Ve_thang where Ma_ve=Mave)
		or new.Tram_xuong not in (select Ma_ga_tram_2 from Ve_thang where Ma_ve=Mave))	
        and (new.Tram_len not in (select Ma_ga_tram_2 from Ve_thang where Ma_ve=Mave)
		or new.Tram_xuong not in (select Ma_ga_tram_1 from Ve_thang where Ma_ve=Mave))
		then 
			 set custom_message= "Ma tram len/xong khong trung voi thong tin trong ve thang";
             signal sqlstate '13500'
             set message_text= custom_message;
	END IF;
END$$
//
delimiter ; 

/* Cau 2 */
DROP TRIGGER if exists Auto_Insert_gia_ve_le;
DELIMITER $$
CREATE TRIGGER Auto_Insert_gia_ve  Before INSERT ON ve_le
FOR EACH ROW
BEGIN
	declare sochuyen1 int;
    declare sochuyen2 int;
    declare gia int;
		begin
			SELECT stt_ INTO sochuyen1 FROM ghe, ve WHERE(ghe.Ma_tuyen = new.Ma_tuyen AND new.Ma_ve = ve.Ma_ve AND ghe.Ma_ga_tram = new.Ma_ga_tram_len);
            SELECT stt_ INTO sochuyen2 FROM ghe, ve WHERE(ghe.Ma_tuyen = new.Ma_tuyen AND new.Ma_ve = ve.Ma_ve AND ghe.Ma_ga_tram = new.Ma_ga_tram_xuong);
				if(new.Ma_tuyen like 'B%') then SELECT don_gia_xe_bus INTO gia FROM Bang_gia;
				else SELECT don_gia INTO gia FROM Tuyen_tau_dien WHERE(Ma_tuyen_tau_xe = new.Ma_tuyen);
				end if;
            SET gia = gia * CEIL(ABS(sochuyen1 - sochuyen2)/2);
        end;
    Update ve set gia_ve = gia where new.Ma_ve = ve.Ma_ve;
END;
$$

DROP TRIGGER if exists Auto_Insert_gia_ve_1_ngay
DELIMITER $$
CREATE TRIGGER Auto_Insert_gia_ve_1_ngay  Before INSERT ON Ve_1_ngay
FOR EACH ROW
BEGIN
    declare gia int;
		begin
            if(WEEKDAY(new.Ngay_su_dung) < 5)	
				then SELECT gia_ve_1_ngay_trong_tuan into gia from Bang_gia;
			else
				SELECT gia_ve_1_ngay_cuoi_tuan into gia from Bang_gia;
			end if;
        end;
    Update ve set gia_ve = gia where new.Ma_ve = ve.Ma_ve;
END;
$$


DROP TRIGGER if exists Auto_Insert_gia_ve_thang
DELIMITER $$
CREATE TRIGGER Auto_Insert_gia_ve_thang  Before INSERT ON Ve_thang
FOR EACH ROW
BEGIN
	declare sochuyen1 int;
    declare sochuyen2 int;
	declare giamgia float(2) default 1.00;
    declare nghenghiep varchar(30);
    declare num int default 0;
	declare NgaySuDung DATE;
    declare gia int;
		begin
			SELECT stt_ INTO sochuyen1 FROM ghe, ve WHERE(ghe.Ma_tuyen = new.ma_tuyen AND ghe.Ma_ga_tram = new.Ma_ga_tram_1 AND ve.Ma_ve = new.Ma_ve);
            SELECT stt_ INTO sochuyen2 FROM ghe, ve WHERE(ghe.Ma_tuyen = new.ma_tuyen AND ghe.Ma_ga_tram = new.Ma_ga_tram_2 AND ve.Ma_ve = new.Ma_ve);
				if(new.ma_tuyen like 'B%') then SELECT don_gia_xe_bus INTO gia FROM Bang_gia;
				else SELECT don_gia INTO gia FROM Tuyen_tau_dien WHERE(Ma_tuyen_tau_xe = new.ma_tuyen);
				end if;
            SELECT COUNT(*) INTO num FROM Ve_thang, Khach_hang, ve WHERE(Khach_hang.Ma_khach_hang = ve.Ma_khach_hang AND Ve_thang.Ma_tuyen = new.Ma_tuyen AND Ve_thang.Ma_ga_tram_1 = new.Ma_ga_tram_1 AND Ve_thang.Ma_ga_tram_2 = new.Ma_ga_tram_2 and ve.ma_ve = ve_thang.ma_ve
				and (DATE_ADD(ve.ngay_gio_mua, INTERVAL 30 day) >= Ve.ngay_gio_mua) ); 
				if(num > 0) then SET giamgia = giamgia - 0.1;
				end if;
            SELECT Nghe_nghiep INTO nghenghiep FROM Khach_hang, ve WHERE(Khach_hang.Ma_khach_hang = ve.Ma_khach_hang and ve.ma_ve = new.ma_ve);
				if(nghenghiep = 'Student') then SET giamgia = giamgia - 0.5;
				end if;
            SET gia = 20 * 2 * gia * giamgia * CEIL(ABS(sochuyen1 - sochuyen2)/2);
        end;
    Update ve set gia_ve = gia where new.Ma_ve = ve.Ma_ve;
END;
$$

/* Cau 1 */
drop procedure if exists LoTrinhTuyenXeTau;
DELIMITER $$
CREATE  PROCEDURE LoTrinhTuyenXeTau(IN ma char(4))
BEGIN
    SELECT Ga_tram.Ten FROM Ga_tram, Ghe
    WHERE (ma = Ghe.Ma_tuyen and Ghe.Ma_ga_tram = Ga_tram.Ma_ga_tram)
    order by Ghe.stt_;

END$$
DELIMITER ;



/* Cau 2 */
drop procedure if exists ThongKeLuotNguoi;
DELIMITER $$
CREATE  PROCEDURE ThongKeLuotNguoi(IN ma char(4), IN tu_ngay date, In toi_ngay date)
BEGIN
	DECLARE countday  INT;
    drop table if exists thong_ke;
    CREATE TABLE thong_ke(
		ngay date PRIMARY KEY,
		tong_so_luot int
	);
    SET countday = 0;
    
    loop_label:  LOOP
		IF  DATE_ADD(tu_ngay , INTERVAL countday day) >  toi_ngay THEN 
			LEAVE  loop_label;
		ELSE 
			Insert into thong_ke values (DATE_ADD(tu_ngay , INTERVAL countday day), 
            (select count(*) from ve_le where Ngay_su_dung = (DATE_ADD(tu_ngay , INTERVAL countday day)) and ma = ve_le.ma_tuyen) + 
            (select count(*) from Hoat_dong_ve_thang, ve_thang where Ngay_su_dung = (DATE_ADD(tu_ngay , INTERVAL countday day)) and ma = ve_thang.ma_tuyen and ve_thang.ma_ve = Hoat_dong_ve_thang.ma_ve) + 
            (select count(*) from Ve_1_ngay, hoat_dong_ve_1_ngay where Ngay_su_dung = (DATE_ADD(tu_ngay , INTERVAL countday day)) and Ve_1_ngay.ma_ve = hoat_dong_ve_1_ngay.ma_ve and hoat_dong_ve_1_ngay.ma_tuyen = ma) 
            );
            set countday = countday + 1;
		END  IF; 
		
	END LOOP;
    select * from thong_ke;

END$$
DELIMITER ;

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
CREATE PROCEDURE insertVeLe(Ngay_gio_mua datetime, Ma_khach_hang char(8),
			Ma_tuyen char(4), Ngay_su_dung date, Ma_ga_tram_len char(7), Gio_len time, Ma_ga_tram_xuong char(7), Gio_xuong time)
begin
	CALL VeID('O', @now_ID);
        Insert into ve values (@now_ID, 0, 0, Ngay_gio_mua, Ma_khach_hang);
        Insert into ve_le values (@now_ID, Ma_tuyen, Ngay_su_dung, Ma_ga_tram_len, Gio_len, Ma_ga_tram_xuong, Gio_xuong);
end$$
DELIMITER ;

-- -------------------------insert vé tháng----------------------------- --

DROP Procedure IF EXISTS insertVeThang;
DELIMITER $$
CREATE PROCEDURE insertVeThang(Ngay_gio_mua datetime, Ma_khach_hang char(8),
			Ma_tuyen char(4), Ma_ga_tram_1 char(7),	Ma_ga_tram_2 char(7))
begin
	CALL VeID('M', @now_ID);
        Insert into ve values (@now_ID, 1, 0, Ngay_gio_mua, Ma_khach_hang);
        Insert into Ve_thang values (@now_ID, Ma_tuyen, Ma_ga_tram_1, Ma_ga_tram_2);
end$$
DELIMITER ;

-- -------------------------insert vé một ngày----------------------------- --

DROP Procedure IF EXISTS insertVe1Ngay;
DELIMITER $$
CREATE PROCEDURE insertVe1Ngay(Ngay_gio_mua datetime, Ma_khach_hang char(8),
			Ngay_su_dung date)
begin
	CALL VeID('D', @now_ID);
        Insert into ve values (@now_ID, 2, 0, Ngay_gio_mua, Ma_khach_hang);
        Insert into Ve_1_ngay values (@now_ID, Ngay_su_dung);
end$$
DELIMITER ;

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


insert into Giao_Lo values (null,'40°24\'12,2\"N', '21°10\'26,5\"E');
insert into Giao_Lo values (null,'41°24\'12,2\"N', '22°10\'26,5\"E');
insert into Giao_Lo values (null,'42°24\'12,2\"N', '23°10\'26,5\"E');
insert into Giao_Lo values (null,'43°24\'12,2\"N', '24°10\'26,5\"E');
insert into Giao_Lo values (null,'44°24\'12,2\"N', '25°10\'26,5\"E');
insert into Giao_Lo values (null,'45°24\'12,2\"N', '26°10\'26,5\"E');
insert into Giao_Lo values (null,'46°24\'12,2\"N', '27°10\'26,5\"E');
insert into Giao_Lo values (null,'47°24\'12,2\"N', '28°10\'26,5\"E');
insert into Giao_Lo values (null,'48°24\'12,2\"N', '29°10\'26,5\"E');
insert into Giao_Lo values (null,'49°24\'12,2\"N', '30°10\'26,5\"E');
select * from Giao_Lo;


insert into Con_duong(Ten_duong) values ('Nguyen Du'), ('Nguyen Khuyen'),('Tran Quoc Toan'),
('Chu Van An'),('Nguyen Tri Phuong'),('Pham Ngoc Thach'),
('Ly Thai To'), ('Hai Ba Trung'), ('Ly Thuong Kiet'), ('Truong Chinh');
select * from Con_duong;


insert into Doan_duong values ('GL1', 'GL2', 1, 'CD1', 1);
insert into Doan_duong values ('GL2', 'GL3', 2, 'CD2', 2);
insert into Doan_duong values ('GL3', 'GL4', 3, 'CD3', 3);
insert into Doan_duong values ('GL4', 'GL5', 4, 'CD4', 4);
insert into Doan_duong values ('GL5', 'GL6', 5, 'CD5', 5);
insert into Doan_duong values ('GL6', 'GL7', 6, 'CD6', 6);
insert into Doan_duong values ('GL7', 'GL8', 7, 'CD7', 7);
insert into Doan_duong values ('GL8', 'GL9', 8, 'CD8', 8);
insert into Doan_duong values ('GL9', 'GL10', 9, 'CD9', 9);
insert into Doan_duong values ('GL10', 'GL1', 10, 'CD10', 10);
select * from Doan_duong;


insert into Tuyen_tau_xe values 
('B001'),('B002'),('B003'),('B004'),
('T001'), ('T002'), ('T003'), ('T004');
select * from Tuyen_tau_xe;


insert into Tuyen_xe_bus values (NULL,'B001'),(NULL,'B002'),(NULL,'B003'),(NULL,'B004');
select * from Tuyen_xe_bus;


insert into Tuyen_tau_dien values ('A', 'A01', 3000, 'T001');
insert into Tuyen_tau_dien values ('B', 'A02', 3000, 'T002');
insert into Tuyen_tau_dien values ('C', 'A03', 3000, 'T003');
insert into Tuyen_tau_dien values ('D', 'A04', 3000, 'T004');
select * from Tuyen_tau_dien;



insert into Chuyen_tau_xe values ('B001', 1), ('B002', 2), ('B003', 3), ('B004', 4);
insert into Chuyen_tau_xe values ('T001', 1), ('T002', 2), ('T003', 3), ('T004', 4);
select * from Chuyen_tau_xe;


Insert into Ga_tram values ('BT00001', 'q1', 'a', 0, 'GL1', 'GL2');
Insert into Ga_tram values ('BT00002', 'q2', 'b', 0, 'GL2', 'GL3');
Insert into Ga_tram values ('BT00003', 'q3', 'c', 0, 'GL3', 'GL4');
Insert into Ga_tram values ('BT00005', 'q5', 'd', 0, 'GL5', 'GL6');
Insert into Ga_tram values ('BT00006', 'q6', 'e', 0, 'GL6', 'GL7');
Insert into Ga_tram values ('BT00007', 'q7', 'f', 0, 'GL7', 'GL8');
Insert into Ga_tram values ('BT00010', 'q9', 'g', 0, 'GL9', 'GL10');
Insert into Ga_tram values ('TT00004', 'q4', 'h', 1, 'GL4', 'GL5');
Insert into Ga_tram values ('TT00008', 'q8', 'i', 1, 'GL8', 'GL9');
Insert into Ga_tram values ('TT00009', 'q9', 'j', 1, 'GL9', 'GL10');
Insert into Ga_tram values ('TT00005', 'q10', 'k', 1, 'GL10', 'GL1');
Insert into Ga_tram values ('TT00002', 'q2', 'l', 1, 'GL2', 'GL3');
Insert into Ga_tram values ('TT00006', 'q3', 'm', 1, 'GL3', 'GL4');
Insert into Ga_tram values ('TT00001', 'q6', 'n', 1, 'GL6', 'GL7');
select * from Ga_tram;


insert into Ghe values ('B001', 1, 'BT00001', 1, '08:00', '08:03'); 
insert into Ghe values ('B001', 1, 'BT00003', 3, '09:00', '09:03'); 

insert into Ghe values ('B002', 2, 'BT00002', 2, '09:00', '09:03'); 

insert into Ghe values ('B003', 3, 'BT00003', 3, '10:00', '10:03'); 

insert into Ghe values ('B004', 4, 'BT00005', 2, '11:00', '11:03'); 
insert into Ghe values ('B004', 4, 'BT00010', 7, '13:00', '13:03'); 

insert into Ghe values ('T001', 1, 'TT00004', 1, '08:00', '08:03'); 
insert into Ghe values ('T001', 1, 'TT00005', 2, '09:00', '09:03'); 

insert into Ghe values ('T002', 2, 'TT00001', 2, '09:00', '09:03'); 
insert into Ghe values ('T002', 2, 'TT00009', 10, '10:00', '10:03'); 

insert into Ghe values ('T003', 3, 'TT00002', 3, '14:00', '14:03'); 
insert into Ghe values ('T003', 3, 'TT00006', 7, '15:00', '15:03'); 

insert into Ghe values ('T004', 4, 'TT00008', 4, '11:00', '11:03'); 
select * from Ghe;



insert into Khach_hang values ('KH000001', '123456789', 'CEO', '0932157541', 'M', 'hoa.ho.van@hcmut.edu.vn', '1990:04:21');
insert into Khach_hang values ('KH000002', '987654321', 'Teacher', '0987654321', 'F', 'an.nguyen@hcmut.edu.vn', '1990:07:23');
insert into Khach_hang values ('KH000005', '997654321', 'Student', '0917654321', 'F', 'an.nguyen_@hcmut.edu.vn', '2001:01:23');
insert into Khach_hang values ('KH000003', '112233445', 'Doctor', '0915365078', 'M', 'khoa.le@hcmut.edu.vn', '1990:12:29');
insert into Khach_hang values ('KH000004', '123455667', 'Engineer', '0988888886', 'M', 'hoang.duong@hcmut.edu.vn', '1993:04:30');
insert into Khach_hang values ('KH000006', '024655666', 'Baker', '0966887786', 'M', 'shawnmendes@hcmut.edu.vn', '1980:11:01');
insert into Khach_hang values ('KH000007', '223355667', 'Chef', '0908182836', 'F', 'emmawatson@hcmut.edu.vn', '1988:10:17');
insert into Khach_hang values ('KH000008', '334455667', 'Waiter', '0909898986', 'F', 'harrystyles@hcmut.edu.vn', '1992:01:28');
insert into Khach_hang values ('KH000009', '023455667', 'Engineer', '0932488576', 'M', 'samsmith@hcmut.edu.vn', '1994:05:20');
insert into Khach_hang values ('KH000010', '111555667', 'Engineer', '0913678996', 'M', 'mr.robert@hcmut.edu.vn', '1994:04:17');

select * from Khach_hang;

insert into The_tu
values 	('TT000001','2021-05-25 15:10:00','KH000001'),
		('TT000002','2021-05-16 16:20:00','KH000002'),
		('TT000003','2019-04-25 12:30:00','KH000003'),
		('TT000004','2021-01-05 09:40:00','KH000004'),
		('TT000005','2020-05-27 08:50:00','KH000005');
select * from The_tu;

insert into Nhan_vien 
values 	('NV0001','Receptionist','2001:04:21','salala@hcmut.edu.vn','F','0932151141','0934567543'),
		('NV1234','Driver','1993:03:30','gogosing@hcmut.edu.vn','M','0987007541','0934567541'),
		('NV2001','Typist','1991:09:26','elsaanna@hcmut.edu.vn','F','096656543','0912456543'),
		('NV4214','Filing clerk','1994:01:21','olaf@hcmut.edu.vn','M','0902255544','0903456123'),
		('NV1701','Manager','1992:01:11','realmino@hcmut.edu.vn','F','0933456543','0967896543');
select * from Nhan_vien;

insert into Ga_Tram_lam_viec
values 	('NV0001','BT00001'),
		('NV2001','BT00007'),
		('NV4214','BT00007'),
		('NV1701','BT00002');
select * from Ga_Tram_lam_viec;

/*
Insert into Ve values ('VO1805202100001', 0, 3000, '2021-05-25 00:00:00', 'KH000001');
Insert into Ve values ('VO1805202100002', 0, 3000, '2021-05-25 08:00:00', 'KH000002');
Insert into Ve values ('VO1805202100003', 0, 3000, '2021-05-25 09:00:00', 'KH000003');
Insert into Ve values ('VO1805202100004', 0, 3000, '2021-05-25 06:00:00', 'KH000004');
Insert into Ve values ('VM1805202100001', 0, 13000, '2021-05-25 00:00:00', 'KH000001');
Insert into Ve values ('VM1805202100002', 0, 13000, '2021-05-25 08:00:00', 'KH000002');
Insert into Ve values ('VM1805202100003', 0, 13000, '2021-05-25 09:00:00', 'KH000003');
Insert into Ve values ('VM1805202100004', 0, 13000, '2021-05-25 06:00:00', 'KH000004');
Insert into Ve values ('VD1805202100001', 0, 113000, '2021-05-25 00:00:00', 'KH000001');
Insert into Ve values ('VD1805202100002', 0, 113000, '2021-05-25 08:00:00', 'KH000002');
Insert into Ve values ('VD1805202100003', 0, 113000, '2021-05-25 09:00:00', 'KH000003');
Insert into Ve values ('VD1805202100004', 0, 113000, '2021-05-25 06:00:00', 'KH000004');
select * from Ve;
insert into Ve_le values ('VO1805202100001', 'B001', '2021-05-21', 'BT00001', '01:00:00','BT00002', '02:01:01');
insert into Ve_le values ('VO1805202100002', 'B002', '28-05-2021', 'BT00002', '01:00:00','BT00004', '03:01:01');
insert into Ve_le values ('VO1805202100003', 'B003', '28-05-2021', 'BT00004', '01:00:00','BT00001', '02:01:01');
insert into Ve_le values ('VO1805202100004', 'B004', '28-05-2021', 'BT00003', '01:00:00','BT00002', '04:01:01');
*/

-- insert into bang_gia values (3000, 4000, 5000);

/* CREATE PROCEDURE insertVeLe(Ngay_gio_mua datetime, Ma_khach_hang char(8),
      		          Ma_tuyen char(4), Ngay_su_dung varchar(40), Ma_ga_tram_len char(6), Gio_len time, Ma_ga_tram_xuong char(6), Gio_xuong time)*/
call insertVeLe ('2021-01-23 12:45:56', 'KH000001', 
		'B001', '2021-05-28', 'BT00001', '08:00:00','BT00003', '09:01:01');
call insertVeLe ('2021-02-01 10:45:00', 'KH000001', 
		'T001', '2021-04-27', 'TT00004', '08:00:00','TT00005', '09:00:01');
call insertVeLe ('2020-12-23 09:25:40', 'KH000002', 
		'B004', '2021-05-28', 'BT00005', '11:00:00','BT00010', '13:01:01');
call insertVeLe ('2020-12-23 10:45:56', 'KH000003', 
		'T002', '2021-05-28', 'TT00001', '09:00:00','TT00009', '10:01:01');
call insertVeLe ('2020-12-23 08:45:56', 'KH000004', 
		'T003', '2021-05-28', 'TT00002', '14:00:00','TT00006', '15:01:01');
        
/*select * from Ve;*/
select * from Ve;
/*(Ngay_gio_mua datetime, Ma_khach_hang char(8),
			Ma_tuyen char(4), Ma_ga_tram_1 char(7),	Ma_ga_tram_2 char(7))*/
call insertVeThang ('2021-01-23 12:45:56', 'KH000001', 
		'B001', 'BT00001', 'BT00003');
call insertVeThang ('2021-01-24 10:45:56', 'KH000002', 
		'T001', 'TT00004', 'TT00005');
call insertVeThang ('2020-03-25 09:45:56', 'KH000002', 
		'B004', 'BT00005', 'BT00010');
call insertVeThang ('2020-02-26 07:45:56', 'KH000005', 
		'B001', 'BT00001', 'BT00003');
call insertVeThang ('2020-02-26 07:45:56', 'KH000005', 
		'T003', 'TT00002', 'TT00006');
call insertVeThang ('2021-01-23 12:45:56', 'KH000001', 
		'B001', 'BT00001', 'BT00003');
select * from Ve_thang;
        
/*insertVe1Ngay(Ngay_gio_mua datetime, Ma_khach_hang char(8),
			Ngay_su_dung date)*/
call insertVe1Ngay('2021-01-23 12:45:56','KH000002','2021-05-18');
call insertVe1Ngay('2020-05-23 12:45:56','KH000002','2021-04-18');
call insertVe1Ngay('2020-04-23 12:45:56','KH000003','2021-03-21');
call insertVe1Ngay('2021-01-21 12:45:56','KH000004','2021-02-28');
select * from Ve_1_ngay;
select * from ve;

insert into hoat_dong_ve_thang 
values 	('VM1306202100001','2021-05-23','14:00:00','15:01:01','BT00001', 'BT00003');
insert into hoat_dong_ve_thang 
values	('VM1306202100002','2021-04-23','08:00:00','09:01:01','TT00004', 'TT00005');
insert into hoat_dong_ve_thang 
values	('VM1306202100003','2021-05-20','11:00:00','13:01:01','BT00005', 'BT00010');
insert into hoat_dong_ve_thang 
values	('VM1306202100004','2021-04-20','14:00:00','15:01:01','BT00001', 'BT00003');

insert into Hoat_dong_ve_1_ngay
values 	('VD1306202100001',1,'T003','TT00002', 'TT00006','14:00:00','15:01:01');
insert into Hoat_dong_ve_1_ngay
values 	('VD1306202100002',2,'B001','BT00001', 'BT00003','14:00:00','15:01:01');
insert into Hoat_dong_ve_1_ngay
values 	('VD1306202100003',3,'T001','TT00004', 'TT00005','08:00:00','09:01:01');
insert into Hoat_dong_ve_1_ngay
values 	('VD1306202100004',4,'B004','BT00005', 'BT00010','11:00:00','13:01:01');

select * from Ve_thang;
select * from Hoat_dong_ve_1_ngay;
select * from hoat_dong_ve_thang;


/*	Check Trigger 1 

-- Insert success
insert into hoat_dong_ve_thang 
values	('VM1306202100005','2021-01-23','14:00:00','15:01:01','TT00002', 'TT00006');
select * from hoat_dong_ve_thang;

-- Insert fail
insert into hoat_dong_ve_thang 
values	('VM1306202100006','2021-01-23','14:00:00','15:01:01','TT00001', 'TT00004');
select * from hoat_dong_ve_thang;

-- Update success
Update hoat_dong_ve_thang 
set Tram_len = 'BT00003', Tram_xuong = 'BT00001'
where Ma_ve = 'VM1306202100004';
select * from hoat_dong_ve_thang;

-- Update fail
Update hoat_dong_ve_thang 
set Tram_len = 'BT00004', Tram_xuong = 'BT00001'
where Ma_ve = 'VM1306202100004';
select * from hoat_dong_ve_thang;

-- Delete success
Delete from hoat_dong_ve_thang where Ma_ve = 'VM1306202100004';
select * from hoat_dong_ve_thang;
*/


/*	Check trigger 2

-- Insert success
select * from ve;

-- Insert fail
-- Comment out statements insert into bang_gia values (3000, 4000, 5000);
select * from ve;

*/

/*	Check procedure 1
-- Success
call LoTrinhTuyenXeTau('B001');

-- Fail
call LoTrinhTuyenXeTau('B010');
 
*/

/*	Check procedure 2
-- Success
call ThongKeLuotNguoi('B001', '2021-05-20', ' 2021-06-20');

-- Fail
call ThongKeLuotNguoi('B001', '2021-07-20', ' 2021-06-20');
 */















