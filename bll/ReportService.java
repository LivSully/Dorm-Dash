package bll;

// This is importing the report data provider from the data access layer
import dal.ReportDataProvider;

// This is the business logic class for report related tasks
public class ReportService {

    // This is the data provider object used for report database operations
    private ReportDataProvider reportDataProvider;

    // This is the constructor that initializes the report data provider
    public ReportService() {
        reportDataProvider = new ReportDataProvider();
    }

    // This is the method that triggers weekly report generation
    public void buildWeeklyReport() {
        reportDataProvider.generateWeeklyReport();
    }
}