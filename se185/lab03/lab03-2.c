/*----------------------------------------------------------------------------
-		    SE 185: Lab 03 - Introduction to the DS4 and Functions	    	 -
-	Name:Riley Lawson															 -
- 	Section: ?														 -
-	NetID:rjlawson											     -
-	Date:9/24/2019														 -
-----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
-								Includes									 -
-----------------------------------------------------------------------------*/
#include <stdio.h>
#include <math.h>

/*----------------------------------------------------------------------------
-	                            Prototypes                                   -
-----------------------------------------------------------------------------*/
int counter ();

/*----------------------------------------------------------------------------
-	                                Notes                                    -
-----------------------------------------------------------------------------*/
// Compile with gcc lab03-2.c -o lab03-2
// Run with ./ds4rd.exe -d 054c:05c4 -D DS4_BT -b | ./lab03-2

/*----------------------------------------------------------------------------
-								Implementation								 -
-----------------------------------------------------------------------------*/
int main(int argc, char *argv[])
{
	int square;
	int triangle;
	int x;
	int o;
	
    while (1){
		
		counter();
	}
	
	fflush(stdin);
	
    return 0;
}

/* Put your functions here, and be sure to put prototypes above. */

int counter(){
	int square;
	int triangle;
	int x;
	int o;
	
	int c = 0;
	
	scanf("%d, %d, %d, %d", &square, &triangle, &x, &o);
	c = (square + triangle + x + o);
	
	printf("Counter = %d\n", c);
	
	return c;
	
}
