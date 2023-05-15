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
#include <math.h>

/*----------------------------------------------------------------------------
-	                                Notes                                    -
-----------------------------------------------------------------------------*/
// Compile with gcc lab04-1_4.c -o lab04-1_4
// Run with ./lab04-1_4
/* This program calculates the energy of one photon
 * of user-inputted wave-length of light */

/*----------------------------------------------------------------------------
-								Implementation								 -
-----------------------------------------------------------------------------*/
int main(int argc, char *argv[])
{
    //double speed_of_light!; //no special characters
    double speed_of_light;
	//double wave-length; //no special characters
	double wavelength;
    double length_in_meters; //no special characters
    //double plank const; //constant has to be in front of the variable
    const double plank = 6.62606957 * pow(10, -34);;
	//double 0energy; //can't have a number in front of the variable
	double energy;
	
    //plank const= 6.62606957 * pow(10, -34); // Planck's constant ///const is not needed ////has to be assigned within declaration of the variable
	speed_of_light = 2.99792458 * pow(10, 8); // Constant for the speed of light
    wavelength = 0;
    length_in_meters = 0;
    energy = 0;

    printf("Welcome! This program will give the energy, in Joules,\n");
    printf("of 1 photon with a certain wave-length.\n");
    printf("Please input a wave-length of light in nano-meters.\n");
    printf("Please do not enter a negative, or zero, wave-length.\n");

    scanf("%lf", &wavelength);

    if (wavelength > 0.0)
    {
        length_in_meters = wavelength / pow(10, 9); // Converting nano-meters to meters
        energy = (plank * speed_of_light) / length_in_meters; // Calculating the energy of 1 photon
        printf("A photon with a wave-length of %08.3lf nano-meters, carries "
               "\napproximately %030.25lf joules of energy.", wavelength, energy);
    } else
    {
        printf("Sorry, you put in an invalid number.");
        printf("Please rerun the program and try again.");
    }

    return 0;
}
