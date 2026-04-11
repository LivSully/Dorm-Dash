package utils;

// This is importing Scanner for user input
import java.util.Scanner;

// This is the helper class for collecting validated user input
public class InputHelper {

    // This is the scanner object used for reading keyboard input
    private Scanner scanner;

    // This is the constructor that initializes the scanner
    public InputHelper() {
        scanner = new Scanner(System.in);
    }

    // This is the method for reading a string input
    public String getStringInput(String prompt) {
        System.out.print(prompt);
        return scanner.nextLine();
    }

    // This is the method for reading an integer input
    public int getIntInput(String prompt) {
        System.out.print(prompt);

        // This is looping until the user enters a valid integer
        while (!scanner.hasNextInt()) {
            System.out.println("Invalid input. Please enter a whole number.");
            scanner.nextLine();
            System.out.print(prompt);
        }

        // This is storing the valid integer
        int value = scanner.nextInt();
        scanner.nextLine();
        return value;
    }

    // This is the method for reading a double input
    public double getDoubleInput(String prompt) {
        System.out.print(prompt);

        // This is looping until the user enters a valid decimal number
        while (!scanner.hasNextDouble()) {
            System.out.println("Invalid input. Please enter a decimal number.");
            scanner.nextLine();
            System.out.print(prompt);
        }

        // This is storing the valid double
        double value = scanner.nextDouble();
        scanner.nextLine();
        return value;
    }
}