package test;

import static org.junit.Assert.*;

import org.junit.Test;

import bll.ReportService;

public class ReportServiceTest {

    @Test
    public void testWeeklyReportRuns() {
        ReportService service = new ReportService();
        service.buildWeeklyReport();
        assertTrue(true);
    }
}