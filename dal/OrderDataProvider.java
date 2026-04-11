package dal;

// This is importing JDBC classes needed for stored procedure calls
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

// This is the data provider class for order database actions
public class OrderDataProvider {

    // This is the method that calls the order stored procedure
    public String submitOrder(int studentId) {

        // This is the stored procedure call for submitting an order
        String sql = "{CALL sp_submit_order(?)}";

        try {
            // This is getting the shared database connection
            Connection connection = DataMgr.getConnection();

            // This is preparing the stored procedure call
            CallableStatement statement = connection.prepareCall(sql);

            // This is setting the procedure input value
            statement.setInt(1, studentId);

            // This is executing the stored procedure
            statement.execute();

            // This is returning a success message if the procedure works
            return "Order submitted successfully.";
        } catch (SQLException e) {
            // This is returning an error message if the procedure fails
            return "Database error while submitting order: " + e.getMessage();
        }
    }
}