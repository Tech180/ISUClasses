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
    char *shm, *s;

    key = 5678;

    /*
     * Create the segment.
     */
    if ((shmid = shmget(key, SHMSZ, IPC_CREAT | 0666)) < 0) {
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
     * Now put some things into the memory for the
     * other process to read.
     */
    s = shm;

    char c;
    int i = 0;
    for (c = 'a'; c <= 'z'; c++)
    {
        s[i] = c;
	i++;
    }
    s[i] = 0;

    /*
     * Finally, we wait until the other process 
     * changes the first character of our memory
     * to '*', indicating that it has read what 
     * we put there.
     */
    while (*shm != '*')
        sleep(1);

    printf("Server detected client read\n");

    shmdt(shm);
    shmctl(shmid, IPC_RMID, 0);

    exit(0);
}
