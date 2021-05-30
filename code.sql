DROP database IF EXISTS Assignment2;
CREATE DATABASE Assignment2;
USE Assignment2;

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


