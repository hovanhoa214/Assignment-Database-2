
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
call LoTrinhTuyenXeTau('B001');


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
            (select count(*) from ve_le where Ngay_su_dung = (DATE_ADD(tu_ngay , INTERVAL countday day))) + 
            (select count(*) from Hoat_dong_ve_thang where Ngay_su_dung = (DATE_ADD(tu_ngay , INTERVAL countday day))) + 
            (select count(*) from Ve_1_ngay where Ngay_su_dung = (DATE_ADD(tu_ngay , INTERVAL countday day))) 
            );
            set countday = countday + 1;
		END  IF; 
		
	END LOOP;
    

END$$
DELIMITER ;

select * from ve_le;
select * from Ve_1_ngay;
select * from Hoat_dong_ve_thang;
call ThongKeLuotNguoi('B001', "2021-05-20", '2021-05-30');
select * from thong_ke;






