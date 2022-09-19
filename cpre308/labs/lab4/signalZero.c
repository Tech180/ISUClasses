#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void zero();

int main() {

    signal(SIGFPE, zero);

    int a = 4;

    printf("Entering a division by zero loop\n");

    a = a / 0;
}

void zero() {
    printf("Caught a SIGFPE");
    exit(0);
}
