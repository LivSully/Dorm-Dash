package models;

// This is the model class for an employee
public class Employee {

    // This is storing the employee ID
    private int employeeId;

    // This is storing the employee name
    private String name;

    // This is storing the employee phone number
    private String phoneNumber;

    // This is storing the employee email
    private String email;

    // This is the default constructor
    public Employee() {
    }

    // This is the full constructor
    public Employee(int employeeId, String name, String phoneNumber, String email) {
        this.employeeId = employeeId;
        this.name = name;
        this.phoneNumber = phoneNumber;
        this.email = email;
    }

    // This is returning the employee ID
    public int getEmployeeId() {
        return employeeId;
    }

    // This is setting the employee ID
    public void setEmployeeId(int employeeId) {
        this.employeeId = employeeId;
    }

    // This is returning the employee name
    public String getName() {
        return name;
    }

    // This is setting the employee name
    public void setName(String name) {
        this.name = name;
    }

    // This is returning the employee phone number
    public String getPhoneNumber() {
        return phoneNumber;
    }

    // This is setting the employee phone number
    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    // This is returning the employee email
    public String getEmail() {
        return email;
    }

    // This is setting the employee email
    public void setEmail(String email) {
        this.email = email;
    }
}