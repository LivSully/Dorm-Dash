DROP DATABASE IF EXISTS DormDash;

CREATE DATABASE DormDash;

USE DormDash;


-- Each employee has an identifying id
-- Each employee has a name, phone number, email
-- Each employee has a designated time that they start their shift, and an end time that is 2 hours later
DROP TABLE IF EXISTS Employee;

CREATE TABLE Employee (
EmployeeId int not null,
FirstName varchar(50)  not null,
LastName varchar(50)  not null,
PhoneNumber varchar(20) not null,
Email varchar(100) not null,
StartTime time not null,
EndTime time,
PRIMARY KEY (EmployeeId)
);
-- End of shift is set automatically to 2 hours after start
UPDATE Employee SET EndTime = ADDTIME(StartTime, '2:00:00');

DROP TABLE IF EXISTS Inventory;

CREATE TABLE Inventory (
ItemId int auto_increment,
Quantity int not null,
Price decimal(10,2) not null,
PRIMARY KEY (ItemId)
);

-- Each student may order as many things as they want in one order
-- Therefore, there can be many rows with the same order id, in order to represent different items in the order
DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders (
OrderId int,
StudentId int not null,
ItemId int not null,
ItemQuantity int not null,
Cost decimal(10,2) not null,
OrderTime time not null,
OrderDate date not null,
PRIMARY KEY (OrderId, ItemId),
FOREIGN KEY (ItemId) REFERENCES Inventory(ItemId)
);

-- can use node ints to reference buildings easier
-- no building name duplicates on the same campus
DROP TABLE IF EXISTS Node;

CREATE TABLE Node(
NodeId int not null auto_increment,
BuildingName varchar(50) not null,
PRIMARY KEY (NodeId)
);

-- time from one node(building) to another node, paths labeled by ints
DROP TABLE IF EXISTS Edge;

CREATE TABLE Edge (
EdgeId int auto_increment,
StartNode int,
EndNode int,
EdgeTime int not null,
PRIMARY KEY (EdgeId),
FOREIGN KEY (StartNode) REFERENCES Node(NodeId),
FOREIGN KEY (EndNode) REFERENCES Node(NodeId),
CONSTRAINT chk_not_equal CHECK (StartNode <> EndNode)
);

