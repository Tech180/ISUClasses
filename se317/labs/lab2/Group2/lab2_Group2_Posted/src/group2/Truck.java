// Introduction to Software Testing
// Authors: Paul Ammann & Jeff Offutt
// Chapter 1, page ??
// See CloneTest.java for JUnit tests
// See also Vehicle.java

package group2;

public class Truck extends Vehicle 
{
   private int y;

   public Truck(int z) { super(z); y = z;}

   @Override public Object clone() {
      Object result = super.clone();
      // Location "B"
      ((Truck) result).y = this.y;  // throws ClassCastException
      return result; 
   }
   @Override public boolean equals (Object o) {
       if (!(o instanceof Truck)) return false;
       Truck t = (Truck) o;
       return super.equals(t) && t.y == this.y;
   }
   // other methods omitted
}
