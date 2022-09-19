/* fat12ls.c 
* 
*  Displays the files in the root sector of an MSDOS floppy disk
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <fcntl.h>

#define SIZE 32      /* size of the read buffer */
#define ROOTSIZE 256 /* max size of the root directory */
//define PRINT_HEX   // un-comment this to print the values in hex for debugging

struct BootSector
{
    unsigned char  sName[9];            // The name of the volume
    unsigned short iBytesSector;        // Bytes per Sector
    
    unsigned char  iSectorsCluster;     // Sectors per Cluster
    unsigned short iReservedSectors;    // Reserved sectors
    unsigned char  iNumberFATs;         // Number of FATs
    
    unsigned short iRootEntries;        // Number of Root Directory entries
    unsigned short iLogicalSectors;     // Number of logical sectors
    unsigned char  xMediumDescriptor;   // Medium descriptor
    
    unsigned short iSectorsFAT;         // Sectors per FAT
    unsigned short iSectorsTrack;       // Sectors per Track
    unsigned short iHeads;              // Number of heads
    
    unsigned short iHiddenSectors;      // Number of hidden sectors
};


// Prints the filename, time, date, attributes and size of each entry
//  Input: Calculated directory offset and number of directory entries
void parseDirectory(int iDirOff, int iEntries, unsigned char buffer[]);



// The characters are swapped (two, one) and returned as a short
// Input: Two initialized characters
unsigned short endianSwap(unsigned char one, unsigned char two);



// Fille out the the BootSector struct from the buffer data
//  Input: An initialized BootSector struct and a pointer to an array
//       of characters read from a BootSector
void decodeBootSector(struct BootSector * pBootS, unsigned char buffer[]);



//  Pre: String is initialized with at least 12 characters, buffer contains
//       the directory array, offset points to the location of the filename
// Post: fills and returns a string containing the filename in 8.3 format
char * toDOSName(char string[], unsigned char buffer[], int offset);



//  Pre: String is initialized with at least five characters, key contains
//       the byte containing the attribue from the directory buffer
// Post: fills the string with the attributes
char * parseAttributes(char string[], unsigned char key);



//  Pre: string is initialzied for at least 9 characters, usTime contains
//       the 16 bits used to store time
// Post: string contains the formatted time
char * parseTime(char string[], unsigned short usTime);



//  Pre: string is initialized for at least 13 characters, usDate contains
//       the 16 bits used to store the date
// Post: string contains the formatted date
char * parseDate(char string[], unsigned short usDate);




// reads the boot sector and root directory
int main(int argc, char * argv[])
{
    int pBootSector = 0;
    unsigned char buffer[SIZE];
    unsigned char rootBuffer[ROOTSIZE * 32];
    struct BootSector sector;
    int iRDOffset = 0;
    
    // Check for argument
    if (argc < 2) {
    	printf("Specify boot sector\n");
    	exit(1);
    }
    
    // Open the file and read the boot sector
    pBootSector = open(argv[1], O_RDONLY);
    read(pBootSector, buffer, SIZE);
    
    // Decode the boot Sector
    decodeBootSector(&sector, buffer);
    
    // Calculate the location of the root directory
    iRDOffset = (1 + (sector.iSectorsFAT * sector.iNumberFATs) )
                 * sector.iBytesSector;
                 
    printf("root dir offset: %d\n", iRDOffset);
	
    
    // Read the root directory into buffer
    lseek(pBootSector, iRDOffset, SEEK_SET);
    read(pBootSector, rootBuffer, ROOTSIZE);
    close(pBootSector);
    
    // Parse the root directory
    printf("max # root dir entries: %d\n", sector.iRootEntries);
    parseDirectory(iRDOffset, sector.iRootEntries, rootBuffer);
    
} // end main


// Converts two characters to an unsigned short with two, one
unsigned short endianSwap(unsigned char one, unsigned char two)
{
	unsigned short res = two;
	res *= 256;
	res += one;
    return res;
}


