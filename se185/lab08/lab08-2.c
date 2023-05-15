/*---------------------------------------------------------------------------
-		        SE 185: Lab 08 - The A-Mazing DS4 Race - Part 2             -
-	Name:                                                                   -
- 	Section:                                                                -
-	NetID:                                                                  -
-	Date:                                                                   -
----------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------
-								Includes
-----------------------------------------------------------------------------*/
#include <stdio.h>
#include <math.h>
#include <ncurses/ncurses.h>
#include <unistd.h>
#include <stdlib.h>
#include <time.h>

/*----------------------------------------------------------------------------
-								Defines	    								 -
-----------------------------------------------------------------------------*/
/*
 * Screen geometry:
 * Use ROWS and COLUMNS for the screen height and width
 * (set by the system). These are the maximums.
 */
#define COLUMNS 100
#define ROWS 80

/* Character definitions taken from the ASCII table */
#define AVATAR 'A'
#define WALL '*'
#define EMPTY_SPACE ' '
/*
 * Number of samples taken to form a moving average
 * for the gyroscope data. Feel free to modify this.
 */
#define LENGTH_OF_AVERAGE 10

/*-----------------------------------------------------------------------------
-								Static Data
-----------------------------------------------------------------------------*/
/* 2D character array which the maze is mapped into */
char MAZE[COLUMNS][ROWS];

/*-----------------------------------------------------------------------------
-								Prototypes
-----------------------------------------------------------------------------*/
void generate_maze(int difficulty);

void draw_maze();

void draw_character(int row, int column, char use);

double moving_average(double buffer[], int average_size, double new_item);

int detect_failure(int avatar_row, int avatar_column);

/*----------------------------------------------------------------------------
-	                                Notes                                    -
-----------------------------------------------------------------------------*/
// Compile with gcc lab08-2.c -o lab08-2 -lncurses
// Run with ./ds4rd.exe -d 054c:05c4 -D DS4_BT -t -g -b | ./lab08-2 { difficulty }
// NO GLOBAL VARIABLES ARE ALLOWED!

/*----------------------------------------------------------------------------
-								Implementation                               -
-----------------------------------------------------------------------------*/
int main(int argc, char *argv[])
{
    /* Place your variables here. */
		int difficulty;
		//int startF = 0;
		//int startT = 1;
		double gx[LENGTH_OF_AVERAGE];
		double new_gx, new_gy, new_gz;
		double avg_gx;
		//avg_gy, avg_gz;
		int triangle, circle, x_button, square;
		int prevTime = 0;
		int i, t;
		int right = 40;
		int down = 0;
		int nTime = 200;
		int flagR = 0;
		int flagL = 0;
		
    sscanf(argv[1], "%d", &difficulty);
    if (difficulty > 0 && difficulty < 100)
    {
		
		printf("The difficulty level must be between 0 and 100.\n"
               "Rerun the command line with a valid difficulty level.\n");
			   

    }
    /*
     * Setup screen for ncurses:
     * The initscr() function is used to setup the ncurses environment.
     * The refresh() function needs to be called to update the screen
     * with any changes you've created. */
    initscr();
    refresh();

    /* WEEK 2 Generate the Maze */

	generate_maze(difficulty);
	draw_maze();


    /* Read gyroscope data and fill the buffer before continuing. */
	for(i = 0; i < LENGTH_OF_AVERAGE; i++){
		//scanf("%d, %lf, %lf, %lf", &t, &new_gx, &new_gy, &new_gz);
		scanf("%d, %lf, %lf, %lf, %d, %d, %d, %d", &t, &new_gx, &new_gy, &new_gz, &triangle, &circle, &x_button, &square);
		gx[i] = new_gx;
		//scanf("%d, %lf, %lf, %lf, %d, %d", &t, &new_gx, &triangle, &circle, &x_button, &square);
		//gx[i] = new_gx;
		
	}
	
	avg_gx = moving_average(gx, LENGTH_OF_AVERAGE, new_gx);
	draw_character(right, down, 'A');
    /* Event loop */
    do
    {
		
		//draw_character(startF, startT);
        /* Read data, update average */
			scanf("%d, %lf, %lf, %lf, %d, %d, %d, %d", &t, &new_gx, &new_gy, &new_gz, &triangle, &circle, &x_button, &square);
			
			avg_gx = moving_average(gx, LENGTH_OF_AVERAGE, new_gx);
			//avg_gy = moving_average(gy, LENGTH_OF_AVERAGE, new_gy);
			//avg_gz = moving_average(gz, LENGTH_OF_AVERAGE, new_gz);
       
	   /* Is it time to move?  if so, then move avatar */
			/*if(t >= prevTime + 100){
				prevTime = t;
				
				startF = avg_gx;
				startT = startT + 1;
				
				draw_character(startF, startT, );
				
			}
			*/
			/*
			if(t >= prevTime + 100){
				if(avg_gx > .25){
					draw_character(right, down,' ');
					draw_character(right + 1, down, 'A');
					
					right = right + 1;
				}
				if(avg_gx < -.25){
					draw_character(right, down, ' ');
					draw_character(right - 1, down, 'A');
					right = right - 1;
				}
			}
			if(t >= prevTime + 250){
				draw_character(right, down + 1,'A');
				draw_character(right, down, ' ');
				
				down = down + 1;
				
				prevTime = t;
			}
			*/
		if(t >= nTime){
			if(avg_gx <= -.5 && right < 80 && right >= 0){ //moving right
				if(MAZE[right + 1][down] != '*'){
					right++;
					nTime = t + 50;
					draw_character(right - 1, down, ' ');
					draw_character(right, down, 'A');
			}
				else if(MAZE[right + 1][down] == '*' && MAZE[right][down + 1] == '*' && avg_gx <= -.5)
				{
					flagR = 1;
				}
			
			}
			if(avg_gx >= .5 && right <= 80 && right > 0){ //moving down
				if(MAZE[right - 1][down] != '*'){ 
					right--;
					nTime = t + 50;
					draw_character(right + 1, down, ' ');
					draw_character(right, down, 'A');
			}
				else if(MAZE[right - 1][down] == '*' && MAZE[right][down + 1] == '*' && avg_gx >= .5){
					flagL = 1;
				}
			
			}
			
			if(t >= prevTime){ //moving down
				if(MAZE[right][down + 1] != '*'){
					down++;
					flagR = 0;
					flagL = 0;
					prevTime = t + 200;
					draw_character(right, down - 1,' ');
					draw_character(right, down, 'A');
				}
			}
			draw_character(right, down, 'A');
		}
		if(down >= 80){ //bottom border
			for(int i = 0; i < 80; i++){
				for(int j = 0; j < 100; j++){
					draw_character (i, j, EMPTY_SPACE);
				}
			}
			refresh();
			printf("YOU WIN!\n");
		break;
		}
		
		if(flagR == 1 && flagL == 1){ 
			for(int i = 0; i < 80; i++){
				for(int j = 0; j < 100; j++){
					draw_character (i, j, EMPTY_SPACE);
				}
			}
			refresh();
			printf("YOU LOSE!\n");
		break;
		}
		
		if(triangle == 1){
			break;
		}
			
			
    } while (1 && !triangle); //triangle ends game

	//while (startT > POST); // Change this to end game at right time
    /* Print the win/loss message */


    /*
     * This function is used to cleanup the ncurses environment.
     * Without it, the characters printed to the screen will
     * persist even after the program terminates. */
    endwin();
	
	return 0;
}

