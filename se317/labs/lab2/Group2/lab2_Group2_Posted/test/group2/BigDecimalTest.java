// Introduction to Software Testing
// Authors: Paul Ammann & Jeff Offutt
// Chapter 1; page ??
// JUnit to exercise java.math.BigDecimal class

package group2;

import static org.junit.Assert.*;
import org.junit.*;
import java.util.*;
import java.math.*;

public class BigDecimalTest { 
  private BigDecimal x;
  private BigDecimal y;

  Set <BigDecimal> tree;
  Set <BigDecimal> hash;

  @Before public void setUp() {
     x = new BigDecimal("1.0"); 
     y = new BigDecimal("1.0");
     // Fact:  !x.equals(y), but x.compareTo(y) == 0

     tree = new TreeSet <BigDecimal> ();
     hash = new HashSet <BigDecimal> ();
  }
 
  @Test public void inconsistentSets() {
     tree.add(x); tree.add(y);
     // TreeSet uses compareTo()

     hash.add(x); hash.add(y);
     // HashSet uses equals()

     assertEquals(tree, hash);  
  }
} 
