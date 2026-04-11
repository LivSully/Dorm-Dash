package models;

// This is the model class for an inventory item
public class InventoryItem {

    // This is storing the item ID
    private int itemId;

    // This is storing the item name
    private String itemName;

    // This is storing the item category
    private String category;

    // This is storing the item quantity
    private int quantity;

    // This is storing the item price
    private double price;

    // This is the default constructor
    public InventoryItem() {
    }

    // This is the full constructor
    public InventoryItem(int itemId, String itemName, String category, int quantity, double price) {
        this.itemId = itemId;
        this.itemName = itemName;
        this.category = category;
        this.quantity = quantity;
        this.price = price;
    }

    // This is returning the item ID
    public int getItemId() {
        return itemId;
    }

    // This is setting the item ID
    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    // This is returning the item name
    public String getItemName() {
        return itemName;
    }

    // This is setting the item name
    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    // This is returning the item category
    public String getCategory() {
        return category;
    }

    // This is setting the item category
    public void setCategory(String category) {
        this.category = category;
    }

    // This is returning the item quantity
    public int getQuantity() {
        return quantity;
    }

    // This is setting the item quantity
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    // This is returning the item price
    public double getPrice() {
        return price;
    }

    // This is setting the item price
    public void setPrice(double price) {
        this.price = price;
    }
}