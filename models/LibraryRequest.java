package models;

// This is the model class for a library request
public class LibraryRequest {

    // This is storing the request ID
    private int requestId;

    // This is storing the customer ID
    private int customerId;

    // This is storing the book title
    private String bookTitle;

    // This is storing the pickup time
    private String pickupTime;

    // This is storing the return time
    private String returnTime;

    // This is the default constructor
    public LibraryRequest() {
    }

    // This is the full constructor
    public LibraryRequest(int requestId, int customerId, String bookTitle, String pickupTime, String returnTime) {
        this.requestId = requestId;
        this.customerId = customerId;
        this.bookTitle = bookTitle;
        this.pickupTime = pickupTime;
        this.returnTime = returnTime;
    }

    // This is returning the request ID
    public int getRequestId() {
        return requestId;
    }

    // This is setting the request ID
    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    // This is returning the customer ID
    public int getCustomerId() {
        return customerId;
    }

    // This is setting the customer ID
    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    // This is returning the book title
    public String getBookTitle() {
        return bookTitle;
    }

    // This is setting the book title
    public void setBookTitle(String bookTitle) {
        this.bookTitle = bookTitle;
    }

    // This is returning the pickup time
    public String getPickupTime() {
        return pickupTime;
    }

    // This is setting the pickup time
    public void setPickupTime(String pickupTime) {
        this.pickupTime = pickupTime;
    }

    // This is returning the return time
    public String getReturnTime() {
        return returnTime;
    }

    // This is setting the return time
    public void setReturnTime(String returnTime) {
        this.returnTime = returnTime;
    }
}