DROP Procedure IF EXISTS Search;
DELIMITER $$
CREATE  PROCEDURE Search (id varchar(20), CMND varchar(20), job varchar(20), phone varchar(20), Sex varchar(20), email varchar(40), dob varchar(40))
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
