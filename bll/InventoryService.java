package bll;

// This is importing the inventory data provider from the data access layer
import dal.InventoryDataProvider;

// This is the business logic class for inventory related tasks
public class InventoryService {

    // This is creating the inventory data provider object
    private InventoryDataProvider inventoryDataProvider;

    // This is the constructor for the inventory service
    public InventoryService() {
        inventoryDataProvider = new InventoryDataProvider();
    }

    // This is the method that validates inventory input and sends it to the data layer
    public boolean addInventoryItem(String itemName, int quantity, double price) {

        // This is checking if the item name is empty
        if (itemName == null || itemName.trim().isEmpty()) {
            return false;
        }

        // This is checking if the quantity is invalid
        if (quantity <= 0) {
            return false;
        }

        // This is checking if the price is invalid
        if (price <= 0) {
            return false;
        }

        // This is calling the data provider to add the inventory item
        return inventoryDataProvider.addInventoryItem(itemName, quantity, price);
    }
}