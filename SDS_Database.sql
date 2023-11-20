--use master
DROP DATABASE IF EXISTS SDS_Database
create database SDS_Database
use SDS_Database
go


--drop tables
drop table Acquisition
drop table AcquisitionModel
drop table Reservation
drop table Loan
drop table Immovable
drop table Movable
drop table Resource
drop table CourseOffering_Privilege
drop table Privilege
drop table CategoryKeywords
drop table Category
drop table Student_CourseOffering
drop table CourseOffering
drop table Course
drop table Student
drop table Staff
drop table Member
go


--MEMBER TABLE
CREATE TABLE Member(
memberID	char(10) NOT NULL,
fName		varchar(20) NOT NULL,	
lName		varchar(20) NOT NULL,
dateOfBirth	date NOT NULL,
address		varchar(50),
phoneNo		int,
email		varchar(50),
status		varchar(10) DEFAULT 'Active' CHECK (Status IN ('Active', 'Inactive')) NOT NULL,
comment		varchar(50),
PRIMARY KEY(memberID));

--STAFF TABLE
CREATE TABLE Staff(
memberID		char(10) NOT NULL,
schoolPosition	varchar(20) NOT NULL,
employeeHistory varchar(50),
isAdmin			bit DEFAULT '1' NOT NULL, -- 1 = true, 0 = false
PRIMARY KEY(memberID),
FOREIGN KEY(memberID) references Member(memberID) on update cascade on delete no action);

--STUDENT TABLE
CREATE TABLE Student(
memberID	char(10) NOT NULL,
points		smallint DEFAULT '12',
PRIMARY KEY(memberID),
FOREIGN KEY(memberID) references Member(memberID) on update cascade on delete no action);

--COURSE TABLE
CREATE TABLE Course(
courseID	char(8) NOT NULL,
courseName	varchar(50) NOT NULL,
PRIMARY KEY(courseID));

--COURSEOFFERING TABLE
CREATE TABLE CourseOffering(
offeringID		int identity(1,1) NOT NULL,
semesterOffered char(1) NOT NULL,
yearOffered		char(4) NOT NULL,
courseBeginDate	date NOT NULL,
courseEndDate	date NOT NULL,
courseID		char(8) NOT NULL,
PRIMARY KEY(offeringID),
FOREIGN KEY(courseID) references Course(courseID) on update cascade on delete no action);

--STUDENT_COURSEOFFERING TABLE
CREATE TABLE Student_CourseOffering(
memberID	char(10) NOT NULL,
offeringID	int NOT NULL,
PRIMARY KEY(memberID, offeringID),
FOREIGN KEY(memberID) references Student(memberID) on update cascade on delete cascade,
FOREIGN KEY(offeringID) references CourseOffering(offeringID) on update cascade on delete cascade);

--CATEGORY TABLE
CREATE TABLE Category(
categoryCode	int identity(1,1) NOT NULL,
name			varchar(20) NOT NULL,
description		varchar(50) NOT NULL,
maxBorrowHours	int NOT NULL,
resourceType	varchar(15) NOT NULL
PRIMARY KEY(categoryCode));

--CATEGORYKEYWORDS TABLE
CREATE TABLE CategoryKeywords(
categoryCode	int NOT NULL,
keywords		varchar(15)	NOT NULL,
PRIMARY KEY(categoryCode, keywords),
FOREIGN KEY(categoryCode) references Category(categoryCode) on update cascade on delete cascade);

--PRIVILEGE TABLE
CREATE TABLE Privilege(
privilegeID		int identity(1,1) NOT NULL,
name			varchar(20) NOT NULL,	
description		varchar(50) NOT NULL,
maxResources	smallint NOT NULL,
categoryCode	int NOT NULL,	
PRIMARY KEY(privilegeID),
FOREIGN KEY(categoryCode) references Category(categoryCode) on update cascade on delete no action);

