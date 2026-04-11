package bll;

// This is the business logic class for library related tasks
public class LibraryService {

    // This is the constructor for the library service
    public LibraryService() {
    }

    // This is the method that validates the library request input
    public String createLibraryRequest(int studentIdForLibrary, String bookTitle) {

        // This is checking if the student ID is invalid
        if (studentIdForLibrary <= 0) {
            return "Invalid student ID.";
        }

        // This is checking if the book title is empty
        if (bookTitle == null || bookTitle.trim().isEmpty()) {
            return "Invalid book title.";
        }

        // This is a placeholder message until the library workflow is fully implemented
        return "Library request created for student ID " + studentIdForLibrary + " for book: " + bookTitle;
    }
}