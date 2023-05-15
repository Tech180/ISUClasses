/*---------------------------------------------------------------------------
		                SE 185: Final Project Battle Ship     (lab 10)                 
-	Name: Group 21
                                   
----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
-								Includes							      	 -
-----------------------------------------------------------------------------*/
#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include <math.h>
#include <windows.h>

/*----------------------------------------------------------------------------
-								Defines	  						             -
-----------------------------------------------------------------------------*/
#define FLEET_HP 6  //total required hits, to sink all ships. 
#define BOAT 'O'

/*----------------------------------------------------------------------------
-	                            Prototypes                                   -
-----------------------------------------------------------------------------*/
void enemy_setup(char grid[5][5]); //randomly positions enemy boats
void player_setup(char grid[5][5]);//promts user for all 3 boat placments
int point(int v);  //promts user for a row/col/ or orentaion
void clear(int v); //prints a bunch of enters to give the illusion of a new screen
void refresh(char grid[5][5]); //a fake refresh function
void firing(char grid[5][5],int player_hp); //calcs enemy shot

/*----------------------------------------------------------------------------
-	                                Notes                                    -
-----------------------------------------------------------------------------*/
// Compile with gcc lab10.c 
// Run with ./a.exe


/*----------------------------------------------------------------------------
-								Implementation                               -
-----------------------------------------------------------------------------*/
int main(int argc, char *argv[])
{
	//Variables
    char player_field[5][5];  //player grid
	char enemy_field[5][5];	//enemy grid
	char shots_fired[5][5]; //displays shots the player has made
	int col,row,input,wait;
	int enemy_hp = FLEET_HP; 
	int player_hp = FLEET_HP;
	
	
	srand(time(NULL));	
	
	/**** main code ****/	
	enemy_setup(enemy_field);   //sets up enemy ships
  	player_setup(player_field); //sets up player ships
	
	for(int i=0; i<5;i++){  //initializez shot grid
		for(int j=0; j<5;j++){
			shots_fired[j][i] = '~';		
		}
	}
	 
	while(enemy_hp>0 && player_hp >0){ 
		while(input==0){ //gets players move
			clear(1); 
			refresh(shots_fired); // draws player top board
			refresh(player_field); //draws players field
			col = point(1);
	
			clear(1); 
			refresh(shots_fired); // draws player top board
			refresh(player_field); //draws players field
			row = point(2);

			clear(1); 
			refresh(shots_fired); // draws player top board
			refresh(player_field); //draws players field
		
			if(shots_fired[col][row]=='*' | shots_fired[col][row] == 'x'){  //prevents firing in same place
				printf("You already fired there! Enter a number to continue: ");
				scanf("%d",wait); //stops program to show result
			}
			if(shots_fired[col][row]!='*' && shots_fired[col][row] != 'x'){
				input=1;
			}
		}
		
			if(enemy_field[col][row]== BOAT){ //checks if hit
				shots_fired[col][row]='X';
				printf("\rYou fired at %d,%d and HIT! Enter a number to continue: ",col,row);
				enemy_hp--;
				scanf("%d",wait); //stops program to show printf before refresh
				input=0;
			}
			if(enemy_field[col][row] != BOAT){ //checks if miss
				shots_fired[col][row]='*';
				printf("\rYou fired at %d,%d and missed. Enter a number to continue: ",col,row);
				scanf("%d",wait);
				input=0;
			}
		
			/** enemys shot **/
		
			clear(1); 
			refresh(shots_fired); // draws player top board
			refresh(player_field); //draws players field
			firing(player_field,player_hp); //enemy shot
			scanf("%d",wait); //wait for player to read enemy result
			
			
		
	
			

	}
	
	//calc winner
	if(player_hp == 0){
		printf("You lost. Better luck next time!");
	}
	if(enemy_hp == 0){
		printf("You Win!");
	}
	return 0;
    
}
/** Functions **/

void enemy_setup(char grid[5][5])
{
	int c,r,o,x;   //collums,rows,orientation, x allows boat to apear on all sides
	
	for(int i=0; i<5;i++){  //initializez sea
			for(int j=0; j<5;j++){
				grid[j][i] = '~';		
			}
		}
	
	for(int i=0; i< 1; ){   //sets up Carrier  i++ is only inside succesful results so it will repeat untill seccuss.
		
		c =	(rand() %5 );   //col value
		r = (rand() %5 ); //row value
		o = (rand() %2);     // 0 is horizontal, 1 is vertical
		
		if(o==1 && r != 0 && r != 4){ //vertical
			if(grid[c][r] != BOAT&& grid[c][r+1] != BOAT && grid[c][r-1] != BOAT){  //checks to see if theres space
				grid[c][r] = BOAT;
				grid[c][r+1] = BOAT;
				grid[c][r-1] = BOAT;
				i++; 					
			}
		}
		if(o==0 && c != 0 && c != 4){ //Horizontal
			if(grid[c][r] != BOAT&& grid[c+1][r] != BOAT && grid[c-1][r] != BOAT){  
				grid[c][r] = BOAT;
				grid[c+1][r] = BOAT;
				grid[c-1][r] = BOAT;
				i++;
			}
		}
	}
		
	for(int i=0; i< 1; ){   //sets up Destroyer
		
		c =	(rand() %5 );   //col value
		r = (rand() %5 );   //row value
		o = (rand() %2);    // 0 is horizontal, 1 is vertical
		
		if(o==1 && r != 0 && r != 4){ //vertical
			if(grid[c][r] != BOAT&& grid[c][r+1] != BOAT){  
				grid[c][r] = BOAT;
				grid[c][r+1] = BOAT;
				i++;
			}
		}
		if(o==0 && c != 0 && c != 4){ //Horizontal
			if(grid[c][r] != BOAT&& grid[c+1][r] != BOAT){  
				grid[c][r] = BOAT;
				grid[c+1][r] = BOAT;
				i++;
			}
		}
	}
		
	for(int i=0; i< 1; ){   //sets up Patrol Boat
		
		c =	(rand() %5 );   //col value
		r = (rand() %5 ); //row value

			if(grid[c][r] != BOAT){  
				grid[c][r] = BOAT;
				i++;
			}
	}
		

}

