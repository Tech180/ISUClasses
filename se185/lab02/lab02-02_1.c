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
	printf("Name: Riley");
	printf("\n");
	
	printf("Section: 5");
	printf("\n");
	
	printf("NetID: rjlawson");
	printf("\n");
	
	printf("Date: 9/11/2019");
	printf("\n");

	int x, y, z;
	
	printf("Enter a width: ");
	scanf("%d", &x);
	
	printf("Enter a height: ");
	scanf("%d", &y);
	
	printf("A %d by %d rectangle's area is %d\n", x, y, x * y);

    return 0;
}
