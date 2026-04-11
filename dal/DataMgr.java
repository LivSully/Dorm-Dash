package dal;

// This is importing JDBC classes for database connection handling
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

// This is importing the database configuration values
import utils.DBConfig;

// This is the data manager class that handles the shared database connection
public class DataMgr {

    // This is the cached database connection object
    private static Connection connection;

    // This is the method that returns a database connection
    public static Connection getConnection() throws SQLException {

        // This is checking if the connection does not exist or is closed
        if (connection == null || connection.isClosed()) {

            // This is creating a new database connection using config values
            connection = DriverManager.getConnection(
                DBConfig.URL,
                DBConfig.USERNAME,
                DBConfig.PASSWORD
            );
        }

        // This is returning the active connection
        return connection;
    }
}