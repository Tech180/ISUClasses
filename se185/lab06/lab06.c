/*----------------------------------------------------------------------------
-		                    SE 185: Lab 06 - Bop-It!	    	             -
-	Name:Riley Lawson																	 -
- 	Section:															 -
-	NetID:rjlawson														     -
-	Date:10/22/2019															 -
-----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
-								Includes									 -
-----------------------------------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

/*----------------------------------------------------------------------------
-	                            Prototypes                                   -
-----------------------------------------------------------------------------*/
int game(int correct_b, int currentT);
/*----------------------------------------------------------------------------
-	                            Notes                                        -
-----------------------------------------------------------------------------*/
// Compile with gcc lab06.c -o lab06
// Run with ./ds4rd.exe -d 054c:05c4 -D DS4_BT -t -b | ./lab06

/*----------------------------------------------------------------------------
-								Implementation								 -
-----------------------------------------------------------------------------*/
int main(int argc, char *argv[])
{
	//variables
	int realTime, triangle, circle, x_button, square;
	int current, round, correct;
	triangle = 0;
	current = 2500;
	correct = 1;
	round = 0;
	
	printf("Press triangle to start!\n\n");
	
	srand(time(NULL)); /* This will ensure a random game each time. */
	
	//if triangle isn't pressed... nothing will happen
	while(!triangle){
		scanf("%d, %d, %d, %d, %d", &realTime, &triangle, &circle, &x_button, &square);
		}
	
	//if triangle is pressed
	while(correct){
		int x;
		x = rand() % 100;
		//scan controller for these variables
		scanf("%d, %d, %d, %d, %d", &realTime, &triangle, &circle, &x_button, &square);
		
		while(triangle == 1|| circle == 1 || x_button == 1 || square == 1){
			scanf("%d, %d, %d, %d, %d", &realTime, &triangle, &circle, &x_button, &square);
		}
		
		//random number generator
		//triangle = correct
		if(x > 75){
			correct = game(1, current);
			if (correct == 1){
				
				current = current - 100;
				
				round = round + 1;
			}
			else{
				break;
			}
			
		}
		
		else if(x > 50){
			correct = game(2, current);
			if (correct == 1){
				
				current = current - 100;
				
				round = round + 1;
			}
			else{
				break;
			}
			
		}
		
		else if(x > 25){
			correct = game(3, current);
			if (correct == 1){
				
				current = current - 100;
				
				round = round + 1;
			}
			else{
				break;
			}
			
		}
		
		
		else if(x > 0){
			correct = game(4, current);
			if (correct == 1){
				
				current = current - 100;
				
				round = round + 1;
			}
			else{
				break;
			}
			
		}
	}
	//prints round
	printf("You made it through %d rounds", round);

	return 0;
}
/* Put your functions here, and be sure to put prototypes above. */

//the game
int game(int correct_b, int currentT){
	int time, triangle = 0, circle = 0, x_button = 0, square = 0;
	
	scanf("%d, %d, %d, %d, %d", &time, &triangle, &circle, &x_button, &square);
	
	int time1 = time;
	//triangle = correct
	if(correct_b == 1){
		
		printf("Press the triangle button!\n");
		
		printf("You have %d milliseconds to respond!\n\n", currentT);
			
			while (time < (time1 + currentT)){
				scanf("%d, %d, %d, %d, %d", &time, &triangle, &circle, &x_button, &square);
				
				if(triangle){
					return 1;
				}
				//pressed wrong button
				else if(circle || x_button || square){
					printf("Wrong Button! \n");
					printf("You lose :(\n");
					return 0;
				}
			}
		
		printf("You ran out of time\n");
		return 0;	
	}

	//circle = correct
	if(correct_b == 2){
		printf("Press the circle button!\n");
		printf("You have %d milliseconds to respond!\n\n", currentT);
			
			while (time < (time1 + currentT)){
				scanf("%d, %d, %d, %d, %d", &time, &triangle, &circle, &x_button, &square);
				
				if(circle){
					return 1;
				}
				//pressed wrong button
				else if(triangle || x_button || square){
					printf("Wrong Button! \n");
					printf("You lose :(\n");
					return 0;
				}
			}
		
		printf("You ran out of time\n");
		return 0;	
	}
	
	//square = correct
	if(correct_b == 3){
		printf("Press the square button!\n");
		printf("You have %d milliseconds to respond!\n\n", currentT);
			
			while (time < (time1 + currentT)){
				scanf("%d, %d, %d, %d, %d", &time, &triangle, &circle, &x_button, &square);
				
				if(square){
					return 1;
				}
				//pressed wrong button
				else if(triangle || x_button || circle){
					printf("Wrong Button! \n");
					printf("You lose :(\n");
					return 0;
				}
			}
			
		printf("You ran out of time\n");
		return 0;	
	}
	//x_button = correct
	if(correct_b == 4){
		printf("Press the cross button!\n");
		printf("You have %d milliseconds to respond!\n\n", currentT);
			
			while (time < (time1 + currentT)){
				scanf("%d, %d, %d, %d, %d", &time, &triangle, &circle, &x_button, &square);
				
				if(x_button){
					return 1;
				}
				//pressed wrong button
				else if(triangle || circle || square){
					printf("Wrong Button!\n");
					printf("You lose :(\n");
					return 0;
				}
			}
		//out of time
		printf("You ran out of time\n");
		return 0;	
	}
	
	return 1;
	
}