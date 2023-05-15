/*----------------------------------------------------------------------------
-		        SE 185: Lab 02 - Solving Simple Problems in C	    	 	 -
-	Name:																	 -
- 	Section:																 -
-	NetID:																     -
-	Date:																	 -
-----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
-								Includes									 -
-----------------------------------------------------------------------------*/
#include <stdio.h>
#include <math.h>

/*----------------------------------------------------------------------------
-								Implementation								 -
-----------------------------------------------------------------------------*/
int main(int argc, char *argv[])
{
    /* Put your code after this line */
	int integer_result;
	double decimal_result;
	double area;
	double pie = 3.14;
	int foot = 1;
	double conversion = 3.28;
	double f;
	double meters;
	double c;
	
	integer_result = 6427 + 1725;
	printf("The value of 6427 + 1725 is %d.\n", integer_result);
	
	integer_result = (6971 * 3925) - 95;
	printf("The value of (6971 * 3925) - 95 is %d.\n", integer_result);
	
	decimal_result = 79 + 12 / 5;
	printf("The value of 79 + 12 / 5 is %lf.\n", decimal_result);
	
	decimal_result = 3640.0 / 107.9;
	printf("The value of 3640.0 / 107.9 is %lf.\n", decimal_result);
	
	integer_result = (22 / 3) * 3;
	printf("The value of (22 / 3) * 3 is %d.\n", integer_result);
	
	integer_result = 22 / (3 * 3);
	printf("The value of (22 / 3) * 3 is %d.\n", integer_result);
	
	decimal_result = 22 / (3 * 3);
	printf("The value of 22 / (3 * 3) is %lf.\n", decimal_result);
	
	decimal_result = 22 / 3 * 3;
	printf("The value of 22 / 3 * 3 is %lf.\n", decimal_result);
	
	decimal_result = (22.0 / 3) * 3.0;
	printf("The value of (22.0 / 3) * 3.0 is %lf.\n", decimal_result);
	
	integer_result = 22 / (3 * 3.0);
	printf("The value of 22 / (3 * 3.0) is %d.\n", integer_result);
	
	decimal_result = 22.0 / 3.0 * 3.0;
	printf("The value of 22.0 / 3.0 * 3.0 is %lf.\n", decimal_result);
	
	area = pow(23.567, 2)  / (4 * pie);
	decimal_result = area;
	printf ("The area of the circle with the circumference is %lf.\n", decimal_result);

	foot = 14;
	meters = foot / conversion;
	decimal_result = meters;
	printf("14 feet to meters is %lf.\n", decimal_result);
	
	f = 76;
	c = (f - 32) / 1.8;
	decimal_result = c;
	printf("76 degrees Fahrenheit to Celsius = %lf.\n", decimal_result);
	
    return 0;
}
