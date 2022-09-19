package group1;

public class CountPositive {

	/** 
	   * Counts positive elements in array
	   *
	   * @param x array to search
	   * @return number of positive elements in x
	   * @throws NullPointerException if x is null
	   */
	   public static int countPositive (int[] x)
	   {
	      int count = 0;
	   
	      for (int i=0; i < x.length; i++)
	      {
	         if (x[i] >= 0)
	         {
	            count++;
	         }
	      }
	      return count;
	   }
	     
	   
	   
}
