package dal;

// This is importing JDBC classes needed for stored procedure calls
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

// This is the data provider class for library request database actions
public class LibraryDataProvider {

    // This is the method that calls the library request stored procedure
    public String scheduleLibraryRequest(int studentId, String bookTitle) {

        // This is the stored procedure call for scheduling a library request
        String sql = "{CALL sp_schedule_library_request(?, ?)}";

        try {
            // This is getting the shared database connection
            Connection connection = DataMgr.getConnection();

            // This is preparing the stored procedure call
            CallableStatement statement = connection.prepareCall(sql);

            // This is setting the procedure input values
            statement.setInt(1, studentId);
            statement.setString(2, bookTitle);

            // This is executing the stored procedure
            statement.execute();

            // This is returning a success message if the procedure works
            return "Library request scheduled successfully.";
        } catch (SQLException e) {
            // This is returning an error message if the procedure fails
            return "Database error while scheduling library request: " + e.getMessage();
        }
    }
}