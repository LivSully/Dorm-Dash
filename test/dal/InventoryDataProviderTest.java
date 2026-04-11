package dal;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

public class InventoryDataProviderTest {

    private static final String TEST_ITEM_NAME = "JUnit StoredProc Item";
    private static final int QUANTITY = 7;
    private static final double PRICE = 4.99;

    private InventoryDataProvider provider;
    private Connection connection;

    @Before
    public void setUp() throws SQLException {
        provider = new InventoryDataProvider();
        connection = DataMgr.getConnection();
        if (connection != null) {
            deleteIfExists(TEST_ITEM_NAME);
        }
    }

    @After
    public void tearDown() throws SQLException {
        if (connection != null) {
            deleteIfExists(TEST_ITEM_NAME);
        }
    }

    @Test
    public void insertInventoryItem_validStoredProcedureExecutes_itemExistsInInventory() throws SQLException {
        boolean inserted = provider.insertInventoryItem(TEST_ITEM_NAME, QUANTITY, PRICE);

        assertTrue("Stored procedure should return true for valid inputs", inserted);

        try (PreparedStatement stmt = connection.prepareStatement(
                "SELECT Quantity, PricePer FROM Inventory WHERE ItemName = ?")) {
            stmt.setString(1, TEST_ITEM_NAME);
            try (ResultSet rs = stmt.executeQuery()) {
                assertTrue("Inventory row should be present after stored procedure insert", rs.next());
                assertEquals(QUANTITY, rs.getInt("Quantity"));
                assertEquals(PRICE, rs.getDouble("PricePer"), 0.001);
                assertFalse("Only one inventory row should exist for the test item", rs.next());
            }
        }
    }

    private void deleteIfExists(String itemName) throws SQLException {
        try (PreparedStatement stmt = connection.prepareStatement("DELETE FROM Inventory WHERE ItemName = ?")) {
            stmt.setString(1, itemName);
            stmt.executeUpdate();
        }
    }
}
