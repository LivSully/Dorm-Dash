package dal;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.assertArrayEquals;
import static org.junit.Assert.assertTrue;

public class DatabaseFunctionalDependencyTest {

    private Connection connection;

    @Before
    public void setUp() throws SQLException {
        connection = DataMgr.getConnection();
    }

    @After
    public void tearDown() throws SQLException {
        if (connection != null && !connection.isClosed()) {
            connection.close();
        }
    }

    @Test
    public void inventory_itemNameFunctionallyDeterminesQuantityAndPricePer() throws SQLException {
        assertTrue("Inventory.ItemName should be a primary key to enforce the functional dependency",
                isPrimaryKey("Inventory", new String[] { "ItemName" }));
    }

    @Test
    public void orders_orderIdFunctionallyDeterminesOrderDetails() throws SQLException {
        assertTrue("Orders.OrderId should be a primary key to enforce the functional dependency",
                isPrimaryKey("Orders", new String[] { "OrderId" }));
    }

    @Test
    public void student_studentIdFunctionallyDeterminesStudentAttributes() throws SQLException {
        assertTrue("Student.StudentId should be a primary key to enforce the functional dependency",
                isPrimaryKey("Student", new String[] { "StudentId" }));
    }

    private boolean isPrimaryKey(String tableName, String[] expectedColumns) throws SQLException {
        String sql = "SELECT COLUMN_NAME FROM information_schema.key_column_usage "
                + "WHERE table_schema = DATABASE() "
                + "AND TABLE_NAME = ? "
                + "AND CONSTRAINT_NAME = 'PRIMARY' "
                + "ORDER BY ORDINAL_POSITION";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, tableName);
            try (ResultSet resultSet = statement.executeQuery()) {
                List<String> actualColumns = new ArrayList<>();
                while (resultSet.next()) {
                    actualColumns.add(resultSet.getString("COLUMN_NAME"));
                }

                if (actualColumns.isEmpty()) {
                    return false;
                }

                assertArrayEquals("Primary key columns must match expected determinant columns",
                        expectedColumns,
                        actualColumns.toArray(new String[0]));
                return true;
            }
        }
    }
}
