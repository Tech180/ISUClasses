package lab3;
import java.util.Random;
/**
 * A RabbitModel is used to simulate the growth
 * of a population of rabbits. 
 */
public class RabbitModel
{
  // TODO - add instance variables as needed
	private int rabbit;
	private int lastYear;
	private int yearBefore;
	private Random rand;
  /**
   * Constructs a new RabbitModel.
   */
  public RabbitModel()
  {
	 rand = new Random();
	 rabbit = 0;
	  //lastYear = 1;
	  //yearBefore = 0;
	 // rabbit = 0;
  }  
 
  /**
   * Returns the current number of rabbits.
   * @return
   *   current rabbit population
   */
  public int getPopulation()
  {
    // TODO - returns a dummy value so code will compile
	  return rabbit;
    
  }
  
  /**
   * Updates the population to simulate the
   * passing of one year.
   */
  public void simulateYear()
  {
   // TODO
	  /*rabbit += 1;
	  if(rabbit == 4){
		  rabbit = 0;
	  }*/
	   ///rabbit /= 2;
	  //rabbit = lastYear + yearBefore;
	  //lastYear = rabbit;
	  //yearBefore = lastYear;
	  
	  rabbit += rand.nextInt(10);
	  
  }
  
  /**
   * Sets or resets the state of the model to the 
   * initial conditions.
   */
  public void reset()
  {
    // TODO
	  ///rabbit = 500;
	  //rabbit = 0;
	  //lastYear = 1;
	  //yearBefore = 0;
	  //rabbit = 0;
  }
}