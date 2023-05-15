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

/*----------------------------------------------------------------------------
-								Implementation								 -
-----------------------------------------------------------------------------*/
int main(int argc, char *argv[])
{
	//Riley Lawson
	//Original lines will be in comments that have errors
    int integer_result;
    double decimal_result;

	//it needs to be %d instead of %lf
    //integer_result = 77 / 5;
	//printf("The value of 77/5 is %lf, using integer math.\n", integer_result);
	integer_result = 77 / 5;
	printf("The value of 77/5 is %d, using integer math.\n", integer_result);
	
	//This is almost correct except it doesn't state the variable again after the quotes
    //printf("The value of 2+3 is %d.\n");
	integer_result = 2 + 3;
	printf("The value of 2+3 is %d.\n", integer_result);
	
	//This is a decimal and should be using a %lf, not a %d
    //printf("The value 1.0/22.0 is %d.\n", decimal_result);
	decimal_result = 1.0 / 22.0;
	printf("The value 1.0/22.0 is %lf.\n", decimal_result);
    
	return 0;
}
