package lab2;

public class StringTest {
	public static void main(String[]args){
	
	String message;
		
	message = "Hello, world!";
	System.out.println(message);
	
	char theChar = message.charAt(0);
	System.out.println(theChar);

	theChar = message.charAt(1);
	System.out.println(theChar);
	
	System.out.println(message.toUpperCase());
	System.out.println(message.substring(0,5));
	
	System.out.println(message.replace('o', '*'));
	
	}
}
