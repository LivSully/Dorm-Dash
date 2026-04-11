package test;

import static org.junit.Assert.*;

import org.junit.Test;

import bll.InventoryService;

public class InventoryServiceTest {

    @Test
    public void testValidInventoryItem() {
        InventoryService service = new InventoryService();
        assertTrue(service.addInventoryItem("Chips", 5, 2.50));
    }

    @Test
    public void testInvalidQuantity() {
        InventoryService service = new InventoryService();
        assertFalse(service.addInventoryItem("Chips", 0, 2.50));
    }

    @Test
    public void testInvalidPrice() {
        InventoryService service = new InventoryService();
        assertFalse(service.addInventoryItem("Chips", 5, 0));
    }

    @Test
    public void testEmptyName() {
        InventoryService service = new InventoryService();
        assertFalse(service.addInventoryItem("", 5, 2.50));
    }
}