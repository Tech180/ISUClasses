package lab4;
/**
 * Donuts are .75 each or 8.00 per dozen.  Coffees are 1.50 each,
 * but you get two free coffees for each dozen donuts. 
 * 
 * This class has a couple of bugs.
 */
public class Donuts
{
  /**
   * Try out the donut and coffee calculation.
   * @param args
   */
  public static void main(String[] args)
  {
    double result = donutHelper(10, 52);
    System.out.println("52 donuts and 10 coffees should be 38.00, actual " + result);
    
    result = donutHelper(5, 52);
    System.out.println("52 donuts and 5 coffees should be 35.00, actual " + result);
  }

  /**
   * Returns the total cost for a given number of donuts and coffees.
   * @param donuts
   *   number of donuts
   * @param coffees
   *   number of coffees
   * @return
   *   cost for a given number of donuts and coffees
   */
  private static double donutHelper(int coffees, int donuts)
  {
    int dozens = donuts / 12;
    int singles = donuts % 12;
    int freeCoffees = dozens * 2;
    if(freeCoffees > coffees){
    	coffees = 0;
    }
    else{
    	 coffees = coffees - freeCoffees;
    }
    double donutCost = dozens * 8.00 + singles * .75;
    double coffeeCost = coffees * 1.50;
    return donutCost + coffeeCost;
  }
}