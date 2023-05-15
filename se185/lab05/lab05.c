/*----------------------------------------------------------------------------
-		         SE 185: Lab 05 - Conditionals (What's up?)	    	         -
-	Name:Riley Lawson																 -
- 	Section:															 -
-	NetID:rjlawson														     -
-	Date:10/15/2019													 -
-----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
-								Includes									 -
-----------------------------------------------------------------------------*/
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
/*----------------------------------------------------------------------------
-	                            Prototypes                                   -
-----------------------------------------------------------------------------*/
int close_to (double tolerance, double point, double value);

double stop (int triangle, int circle, int x_button, int square);

double magnitude(double x, double y, double z);
/*----------------------------------------------------------------------------
-	                                Notes                                    -
-----------------------------------------------------------------------------*/
// Compile with gcc lab05.c -o lab05
// Run with ./ds4rd.exe -d 054c:05c4 -D DS4_BT -a -g -b | ./lab05

/*----------------------------------------------------------------------------
-								Implementation								 -
-----------------------------------------------------------------------------*/
int main(int argc, char *argv[])
{
	//variables
    int triangle, circle, x_button, square;
    double ax, ay, az, gx, gy, gz;
	double tolerance, point, value;
	int last, current;
	
	printf("Press triangle to start\n");
	
	
	
    while (1)
    {
        scanf("%lf, %lf, %lf, %lf, %lf, %lf, %d, %d, %d, %d",
              &ax, &ay, &az, &gx, &gy, &gz, &triangle, &circle, &x_button, &square);
		
		//checking position on controller
		if (close_to(.1, 0 ,magnitude(ax, ay, az))){
		
			if (close_to(.1, 1, (gx))){
				current = 0;
			}
			else if (close_to(.1, -1, (gx))){
				current = 1;
			}
			
			else if (close_to(.1, 1, (gy))){
				current = 2;
			}
			
			else if (close_to(.1, -1, (gy))){
				current = 3;
			}
			
			else if (close_to(.1, 1, (gz))){
				current = 4;
			}
			
			else if (close_to(.1, -1, (gz))){
				current = 5;
			}
			//when the controller is in one of these orientations it will output (for example: "Right") only one until the orientation changes
			if(current != last) {
				if(current == 0){
					printf("Right\n");
					fflush(stdout);
				}
				else if(current == 1){
					printf("Left\n");
					fflush(stdout);

				}
				else if(current == 2){
					printf("Top\n");
					fflush(stdout);
				}
				else if(current == 3){
					printf("Bottom\n");
					fflush(stdout);

				}
				else if(current == 4){
					printf("Back\n");
					fflush(stdout);

				}
				else if(current == 5){
					printf("Front\n");
					fflush(stdout);

				}
			}
			}
			last = current;
		
        /* printf for observing values scanned in from ds4rd.exe,
         * be sure to comment or remove in final program */
        //printf("Echoing output: %lf, %lf, %lf, %lf, %lf, %lf, %d, %d, %d, %d \n",
        //       ax, ay, az, gx, gy, gz, triangle, circle, x_button, square);
		
		//closeto function
		close_to(tolerance, point, value);
		stop(triangle, circle, x_button, square);
		
        /* It would be wise (mainly save time) if you copy your code to calculate
         * the magnitude from lab03-1.c. You will also need to copy your
         * prototypes and functions to the appropriate sections in this program. */

        //printf("The acceleration's current magnitude is: %lf\n", t, magnitude(ax, ay, az));
    }

    return 0;
}

/* Put your functions here, and be sure to put prototypes above. */
//if the numbers are close to a certain range of numbers
int close_to (double tolerance, double point, double value){
	
	double upper = point + tolerance;
	double lower = point - tolerance;
	
		if(value <= upper && value >= lower){
			value = 1;
}
		else{
			value = 0;
		}
		
		return value;
}

//magnetude imported from previous code
double magnitude(double x, double y, double z)
{
	double magnetude = pow(x, 2) + pow(y, 2) + pow(z, 2);

    return sqrt(magnetude);
}

//stop function
//when the triangle button is pressed it stops the program
double stop(int triangle, int circle, int x_button, int square){
	
	if(triangle == 1 ){
		exit(0);
	}
	else if (circle == 1 || x_button == 1 || square == 1){
		return 0;
	}
	
}
