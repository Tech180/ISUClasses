/*----------------------------------------------------------------------------
-		                 SE 185: Lab 04 - Debugging Code	    	         -
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
-	                                Notes                                    -
-----------------------------------------------------------------------------*/
// Compile with gcc lab04-1_1.c -o lab04-1_1
// Run with ./lab04-1_1
/* This program outputs if a integer will divide into another integer with no remainder. */

/*----------------------------------------------------------------------------
-								Implementation								 -
-----------------------------------------------------------------------------*/
int main(int argc, char *argv[])
{
    int i, j;

    printf("Enter an integer: ");
	//printf("Enter an integer: ")	//no semicolon
    scanf("%d", &i);

    //printf("Enter another integer: ); //no end quotes
	printf("Enter another integer: ");
    //scanf("%d", &j) //no semicolon
	scanf("%d", &j);

    if (j % i == 0)
    {
        //printf("%d divides %d\n", i, j);
		printf("%d divides %d\n", i, j);
		
    } //else {	//no else bracket
		else {
			
		//pritf("%d does not divide %d\n", i, j); //pritf
		printf("%d does not divide %d\n", i, j);
        printf("%d %% %d is %d\n", j, i, (j % i));
    }

    return 0;
}
