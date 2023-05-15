package lab2;

public class BasketballTest {
	public static void main (String args[]){
		Basketball b;
		b = new Basketball(4.0);
		
		System.out.println(b.getDiameter());
		
		System.out.println(b.isDribbleable());
		
		Basketball b2 = new Basketball(6.0);
		
		b.inflate();
		
		System.out.println(b.isDribbleable());
		System.out.println(b2.isDribbleable());
	}
}