--COURSEOFFERING_PRIVILEGE TABLE
CREATE TABLE CourseOffering_Privilege(
offeringID		int NOT NULL,
privilegeID		int NOT NULL,
PRIMARY KEY(offeringID, privilegeID),
FOREIGN KEY(offeringID) references CourseOffering(offeringID) on update cascade on delete cascade,
FOREIGN KEY(privilegeID) references Privilege(privilegeID) on update cascade on delete cascade);

--RESOURCES TABLE
CREATE TABLE Resource(
resourceID		char(10) NOT NULL,
description		varchar(50) NOT NULL,
presentStatus	varchar(15) DEFAULT 'Available' CHECK (presentStatus IN ('Available', 'Lost', 'Borrowed', 'Reserved', 'Maintenance')) NOT NULL,
categoryCode	int,	
PRIMARY KEY(resourceID),
FOREIGN KEY(categoryCode) references Category(categoryCode) on update cascade on delete no action);

--MOVABLE TABLE
CREATE TABLE Movable(
resourceID		char(10) NOT NULL,
name			varchar(20) NOT NULL,
manufacturer	varchar(20) NOT NULL,
model			varchar(15) NOT NULL,
year			char(10) NOT NULL,
assetValue		decimal(6) NOT NULL,
buildingBDS		varchar(10) NOT NULL,
PRIMARY KEY(resourceID),
FOREIGN KEY(resourceID) references Resource(resourceID) on update cascade on delete no action);

--IMMOVABLE TABLE
CREATE TABLE Immovable(
resourceID	char(10) NOT NULL,
capacity	smallint NOT NULL,
room		varchar(10) NOT NULL,
building	varchar(10) NOT NULL,
campus		varchar(20) NOT NULL,
PRIMARY KEY(resourceID),
FOREIGN KEY(resourceID) references Resource(resourceID) on update cascade on delete no action);

--LOAN TABLE
CREATE TABLE Loan(
loanID				int identity(1,1) NOT NULL,
dateTimeBorrowed	datetime,
dateTimeReturned	datetime,
dateTimeDue			datetime,
memberID			char(10) NOT NULL,
resourceID			char(10) NOT NULL,
PRIMARY KEY(loanID),
FOREIGN KEY(memberID) references Member(memberID) on update cascade on delete no action,
FOREIGN KEY(resourceID) references Movable(resourceID) on update cascade on delete no action);

--RESERVATION TABLE
CREATE TABLE Reservation(
reservationID	int identity(1,1) NOT NULL,
isCancelled		bit DEFAULT '0' NOT NULL, -- 1 = true, 0 = false
pickupUseDate	datetime,
returnDueDate	datetime,
memberID		char(10) NOT NULL,
resourceID		char(10) NOT NULL,
PRIMARY KEY(reservationID),
FOREIGN KEY(memberID) references Member(memberID) on update cascade on delete no action,
FOREIGN KEY(resourceID) references Resource(resourceID) on update cascade on delete no action);

--ACQUISITIONMODEL TABLE
CREATE TABLE AcquisitionModel(
model		varchar(15) NOT NULL,
description varchar(50) NOT NULL, 
PRIMARY KEY(model));

--ACQUISITION TABLE
CREATE TABLE Acquisition(
acquisitionID int identity(1,1) NOT NULL,
itemName		varchar(20) NOT NULL,
manufacturer	varchar(20) NOT NULL,
year			char(4) NOT NULL,
urgency			varchar(20) NOT NULL,
model			varchar(15) NOT NULL,
memberID		char(10) NOT NULL,
PRIMARY KEY(acquisitionID),
FOREIGN KEY(model) references AcquisitionModel(model) on update cascade on delete no action,
FOREIGN KEY(memberID) references Member(memberID) on update cascade on delete no action);
go


