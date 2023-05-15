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
double voltage(double resistance, double current);

double resistance(double voltage, double current);

double current(double voltage, double resistance);

/*----------------------------------------------------------------------------
-	                                Notes                                    -
-----------------------------------------------------------------------------*/
// Compile with gcc lab04-2_4.c -o lab04-2_4
// Run with ./lab04-2_4
/* This program calculates values of resistances,
 * voltages, or current using Ohm's Law */

/*----------------------------------------------------------------------------
-								Implementation								 -
-----------------------------------------------------------------------------*/
int main(int argc, char *argv[])
{
    int selection = 0; 
    double v, i, r; //needs to be double not integer

    printf("selection:\n1 for voltage\n2 for resistance\n3 for current\n");

    scanf("%d", &selection);

    if (selection > 3 || selection < 1)
    {
        printf("Invalid number\n");
        return -1;
    }

    printf("Enter floating point numbers for input...\n");
    if (selection == 1)
    {
        printf("Please enter a resistance value: ");
        scanf("%lf", &r);

        printf("Please enter a current value: ");
        scanf("%lf", &i);

        printf("Your voltage is: %lf Volts\n", voltage(r, i));
    } else if (selection == 2)
    {
        printf("Please enter a voltage value: ");
        scanf("%lf", &v);

        printf("Please enter a current value: ");
        scanf("%lf", &i);

        printf("Your Resistance is: %lf Ohms\n", resistance(v, i));

    } else if (selection == 3)
    {
        printf("Please enter a resistance value: ");
        scanf("%lf", &r);

        printf("Please enter a voltage value: ");
        scanf("%lf", &v);

        printf("Your current is: %lf Amps\n", current(v, r));
    }

    return 0;
}

/**
 * Given the resistance and current, calculates and returns the voltage.
 *
 * @param resistance - The resistance used to calculate the voltage.
 * @param current - The current used to calculate the voltage.
 * @return - The voltage calculated from the resistance and current.
 */
double voltage(double resistance, double current)
{
    return resistance * current;
}

/**
 * Given the voltage and current, calculates and returns the resistance.
 *
 * @param voltage - The voltage used to calculate the resistance.
 * @param current - The resistance used to calculate the resistance.
 * @return - The resistance calculated from the voltage and current.
 */
double resistance(double voltage, double current)
{
    return voltage / current;
}

/**
 * Given the voltage and resistance, calculates and returns the current.
 *
 * @param voltage - The voltage used to calculate the current.
 * @param resistance - The resistance used to calculate the current.
 * @return - The current calculated from the voltage and resistance.
 */
double current(double voltage, double resistance)
{
    return voltage / resistance;
}
