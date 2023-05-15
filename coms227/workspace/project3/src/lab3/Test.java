package lab3;

import java.util.Random;

public class Test {
	public static void main(String [] args){
		//String s = "42";
		//int x = Integer.parseInt(s);
		
		//String lol = Integer.parseInt(lol);
		
		System.out.println(Integer.MAX_VALUE + 1);
		System.out.println(Integer.MIN_VALUE + 1);
		
		System.out.println(Integer.MAX_VALUE + 2);
		System.out.println(Integer.MIN_VALUE + 2);

		System.out.println(Integer.MAX_VALUE + Integer.MIN_VALUE);
		
		Random rand = new Random();
		
		System.out.println(rand.nextInt(6));
		System.out.println(rand.nextInt(6));
		System.out.println(rand.nextInt(6));
		System.out.println(rand.nextInt(6));
		
		rand = new Random(137);
		
		System.out.println(rand.nextInt(6));
		System.out.println(rand.nextInt(6));
		System.out.println(rand.nextInt(6));
		System.out.println(rand.nextInt(6));
	}
}
