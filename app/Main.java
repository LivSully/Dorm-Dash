package app;

// This is importing Scanner for user input
import java.util.Scanner;

// This is importing the service classes from the business logic layer
import bll.InventoryService;
import bll.LibraryService;
import bll.OrderService;
import bll.ReportService;

// This is the main class that starts the Dorm Dash program
public class Main {

    // This is the main method where the program begins
    public static void main(String[] args) {

        // This is creating the scanner object for keyboard input
        Scanner scanner = new Scanner(System.in);

        // This is creating service objects for each workflow
        InventoryService inventoryService = new InventoryService();
        OrderService orderService = new OrderService();
        LibraryService libraryService = new LibraryService();
        ReportService reportService = new ReportService();

        // This is storing the user's menu choice
        int choice = 0;

        // This is the main loop that keeps the menu running until the user exits
        while (choice != 5) {
            System.out.println("\n=== Dorm Dash Menu ===");
            System.out.println("1. Enter New Inventory");
            System.out.println("2. Submit Dorm Dash Order");
            System.out.println("3. Schedule Library Pickup and Return");
            System.out.println("4. Generate Weekly Manager Report");
            System.out.println("5. Exit");
            System.out.print("Enter your choice: ");

            // This is checking if the user entered a valid integer
            if (scanner.hasNextInt()) {
                choice = scanner.nextInt();
                scanner.nextLine();

                // This is handling the user's menu selection
                switch (choice) {
                    case 1:
                        // This is collecting inventory information from the user
                        System.out.print("Enter item name: ");
                        String itemName = scanner.nextLine();

                        System.out.print("Enter category: ");
                        String category = scanner.nextLine();

                        System.out.print("Enter quantity: ");
                        int quantity = scanner.nextInt();
                        scanner.nextLine();

                        System.out.print("Enter price: ");
                        double price = scanner.nextDouble();
                        scanner.nextLine();

                        // This is calling the inventory workflow
                        boolean inventoryAdded = inventoryService.addInventoryItem(itemName, category, quantity, price);

                        // This is displaying the result of the inventory workflow
                        if (inventoryAdded) {
                            System.out.println("Inventory item added successfully.");
                        } else {
                            System.out.println("Failed to add inventory item.");
                        }
                        break;

                    case 2:
                        // This is collecting the student ID for the order workflow
                        System.out.print("Enter student ID: ");
                        int studentIdForOrder = scanner.nextInt();
                        scanner.nextLine();

                        // This is calling the order workflow
                        String orderResult = orderService.placeOrder(studentIdForOrder);
                        System.out.println(orderResult);
                        break;

                    case 3:
                        // This is collecting library request information from the user
                        System.out.print("Enter student ID: ");
                        int studentIdForLibrary = scanner.nextInt();
                        scanner.nextLine();

                        System.out.print("Enter book title: ");
                        String bookTitle = scanner.nextLine();

                        // This is calling the library workflow
                        String libraryResult = libraryService.createLibraryRequest(studentIdForLibrary, bookTitle);
                        System.out.println(libraryResult);
                        break;

                    case 4:
                        // This is calling the weekly report workflow
                        reportService.buildWeeklyReport();
                        break;

                    case 5:
                        // This is exiting the program
                        System.out.println("Exiting Dorm Dash.");
                        break;

                    default:
                        // This is handling invalid menu choices
                        System.out.println("Invalid choice. Please try again.");
                }
            } else {
                // This is handling non numeric input
                System.out.println("Please enter a valid number.");
                scanner.nextLine();
            }
        }

        // This is closing the scanner before the program ends
        scanner.close();
    }
}