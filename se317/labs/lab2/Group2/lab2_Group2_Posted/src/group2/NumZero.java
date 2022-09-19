// Introduction to Software Testing
// Authors: Paul Ammann & Jeff Offutt
// Chapter 1; page ??
// Can be run from command line
// See NumZeroTest.java for JUnit tests

package group2;

public class NumZero
{
  /**
   * Counts zeroes in an array
   *
   * @param x  array to count zeroes in
   * @return   number of occurrences of 0 in x
   * @throws   NullPointerException if x is null
   */
   public static int numZero (int[] x)
   {  
      int count = 0;
   
      // As example in the book points out, this loop should start at 0.
      // Better yet, is should be a foreach loop,
      // which eliminates the possibility of the fencepost fault:
      // for (int i:x) { if (x==0) count++; }
      for (int i = 1; i < x.length; i++)
      {
         if (x[i] == 0) count++;
      }
      return count;
   }

   public static void main (String []argv)
   {  // Driver method for numZero
      // Read an array from standard input, call numZero()
      int []inArr = new int [argv.length];
      if (argv.length == 0)
      {
         System.out.println ("Usage: java NumZero v1 [v2] [v3] ... ");
         return;
      }
   
      for (int i = 0; i< argv.length; i++)
      {
         try
         {
            inArr [i] = Integer.parseInt (argv[i]);
         }
         catch (NumberFormatException e)
         {
            System.out.println ("Entry must be a integer, using 1.");
            inArr [i] = 1;
         }
      }
      System.out.println ("Number of zeros is: " + numZero (inArr));
   }
}
