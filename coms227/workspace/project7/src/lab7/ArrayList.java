package lab7;

import java.util.*;

public class ArrayList {
	public static void main(String [] args){
		
		int[] arr;
		
		arr = new int[4];
		
		arr[0] = 17;
	    arr[1] = 42;
	    arr[2] = arr[1] - arr[0];
	    arr[3] = arr[0]- arr[1];
	    
	    System.out.println(Arrays.toString(arr));
	    System.out.println(Arrays.toString(getPositiveNumbers(arr)));
	    
	    
	    System.out.println(Arrays.toString(randomExperiment(10, 1000)));
	    
	    
	}
	
	
	
	public static int[] getPositiveNumbers(int[] numbers){
		
		int[] arr = new int[numbers.length];
		
		for(int i = 0; i < numbers.length; i++){
			if(numbers[i] > 0){
				arr[i] = numbers[i];
			}
			else{
				arr[i] = 0;
			}
		}
		return arr;
		}
		
	    public static int[] randomExperiment(int max, int iters){
	    	
	    	Random r = new Random();
	    	int[] count  = new int[max];
	    	for(int i = 0; i < iters; i += 1){
	    		int rInt = r.nextInt(max);
	    		count[rInt]++;
	    	}
	    	return count;
	    	
	    }
		
	}

