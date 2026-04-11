package models;

// This is the model class for a customer
public class Customer {

    // This is storing the customer ID
    private int customerId;

    // This is storing the customer name
    private String name;

    // This is storing the customer phone number
    private String phoneNumber;

    // This is storing the customer email
    private String email;

    // This is storing the customer dorm address
    private String dormAddress;

    // This is the default constructor
    public Customer() {
    }

    // This is the full constructor
    public Customer(int customerId, String name, String phoneNumber, String email, String dormAddress) {
        this.customerId = customerId;
        this.name = name;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.dormAddress = dormAddress;
    }

    // This is returning the customer ID
    public int getCustomerId() {
        return customerId;
    }

    // This is setting the customer ID
    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    // This is returning the customer name
    public String getName() {
        return name;
    }

    // This is setting the customer name
    public void setName(String name) {
        this.name = name;
    }

    // This is returning the customer phone number
    public String getPhoneNumber() {
        return phoneNumber;
    }

    // This is setting the customer phone number
    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    // This is returning the customer email
    public String getEmail() {
        return email;
    }

    // This is setting the customer email
    public void setEmail(String email) {
        this.email = email;
    }

    // This is returning the customer dorm address
    public String getDormAddress() {
        return dormAddress;
    }

    // This is setting the customer dorm address
    public void setDormAddress(String dormAddress) {
        this.dormAddress = dormAddress;
    }
}