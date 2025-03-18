create database COURSE_ENROLLMENT
use COURSE_ENROLLMENT
--q1.
create table DEPARTMENTS(Dno char(4) not null primary key, Dname varchar(50) not null, 
Location varchar(120))
--
create table COURSES(Cno char(7) not null primary key,
Cname varchar(20) not null, Credit int not null default 3 check(Credit>0),
CourseType bit not null, Dno char(4) not null, constraint FK_DEP foreign key (Dno)
references DEPARTMENTS(Dno))
--
create table STUDENTS(Sno char(12) not null primary key, Sname varchar(50) not null,
Class char(7) not null, DateOfBirth date, Gender bit, Saddress varchar(120), Email varchar(50) unique,
Dno char(4) not null, constraint FK_STU_DEP foreign key (Dno) references DEPARTMENTS(Dno))
--
create table ENROLLMENTS(Sno char(12) not null, Cno char(7) not null,
Time_Enroll datetime default getdate() not null, Semester char(1) not null,
SchoolYear char(9) not null, Fee int, primary key(Sno, Cno))
----
alter table ENROLLMENTS
add constraint FK_STU foreign key(Sno) references STUDENTS(Sno),
constraint FK_COU foreign key (Cno) references COURSES(Cno)
--q2.
insert into DEPARTMENTS(Dno, Dname, Location)
values
('ECOM','ECOMMERCE', 'BUILDING A, ROOM H403'),
('ACCO', 'ACCOUNTING', 'BUILDING A, ROOM H502'),
('BANK', 'BANKING', 'BUILDING A, ROOM H603'),
('FINA', 'FINANCE', 'BUILDING A, ROOM H402'),
('MARK', 'MARKETING', 'BUILDING A, ROOM H503')
---
insert into COURSES(Cno, Cname, Credit, CourseType, Dno)
values
('ECO2001', 'DATA', 2, 1, 'ECOM'),
('ACC2001', 'ACCOUNTING', 3, 1, 'ACCO'),
('ECO2002', 'EPAYMENT', 3, 0, 'ECOM'),
('MAR2001', 'MERKETING', 3, 1, 'MARK'),
('MAR2002', 'CRM', 3, 1, 'MARK')
---
insert into STUDENTS( Sno, Sname, Class, DateOfBirth, Gender, Saddress, Email, Dno)
values
('123456789012', 'NAM', '46K29.1', '2000-12-25', 1, 'HUE', 'NAM@GMAIL.COM', 'ECOM'),
('123456789013', 'HOA', '47K06.1', '2001-10-15', 0, 'DANANG', 'HOA@GMAIL.COM', 'ACCO'),
('123456789014', 'HUNG', '46K29.2', '2000-08-25', 1, 'QUANGNAM', 'HUNG@GMAIL.COM', 'ECOM'),
('123456789015', 'NGA', '47K06.2', '2001-11-15', 0, 'DANANG', 'NGA@GMAIL.COM', 'ACCO'),
('123456789016', 'CHUNG', '47K12.2', '2001-09-15', 1, 'HUE', 'CHUNG@GMAIL.COM', 'MARK')
---
INSERT INTO ENROLLMENTS( Sno, Cno, Semester, SchoolYear)
values
('123456789012', 'ECO2001','1','2021-2022'),
('123456789013', 'ECO2001', '1', '2021-2022'),
('123456789014', 'MAR2001', '1', '2021-2022'),
('123456789015', 'MAR2001', '1', '2021-2022'),
('123456789016', 'MAR2001', '1', '2021-2022')
--Q3.
update COURSES
SET Cname='DATABASE', Credit=3
where Cno='ECO2001'
--Q4
update ENROLLMENTS
set Fee=Credit*500000
from COURSES inner join ENROLLMENTS on COURSES.Cno= ENROLLMENTS.Cno
--Q5
select Dno, count(*) as Course_count
from COURSES
group by Dno
order by Course_count DESC
--q6
select*from STUDENTS
where Sno in(Select top 10 Sno from ENROLLMENTS where Semester='1' and
SchoolYear='2021-2022'
group by Sno
order by count(*) desc)
--q7
select Cno, count(*) as Student_Count
from ENROLLMENTS
where Semester='1' and SchoolYear='2021-2022'
group by Cno
order by Student_Count desc
--q8
select*from STUDENTS
where Sno in(select Sno from ENROLLMENTS inner join COURSES on ENROLLMENTS.Cno=COURSES.Cno
where Semester='1' and SchoolYear='2021-2022'
group by Sno
having sum(credit)>20)
--q9
select Cno, count(*) as Student_Count
from ENROLLMENTS
WHERE Semester='1' and SchoolYear='2021-2022'
group by Cno
having count(*)<10
--q10
select Semester, Dname, Cname, Count(*) as Student_Count
from ENROLLMENTS inner join COURSES on ENROLLMENTS.Cno=COURSES.Cno
inner join STUDENTS ON ENROLLMENTS.Sno=STUDENTS.Sno
inner join DEPARTMENTS on COURSES.Dno=DEPARTMENTS.Dno
where SchoolYear='2021-2022'
group by Semester, Dname, Cname
order by Dname
--q11
select Cno, count(*) as Student_Count
from ENROLLMENTS
where Time_Enroll<='2023-12-20 12:00:00'
group by Cno
having count(*)>60
--
select Cno, count(*) as Student_Count
from ENROLLMENTS
where datepart(hour, Time_Enroll)<=12 and Time_Enroll<='2023-12-20'
group by Cno
having count(*)>60