--MEMBER DATA
INSERT INTO Member VALUES
('M0001', 'John', 'Briar', '1999-11-27', null, '0412874785', 'adjedan6@hotmail.com', default, 'good student'),
('M0002', 'Nicholas', 'Greene', '1986-08-22', '74 Tooraweenah Road Grawlin', '0440366836', null, 'Active', null),
('M0003', 'Alexandra', 'Lorenz', '1993-12-20', '5 Cecil Street Dundas', '0496034933', 'swinkler7@gmail.com', 'Active', null),
('M0004', 'Valerie', 'Eula', '1990-03-13', null, '0453589617', 'valerie@gmail.com', 'Active', 'excellent teacher'),
('M0005', 'Rolland', 'Owens', '2001-05-11', '28 Walpole Avenue Woolsthorpe', null, 'ronin14@outlook.com', 'Active', null),
('M0006', 'Darwin', 'Mann', '1979-03-18', '46 Berambing Crescent', '0441577215', 'fwiw9774@gmail.com', 'Active', null),
('M0007', 'Monique', 'Sullivan', '2001-08-19', '23 Martens Place', null, 'monisull72@gmail.com', 'Active', 'overdue loan'),
('M0008', 'Tara', 'Peters', '1991-04-15', '48 Avondale Drive', '0492038974', 'donnis312@hotmail.com', 'Active', null),
('M0009', 'Charles', 'Short', '1988-06-20', null, '0453319155', null, 'Active', 'contact for system problems'),
('M0010', 'Mike', 'Hobbs', '1997-05-03', '19 Creegans Road', '0467954254', null, 'Inactive', 'student has completed studies')
go

--STAFF DATA
INSERT INTO Staff VALUES
('M0002', 'Professor', null, '0'),
('M0004', 'Professor', null, '1'),
('M0006', 'System Admin', 'System Admin for EnvoTech', '1'),
('M0009', 'HR Officer', null, '0')
go

--STUDENT DATA
INSERT INTO Student VALUES
('M0001', '12'),
('M0003', '11'),
('M0005', '12'),
('M0007', '6'),
('M0008', default),
('M0010', '8')
go

--COURSE DATA
INSERT INTO Course VALUES
('INFT1060', 'CyberSecurity Fundamentals'), --1
('SENG1120', 'Data Structures'),			--2
('FNPS1001', 'Engineering Physics 1'),		--3
('STAT2020', 'Predictive Analytics')		--4
go

--COURSEOFFERING DATA
INSERT INTO CourseOffering VALUES
('1', '2022', '2022-02-26', '2022-05-03', 'INFT1060'),
('1', '2022', '2022-02-26', '2022-05-03', 'SENG1120'),
('2', '2022', '2022-06-18', '2022-10-27', 'SENG1120'),
('1', '2022', '2022-02-26', '2022-05-03', 'FNPS1001'),
('2', '2022', '2022-06-18', '2022-10-27', 'STAT2020')
go

--STUDENT_COURSEOFFERING DATA
INSERT INTO Student_CourseOffering VALUES
('M0001', '1'),
('M0001', '2'),
('M0003', '1'),
('M0003', '3'),
('M0003', '4'),
('M0005', '3'),
('M0005', '4'),
('M0007', '2'),
('M0007', '3'),
('M0008', '1'),
('M0008', '4'),
('M0008', '2')
go

--CATEGORY DATA
INSERT INTO Category VALUES
('Speaker', 'All types of speakers other than headphones', '6', 'Audio'),	--1
('Headphone', 'All type of headphones', '6', 'Audio'),						--2
('Camera', 'All types of cameras and lenses', '12', 'Camera'),				--3
('Laptop', 'Less than 3kg', '36', 'Computer'),								--4
('Lab', 'Laboratory/Computer Rooms,', '2', 'Room'),							--5
('Study Room', 'Rooms for studying', '6', 'Room')							--6
go

