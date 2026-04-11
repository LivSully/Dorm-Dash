package models;

// This is the model class for a weekly report
public class WeeklyReport {

    // This is storing the employee ID
    private int employeeId;

    // This is storing the employee name
    private String employeeName;

    // This is storing the report day
    private String reportDay;

    // This is storing the delivery path
    private String deliveryPath;

    // This is storing the delivered goods
    private String deliveredGoods;

    // This is storing the time spent on deliveries
    private double timeSpent;

    // This is the default constructor
    public WeeklyReport() {
    }

    // This is the full constructor
    public WeeklyReport(int employeeId, String employeeName, String reportDay, String deliveryPath, String deliveredGoods, double timeSpent) {
        this.employeeId = employeeId;
        this.employeeName = employeeName;
        this.reportDay = reportDay;
        this.deliveryPath = deliveryPath;
        this.deliveredGoods = deliveredGoods;
        this.timeSpent = timeSpent;
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
    public String getEmployeeName() {
        return employeeName;
    }

    // This is setting the employee name
    public void setEmployeeName(String employeeName) {
        this.employeeName = employeeName;
    }

    // This is returning the report day
    public String getReportDay() {
        return reportDay;
    }

    // This is setting the report day
    public void setReportDay(String reportDay) {
        this.reportDay = reportDay;
    }

    // This is returning the delivery path
    public String getDeliveryPath() {
        return deliveryPath;
    }

    // This is setting the delivery path
    public void setDeliveryPath(String deliveryPath) {
        this.deliveryPath = deliveryPath;
    }

    // This is returning the delivered goods
    public String getDeliveredGoods() {
        return deliveredGoods;
    }

    // This is setting the delivered goods
    public void setDeliveredGoods(String deliveredGoods) {
        this.deliveredGoods = deliveredGoods;
    }

    // This is returning the time spent
    public double getTimeSpent() {
        return timeSpent;
    }

    // This is setting the time spent
    public void setTimeSpent(double timeSpent) {
        this.timeSpent = timeSpent;
    }
}