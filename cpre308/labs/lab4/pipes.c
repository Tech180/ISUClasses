#include <stdio.h>
#include <signal.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#define MSGSIZE 16

int main() {
    char *msg = "How are you?\n";
    char inbuff[MSGSIZE];

    int p[2];
    int ret;

    pipe(p);
    ret = fork();

    if (ret > 0) {
        write(p[1], msg, MSGSIZE);
        printf("im 1\n");
    }
    else {
        sleep(1);
        read(p[0], inbuff, MSGSIZE);
        printf("%s\n", inbuff);
        printf("im 2");
    }

    printf("ending\n");
    exit(0);
}
