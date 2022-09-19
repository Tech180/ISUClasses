// Introduction to Software Testing
// Authors: Paul Ammann & Jeff Offutt
// Chapter 1, page ??
// See CloneTest.java for JUnit tests
// See also Truck.java

package group2;

public class Vehicle implements Cloneable 
{
   private int x;

   public Vehicle(int y) { x = y;}

   @Override public Object clone() { 
      Object result = new Vehicle(this.x);
      // Location "A"
      return result;
   }
   @Override public boolean equals (Object o) {
       if (!(o instanceof Vehicle)) return false;
       Vehicle v = (Vehicle) o;
       return v.x == this.x;
   }
}
