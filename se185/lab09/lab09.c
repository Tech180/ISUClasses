/*---------------------------------------------------------------------------
-		                SE 185: Lab 09 - The DS4Talker                      -
-	Name:Riley Lawson                                                       -
- 	Section:                                                                -
-	NetID: rjlawson                                                         -
-	Date: 11/21/2019                                                        -
----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
-								Includes									 -
-----------------------------------------------------------------------------*/
#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
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
{
	//most variables
    char *word_list[MAX_WORDS];
    int word_count = read_words(word_list, argv[1]);
    int i, j, n = 0;
	int t, triangle, circle, x_button, square, right_joy_down, left_joy_down, options, share, R2, L2, R1, L1, d_up, d_left, d_down, d_right;
	int down = 0, right = 0;
	int n_time = 200;
	//int row = 11, column = 0;
	//y_Cord = 22, x_Cord = 0;
	int length;
	char space[50];
	char final_string[120];
	int data[100];
	data[0] = 0;
	initscr();
	read_words(word_list, argv[1]);
	strcpy(word_list[0], "the");
	
	
    /* Most of your code should go here. */
	
	strcpy(space," ");
	
	//creates table for words
	
	int x = 0;
	
	for(i = 0; i < 5; i++){
			for(j = 0; j < 15; j++){
				mvprintw(j, i * 12, "%s", word_list[x]);
				x++;
				//printf("%d", x);
				//printf("%d\n", word_count);
				
				refresh();
			}
		
		}
	//mvprintw(column, row, "%c", '*');
	//refresh();
	
	do{
		scanf("%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d", &t, &triangle, &circle, &x_button, &square, &right_joy_down, &left_joy_down, &options, &share, &R2, &L2, &R1, &L2, &d_up, &d_left, &d_down, &d_right);
		
		//detects movement for down, up, right, and left
		if(t >= n_time){
			
			if(d_right == 1 && right < 4){
				mvprintw(down, 5 + (13 * right), "%c", ' ');
				right++;
				n += 15;
				n_time = t + 200;
			}
			
			if(d_left == 1 && right > 0){
				mvprintw(down, 5 + (13 * right), "%c", ' ');
				right--;
				n -= 15;
				n_time = t + 200;
			}
			
			if(d_down == 1 && down < 14){
				mvprintw(down ,5 + (13 * right), "%c", ' ');
				down++;
				n++;
				n_time = t + 200;
			}
			
			if(d_up == 1 && down > 0){
				mvprintw(down, 5 + (13 * right), "%c", ' ');
				down--;
				n--;
				n_time = t + 200;
			}
			
			int place = 0, locate = 0;
			
			//triangle
			if(triangle == 1){
				mvprintw(20, place, " %s", word_list[n]);
				length = 1 + strlen(word_list[n]);
				place += length;
				locate++;
				data[locate] = length;
				n_time = t + 200;
				
			}
			//square
			if(square == 1){        
				mvprintw(20, place, "%s", word_list[n]);
				length = strlen(word_list[n]);
				place += length;
				locate++;
				data[locate] = length;
				n_time = t + 200;
			}
			
			//clear
			if(R2 == 1 || L2 == 1){      
				mvprintw(20, 0, "                                                 ", word_list);
				place = 0;
				locate = 0;
			}
			
			if(options == 1 || share == 1){
				return 0;
			}

			//Bonus?????
			/*if(circle == 1){
				strcpy(str[], word_list[n]);
				toupper(str[0]);
				mvprintw(20, place, " %s", str[]);
				length = 1 + strlen(word_list[n]);
				place += length;
				locate++;
				data[locate] = length;
				n_time = t + 200;
			}    
			*/
			if(x_button == 1){
				place -= length;
				locate--;
				length = data[locate];
				if(place < 0){
					place = 0;
				}
				mvprintw(20, place, "           ", word_list);
				n_time = t + 200;
			}
		} // end of time
		
		mvprintw(down, (5 + (13 * right)), "%c", '*');
		refresh();
		
	} while(1);
	
	//adds word with a space
	/*if(square){
		while(square == 1){
			scanf("%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d", &t, &triangle, &circle, &x_button, &square, &right_joy_down, &left_joy_down, &options, &share, &R2, &L2, &R1, &L2, &d_up, &d_left, &d_down, &d_right);
		}
		
		string = wordNumber;
		x_Cord++;
		mvprintw(y_Cord, x_Cord, "%s", strlen(word_list[string]));
		x_Cord = x_Cord + strlen(word_list[string]);
		last_String = strlen(word_list[string]);
		refresh();
	}
	if(triangle){
		while(triangle == 1){
			scanf("%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d", &t, &triangle, &circle, &x_button, &square, &right_joy_down, &left_joy_down, &options, &share, &R2, &L2, &R1, &L2, &d_up, &d_left, &d_down, &d_right);
		}
		
		string = wordNumber;
		x_Cord++;
		mvprintw(y_Cord, x_Cord, "%s", strlen(word_list[string]));
		x_Cord = x_Cord + strlen(word_list[string]);
		last_String = strlen(word_list[string]);
		words += last_String;
		refresh();
	
	}
	if(x_button){
		while(x_button == 1){
			scanf("%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d", &t, &triangle, &circle, &x_button, &square, &right_joy_down, &left_joy_down, &options, &share, &R2, &L2, &R1, &L2, &d_up, &d_left, &d_down, &d_right);
		}
		for(int i = 0; i < last_String; i++){
			x_Cord--;
			mvprintw(y_Cord, x_Cord, "%c", ' ');
			refresh();
		}
	}
*/
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