//sets up your grid to play battleship
void player_setup(char grid [5][5]){
	
		int c,r,o,x=1;   //columns, rows, orientation, x allows boat to appear on all sides
		
	for(int i=0; i<5;i++){  //initializes sea
			for(int j=0; j<5;j++){
				grid[j][i] = '~';		
			}
		}
	printf("You will now set up the carrier.\n The point you choose will be the center of the boat.\n");
	for(int i=0; i< 1; ){   //sets up Carrier
		
		
		
		o = point(0);  //gets an orientation
		c = point(1);  //gets column
		r = point(2);	//gets a row	
		
		if(o==1 && r != 0 && r != 4){ //vertical grid
			if(grid[c][r] != BOAT&& grid[c][r+1] != BOAT && grid[c][r-1] != BOAT){  
				grid[c][r] = BOAT;
				grid[c][r+1] = BOAT;
				grid[c][r-1] = BOAT;
				i++;
				x++;//skips error message
			}
		}
		if(o==0 && c != 0 && c != 4){ //Horizontal grid
			if(grid[c][r] != BOAT&& grid[c+1][r] != BOAT && grid[c-1][r] != BOAT){  
				grid[c][r] = BOAT;
				grid[c+1][r] = BOAT;
				grid[c-1][r] = BOAT;
				i++;
				x++;
			}
		}
		if(x==1){
		printf("\nFailed to set up. Please try to stay in bounds! \n");
		}
	}
	printf("You will now set up the Destroyer.\n");	
	for(int i=0; i< 1; ){   //sets up Destroyer
		
		o = point(0);
		c = point(1);
		r = point(2);
		
		if(o==1 && r != 0 && r != 4){ //vertical
			if(grid[c][r] != BOAT&& grid[c][r+1] != BOAT){  
				grid[c][r] = BOAT;
				grid[c][r+1] = BOAT;
				i++;
				x++;
			}
		}
		if(o==0 && c != 0 && c != 4){ //Horizontal
			if(grid[c][r] != BOAT&& grid[c+1][r] != BOAT){  
				grid[c][r] = BOAT;
				grid[c+1][r] = BOAT;
				i++;
				x++;
				
			}
		}	
		if(x==2){
			printf("\nFailed to set up. Please try to stay in bounds! \n");
		}
	}
	printf("You will now set up the Patrol Boat.\n");	
	for(int i=0; i< 1; ){   //sets up Patrol Boat
		
		c = point(1);
		r = point(2);

		if(grid[c][r] != BOAT){  
			grid[c][r] = BOAT;
			i++;
			x++;
		}
		if(x==3){
			printf("\nFailed to set up. Please try to stay in bounds! \n");
		}
	}
		
}

/**
v=0 selects horizontal or vertical
v=1 selects collum
v=2 selects row
**/
int point(int v){ //gets a point value from the player
	int c,r,o;
	

	if(v==1){	//choosing a col		
		printf("Choose a column(0~4): ");
		scanf("%d",&c);
			
		if(c<0 | c>4){  //checks if its acceptable
			printf("Choose a column(0~4):     (previous input was invalid)");
			point(1);  //recursion until it is acceptable
		}
		if(c>-1 && c<5){
				return c;
		}
	}
	
	if(v==2){	//choosing a row
		printf("Choose a row (0~4): ");
		scanf("%d",&c);
			
		if(c<0 | c>4){
			printf("Choose a row  (0~4):    (previous input was invalid)");
			
			point(2);
		}
		if(c>-1 && c<5){
				return c;
		}
	}
		
	
	if (v==0){ 	//choosing orientation
	
	
		printf("Choose orientation, type 1 for vertical or 0 for horizontal: ");
		scanf("%d",&o);
		if(o==1 | o==0){
			return o;
		}
		
		printf("Incorrect format. Exiting program!");
		exit (1);
		
		
		
	}	
}


/**
v=0 clears curent line with spaces
v=1 clears screen with new lines
**/
void clear(int v){  //clears input line
	if(v==0){    // a failed attempt at trying to clear lines
		for(int i = 0; i<30;++i){
			printf("\b ");
		}
	}
	if(v==1){  //enough enters to make it look new
		printf("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
	}
}
	
void refresh(char player_field[5][5]){ //fake refresh
   
    
    printf("     0 1 2 3 4\n");  //top letters
	printf("    __________");    //top line
	for(int i=0; i<5;i++){   //prints the matrix with side letters
		printf("\n %d |",i);
		for(int j=0; j<5;j++){
			printf(" %c", player_field[j][i] );
			fflush(stdout);
		}
	}
	printf("\n");
	
}


void firing(char grid[5][5],int player_hp){
	int c,r;
	c =	(rand() %5 );   //col value
	r = (rand() %5 ); //row value
	for(int i=0;i<1;){  //loop goes until desired result
	
		c =	(rand() %5 );   //col value
		r = (rand() %5 ); //row value
	
		if(grid[c][r] == BOAT){  //if enemy hit
			grid[c][r] = 'x';
			player_hp--;
			i++;
			printf("Enemy HIT! Enter a number to continue: ");
		}
		if(grid[c][r] == '~'){   //if enemy missed
			grid[c][r]='*';
			i++;
			printf("Enemy missed. Enter a number to continue: ");
		}
	}
}

