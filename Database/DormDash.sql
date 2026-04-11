DROP DATABASE IF EXISTS DormDash;

CREATE DATABASE DormDash;

USE DormDash;

DROP TABLE IF EXISTS Deliveries;
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Paths;
DROP TABLE IF EXISTS Rooms;
DROP TABLE IF EXISTS Building;

CREATE TABLE Building (
    BuildingName VARCHAR(50) NOT NULL,
    PRIMARY KEY (BuildingName)
);

CREATE TABLE Rooms (
    Room VARCHAR(10) NOT NULL,
    BuildingName VARCHAR(50) NOT NULL,
    PRIMARY KEY (BuildingName, Room),
    FOREIGN KEY (BuildingName) REFERENCES Building(BuildingName)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE Paths (
    PathId INT AUTO_INCREMENT,
    StartBuilding VARCHAR(50) NOT NULL,
    EndBuilding VARCHAR(50) NOT NULL,
    PathTime INT NOT NULL,
    PRIMARY KEY (PathId),
    FOREIGN KEY (StartBuilding) REFERENCES Building(BuildingName)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (EndBuilding) REFERENCES Building(BuildingName)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    UNIQUE (StartBuilding, EndBuilding)
);

CREATE TABLE Student (
    StudentId INT NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    BuildingName VARCHAR(50) NOT NULL,
    Room VARCHAR(10) NOT NULL,
    PRIMARY KEY (StudentId),
    FOREIGN KEY (BuildingName, Room) REFERENCES Rooms(BuildingName, Room)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE Employee (
    StudentId INT NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME GENERATED ALWAYS AS (ADDTIME(StartTime, '02:00:00')),
    PRIMARY KEY (StudentId),
    FOREIGN KEY (StudentId) REFERENCES Student(StudentId)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE Inventory (
    ItemName VARCHAR(100) NOT NULL,
    Quantity INT NOT NULL,
    PricePer DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (ItemName)
);

CREATE TABLE Orders (
    OrderId INT AUTO_INCREMENT,
    StudentId INT NOT NULL,
    OrderTime TIME NOT NULL,
    OrderDate DATE NOT NULL,
    BuildingName VARCHAR(50) NOT NULL,
    Room VARCHAR(10) NOT NULL,
    PRIMARY KEY (OrderId),
    FOREIGN KEY (StudentId) REFERENCES Student(StudentId)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (BuildingName, Room) REFERENCES Rooms(BuildingName, Room)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    UNIQUE (StudentId, OrderDate)
);

CREATE TABLE OrderItems (
    OrderId INT NOT NULL,
    ItemName VARCHAR(100) NOT NULL,
    ItemQuantity INT NOT NULL,
    PRIMARY KEY (OrderId, ItemName),
    FOREIGN KEY (OrderId) REFERENCES Orders(OrderId)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (ItemName) REFERENCES Inventory(ItemName)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE Deliveries (
    DeliveryId INT AUTO_INCREMENT,
    OrderId INT NOT NULL,
    EmployeeId INT NOT NULL,
    DeliveryTime TIME NOT NULL,
    DeliveryDay DATE NOT NULL,
    TimeTaken INT NOT NULL,
    PRIMARY KEY (DeliveryId),
    FOREIGN KEY (OrderId) REFERENCES Orders(OrderId)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (EmployeeId) REFERENCES Employee(StudentId)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DELIMITER $$

CREATE PROCEDURE GetAvailableEmployees(IN T TIME)
BEGIN
    SELECT Employee.StudentId, Student.FirstName, Student.LastName, Employee.StartTime, Employee.EndTime
    FROM Employee
    INNER JOIN Student ON Employee.StudentId = Student.StudentId
    WHERE Employee.StartTime <= T AND Employee.EndTime > T;
END $$

CREATE PROCEDURE GetGraphInfo()
BEGIN
    SELECT StartBuilding, EndBuilding, PathTime
    FROM Paths;
END $$

CREATE PROCEDURE InputInventory(IN I VARCHAR(100), IN Q INT, IN P DECIMAL(10,2))
BEGIN
    INSERT INTO Inventory(ItemName, Quantity, PricePer)
    VALUES (I, Q, P)
    ON DUPLICATE KEY UPDATE
        Quantity = Quantity + Q,
        PricePer = P;
END $$

CREATE PROCEDURE GetInventory()
BEGIN
    SELECT ItemName, Quantity, PricePer
    FROM Inventory;
END $$

CREATE FUNCTION StudentOrderedToday(I INT, T DATE)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM Orders
        WHERE StudentId = I AND OrderDate = T
    );
END $$

CREATE PROCEDURE CreateOrder(
    IN SI INT,
    IN OT TIME,
    IN OD DATE,
    IN BN VARCHAR(50),
    IN R VARCHAR(10),
    OUT ID INT
)
BEGIN
    INSERT INTO Orders (StudentId, OrderTime, OrderDate, BuildingName, Room)
    VALUES (SI, OT, OD, BN, R);

    SET ID = LAST_INSERT_ID();
END $$

CREATE PROCEDURE AddOrderItem(
    IN O INT,
    IN N VARCHAR(100),
    IN Q INT,
    OUT P BOOLEAN
)
BEGIN
    DECLARE CurrentQuantity INT;

    SELECT Quantity INTO CurrentQuantity
    FROM Inventory
    WHERE ItemName = N;

    IF CurrentQuantity IS NOT NULL AND Q <= CurrentQuantity THEN
        INSERT INTO OrderItems(OrderId, ItemName, ItemQuantity)
        VALUES (O, N, Q);

        UPDATE Inventory
        SET Quantity = Quantity - Q
        WHERE ItemName = N;

        SET P = TRUE;
    ELSE
        SET P = FALSE;
    END IF;
END $$

CREATE PROCEDURE CreateDelivery(
    IN O INT,
    IN E INT,
    IN T TIME,
    IN D DATE,
    IN TT INT
)
BEGIN
    INSERT INTO Deliveries(OrderId, EmployeeId, DeliveryTime, DeliveryDay, TimeTaken)
    VALUES (O, E, T, D, TT);
END $$

CREATE PROCEDURE DeliveryPathOfEmployee(IN E INT, IN D DATE)
BEGIN
    SELECT Orders.BuildingName, Orders.Room
    FROM Deliveries
    INNER JOIN Orders ON Deliveries.OrderId = Orders.OrderId
    WHERE Deliveries.EmployeeId = E
      AND Deliveries.DeliveryDay = D
    ORDER BY Deliveries.DeliveryTime;
END $$

CREATE PROCEDURE GoodsDeliveredByEmployee(IN E INT, IN D DATE)
BEGIN
    SELECT OrderItems.ItemName, OrderItems.ItemQuantity
    FROM Orders
    INNER JOIN OrderItems ON Orders.OrderId = OrderItems.OrderId
    INNER JOIN Deliveries ON Deliveries.OrderId = Orders.OrderId
    WHERE Deliveries.EmployeeId = E
      AND Deliveries.DeliveryDay = D;
END $$

CREATE FUNCTION ShiftTime(E INT, D DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE TotalTime INT;

    SELECT SUM(TimeTaken) INTO TotalTime
    FROM Deliveries
    WHERE EmployeeId = E
      AND DeliveryDay = D;

    RETURN IFNULL(TotalTime, 0);
END $$

CREATE PROCEDURE sp_add_inventory_item(
    IN p_item_name VARCHAR(100),
    IN p_quantity INT,
    IN p_price DECIMAL(10,2)
)
BEGIN
    INSERT INTO Inventory (ItemName, Quantity, PricePer)
    VALUES (p_item_name, p_quantity, p_price)
    ON DUPLICATE KEY UPDATE
        Quantity = Quantity + p_quantity,
        PricePer = p_price;
END $$

CREATE PROCEDURE sp_submit_order(IN p_student_id INT)
BEGIN
    DECLARE v_building VARCHAR(50);
    DECLARE v_room VARCHAR(10);

    SELECT BuildingName, Room
    INTO v_building, v_room
    FROM Student
    WHERE StudentId = p_student_id;

    INSERT INTO Orders (StudentId, OrderTime, OrderDate, BuildingName, Room)
    VALUES (p_student_id, CURTIME(), CURDATE(), v_building, v_room);
END $$

DELIMITER ;

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
('Maple Hall','Oak Hall',5), ('Oak Hall','Pine Hall',4),
('Cedar Hall','Pine Hall',6), ('Birch Hall','Cedar Hall',3),
('Birch Hall','Elm Hall',5), ('Ash Hall','Elm Hall',7),
('Ash Hall','Willow Hall',4), ('Spruce Hall','Willow Hall',6),
('Cherry Hall','Spruce Hall',5), ('Cherry Hall','Hawthorn Hall',4),
('Hawthorn Hall','Magnolia Hall',6), ('Magnolia Hall','Redwood Hall',7),
('Redwood Hall','Sequoia Hall',3), ('Palm Hall','Sequoia Hall',6),
('Cypress Hall','Palm Hall',4), ('Cypress Hall','Poplar Hall',5),
('Fir Hall','Poplar Hall',6), ('Fir Hall','Juniper Hall',4),
('Alder Hall','Juniper Hall',5), ('Alder Hall','Sycamore Hall',6),
('Beech Hall','Sycamore Hall',4), ('Beech Hall','Hemlock Hall',5),
('Dogwood Hall','Hemlock Hall',6), ('Aspen Hall','Dogwood Hall',4),
('Aspen Hall','Chestnut Hall',5), ('Chestnut Hall','Walnut Hall',6),
('Linden Hall','Walnut Hall',4), ('Linden Hall','Olive Hall',5),
('Bamboo Hall','Olive Hall',6), ('Bamboo Hall','Maple Hall',7);

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