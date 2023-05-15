/*---------------------------------------------------------------------------
-					   SE 185: Lab 07 - The DS4 Equalizer                   -
-	Name:Riley Lawson                                                               -
- 	Section:                                                                -
-	NetID:rjlawson                                             -
-	Date: 10/19/2019                                                             -
-                                                                           -
-   This file provides the outline for your program.                        -
-   Please implement the functions given by the prototypes below and        -
-   complete the main function to make the program complete.                -
-   You must implement the functions which are prototyped below exactly     -
-   as they are prototyped.                                                 -
----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
-								Includes									 -
-----------------------------------------------------------------------------*/
#include <stdio.h>

/*----------------------------------------------------------------------------
-	                            Prototypes                                   -
-----------------------------------------------------------------------------*/
void read_input(double *gx, double *gy, double *gz, int *triangle,
                int *circle, int *x_button, int *square, int *left_joy_x_axis,
                int *left_joy_y_axis, int *right_joy_x_axis, int *right_joy_y_axis);

int scale_gyro_for_screen(double gyro_value);

int scale_joy_for_screen(int joy_value);

void print_chars(int number, char char_to_print);

void graph_line(int number, int current_mode);
/*----------------------------------------------------------------------------
-	                                Notes                                    -
-----------------------------------------------------------------------------*/
// Compile with gcc lab07.c -o lab07
// Run with ./ds4rd.exe -d 054c:05c4 -D DS4_BT -g -b -j | ./lab07
// GLOBAL VARIABLES ARE NOT ALLOWED!!!

/*-----------------------------------------------------------------------------
-								Implementation
-----------------------------------------------------------------------------*/
int main(int argc, char *argv[])
{
    double gx, gy, gz;                              /* Values of gx, gy, and gz axis            */

    int triangle, circle, x_button, square,         /* Variables to hold the button statuses    */

            left_joy_x_axis, left_joy_y_axis,       /* Variables to hold the joystick statuses  */
            right_joy_x_axis, right_joy_y_axis,

            scaled_gyro_pitch, scaled_gyro_roll,    /* Value of the roll/pitch of the gyroscope
                                                       adjusted to fit screen display           */

            scaled_joy_pitch, scaled_joy_roll;      /* Value of the roll/pitch of the joystick
                                                       adjusted to fit screen display           */

    /* Put pre-loop preparation code here */
	int mode = 0;
	int pre = 0;
	
    do
    {
        /* Scan a line of input. */
		//scanf("%lf %lf %lf %d %d %d %d %d %d %d %d", gx, gy, gz, triangle, circle, x_button, square, left_joy_x_axis, left_joy_y_axis, right_joy_x_axis, right_joy_y_axis);
		read_input(&gx, &gy, &gz, &triangle,
						&circle, &x_button, &square, &left_joy_x_axis,
						&left_joy_y_axis, &right_joy_x_axis, &right_joy_y_axis);
        /* Calculate and scale for pitch AND roll AND joystick. */
		scaled_gyro_pitch = scale_gyro_for_screen(gz);
		scaled_gyro_roll = scale_gyro_for_screen(gx);
		scaled_joy_pitch = scale_joy_for_screen(left_joy_x_axis);
		scaled_joy_roll = scale_joy_for_screen(left_joy_y_axis);
		
		//printf("%lf %lf %lf %d %d %d %d %d %d %d %d\n", gx, gy, gz, triangle, circle, x_button, square, left_joy_x_axis, left_joy_y_axis, right_joy_x_axis, right_joy_y_axis);

        /* Switch between roll, pitch, and joystick with the up, down, and right button, respectively. */

		//selects mode
		if(pre != x_button && x_button == 1){
			
			mode = mode + 1;
			
			mode = mode % 4;
		
		}
        /* Output your graph line. */
		//each mode (3 does nothing)
		switch(mode){
			case 0:
				graph_line(-scaled_gyro_roll, 0);
				break;
			case 1:
				graph_line(scaled_gyro_pitch, 1);
				break;
			case 2:
				graph_line(scaled_joy_roll, 2);
				break;
			case 3:
				graph_line(scaled_joy_pitch, 3);
				break;
		}
		
		pre = x_button;
        fflush(stdout);

	//triangle stops programs
    } while (!triangle); /* Modify to stop when Triangle is pressed */
	
	
    return 0;

}

/**
 * PRE: Arguments must point to double variables or int variables as appropriate.
 * This function scans a line of DS4 data. It's essentially a convoluted way of
 * doing your standard DS4 scan statement, but it's a basic practice in pointers.
 * POST: it modifies its arguments to return values read from the input line.
 */
