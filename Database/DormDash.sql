DROP DATABASE IF EXISTS DormDash;

CREATE DATABASE DormDash;

USE DormDash;

-- building nodes referenced by buildingname to take input from clients
-- no building name duplicates on the same campus
DROP TABLE IF EXISTS Building;

CREATE TABLE Building(
BuildingName varchar(50) not null,
PRIMARY KEY (BuildingName)
);

-- some buildings may have the same room number, but no individual building has duplicate room numbers
DROP TABLE IF EXISTS Rooms;

CREATE TABLE Rooms(
Room varchar(10) not null,
BuildingName varchar(50) not null,
PRIMARY KEY (BuildingName, Room),
FOREIGN KEY (BuildingName) REFERENCES Building(BuildingName) ON UPDATE CASCADE ON DELETE CASCADE
);

-- time from one building to another building, paths labeled by ints
DROP TABLE IF EXISTS Paths;

CREATE TABLE Paths (
PathId int auto_increment,
StartBuilding varchar(50) not null,
EndBuilding varchar(50) not null,
PathTime int not null,
PRIMARY KEY (PathId),
FOREIGN KEY (StartBuilding) REFERENCES Building(BuildingName)ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (EndBuilding) REFERENCES Building(BuildingName)ON DELETE CASCADE ON UPDATE CASCADE,
UNIQUE (StartBuilding, EndBuilding)
);

-- Each student has a student id, and if a student is an employee then their id is in the employee table
-- Each student has a building and room
DROP TABLE IF EXISTS Student;

