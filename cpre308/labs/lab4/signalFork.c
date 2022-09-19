#include <signal.h>
#include <stdio.h>
#include <unistd.h>

void my_routine( );

int ret;

int main() {

    ret = fork( );

    signal(SIGINT, my_routine);

    printf("Entering infinite loop\n");

    while(1) {
        sleep(10);
    }

    printf("Can’t get here\n");
}

void my_routine() {
    printf("Return value from fork = %d\n", ret);
}
