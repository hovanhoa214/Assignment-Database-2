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

-- select * from Ve_thang;
-- insert into Hoat_dong_ve_thang values ('VM3005202100001', '2021-05-28', '01:00:00', '02:01:01', 'BT00001', 'BT00002');
-- select * from Hoat_dong_ve_thang;

/* Cau 2 */
DROP TRIGGER if exists Auto_Insert_gia_ve_le;
DELIMITER $$
CREATE TRIGGER Auto_Insert_gia_ve  Before INSERT ON ve_le
FOR EACH ROW
BEGIN
	declare sochuyen1 int default 0;
    declare sochuyen2 int default 0;
    declare matuyen char(4);
    declare gia int;
		begin
			set matuyen = new.Ma_tuyen;
			SELECT stt_ INTO sochuyen1 FROM ghe, ve WHERE(ghe.Ma_tuyen = matuyen AND ghe.Ma_ga_tram = new.Ma_ga_tram_len AND new.Ma_ve = ve.Ma_ve);
            SELECT stt_ INTO sochuyen2 FROM ghe, ve WHERE(ghe.Ma_tuyen = matuyen AND ghe.Ma_ga_tram = new.Ma_ga_tram_xuong AND new.Ma_ve = ve.Ma_ve);
				if(matuyen like 'B%') then SELECT don_gia_xe_bus INTO gia FROM Bang_gia;
				else SELECT don_gia INTO gia FROM Tuyen_tau_dien WHERE(Ma_tuyen_tau_xe = matuyen);
				end if;
            SET sochuyen1 = ABS(sochuyen1 - sochuyen2);
            SET gia = gia * CEIL(sochuyen1/2);
        end;
    Update ve set gia_ve = gia where new.Ma_ve = ve.Ma_ve;
END;
$$

DROP TRIGGER if exists Auto_Insert_gia_ve_1_ngay
DELIMITER $$
CREATE TRIGGER Auto_Insert_gia_ve_1_ngay  Before INSERT ON Ve_1_ngay
FOR EACH ROW
BEGIN
	declare NgaySuDung DATE;
    declare gia int;
		begin
			set NgaySuDung = new.Ngay_su_dung;
            if(WEEKDAY(NgaySuDung)<=4)	
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
	declare sochuyen1 int default 0;
    declare sochuyen2 int default 0;
	declare matuyen char(4);
	declare giamgia float(2) default 1.00;
    declare nghenghiep text;
    declare num int default 0;
    declare magatram1 char(7);
    declare magatram2 char(7);
	declare NgaySuDung DATE;
    declare gia int;
		begin
			set matuyen = new.ma_tuyen;
            set magatram1 = new.Ma_ga_tram_1;
            set magatram2 = new.Ma_ga_tram_2;
			SELECT stt_ INTO sochuyen1 FROM ghe, ve WHERE(ghe.Ma_tuyen = matuyen AND ghe.Ma_ga_tram = magatram1 AND ve.Ma_ve = new.Ma_ve);
            SELECT stt_ INTO sochuyen2 FROM ghe, ve WHERE(ghe.Ma_tuyen = matuyen AND ghe.Ma_ga_tram = magatram2 AND ve.Ma_ve = new.Ma_ve);
				if(matuyen like 'B%') then SELECT don_gia_xe_bus INTO gia FROM Bang_gia;
				else SELECT don_gia INTO gia FROM Tuyen_tau_dien WHERE(Ma_tuyen_tau_xe = matuyen);
				end if;
            SET sochuyen1 = ABS(sochuyen1 - sochuyen2);
            SELECT COUNT(*) INTO num FROM Ve_thang, Khach_hang, ve WHERE(Khach_hang.Ma_khach_hang = ve.Ma_khach_hang AND Ve_thang.Ma_tuyen = new.Ma_tuyen AND Ve_thang.Ma_ga_tram_1 = magatram1 AND Ve_thang.Ma_ga_tram_2 = magatram2 and ve.ma_ve = ve_thang.ma_ve
				and (DATE_ADD(ve.ngay_gio_mua, INTERVAL 30 day) >= Ve.ngay_gio_mua) ); 
				if(num > 0) then SET giamgia = giamgia - 0.1;
				end if;
            SELECT Nghe_nghiep INTO nghenghiep FROM Khach_hang, ve WHERE(Khach_hang.Ma_khach_hang = ve.Ma_khach_hang and ve.ma_ve = new.ma_ve);
				if(nghenghiep = 'Student') then SET giamgia = giamgia - 0.5;
				end if;
            SET gia = 20 * 2 * giamgia * gia * CEIL(sochuyen1/2);
        end;
    Update ve set gia_ve = gia where new.Ma_ve = ve.Ma_ve;
END;
$$


-- select * from ghe;
-- select * from ve;
-- select * from ve_le;
-- select * from tuyen_tau_dien;


