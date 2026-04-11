package bll;

import org.junit.Test;
import static org.junit.Assert.assertFalse;

public class InventoryServiceTest {

    private final InventoryService service = new InventoryService();

    @Test
    public void addInventoryItem_nullName_returnsFalse() {
        assertFalse(service.addInventoryItem(null, "Snacks", 10, 1.50));
    }

    @Test
    public void addInventoryItem_emptyName_returnsFalse() {
        assertFalse(service.addInventoryItem("   ", "Snacks", 10, 1.50));
    }

    @Test
    public void addInventoryItem_nullCategory_returnsFalse() {
        assertFalse(service.addInventoryItem("Chips", null, 10, 1.50));
    }

    @Test
    public void addInventoryItem_negativeQuantity_returnsFalse() {
        assertFalse(service.addInventoryItem("Chips", "Snacks", -1, 1.50));
    }

    @Test
    public void addInventoryItem_negativePrice_returnsFalse() {
        assertFalse(service.addInventoryItem("Chips", "Snacks", 10, -1.00));
    }
}
