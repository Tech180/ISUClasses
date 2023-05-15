/*---------------------------------------------------------------------------
-		                SE 185: Lab 09 - The DS4Talker                      -
-	Name:                                                                  -
- 	Section:                                                                -
-	NetID:                                                                -
-	Date:11/13/2019                                                                   -
----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
-								Includes									 -
-----------------------------------------------------------------------------*/
#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <curses.h>
#include <ncurses/ncurses.h>

/*----------------------------------------------------------------------------
-								Defines	    								 -
-----------------------------------------------------------------------------*/
#define MAX_WORD_LENGTH 12 /* The maximum length a word can be. */
#define MAX_WORDS 75 /* The maximum words that can be in the DS4Talker. */

/*----------------------------------------------------------------------------
-	                            Prototypes                                   -
-----------------------------------------------------------------------------*/
void trim_whitespace(char *string);

int read_words(char *word_list[MAX_WORDS], char *file_name);

/*----------------------------------------------------------------------------
-	                                Notes                                    -
-----------------------------------------------------------------------------*/
// Compile with gcc lab09.c -o lab09 -lncurses
// Run with ./ds4rd.exe -d 054c:05c4 -D DS4_BT -t -b -bt -bd | ./lab09 word_list.txt
// NO GLOBAL VARIABLES ARE ALLOWED!

/*----------------------------------------------------------------------------
-								Implementation                               -
-----------------------------------------------------------------------------*/
int main(int argc, char *argv[])
{//created variables
	int timer, triangle, circle, cross, square, rjoy, ljoy, options, share, Rtwo, Ltwo, Rone, Lone, upA, leftA, downA, rightA;
	
    char *word_list[MAX_WORDS];
    int word_count = read_words(word_list, argv[1]);
    int i;
	int down = 0;
	int right = 0;
	int amount = 0;
	int newtimer = 200;
	int n = 0;
	char space[50];
	int place = 0;
	char final_string[120];
	int length = 0;
	int track = 0;
	int dataArray[100];
	char str[MAX_WORD_LENGTH];
	dataArray[0] = 0;
    initscr();
	read_words(word_list, argv[1]);
	strcpy(word_list[0],"the");
    /* Most of your code should go here. */
	
	strcpy(space," ");
	
	for(int i = 0; i < 5; i++){    //creates word table
		for(int j = 0; j < 15; j++){
			mvprintw(j,i*12,"%s",word_list[amount]);
			amount++;
			refresh();
		}
	}
	
	//mvprintw(down,right, "%c", '*');
	//refresh();
	do
	{
		scanf("%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d,", &timer, &triangle, &circle,
		&cross, &square, &rjoy, &ljoy, &options, &share, &Rtwo, &Ltwo, &Rone, &Lone, &upA, &leftA, 
		&downA, &rightA);
		if(timer >= newtimer){
		if(rightA == 1 && right < 4){
			mvprintw(down,5 + (13*right), "%c", ' ');
			right++;
			n += 15;
			newtimer = timer + 200;
		}
		if(leftA == 1 && right > 0){
			mvprintw(down,5 + (13*right), "%c", ' ');
			right--;
			n -= 15;
			newtimer = timer + 200;
		}
		if(downA == 1 && down < 14){
			mvprintw(down,5 + (13*right), "%c", ' ');
			n++;
			down++;
			newtimer = timer + 200;
		}
		if(upA == 1 && down > 0){
			mvprintw(down,5 + (13*right), "%c", ' ');
			down--;
			n--;
			newtimer = timer + 200;
		}
		
		
		
		if(triangle == 1){              //triangle function
			mvprintw(20,place," %s",word_list[n]);
			length = 1 + strlen(word_list[n]);
			place += length;
			track ++;
			dataArray[track] = length;
			newtimer = timer + 200;
			
		}
		if(square == 1){         //square function
			mvprintw(20,place,"%s",word_list[n]);
			length = strlen(word_list[n]);
			place += length;
			track++;
			dataArray[track] = length;
			newtimer = timer + 200;
		}
		if(Rtwo == 1 || Ltwo == 1){       //clear line
			mvprintw(20,0,"                                                 ",word_list);
			place = 0;
			track = 0;
		}
		if(options == 1 || share == 1){
			return 0;
		}

		/*if(circle == 1){              //Bonus
			strcpy(str[], word_list[n]);
			toupper(str[0]);
			mvprintw(20,place," %s",str[]);
			length = 1 + strlen(word_list[n]);
			place += length;
			track ++;
			dataArray[track] = length;
			newtimer = timer + 200;
		}    
		*/
		if(cross == 1){
			
			place -= length;
			track--;
			length = dataArray[track];
			if(place < 0){
				place = 0;
			}
			mvprintw(20,place,"           ",word_list);
			newtimer = timer + 200;
		}
		} // end of time if statement
		
		mvprintw(down,5 + (13*right), "%c", '*');
		refresh();
		//mvprintw(down,right*12,"%c",'*');
		//refresh();
	}while(1);

    return 0;
}

/**
 * Modifies the given string to trim white space off at the end.
 * DO NOT MODIFY THIS FUNCTION.
 *
 * @param string - The string to ensure has no whitespace.
 */
void trim_whitespace(char *string)
{
    int length = strlen(string);
    if (length == 0) return;

    int i = length - 1;
    while (isspace(string[i]) && i >= 0)
    {
        string[i] = '\0';
        i--;
    }
}

/**
 * Reads words from the given file into word_list.
 * DO NOT MODIFY THIS FUNCTION.
 *
 * @param word_list - The list of words where the words taken from the given
 *                    file will be placed.
 * @param file_name - The name of the file to read from.
 * @return - The number of words read from the file.
 */
int read_words(char *word_list[MAX_WORDS], char *file_name)
{
    int number_of_words_read = 0;
    char line[MAX_WORD_LENGTH];
    char *pointer;
    FILE *file = fopen(file_name, "r");

    while (!feof(file))
    {
        pointer = fgets(line, MAX_WORD_LENGTH, file);
        if (pointer != NULL)
        {
            trim_whitespace(line);
            word_list[number_of_words_read] = (char *) malloc(strlen(line) + 1);
            strcpy(word_list[number_of_words_read], line);
            number_of_words_read++;
        }
    }

    fclose(file);
    return number_of_words_read;
}