// TODO Fills out the BootSector Struct from the buffer
void decodeBootSector(struct BootSector * pBootS, unsigned char buffer[])
{
	
	//skip 3 bytes
	int i = 3;

	char c1;
	char c2;

	// TODO: Pull the name and put it in the struct pBootS (remember to null-terminate)
    memcpy(pBootS -> sName, &buffer[i], 8);

	//boot sector
	pBootS -> sName[9] = 0;

	// TODO: Read bytes/sector and convert to big endian
    i += 8;

	c1 = buffer[i++];
	c2 = buffer[i++];

	//byte sector
	pBootS -> iBytesSector = endianSwap(c1, c2);

	// TODO: Read sectors/cluster, Reserved sectors and Number of Fats
    c1 = buffer[i++];
	c2 = 0;

	//sector/cluster
	pBootS -> iSectorsCluster = endianSwap(c1, c2);

	c1 = buffer[i++];
	c2 = buffer[i++];

	//reserved sectors
	pBootS -> iReservedSectors = endianSwap(c1, c2);

	c1 = buffer[i++];
	c2 = 0;

	//number of FAT's
	pBootS -> iNumberFATs = endianSwap(c1, c2);

	// TODO: Read root entries, logicical sectors and medium descriptor
    c1 = buffer[i++];
	c2 = buffer[i++];

	//root entries
	pBootS -> iRootEntries = endianSwap(c1, c2);


	c1 = buffer[i++];
	c2 = buffer[i++];

	//logical sectors
	pBootS -> iLogicalSectors = endianSwap(c1, c2);

	c1 = buffer[i++];
	c2 = 0;

	//medium descriptor
	pBootS -> xMediumDescriptor = endianSwap(c1, c2);

	// TODO: Read and covert sectors/fat, sectors/track, and number of heads
    c1 = buffer[i++];
	c2 = buffer[i++];

	//sector/FAT
	pBootS -> iSectorsFAT = endianSwap(c1, c2);

	c1 = buffer[i++];
	c2 = buffer[i++];

	//Sector Track
	pBootS -> iSectorsTrack = endianSwap(c1, c2);

	c1 = buffer[i++];
	c2 = buffer[i++];

	//Number of Heads
	pBootS -> iHeads = endianSwap(c1, c2);

	// TODO: Read hidden sectors
	c1 = buffer[i++];
	c2 = buffer[i++];

	//Hidden Sectors
	pBootS -> iHiddenSectors = endianSwap(c1, c2);

	return;
	
}


// TODO: iterates through the directory to display filename, time, date,
// attributes and size of each directory entry to the console
void parseDirectory(int iDirOff, int iEntries, unsigned char buffer[])
{
    int i = 0;
    char string[13];
    
    // Display table header with labels
    printf("Filename\tAttrib\tTime\t\tDate\t\tSize\n");
    
    // loop through directory entries to print information for each
	// Don't forget to NULL terminate the strings
    for(i = 0; i < (iEntries); i = i + 1)   {

    	if (buffer[i*32]==0x00)
    		break;
    		
    	if (buffer[i*32]==0xe5)
    		continue;

		//Display filename
		toDOSName(string, buffer, i * 32 + 0x0); /*TODO: replace 0 with correct value */
		printf("%-12s\t", string);
		
		//Display Attributes
		parseAttributes(string, buffer[i * 32 + 0x0b]); /*TODO: replace 0 with correct value */
		printf("%s\t", string);
		
		//Display Time
		parseTime(string, endianSwap(buffer[i * 32 + 0x16], buffer[i * 32 + 0x17])); /*TODO: replace 0 with correct value */
		printf("%s\t", string);
		
		//Display Date
		parseDate(string, endianSwap(buffer[i * 32 + 0x18], buffer[i * 32 + 0x19])); /*TODO: replace 0 with correct value */
		printf("%s\t", string);
		
		//Display Size
		printf("%d\n", endianSwap(buffer[i * 32 + 0x1c], buffer[i * 32 + 0x1d])); /* TODO: replace 0 with actual size */
    }
    
    // Display key
    printf("(R)ead Only (H)idden (S)ystem (A)rchive\n");
}


// Parses the attributes bits of a file
char * parseAttributes(char *string, unsigned char key)
{
 	int i=0;
 	if (key&1)
 		string[i++] = 'R';
 	if ((key>>1)&1)
 		string[i++] = 'H';
 	if ((key>>2)&1)
 		string[i++] = 'S';
 	if ((key>>5)&1)
 		string[i++] = 'A';
 	
 	string[i] = '\0';
    return string;
} // end parseAttributes()


// Decodes the bits assigned to the time of each file
char * parseTime(char *time_string, unsigned short time)
{
	unsigned short hour = (time>>11)&0x1f;
	unsigned short minute = (time>>5)&0x3f;
	unsigned short second = (time&0x1f)*2;
	
    sprintf(time_string, "%02d:%02d:%02d", hour, minute, second);
			
    return time_string;
    
    
} // end parseTime()


// Decodes the bits assigned to the date of each file
char * parseDate(char *date_string, unsigned short date)
{
	unsigned short year = (date>>9) + 1980;
	unsigned short month = (date>>5)&0xf;
	unsigned short day = date&0x1f;
	
    sprintf(date_string, "%04d/%02d/%02d", year, month, day);

    return date_string;
    
} // end parseDate()


// Formats a filename string as DOS (adds the dot to 8-dot-3)
char * toDOSName(char *string, unsigned char buffer[], int offset)
{
	int index = 0;
	int i;
	for (i=0; i<8; i++)
		string[index++] = buffer[offset+i];
	while (string[--index]==' ');
	
	string[++index] = '.';
	
    for (i=8; i<11; i++)
    	string[++index] = buffer[offset+i];
    string[++index] = '\0';
    return string;
} // end toDosNameRead-Only Bit

