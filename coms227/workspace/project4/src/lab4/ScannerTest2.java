package lab4;
import java.util.Scanner;

public class ScannerTest2
{
  public static void main(String[] args)
  {
    // construct a scanner to read from the console
    Scanner in = new Scanner(System.in);
    
    // print a "prompt" so the user knows why the program is waiting
    System.out.print("Enter three words separated by spaces: ");
    
    // parse the input to get the three items
    String first = in.next();
    String second = in.next();
    String third = in.next();
    
    // print them out
    System.out.println(first);
    System.out.println(second);
    System.out.println(third);
  }
}