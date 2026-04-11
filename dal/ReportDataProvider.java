package dal;

// This is importing JDBC classes needed for report generation
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

// This is the data provider class for report database actions
public class ReportDataProvider {

    // This is the method that calls the weekly report stored procedure
    public void generateWeeklyReport() {

        // This is the stored procedure call for generating the weekly report
        String sql = "{CALL sp_generate_weekly_report()}";

        try {
            // This is getting the shared database connection
            Connection connection = DataMgr.getConnection();

            // This is preparing the stored procedure call
            CallableStatement statement = connection.prepareCall(sql);

            // This is executing the query and storing the result set
            ResultSet resultSet = statement.executeQuery();

            // This is printing the report header
            System.out.println("\n=== Weekly Manager Report ===");

            // This is looping through the result set and printing each row
            while (resultSet.next()) {
                System.out.println(resultSet.getString(1));
            }
        } catch (SQLException e) {
            // This is printing an error message if the procedure fails
            System.out.println("Database error while generating report: " + e.getMessage());
        }
    }
}