--CATEGORYKEYWORDS DATA
INSERT INTO CategoryKeywords VALUES
('1', 'wireless'),
('1', 'speakers'),
('2', 'headphones'),
('2', 'Over-Ear'),
('3', 'Telephoto'),
('4', 'Powerful'),
('4', 'DDR3'),
('5', 'Laboratory'),
('5', 'Activities'),
('6', 'Study')
go

--PRIVILEGE DATA
INSERT INTO Privilege VALUES
('Speakers', 'Allowed to borrow ', '2', '1'),				--1
('Headphones', 'Allowed to borrow ', '2', '2'),				--2
('Cameras', 'Allowed to borrow ', '2', '3'),				--3
('Laptops', 'Allowed to borrow ', '1', '4'),				--4
('Labs', 'Allowed to reserve lab rooms', '1', '5'),			--5
('Study Rooms', 'Allowed to reserve study rooms', '1', '6')	--6
go

--COURSEOFFERING_PRIVILEGE DATA
INSERT INTO CourseOffering_Privilege VALUES
('1', '2'), --INFT1060, Headphones
('1', '4'), --INFT1060, Laptops
('1', '5'), --INFT1060, Labs
('2', '4'), --SENG1120, Laptops
('2', '5'), --SENG1120, Labs
('3', '1'), --FNPS1001, Speakers
('3', '3'), --FNPS1001, Cameras
('3', '4'), --FNPS1001, Laptops
('3', '6'), --FNPS1001, Study Rooms
('4', '1'), --STAT2020, Speakers
('4', '5')  --STAT2020, Labs
go

--RESOURCE DATA
INSERT INTO Resource VALUES
('MR00001', 'bluetooth 50W speaker', 'available', '1'),
('MR00002', 'large speaker', 'available', '1'),
('MR00003', 'high-end headphone', 'available', '2'),
('MR00004', 'on-ear headphone', 'available', '2'),
('MR00005', '16X optical super telephoto lens', 'available', '3'),
('MR00006', 'ND filter (3-stop) on/auto/off', 'available', '3'),
('MR00007', 'N3050 1.3GHZ 4GB DDR3', default, '4'),
('MR00008', 'stylish and powerful device', 'available', '3'),
('MR00009', 'high power laptop', 'available', '4'),
('MR00010', '12 gb ram laptop with large screen', 'available', '4'),
--('MR00011', '', 'available', ''),
('ICT-325', 'study room1 in UON Callaghan campus', 'available', '5'),
('ICT-326', 'study room1 in UON Callaghan campus', default, '5'),
('ICT-327', 'lab1 in UON Callaghan campus', 'available', '6'),
('ICT-328', 'lab2 in UON Callaghan campus', 'available', '6')
go

--MOVABLE DATA
INSERT INTO Movable VALUES

('MR00001', '50W speaker', 'SONY', 'SX11', '2015', '96.00', 'ICT'),
('MR00002', 'USB speaker', 'Phillips', 'WE68', '2011', '35.00', 'ESCS'), 
('MR00003', 'headphone', 'Phillips', 'HD390', '2020', '187.00', 'ICT'),
('MR00004', 'headphone', 'YAMAHA', 'Pro-Series', '2007', '98.00', 'CT'),
('MR00005', '300m telephoto lens', 'LTPS', '16MP', '2021', '206.00', 'ICT'),
('MR00006', 'ultraviolet filter', 'Canon', 'G9X', '2017', '699.00', 'CT'),
('MR00007', 'laptop medium power', 'ACER', 'R3-131T', '2016', '382.00', 'SR'),
('MR00008', 'small olympus camera', 'Olympus', 'E-M10', '2020', '72.00', 'ICT'),
('MR00009', 'lenovo laptop', 'Lenovo', '300-151SK', '2019', '799.00', 'ICT'),
('MR00010', '12gb laptop', 'Pavilion', 'E-M10', '2022', '299.00', 'ICT')
go

