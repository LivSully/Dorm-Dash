package dal;

// This is importing JDBC classes needed for stored procedure calls
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

// This is the data provider class for inventory database actions
public class InventoryDataProvider {

    // This is the method that calls the inventory stored procedure
    public boolean addInventoryItem(String name, int quantity, double price) {

        // This is the stored procedure call for adding inventory
        String sql = "{CALL sp_add_inventory_item(?, ?, ?)}";

        try {
            // This is getting the shared database connection
            Connection connection = DataMgr.getConnection();

            // This is preparing the stored procedure call
            CallableStatement statement = connection.prepareCall(sql);

            // This is setting the procedure input values
            statement.setString(1, name);
            statement.setInt(2, quantity);
            statement.setDouble(3, price);

            // This is executing the stored procedure
            statement.execute();

            // This is returning true if the database call succeeds
            return true;
        } catch (SQLException e) {
            // This is printing an error message if the database call fails
            System.out.println("Database error while adding inventory: " + e.getMessage());
            return false;
        }
    }

    // This alias method is provided for tests that expect an insertInventoryItem
    // API.
    public boolean insertInventoryItem(String name, int quantity, double price) {
        return addInventoryItem(name, quantity, price);
    }
}