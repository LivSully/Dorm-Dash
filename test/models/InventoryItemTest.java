package models;

import org.junit.Test;

import static org.junit.Assert.*;

public class InventoryItemTest {

    @Test
    public void constructorAndGetters_returnExpectedValues() {
        InventoryItem item = new InventoryItem(101, "Water Bottle", "Beverages", 25, 1.50);

        assertEquals(101, item.getItemId());
        assertEquals("Water Bottle", item.getItemName());
        assertEquals("Beverages", item.getCategory());
        assertEquals(25, item.getQuantity());
        assertEquals(1.50, item.getPrice(), 0.001);
    }

    @Test
    public void setters_updateFieldsSuccessfully() {
        InventoryItem item = new InventoryItem();
        item.setItemId(102);
        item.setItemName("Chips");
        item.setCategory("Snacks");
        item.setQuantity(50);
        item.setPrice(2.00);

        assertEquals(102, item.getItemId());
        assertEquals("Chips", item.getItemName());
        assertEquals("Snacks", item.getCategory());
        assertEquals(50, item.getQuantity());
        assertEquals(2.00, item.getPrice(), 0.001);
    }
}
