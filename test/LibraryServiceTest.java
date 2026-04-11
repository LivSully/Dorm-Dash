package test;

import static org.junit.Assert.*;

import org.junit.Test;

import bll.LibraryService;

public class LibraryServiceTest {

    @Test
    public void testValidLibraryRequest() {
        LibraryService service = new LibraryService();
        String result = service.createLibraryRequest(1, "Database Systems");
        assertTrue(result.contains("Library request created"));
    }

    @Test
    public void testInvalidStudentId() {
        LibraryService service = new LibraryService();
        String result = service.createLibraryRequest(0, "Database Systems");
        assertEquals("Invalid student ID.", result);
    }

    @Test
    public void testEmptyBookTitle() {
        LibraryService service = new LibraryService();
        String result = service.createLibraryRequest(1, "");
        assertEquals("Invalid book title.", result);
    }
}