--IMMOVABLE DATA
INSERT INTO Immovable VALUES
('ICT-325', '60', '325', 'ICT', 'Callaghan'),
('ICT-326', '60', '326', 'ICT', 'Callaghan'),
('ICT-327', '42', '327', 'ICT', 'Callaghan'),
('ICT-328', '40', '328', 'ICT', 'Callaghan')
--go

--LOAN DATA
INSERT INTO Loan VALUES
('2022-10-02 14:00:00', '2022-10-02 20:00:00', '2022-10-03 2:00:00', 'M0005', 'MR00008'),
('2022-09-21 12:00:00', '2022-09-21 17:00:00', '2022-09-21 18:00:00', 'M0003', 'MR00002'),
('2022-10-04 7:00:00', '2022-10-04 17:00:00', '2022-10-04 19:00:00', 'M0003', 'MR00008'),
('2022-10-18 11:00:00', null, '2022-10-19 23:00:00', 'M0008', 'MR00007'),
('2022-10-15 8:00:00', '2022-10-15 18:00:00', null, 'M0004', 'MR00001'), --staff with no due date
('2022-10-17 8:00:00', null, '2022-10-17 14:00:00', 'M0007', 'MR00003') --overdue
--added next two for Q4 examples
--('2021-05-09 9:00:00', '2021-05-10 9:00:00', '2021-05-10 21:00:00', 'M0003', 'MR00008'), --camera model E-M10 diff year
--('2022-05-09 9:00:00', '2022-05-10 9:00:00', '2022-05-10 21:00:00', 'M0003', 'MR00010') --laptop same model as a camera
go

--RESERVATION DATA
INSERT INTO Reservation VALUES
('0', '2021-03-19 9:00:00', '2021-03-19 11:00:00', 'M0004', 'ICT-327'),
('0', '2022-10-07 13:00:00', '2022-10-07 15:00:00', 'M0004', 'ICT-328'),
('0', '2022-10-24 11:00:00', '2022-10-24 17:00:00', 'M0002', 'ICT-326'),
('0', '2022-10-25 14:00:00', '2022-10-25 16:00:00', 'M0007', 'ICT-328'),
('1', NULL, NULL, 'M0003', 'ICT-327'),
(default, '2022-05-01 9:00:00', '2022-05-01 15:00:00', 'M0001', 'ICT-325'),
('0', '2022-06-05 12:00:00', '2022-06-05 18:00:00', 'M0009', 'ICT-325'),
('0', '2022-09-19 10:00:00', '2022-09-19 16:00:00', 'M0004', 'ICT-325'), 
--('0', '2022-10-25 10:00:00', '2022-10-25 16:00:00', 'M0004', 'ICT-325'),
('0', '2022-09-19 14:00:00', '2022-09-19 20:00:00', 'M0008', 'ICT-325')
go

--ACQUISITIONMODEL DATA
INSERT INTO AcquisitionModel VALUES
('DRP100', 'accurate sound and extreme audio isolation'),
('LQ-53', '3.5mm lightning in-ear headphones'),
('HD-794', 'high performance SLR camera'),
('400-15K', 'premium precision laptop')
go

--ACQUISITION DATA
INSERT INTO Acquisition VALUES
('drum headphones', 'Alesis', '2020', 'Not needed quickly', 'DRP100', 'M0001'),
('in-ear headphones', 'Apple', '2016', 'Very urgent', 'LQ-53', 'M0003'),
('photo camera', 'Nikon', '2019', 'Need soon', 'HD-794', 'M0005'),
('flipbook laptop', 'ASUS', '2018', 'Not urgent, can wait', '400-15K', 'M0007')
go


--SQL QUERIES

-- Q1: Name of students who have enrolled in courseID INFT1060
select m.fname as 'First Name of Student in INFT1060', m.lname as 'Last Name of Student in INFT1060'
from member m, course c, courseoffering co, Student_CourseOffering sc
where m.memberID = sc.memberID
	and c.courseID = co.courseID
	and co.offeringID = sc.offeringID
	and co.courseID = 'INFT1060';


