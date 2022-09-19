/*
 * shm-client - client program to demonstrate shared memory.
 */
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <stdio.h>
#include <stdlib.h>

#define SHMSZ     27	// Define size of shared memory segment

main()
{
    int shmid;		// Hold shared memory "file descriptor"
    key_t key;		// Key to locate same memory in different processes
    char *shm;
    char msg[SHMSZ];

    key = 5678;

    /*
     * Locate the segment.
     */
    if ((shmid = shmget(key, SHMSZ, 0666)) < 0) {
        perror("shmget failed");
        exit(1);
    }

    /*
     * Now we attach the segment to our data space.
     */
    if ((shm = shmat(shmid, NULL, 0)) == (char *) -1) {
        perror("shmat failed");
        exit(1);
    }

    /*
     * Now read what the server put in the memory.
     */
    int i;
    for (i = 0; shm[i] != 0; i++)
    {
 	msg[i] = shm[i];
    }
    msg[i] = 0;
    printf("Message read: %s\n", msg);
    printf("Client done reading memory\n");

    /*
     * Finally, change the first character of the 
     * segment to '*', indicating we have read 
     * the segment.
     */
    *shm = '*';

    exit(0);
}
