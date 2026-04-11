package bll;

// This is importing the order data provider from the data access layer
import dal.OrderDataProvider;

// This is the business logic class for order related tasks
public class LibraryService {

    // This is the data provider object used for order database operations
    private OrderDataProvider orderDataProvider;

    // This is the constructor that initializes the order data provider
    public LibraryService() {
        orderDataProvider = new OrderDataProvider();
    }

    // This is the method that validates the student ID before placing an order
    public String placeOrder(int studentId) {

        // This is checking if the student ID is valid
        if (studentId <= 0) {
            return "Invalid student ID.";
        }

        // This is sending the valid order request to the data provider
        return orderDataProvider.submitOrder(studentId);
    }

    public String createLibraryRequest(int studentIdForLibrary, String bookTitle) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'createLibraryRequest'");
    }
}