void read_input(double *gx, double *gy, double *gz, int *triangle,
                int *circle, int *x_button, int *square, int *left_joy_x_axis,
                int *left_joy_y_axis, int *right_joy_x_axis, int *right_joy_y_axis)
{
	scanf("%lf, %lf, %lf, %d, %d, %d, %d, %d, %d, %d, %d", gx, gy, gz, triangle, circle, x_button, square, left_joy_x_axis, left_joy_y_axis, right_joy_x_axis, right_joy_y_axis);
	
}

/**
 * PRE: ~(-1.0) <= gyro_value <= ~(1.0)
 * This function scales the roll/pitch value of the gyroscope to
 * fit on the screen. Input should be capped at either -1.0 or 1.0
 * before the rest of your conversion.
 * POST: -39 <= return value <= 39
 *
 * @param gyro_value - The appropriate gyroscope value for printing characters.
 * @return - The amount of characters that should be printed.
 */
int scale_gyro_for_screen(double gyro_value)
{
		return gyro_value * 39;
}

/**
 * PRE: -128 <= mag <= 127
 * This function scales the joystick value to fit on the screen.
 * POST: -39 <= return value <= 39
 *
 * @param joy_value - The appropriate joystick value for printing characters.
 * @return - The amount of characters that should be printed.
 */
int scale_joy_for_screen(int joy_value)
{

	return (-joy_value * (39 / 127.0));
}

/**
 * PRE: number >= 0
 * This function prints the character "use" to the screen "num" times.
 * This function is the ONLY place printf is allowed to be used nothing.
 * POST: nothing is returned, but "char_to_print" has been printed "num" times.
 *
 * @param number - The amount of characters to print.
 * @param char_to_print - The character that should be printed.
 */
void print_chars(int number, char char_to_print)
{
	//prints R on right side of center line (0)
	if (char_to_print == 'R'){
		for(int i = 0; i < 40; i++){
			printf(" ");
		}
		
		for(int i = 0; i < number; i++){
			printf("%c", char_to_print);
		}
	}
	
	//prints L on left side of center line (0)
	else if(char_to_print == 'L'){
		for(int i = 0; i < 39 - number; i++){
			printf(" ");
		}
		for(int i = 0; i < number; i++){
			printf("%c", char_to_print);
		}
		
	}
	
	//prints F on right side of center line (0)
	else if (char_to_print == 'F'){
		for(int i = 0; i < 40; i++){
			printf(" ");
		}
		
		for(int i = 0; i < number; i++){
			printf("%c", char_to_print);
		}
	}
	
	//prints B on left side of center line (0)
	else if(char_to_print == 'B'){
		for(int i = 0; i < 39 - number; i++){
			printf(" ");
		}
		for(int i = 0; i < number; i++){
			printf("%c", char_to_print);
		}
		
	}
	else {
		for(int i = 0; i < 39; i++){
			printf("%c", ' ');
		}
		
		printf("%c", '0');
	}
	
	printf("\n");
	fflush(stdout);
}

/**
 * PRE: -39 <= number <= 39
 * Uses print_chars to graph a number from -39 to 39 on the screen.
 * You may assume that the screen is 80 characters wide.
 *
 * @param number - The amount of characters that are to be printed.
 * @param current_mode - The current mode the program is in.
 *                       {0:gyro_roll, 1:gyro_pitch, 2:joy_roll, 3:joy_pitch}
 */
void graph_line(int number, int current_mode)
{
	char c;
	
	//mode 0
	//if == 0 then print 0
	if (current_mode == 0){
		if(number < 1 && number > -1){
			c = '0';
			print_chars(1, '0');
		}
		else if(number > 0){
			c = 'R';
			print_chars(number, c);
		}
		else if (number < 0){
			c = 'L';
			print_chars(number * -1, c);
		}
		
	}
	//mode 1
	if (current_mode == 1){
		if(number < 1 && number > -1){
			c = '0';
			print_chars(1, '0');
		}
		else if(number > 0){
			c = 'F';
			print_chars(number, c);
		}
		else if (number < 0){
			c = 'B';
			print_chars(number * -1, c);
		}
		
	}
	//mode 2
	if (current_mode == 2){
		if(number < 1 && number > -1){
			c = '0';
			print_chars(1, c);
		}
		else if(number > 0){
			c = 'R';
			print_chars(number, c);
		}
		else if (number < 0){
			c = 'L';
			print_chars(number * -1, c);
		}
		
	}