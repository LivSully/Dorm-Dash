DROP DATABASE IF EXISTS DormDash;

CREATE DATABASE DormDash;

USE DormDash;

CREATE TABLE IF NOT EXISTS Inventory (
    InventoryId INT AUTO_INCREMENT PRIMARY KEY,
    ItemName VARCHAR(100) NOT NULL,
    Category VARCHAR(100) NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL
);

DROP PROCEDURE IF EXISTS sp_add_inventory_item;

DELIMITER $$

CREATE PROCEDURE sp_add_inventory_item(
    IN p_item_name VARCHAR(100),
    IN p_category VARCHAR(100),
    IN p_quantity INT,
    IN p_price DECIMAL(10,2)
)
BEGIN
    INSERT INTO Inventory (ItemName, Category, Quantity, Price)
    VALUES (p_item_name, p_category, p_quantity, p_price);
END $$

DELIMITER ;