CREATE TABLE Student (
StudentId int not null,
FirstName varchar(50)  not null,
LastName varchar(50)  not null,
PhoneNumber varchar(20) not null,
Email varchar(100) not null,
BuildingName varchar(50) not null,
Room varchar(10) not null,
PRIMARY KEY (StudentId),
FOREIGN KEY (BuildingName, Room) REFERENCES Rooms(BuildingName, Room) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Each employee is identified by their student id
-- Each employee has a designated time that they start their shift, and an end time that is 2 hours later
DROP TABLE IF EXISTS Employee;

CREATE TABLE Employee (
StudentId int not null,
StartTime time not null,
EndTime time generated always as (ADDTIME(StartTime, '02:00:00')),
PRIMARY KEY (StudentId),
FOREIGN KEY (StudentId) REFERENCES Student(StudentId) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS Inventory;

CREATE TABLE Inventory (
ItemName varchar(100) not null,
Quantity int not null,
PricePer decimal(10,2) not null,
PRIMARY KEY (ItemName)
);


-- Room doesn't have to be filled out (in the case where there is a library delivery)
-- pickup for library deliveries and dropoff for library deliveries are scheduled as 2 orders
DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders (
OrderId int auto_increment,
StudentId int not null,
OrderTime time not null,
OrderDate date not null,
BuildingName varchar(50) not null,
Room varchar(10),
PRIMARY KEY (OrderId),
FOREIGN KEY (StudentId) REFERENCES Student(StudentId) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (BuildingName, Room) REFERENCES Rooms(BuildingName, Room) ON UPDATE CASCADE ON DELETE CASCADE
);


-- how many of each item were purchased per order
DROP TABLE IF EXISTS OrdersItems;

CREATE TABLE OrderItems (
OrderId int,
ItemName varchar(100),
ItemQuantity int not null,
PRIMARY KEY (OrderId, ItemName),
FOREIGN KEY (OrderId) REFERENCES Orders(OrderId) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (ItemName) REFERENCES Inventory(ItemName) ON UPDATE CASCADE ON DELETE CASCADE
);



-- returns a result set of all employees who are on shift at a given time
DELIMITER $$

CREATE PROCEDURE GetAvailableEmployees(IN T TIME)
BEGIN
    SELECT EmployeeId, FirstName, LastName, StartTime, EndTime
    FROM Employee INNER JOIN Student ON Employee.StudentId = Student.StudentId
    WHERE StartTime <= T AND EndTime > T;
END $$



-- returns the weighted graph (how long it takes to travel from building to building)
CREATE PROCEDURE GetGraphInfo()
BEGIN
	SELECT StartBuilding, EndBuilding, PathTime FROM Paths;
END $$



-- used to add inventory (employees only)
CREATE PROCEDURE InputInventory(IN I varchar(100), IN Q int, P decimal(10,2))
BEGIN
	INSERT INTO Inventory(ItemName, Quantity, PricePer) VALUES (I, Q, P);
END $$



-- returns result set of the current inventory
CREATE PROCEDURE GetInventory()
BEGIN
	SELECT ItemName, Quantity, PricePer FROM Inventory;
END $$


-- returns a boolean (true if a student has ordered today, false if they havent)
CREATE FUNCTION StudentOrderedToday(I int, T Date)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
	IF I in (SELECT StudentId FROM Orders WHERE OrderDate = T) THEN
		RETURN True;
	ELSE
		RETURN False;
	END IF;
END $$


-- creates an order and returns the order id (for the purpose of inputting items to order with the OrderItems method
CREATE PROCEDURE CreateOrder(IN SI int, IN OT time, IN OD date, IN BN varchar(50), IN R varchar(10), OUT ID int)
BEGIN
	INSERT INTO Orders (StudentId, OrderTime, OrderDate, BuildingName, Room) VALUES (SI,OT,OD,BN,R);
    SET ID = LAST_INSERT_ID();
END $$


-- adds items to created order (CreateOrder and OrderItems are meant to be used in succession)
-- seperation is so that students can place one order for many different items
CREATE PROCEDURE OrderItems(IN O int, IN N varchar(100), IN Q int)
BEGIN
	INSERT INTO OrderItems(OrderId, ItemName, ItemQuantity) VALUES (O, N, Q);
END $$

DELIMITER ;


-- Inserts (Chatgpt generated):
INSERT INTO Building (BuildingName) VALUES
('Maple Hall'), ('Oak Hall'), ('Pine Hall'), ('Cedar Hall'), ('Birch Hall'),
('Elm Hall'), ('Ash Hall'), ('Willow Hall'), ('Spruce Hall'), ('Cherry Hall'),
('Hawthorn Hall'), ('Magnolia Hall'), ('Redwood Hall'), ('Sequoia Hall'), ('Palm Hall'),
('Cypress Hall'), ('Poplar Hall'), ('Fir Hall'), ('Juniper Hall'), ('Alder Hall'),
('Sycamore Hall'), ('Beech Hall'), ('Hemlock Hall'), ('Dogwood Hall'), ('Aspen Hall'),
('Chestnut Hall'), ('Walnut Hall'), ('Linden Hall'), ('Olive Hall'), ('Bamboo Hall');

INSERT INTO Rooms (BuildingName, Room) VALUES
('Maple Hall','101'), ('Oak Hall','101'), ('Pine Hall','101'), ('Cedar Hall','101'), ('Birch Hall','101'),
('Elm Hall','101'), ('Ash Hall','101'), ('Willow Hall','101'), ('Spruce Hall','101'), ('Cherry Hall','101'),
('Hawthorn Hall','101'), ('Magnolia Hall','101'), ('Redwood Hall','101'), ('Sequoia Hall','101'), ('Palm Hall','101'),
('Cypress Hall','101'), ('Poplar Hall','101'), ('Fir Hall','101'), ('Juniper Hall','101'), ('Alder Hall','101'),
('Sycamore Hall','101'), ('Beech Hall','101'), ('Hemlock Hall','101'), ('Dogwood Hall','101'), ('Aspen Hall','101'),
('Chestnut Hall','101'), ('Walnut Hall','101'), ('Linden Hall','101'), ('Olive Hall','101'), ('Bamboo Hall','101');

INSERT INTO Paths (StartBuilding, EndBuilding, PathTime) VALUES
('Maple Hall','Oak Hall',5),('Oak Hall','Pine Hall',4),
('Cedar Hall','Pine Hall',6),('Birch Hall','Cedar Hall',3),
('Birch Hall','Elm Hall',5),('Ash Hall','Elm Hall',7),
('Ash Hall','Willow Hall',4),('Spruce Hall','Willow Hall',6),
('Cherry Hall','Spruce Hall',5),('Cherry Hall','Hawthorn Hall',4),
('Hawthorn Hall','Magnolia Hall',6),('Magnolia Hall','Redwood Hall',7),
('Redwood Hall','Sequoia Hall',3),('Palm Hall','Sequoia Hall',6),
('Cypress Hall','Palm Hall',4),('Cypress Hall','Poplar Hall',5),
('Fir Hall','Poplar Hall',6),('Fir Hall','Juniper Hall',4),
('Alder Hall','Juniper Hall',5),('Alder Hall','Sycamore Hall',6),
('Beech Hall','Sycamore Hall',4),('Beech Hall','Hemlock Hall',5),
('Dogwood Hall','Hemlock Hall',6),('Aspen Hall','Dogwood Hall',4),
('Aspen Hall','Chestnut Hall',5),('Chestnut Hall','Walnut Hall',6),
('Linden Hall','Walnut Hall',4),('Linden Hall','Olive Hall',5),
('Bamboo Hall','Olive Hall',6),('Bamboo Hall','Maple Hall',7);

INSERT INTO Student VALUES
(1,'John','Smith','1111111111','john1@email.com','Maple Hall','101'),
(2,'Emma','Johnson','1111111112','emma2@email.com','Oak Hall','101'),
(3,'Liam','Brown','1111111113','liam3@email.com','Pine Hall','101'),
(4,'Olivia','Jones','1111111114','olivia4@email.com','Cedar Hall','101'),
(5,'Noah','Garcia','1111111115','noah5@email.com','Birch Hall','101'),
(6,'Ava','Miller','1111111116','ava6@email.com','Elm Hall','101'),
(7,'Elijah','Davis','1111111117','elijah7@email.com','Ash Hall','101'),
(8,'Sophia','Martinez','1111111118','sophia8@email.com','Willow Hall','101'),
(9,'James','Hernandez','1111111119','james9@email.com','Spruce Hall','101'),
(10,'Isabella','Lopez','1111111120','isabella10@email.com','Cherry Hall','101'),
(11,'Benjamin','Gonzalez','1111111121','ben11@email.com','Hawthorn Hall','101'),
(12,'Mia','Wilson','1111111122','mia12@email.com','Magnolia Hall','101'),
(13,'Lucas','Anderson','1111111123','lucas13@email.com','Redwood Hall','101'),
(14,'Charlotte','Thomas','1111111124','charlotte14@email.com','Sequoia Hall','101'),
(15,'Henry','Taylor','1111111125','henry15@email.com','Palm Hall','101'),
(16,'Amelia','Moore','1111111126','amelia16@email.com','Cypress Hall','101'),
(17,'Alexander','Jackson','1111111127','alex17@email.com','Poplar Hall','101'),
(18,'Harper','Martin','1111111128','harper18@email.com','Fir Hall','101'),
(19,'Daniel','Lee','1111111129','daniel19@email.com','Juniper Hall','101'),
(20,'Evelyn','Perez','1111111130','evelyn20@email.com','Alder Hall','101'),
(21,'Matthew','Thompson','1111111131','matt21@email.com','Sycamore Hall','101'),
(22,'Abigail','White','1111111132','abby22@email.com','Beech Hall','101'),
(23,'Joseph','Harris','1111111133','joe23@email.com','Hemlock Hall','101'),
(24,'Emily','Sanchez','1111111134','emily24@email.com','Dogwood Hall','101'),
(25,'Samuel','Clark','1111111135','sam25@email.com','Aspen Hall','101'),
(26,'Elizabeth','Ramirez','1111111136','liz26@email.com','Chestnut Hall','101'),
(27,'David','Lewis','1111111137','david27@email.com','Walnut Hall','101'),
(28,'Sofia','Robinson','1111111138','sofia28@email.com','Linden Hall','101'),
(29,'Logan','Walker','1111111139','logan29@email.com','Olive Hall','101'),
(30,'Ella','Young','1111111140','ella30@email.com','Bamboo Hall','101');

INSERT INTO Employee (StudentId, StartTime) VALUES
(1,'08:00:00'), (3,'10:00:00'), (5,'12:00:00'),
(6,'13:00:00'), (8,'15:00:00'), (9,'16:00:00'), 
(11,'08:30:00'), (12,'09:30:00'), (13,'10:30:00'), 
(15,'12:30:00'), (19,'16:30:00'), (20,'17:30:00'),
(21,'08:15:00'), (24,'11:15:00'), (25,'12:15:00'),
(26,'13:15:00'), (27,'14:15:00');

INSERT INTO Inventory VALUES
('Water Bottle',100,1.50), ('Chips',100,2.00), ('Candy',100,1.25),
('Notebook',50,3.00), ('Pen',200,0.75), ('Pencil',200,0.50),
('Soda',100,2.50), ('Juice',100,2.75), ('Sandwich',50,5.00),
('Salad',40,6.50), ('Pizza Slice',60,3.50), ('Coffee',80,2.25),
('Tea',80,2.00), ('Energy Drink',60,3.00), ('Protein Bar',70,2.75),
('Cookies',90,2.50), ('Crackers',100,2.00), ('Milk',80,2.25),
('Yogurt',70,2.50), ('Fruit Cup',60,3.00), ('Granola',50,2.75),
('Bagel',50,2.00), ('Muffin',50,2.50), ('Ice Cream',40,3.50),
('Cereal',30,4.00), ('Ramen',100,1.50), ('Mac and Cheese',80,2.50),
('Chicken Wrap',40,6.00), ('Burger',30,7.50), ('Fries',60,3.00);

INSERT INTO Orders (StudentId, OrderTime, OrderDate, BuildingName, Room) VALUES
(1,'12:00:00','2026-04-01','Maple Hall','101'),
(2,'12:05:00','2026-04-01','Oak Hall','101'),
(3,'12:10:00','2026-04-01','Pine Hall','101'),
(4,'12:15:00','2026-04-01','Cedar Hall','101'),
(5,'12:20:00','2026-04-01','Birch Hall','101'),
(6,'12:25:00','2026-04-01','Elm Hall','101'),
(7,'12:30:00','2026-04-01','Ash Hall','101'),
(8,'12:35:00','2026-04-01','Willow Hall','101'),
(9,'12:40:00','2026-04-01','Spruce Hall','101'),
(10,'12:45:00','2026-04-01','Cherry Hall','101'),
(11,'12:50:00','2026-04-01','Hawthorn Hall','101'),
(12,'12:55:00','2026-04-01','Magnolia Hall','101'),
(13,'13:00:00','2026-04-01','Redwood Hall','101'),
(14,'13:05:00','2026-04-01','Sequoia Hall','101'),
(15,'13:10:00','2026-04-01','Palm Hall','101'),
(16,'13:15:00','2026-04-01','Cypress Hall','101'),
(17,'13:20:00','2026-04-01','Poplar Hall','101'),
(18,'13:25:00','2026-04-01','Fir Hall','101'),
(19,'13:30:00','2026-04-01','Juniper Hall','101'),
(20,'13:35:00','2026-04-01','Alder Hall','101'),
(21,'13:40:00','2026-04-01','Sycamore Hall','101'),
(22,'13:45:00','2026-04-01','Beech Hall','101'),
(23,'13:50:00','2026-04-01','Hemlock Hall','101'),
(24,'13:55:00','2026-04-01','Dogwood Hall','101'),
(25,'14:00:00','2026-04-01','Aspen Hall','101'),
(26,'14:05:00','2026-04-01','Chestnut Hall','101'),
(27,'14:10:00','2026-04-01','Walnut Hall','101'),
(28,'14:15:00','2026-04-01','Linden Hall','101'),
(29,'14:20:00','2026-04-01','Olive Hall','101'),
(30,'14:25:00','2026-04-01','Bamboo Hall','101');

INSERT INTO OrderItems (OrderId, ItemName, ItemQuantity) VALUES
(1,'Water Bottle',2),
(2,'Chips',1),
(3,'Candy',3),
(4,'Notebook',1),
(5,'Pen',5),
(6,'Pencil',5),
(7,'Soda',2),
(8,'Juice',1),
(9,'Sandwich',1),
(10,'Salad',1),
(11,'Pizza Slice',2),
(12,'Coffee',2),
(13,'Tea',1),
(14,'Energy Drink',1),
(15,'Protein Bar',2),
(16,'Cookies',2),
(17,'Crackers',1),
(18,'Milk',1),
(19,'Yogurt',1),
(20,'Fruit Cup',1),
(21,'Granola',1),
(22,'Bagel',2),
(23,'Muffin',1),
(24,'Ice Cream',1),
(25,'Cereal',1),
(26,'Ramen',2),
(27,'Mac and Cheese',1),
(28,'Chicken Wrap',1),
(29,'Burger',1),
(30,'Fries',1);
