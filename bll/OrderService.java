package bll;

// This is importing the order data provider from the data access layer
import dal.OrderDataProvider;

// This is the business logic class for order related tasks
public class OrderService {

    // This is the data provider object used to access the database
    private OrderDataProvider orderDataProvider;

    // This is the constructor that initializes the order data provider
    public OrderService() {
        orderDataProvider = new OrderDataProvider();
    }

    // This is the method that validates the student ID and sends the order request to the DAL
    public String placeOrder(int studentIdForOrder) {

        // This is checking if the student ID is invalid
        if (studentIdForOrder <= 0) {
            return "Invalid student ID.";
        }

        // This is passing valid data to the data provider
        return orderDataProvider.submitOrder(studentIdForOrder);
    }
}