--cleaner version, but also prints memberID
select m.memberID as 'Students enrolled in INFT1060', m.fname, m.lname
from member m, course c, courseoffering co, Student_CourseOffering sc
where m.memberID = sc.memberID
	and c.courseID = co.courseID
	and co.offeringID = sc.offeringID
	and co.courseID = 'INFT1060';
	


-- Q2: Maximum number of speakers that student Rolland Owens can borrow 
-- V1: using sum to add maxResources. (change to distinct for if not adding them)
select sum(p.maxResources) as 'Max number of speakers Rolland Owens can borrow'
from category c, member m, privilege p, Student_CourseOffering sco, CourseOffering_Privilege cop 
where c.name = 'speaker'
	and m.fname = 'rolland'
	and m.lname = 'owens'
	and p.categoryCode = c.categoryCode
	and sco.offeringID = cop.offeringID
	and p.privilegeID = cop.privilegeID
	and m.memberID = sco.memberID;

-- V2: showing each maxResources and the course that grants them. (note added courseOffering)
select (p.maxResources) as 'Max number of speakers Rolland Owens can borrow', co.courseID as 'granted by'
from category c, member m, privilege p, Student_CourseOffering sco, CourseOffering_Privilege cop, CourseOffering co 
where c.name = 'speaker'
	and m.fname = 'rolland'
	and m.lname = 'owens'
	and p.categoryCode = c.categoryCode
	and sco.offeringID = cop.offeringID
	and p.privilegeID = cop.privilegeID
	and m.memberID = sco.memberID
	and co.offeringID = sco.offeringID; --added line



-- Q3: For Staff with ID number M0004, print name, phone, total reservations made in 2022
select m.fname, m.lname, m.phoneNo, count(r.reservationID) as 'total reservations in 2022'
from member m, reservation r
where m.memberID = 'M0004'
	and m.memberID = r.memberID
	and r.pickupUseDate between '2022-01-01' and '2022-12-31'
group by m.fname, m.lname, m.phoneNo;



-- Q4: Names of students who have borrowed from category camera with model E-M10 this year.
select m.fname, m.lname
from member m, loan l, category c, movable mr, resource r
where m.memberID = l.memberID
	and mr.resourceID = l.resourceID
	and r.resourceID = l.resourceID 
	and r.categoryCode = c.categorycode
	and c.name = 'camera'
	and mr.model = 'E-M10'
	and year(l.dateTimeBorrowed) = year(SYSDATETIME());



-- Q5: Find movable resource that is the most loaned in current month. Print name/ID
select mr.resourceID, mr.name 
from movable mr, loan l
where mr.resourceID = l.resourceID
	and month(l.dateTimeBorrowed) = month(SYSDATETIME()) --can also use getdate()
	and year(l.dateTimeBorrowed) = year(SYSDATETIME())
group by mr.resourceID, mr.name
having count(*) >= All
	(Select count(*)
	from movable mr, loan l
	where mr.resourceID = l.resourceID
	and month(l.dateTimeBorrowed) = month(SYSDATETIME())
	and year(l.dateTimeBorrowed) = year(SYSDATETIME())
	group by mr.resourceID); 



-- Q6: For the three days (01-May-2022, 05-June-2022, 19-Sep-2022), print date, room name, and 
-- total reservations made for room ICT-325 on each day.
select cast(r.pickupUseDate as date) as 'Reservation date', i.room, count(r.pickupUseDate) as '# of reservations'
from reservation r left join immovable i on (r.resourceID = i.resourceID)
where i.room = '325'
	--cast datetime to date
	and cast(r.pickupUseDate as date) in ('2022-05-01', '2022-06-05', '2022-09-19')
	group by cast(r.pickupUseDate as date), i.room;
go
