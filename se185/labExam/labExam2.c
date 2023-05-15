//Prototypes

int position();



//Riley Lawson
int main(){
	
	//variables
	int i;
	char inp_string[20];
	int len_amount;
	int b;
	
	
	//this allows the length amount to be the length of the string input
	len_amount = strlen(inp_string);
	
	//prints a string 
	printf("Please enter a string (that is less than 20 letters)\n");
	scanf(" %s", inp_string); //scans that string 
	
	//if it is not long enough then it will print this message
	if (len_amount > 20){
		printf("Please enter a string (that is less than 20 letters)\n");
	}
	//if not then execute this logic
	else{
		for(inp_string[i]; i < 20; ++i){
			if(inp_string[i] == 'c'){
				for(inp_string[i]; i < 20; i++){
					if(inp_string[i] == 'b'){
						b = b + 1;
					}
				}
				//print the amount of b that are in the string
				printf("Count = %d", b);
			}
		}
		printf("%d", position(position));
	}
}

	//function for position
	int position(int position){
		int i;
		char inp_string[20];
		
		
		for(inp_string[i]; i < 20; ++i){	
			for(inp_string[i]; i < 20; ++i){
				if(inp_string[i] == 'c'){
					position > 1;
				}
			}	
		}
	return (position);
	}


