package bll;

// This is importing the inventory data provider from the data access layer
import dal.InventoryDataProvider;

// This is the business logic class for inventory related tasks
public class InventoryService {

    // This is the data provider object used to access the database
    private InventoryDataProvider inventoryDataProvider;

    // This is the constructor that initializes the inventory data provider
    public InventoryService() {
        inventoryDataProvider = new InventoryDataProvider();
    }

    // This is the method that validates inventory input and sends it to the DAL
    public boolean addInventoryItem(String name, String category, int quantity, double price) {

        // This is checking if the item name is empty
        if (name == null || name.trim().isEmpty()) {
            return false;
        }

        // This is checking if the category is empty
        if (category == null || category.trim().isEmpty()) {
            return false;
        }

        // This is checking for invalid quantity or price values
        if (quantity < 0 || price < 0) {
            return false;
        }

        // This is passing valid data to the data provider
        return inventoryDataProvider.insertInventoryItem(name, category, quantity, price);
    }
}