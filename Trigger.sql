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



