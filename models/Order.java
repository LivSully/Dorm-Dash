package models;

// This is the model class for an order
public class Order {

    // This is storing the order ID
    private int orderId;

    // This is storing the customer ID
    private int customerId;

    // This is storing the order date
    private String orderDate;

    // This is storing the delivery time
    private String deliveryTime;

    // This is the default constructor
    public Order() {
    }

    // This is the full constructor
    public Order(int orderId, int customerId, String orderDate, String deliveryTime) {
        this.orderId = orderId;
        this.customerId = customerId;
        this.orderDate = orderDate;
        this.deliveryTime = deliveryTime;
    }

    // This is returning the order ID
    public int getOrderId() {
        return orderId;
    }

    // This is setting the order ID
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    // This is returning the customer ID
    public int getCustomerId() {
        return customerId;
    }

    // This is setting the customer ID
    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    // This is returning the order date
    public String getOrderDate() {
        return orderDate;
    }

    // This is setting the order date
    public void setOrderDate(String orderDate) {
        this.orderDate = orderDate;
    }

    // This is returning the delivery time
    public String getDeliveryTime() {
        return deliveryTime;
    }

    // This is setting the delivery time
    public void setDeliveryTime(String deliveryTime) {
        this.deliveryTime = deliveryTime;
    }
}