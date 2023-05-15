package lab5;

import balloon2.Balloon;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;

public class BalloonTest {
	
	private static final double EPSILON = 10e-07;
	private Balloon b ;
	
	@Before
	public void setup(){
		b = new Balloon (10);
	}
	@Test
	public void blow(){
		assertEquals(0, b.getRadius());
		b.blow(1);
		assertEquals(1, b.getRadius());
		b.blow(1);
		assertEquals(2, b.getRadius()); //3
		assertEquals(false, b.isPopped());
		b.blow(1);
		assertEquals(3, b.getRadius());
		b.blow(1);
		assertEquals(4, b.getRadius());
		b.deflate();
		assertEquals(0, b.getRadius());
		b.blow(1);
		assertEquals(1, b.getRadius());
		b.blow(1);
		assertEquals(2, b.getRadius());
		b.blow(3);
		assertEquals(5, b.getRadius());
		b.pop();
		b.blow(5);
		assertEquals(0, b.getRadius(), EPSILON); //pop it, blow it, it is still supposed to be 0
		
		
	}
	@Test
	public void blow2(){
		b.blow(20);
//		assertEquals(0, b.getRadius());
		assertEquals(true, b.isPopped());
		
	}
	
	@Test
	public void deflate(){
		b.blow(1);
		b.deflate();
		b.blow(3);
		assertEquals(3, b.getRadius());
		b.pop();
		assertEquals(true, b.isPopped());
		b.blow(5);
		assertEquals(true, b.isPopped());
		
		
	}
	
	@Test
	public void getRadius(){
		assertEquals(0, b.getRadius(), EPSILON);
		b.blow(1);
		b.deflate();
		b.blow(3);
		assertEquals(3, b.getRadius());
		b.pop();
		assertEquals(true, b.isPopped());
		b.blow(5);
		assertEquals(true, b.isPopped());
	}
	
	@Test
	public void isPopped(){
		assertEquals(false, b.isPopped());
		b.blow(1);
		b.deflate();
		b.blow(1);
		assertEquals(false, b.isPopped());
		assertEquals(1, b.getRadius()); //4
		b.pop();
		assertEquals(true, b.isPopped());
		b.blow(5);
		assertEquals(true, b.isPopped());
	}
	
	@Test
	public void pop(){
		assertEquals(false, b.isPopped());
		b.blow(1);
		b.deflate();
		b.blow(1);
		assertEquals(1, b.getRadius());
		b.pop();
		assertEquals(true, b.isPopped());
		b.blow(5);
		assertEquals(true, b.isPopped());
	}
	
}
