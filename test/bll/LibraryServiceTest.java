package bll;

import org.junit.Test;

import static org.junit.Assert.*;

public class LibraryServiceTest {

    private final LibraryService service = new LibraryService();

    @Test
    public void createLibraryRequest_invalidStudentId_returnsInvalidStudentId() {
        assertEquals("Invalid student ID.", service.createLibraryRequest(0, "Data Structures"));
    }

    @Test
    public void createLibraryRequest_invalidBookTitle_returnsInvalidBookTitle() {
        assertEquals("Invalid book title.", service.createLibraryRequest(1, ""));
    }

    @Test
    public void createLibraryRequest_validInput_returnsSuccessMessage() {
        assertEquals(
                "Library request created for student ID 1 for book: Data Structures",
                service.createLibraryRequest(1, "Data Structures"));
    }
}
