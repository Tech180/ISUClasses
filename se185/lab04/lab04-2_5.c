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
-	                            Prototypes                                   -
-----------------------------------------------------------------------------*/
int is_positive(int number);

int is_negative(int number);

int is_zero(int number);

/*----------------------------------------------------------------------------
-	                                Notes                                    -
-----------------------------------------------------------------------------*/
// Compile with gcc lab04-2_5.c -o lab04-2_5
// Run with ./lab04-2_5
/* This program takes in an integer from the user and
 * checks to see if it is a whole number. Additionally,
 * it will tell the user if the number is positive,
 * negative, or zero.
 *
 * Example:
 *      $ ./lab04_2-5
 *      $ Please type a number between -10000 and 10000: -500
 *      $ -500 is non-positive and -500 is non-zero and -500 is non-whole number.
 */

/*----------------------------------------------------------------------------
-								Implementation								 -
-----------------------------------------------------------------------------*/
int main(int argc, char *argv[])
{
    int number;

    printf("Please type a number between -10000 and 10000: ");
    scanf("%d", &number);

    if (number > 10000 | number < -10000)
    {
        printf("Number is out of range!\n");
        return -1;
    }

    if ((is_positive(number) & !is_negative(number)) | is_zero(number))
    {
        printf("%d is a whole number.\n", number);
    } else
    {
        printf("%d is non-whole number.\n", number);
    }

    return 0;
}

/**
 * Determines if the given number is positive.
 *
 * @param number - The number in question of whether it is positive or not.
 * @return - Whether the given number is positive.
 */
int is_positive(int number)
{
    if (number > 0)
    {
        printf("%d is positive and ", number);
        return 1;
    }

    printf("%d is non-positive and ", number);
    return 0;
}

/**
 * Determines if the given number is negative.
 *
 * @param number - The number in question of whether it is negative or not.
 * @return - Whether the given number is negative.
 */
int is_negative(int number)
{
    if (number < 0)
    {
        printf("%d is negative and ", number);
        return 1;
    }

    printf("%d is non-negative and ", number);
    return 0;
}

/**
 * Determines if the given number is 0.
 *
 * @param number - The number in question of whether it is 0 or not.
 * @return - Whether the given number is 0.
 */
int is_zero(int number)
{
    if (number == 0) //== instead of = 
    {
        printf("%d is zero and ", number); //n has to be number
        return 1;
    }

    printf("%d is non-zero and ", number);
    return 0;
}