/**
 * POST: Generates a random maze structure into MAZE[][].
 * You will want to use the rand() function and maybe use the output %100.
 * You will have to use the argument to the command line to determine how
 * difficult the maze is (how many maze characters are on the screen).
 *
 * @param difficulty - The percentage of the MAZE to be covered in walls.
 */
void generate_maze(int difficulty)
{
	/*
	srand(time(NULL));
	int numOfRows = difficulty;
	int x; //columns
	
	for(int i = 0; i < COLUMNS; i++){
		for(int j = 0; j < ROWS; j++){
			MAZE[i][j]= EMPTY_SPACE;
		}
	}
	
	for(int j = 0; j < ROWS; j++){
		int drawn_walls[numOfRows];
		for(int i = 0; i < numOfRows; i++){ //fix
		if(rand() % 100 < difficulty){ //????
			for(int i = 0; i < numOfRows; i++){
				if (drawn_walls[i] == x){
					i--;
					break;
				}
			}
		}
		drawn_walls[i] = x;
		
		MAZE[x][j] = NULL;
		}
	}
	*/
	//generates maze
	for(int i = 0; i < COLUMNS; i++){
		for(int j = 0; j < ROWS; j++){
			if(rand() % 100 < difficulty){
				MAZE[i][j] = WALL;
			} else {
				MAZE[i][j] = EMPTY_SPACE;
			}
		}
	}
}

/**
 * PRE: MAZE[][] has been initialized by generate_maze().
 * POST: Draws the maze to the screen.
 */
void draw_maze()
{
	//draws maze
	for(int i = 0; i < COLUMNS; i++){ //i < 100
		for(int j = 0; j < ROWS ; j++){ //i < 80
			draw_character(i, j, MAZE[i][j]);
			//draw_character(i, j,'*');
		}
	}
}

/**
 * PRE: 0 < x < COLUMNS, 0 < y < ROWS, 0 < use < 255.
 * POST: Draws character use to the screen and position x, y.
 * THIS CODE FUNCTIONS FOR PLACING THE AVATAR AS PROVIDED.
 * DO NOT MODIFY THIS FUNCTION!
 *
 * @param row - The row in which the character "use" will be drawn.
 * @param column - The column in which the character "use" will be drawn.
 * @param use - The character that is to be drawn in the MAZE.
 */
void draw_character(int row, int column, char use)
{
    mvaddch(column, row, use);
    refresh();
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
	
	for(i = average_size - 1; i >= 1; i--) {
		buffer[i] = buffer[i - 1];
	}
	
	buffer[0] = new_item;
	
	for(int i = 0; i < average_size; i++){
		b_size = b_size + buffer[i];
	}
	
	overall_avg = b_size / average_size;
	return overall_avg;
}

/**
 * Detect if the AVATAR is in a position in which it is impossible
 * to reach the bottom of the MAZE and win the game.
 *
 * @param row - The coordinate of the row in which the AVATAR is currently positioned.
 * @param column - The coordinate of the column in which the AVATAR is currently positioned.
 * @return - True if failure has occurred and you have lost the game. Otherwise, False.
 */
int detect_failure(int avatar_row, int avatar_column)
{
	//if(MAZE(_column()
/*
	int leftNULL = 0, rightNULL = 0;
	
	//left null
	for(int i = 0; avatar_column - i > 0; i++){
		if([MAZE]avatar_column = i[avatar_row] == NULL){
			leftNULL = 1;
			break;
		}
	}

	//right null
	for(int i = 0; COLUMNS - i > avatar_column; i++){
		if([MAZE]avatar_column = i[avatar_row] == NULL){
			rightNULL = 1;
			break;
		}
	}
		
		
	if(rightNULL && leftNULL){
		for(int i = ____ + 1; i < ____; j++;){
			if(MAZE[i][avatar_row + 1]){
				return 1;
		}
			return 1;
	}
	*/
	return 0;
}
