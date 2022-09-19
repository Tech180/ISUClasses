// Introduction to Software Testing
// Authors: Paul Ammann & Jeff Offutt
// Chapter 1; page ??
// JUnit for Point.java, ColorPoint.java

package group2;

import static org.junit.Assert.*;
import org.junit.*;
import java.util.*;

public class PointTest {
   private Point p  = new Point(1,2);
   private ColorPoint cp1   = new ColorPoint(1,2,Color.RED);
   private ColorPoint cp2   = new ColorPoint(1,2,Color.BLUE);

   @Test public void transitivity() {
      if (cp1.equals(p) && p.equals(cp2)) {
         assertTrue(cp1.equals(cp2));
      }
   }
}
