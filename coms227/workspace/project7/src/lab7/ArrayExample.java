package lab7;

import java.util.*;

public class ArrayExample
{
  public static void main(String[] args)
  {   
    // Declares a variable whose type is "array of int"  
    int[] arr;
    
    // Creates an array of four elements.  All values are zero by default.
    arr = new int[4];
    
    // Assign some values
    arr[0] = 17;
    arr[1] = 42;
    arr[2] = arr[1] - arr[0];
    
    // Print out all four elements (note the fourth one is still zero)
    for (int i = 0; i < arr.length; i += 1)
    {
      System.out.println(arr[i]);
    }
    System.out.println();    
  }


	public static int countPs(String s)
	{
	  int total = 0;
	  for (int i = 0; i < s.length(); i += 1)
	  {
	    if (s.charAt(i) == 'p')
	    {
	      total += 1;
	    }
	  }
	  return total;
	}
	
	public static int countPositiveNumbers(int[] numbers)
	  {
	    int total = 0;
	    for (int i = 0; i < numbers.length; i += 1)
	    {
	      if (numbers[i] > 0)
	      {
	        total += 1;
	      }
	    }
	    return total;    
	  }
	
}