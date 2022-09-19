// Introduction to Software Testing
// Authors: Paul Ammann & Jeff Offutt
// Chapter 1, page ??
// JUnit tests for Vehicle.java, Truck.java 

package group2;

import static org.junit.Assert.*;
import org.junit.*;
import java.util.*;

public class CloneTest 
{
   @Test public void cloneSuper() {
      Vehicle v = new Vehicle(4); 
      Vehicle w = (Vehicle) v.clone();
      assertFalse(v == w);
      assertEquals(v.getClass(), w.getClass());
      assertTrue(v.equals(w));
   }

}
