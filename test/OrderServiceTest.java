package test;

import static org.junit.Assert.*;

import org.junit.Test;

import bll.OrderService;

public class OrderServiceTest {

    @Test
    public void testValidOrder() {
        OrderService service = new OrderService();
        String result = service.placeOrder(1);
        assertNotNull(result);
    }

    @Test
    public void testInvalidStudentId() {
        OrderService service = new OrderService();
        String result = service.placeOrder(0);
        assertNotNull(result);
    }
}