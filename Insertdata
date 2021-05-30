insert into Giao_Lo values (null,'1', '40°24\'12,2\"N 2°10\'26,5\"E');
insert into Giao_Lo values (null,'2', '42°24\'12,2\"N 2°10\'26,5\"E');
insert into Giao_Lo values (null,'3', '43°24\'12,2\"N 2°10\'26,5\"E');
insert into Giao_Lo values (null,'2', '46°24\'12,2\"N 2°10\'26,5\"E');
insert into Giao_Lo values (null,'4', '45°24\'12,2\"N 2°10\'26,5\"E');
select * from Giao_Lo;




insert into Con_duong(Ten_duong) values ('Nguye Du'), ('Nguyen Khuyen'),('Tran Quoc Toan'),('Chu Van AN');
select * from Con_duong;



insert into Doan_duong values ('GL1', 'GL2', 3, 'CD1', 1);
insert into Doan_duong values ('GL2', 'GL3', 2, 'CD1', 2);
insert into Doan_duong values ('GL3', 'GL4', 4, 'CD1', 3);
insert into Doan_duong values ('GL4', 'GL5', 3, 'CD1', 4);
select * from Doan_duong;


insert into Tuyen_tau_xe values ('B001'),('B002'),('B003'),('B004'), ('T002'), ('T003'), ('T004'), ('T001');
select * from Tuyen_tau_xe;


insert into Tuyen_xe_bus values (NULL,'B001'),(NULL,'B002'),(NULL,'B003'),(NULL,'B004');
select * from Tuyen_xe_bus;


insert into Tuyen_tau_dien values ('A', 'A37', 3000, 'T001');
insert into Tuyen_tau_dien values ('B', 'A12', 4000, 'T002');
insert into Tuyen_tau_dien values ('C', 'A63', 5000, 'T003');
insert into Tuyen_tau_dien values ('D', 'A71', 6000, 'T004');
select * from Tuyen_tau_dien;



insert into Chuyen_tau_xe values ('B001', 1);
insert into Chuyen_tau_xe values ('B002', 2);
insert into Chuyen_tau_xe values ('B001', 3);
insert into Chuyen_tau_xe values ('B002', 4);
select * from Chuyen_tau_xe;


Insert into Ga_tram values ('BT00001', 'sg', 'das1', 1, 'GL1', 'GL2');
Insert into Ga_tram values ('BT00002', 'sg', 'das2', 1, 'GL2', 'GL3');
Insert into Ga_tram values ('BT00003', 'sg', 'das3', 1, 'GL3', 'GL4');
Insert into Ga_tram values ('BT00004', 'sg', 'das4', 1, 'GL3', 'GL4');
select * from Ga_tram;


insert into Ghe values ('B001', 1, 'BT00001', 1, '08:00', '08:03'); 
-- insert into Ghe values ('B002', 2, 'BT00001', 2, '09:00', '09:03'); 
-- insert into Ghe values ('B001', 3, 'BT00001', 3, '08:00', '08:03'); 
insert into Ghe values ('B001', 4, 'BT00002', 10, '10:00', '10:03'); 
select * from Ghe;



insert into Khach_hang values ('KH000001', '123456789', 'CEO', '0932127541', 'M', 'hoa.ho.van@hcmut.edu.vn', '2001:04:21');
insert into Khach_hang values ('KH000002', '987654321', 'Teacher', '0987654321', 'F', 'an.nguyen@hcmut.edu.vn', '2001:07:23');
insert into Khach_hang values ('KH000003', '112233445', 'Doctor', '0915365078', 'M', 'khoa.le@hcmut.edu.vn', '2001:12:29');
insert into Khach_hang values ('KH000004', '123455667', 'Engineer', '0988888886', 'M', 'hoang.duong@hcmut.edu.vn', '2001:04:30');
select * from Khach_hang;

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

insert into bang_gia values (12, 4000, 5000);

/* CREATE PROCEDURE insertVeLe(Gia_ve int, Ngay_gio_mua datetime, Ma_khach_hang char(8),
      		          Ma_tuyen char(4), Ngay_su_dung varchar(40), Ma_ga_tram_len char(6), Gio_len time, Ma_ga_tram_xuong char(6), Gio_xuong time)*/
call insertVeLe (null, '1998-01-23 12:45:56', 'KH000001', 
		'B001', '2021-05-28', 'BT00001', '01:00:00','BT00002', '02:01:01');
call insertVeLe (null, '1998-01-23 12:45:56', 'KH000001', 
		'B001', '2021-05-28', 'BT00001', '01:00:00','BT00002', '02:01:01');
call insertVeLe (null, '1998-01-23 12:45:56', 'KH000001', 
		'B001', '2021-05-28', 'BT00001', '01:00:00','BT00002', '02:01:01');
select * from Ve;
select * from Ve_le;

call insertVeThang (3000, '1998-01-23 12:45:56', 'KH000001', 
		'B001', 'BT00001', 'BT00002');
call insertVeThang (4000, '1998-01-23 12:45:56', 'KH000001', 
		'B001', 'BT00001', 'BT00002');
call insertVeThang (5000, '1998-01-23 12:45:56', 'KH000001', 
		'B001', 'BT00001', 'BT00002');
select * from Ve;
select * from Ve_thang;
select * from hoat_dong_ve_thang;
