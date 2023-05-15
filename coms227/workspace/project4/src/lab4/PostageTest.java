package lab4;
/**
 * Edit this import to test a different version
 */
import postage3.PostageUtil;;

public class PostageTest
{
  /**
   * Tests the postage calculation utility.
   * @param args
   */
  public static void main(String[] args)
  {
    System.out.println("0.5 ounces: " + PostageUtil.computePostage(0.5));
    System.out.println("Expected .47");
    System.out.println("1.0 ounces: " + PostageUtil.computePostage(1.0));
    System.out.println("Expected .47");
    System.out.println("3.0 ounces: " + PostageUtil.computePostage(3.0));
    System.out.println("Expected .89");
    System.out.println("2.3 ounces: " + PostageUtil.computePostage(2.3));
    System.out.println("Expected .89");
    System.out.println("3.1 ounces: " + PostageUtil.computePostage(3.1));
    System.out.println("Expected 1.10");
    System.out.println("3.5 ounces: " + PostageUtil.computePostage(3.5));
    System.out.println("Expected 1.10");
    System.out.println("3.8 ounces: " + PostageUtil.computePostage(3.8));
    System.out.println("Expected .1.57");
    System.out.println("10 ounces: " + PostageUtil.computePostage(10));
    System.out.println("Expected 2.83");
  }

}