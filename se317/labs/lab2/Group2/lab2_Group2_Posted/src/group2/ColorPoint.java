// Introduction to Software Testing
// Authors: Paul Ammann & Jeff Offutt
// Chapter 1; page ??
// See PointTest.java for JUnit tests
// See also Point.java

package group2;

public class ColorPoint extends Point 
{
   private Color color;
   // Fault: Superclass instantiable; subclass state extended
 
   public ColorPoint(int x, int y, Color color) { 
      super (x,y);
      this.color=color; 
   } 

   @Override public boolean equals(Object o) { 
      // Location B
      if (!(o instanceof ColorPoint)) return false;
      ColorPoint cp = (ColorPoint) o;
      return (super.equals(cp) &&  (cp.color == this.color));
   }
}

enum Color { RED, WHITE, BLUE }
