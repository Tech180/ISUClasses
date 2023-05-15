/*---------------------------------------------------------------------------
-		        SE 185: Lab 08 - The A-Mazing DS4 Race - Part 1             -
-	Name:                                                                   -
- 	Section:                                                                -
-	NetID:                                                                  -
-	Date:                                                                   -
----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
-								Includes									 -
-----------------------------------------------------------------------------*/
#include <stdio.h>

/*----------------------------------------------------------------------------
-								Defines	    								 -
-----------------------------------------------------------------------------*/
#define MAX_POINTS 10000

/*----------------------------------------------------------------------------
-	                            Prototypes                                   -
-----------------------------------------------------------------------------*/
double moving_average(double buffer[], int average_size, double new_item);

/*----------------------------------------------------------------------------
-	                                Notes                                    -
-----------------------------------------------------------------------------*/
// Compile with gcc lab08-1.c -o lab08-1
// Run with ./ds4rd.exe -d 054c:05c4 -D DS4_BT -g | ./lab08-1 { buffer_length }
// NO GLOBAL VARIABLES ARE ALLOWED!

/*---------------------------------------------------------------------------
-								Implementation                              -
----------------------------------------------------------------------------*/
int main(int argc, char *argv[])
{
    /* DO NOT CHANGE THE MAIN FUNCTION. */
    double gx[MAX_POINTS], gy[MAX_POINTS], gz[MAX_POINTS];
    double new_gx, new_gy, new_gz;
    double avg_gx, avg_gy, avg_gz;
    int length_of_average = 0;
    int i;

    if (argc > 1)
    {
        sscanf(argv[1], "%d", &length_of_average);
        printf("You entered a buffer length of %d.\n", length_of_average);
    } else
    {
        printf("Enter a length on the command line.\n");
        return -1;
    }
    if (length_of_average < 1 || length_of_average > MAX_POINTS)
    {
        printf("Invalid length.\n");
        return -1;
    }

    for (i = 0; i < length_of_average; i++)
    {
        scanf("%lf, %lf, %lf", &new_gx, &new_gy, &new_gz);
        gx[i] = new_gx;
        gy[i] = new_gy;
        gz[i] = new_gz;
    }

    while (1)
    {
        scanf("%lf, %lf, %lf", &new_gx, &new_gy, &new_gz);

        avg_gx = moving_average(gx, length_of_average, new_gx);
        avg_gy = moving_average(gy, length_of_average, new_gy);
        avg_gz = moving_average(gz, length_of_average, new_gz);

        printf("RAW, %lf, %lf, %lf, AVG, %lf, %lf, %lf\n", new_gx, new_gy, new_gz, avg_gx, avg_gy, avg_gz);
        fflush(stdout);
    }
}

/**
 * Updates the buffer (that determines orientation) with the new_item
 * and returns the computed moving average of the updated buffer.
 *
 * @param buffer - An array of doubles used to hold the values that determine the average.
 * @param average_size - The size of your buffer.
 * @param new_item - The new element to be placed into the array.
 * @return - The moving average of the values in the buffer (your array).
 */
double moving_average(double buffer[], int average_size, double new_item)
{
	double b_size = 0;
	double overall_avg = 0;
	int i = 0;
	
	for(i = average_size; i > 1; i--) {
		buffer[i] = buffer[i + 1];
	}
	
	buffer[average_size-1] = new_item;
	
	for(int i = 0; i < average_size; i++){
		b_size = buffer[i] + 1;
	}
	
	overall_avg = b_size / average_size;
	return overall_avg;
}
