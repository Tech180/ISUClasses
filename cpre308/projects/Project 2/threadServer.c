#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <string.h>
#include <sys/time.h>
#include "Bank.h"
#include "Bank.c"
#include "threadServer.h"

int workers; //workers required
int accounts; //num of accounts

//important trigger variable
int trigger = 1;

char* out; //output file

//requests list
pthread_mutex_t list;

//output
FILE *f;

struct account *allocate; //accounts

//user input
int main(int argc, char * argv[]) {

    int rID = 0;

    if(argv[1] != 0 && argv[2] != 0 && argv[3] != 0){
        workers = atoi(argv[1]);
        accounts = atoi(argv[2]);
        out = argv[3];

        //possible fault point
        //f = (char *) malloc(sizeof(char *) * 128);
        f = malloc(sizeof(char *) * 128);

        f = fopen(out, "w");
    }

    //initialize the accounts
    initialize_accounts(accounts);

    //account mutex
    int i = 0;
    allocate = malloc((sizeof(pthread_mutex_t) + sizeof(int)) * accounts);

    for(i = 1; i < accounts;i++) {

        struct account acc;

        pthread_mutex_init(&acc.lock, NULL);

        acc.value = read_account(i);

        allocate[i]=acc;
    }

    //all the worker threads
    pthread_t threads[workers];
    pthread_t a;

    //create thread(s)
    for(i = 0; i < workers; i++) {
        pthread_create(&threads[i], NULL, handleMutexAndCommands, NULL);
    }

    root = NULL;
    last = NULL;
    root = last;

    pthread_mutex_init(&list, NULL);

    while(1){
        struct request r;

        //read
        char command[1024];
        char *word[1024];

        fgets(command, sizeof(command), stdin); //input

        int i = 0;
        char* token = strtok(command, " ");

        word[0] = token;

        if(strcmp("END\n", word[0]) == 0) {
            exit(0);
        }

        while (token != NULL) {
            i++;
            token = strtok(NULL, " ");
            word[i] = token;
        }

        //prevents extra line
        int len = strlen(word[i-1]);
        char *b = word[i-1];
        b[len - 1] = 0;
        word[i - 1] = b;

        //cool function that gets the time of day and time zone
        gettimeofday(&r.times, NULL);

        memcpy(&r.task, &word,sizeof word);

        r.rID=rID++;

        pthread_mutex_lock(&list);

        if(root == NULL) {
                root = (struct node *) malloc(sizeof(struct node*));

                root -> next = NULL;
                root -> data = r;

                last = root;
        }
        else if(last -> next == NULL) {
                struct node *a;

                a = (struct node *) malloc(sizeof(struct node*));

                a -> data = r;
                a -> next = NULL;
                last -> next = a;

                last = a;
        }

        pthread_mutex_unlock(&list);

        fclose(f);
    }

    //nothing showing... really confused? Did i clear memory too often?
    //Did i not output to a file correctly?
    //Runtime isn't showing
    //fixed deadlock

}


void transaction(int id,char* task[1024], struct timeval start) {

    int accounts[10] = {0};
    int amounts[10] = {0};
    int i = 0;
    int transactions = 0;
    int properB = 0; //proper balance

    //to transfer specific amounts
    while(task[i] != NULL){
        accounts[i] = atoi(task[i]);
        i++;
        amounts[i] = atoi(task[i]);
        transactions++;
    }

    for (i = 1; i < transactions + 1; i++) {
        pthread_mutex_lock(&allocate[accounts[i]].lock);
    }

     //check balance
    for (i = 1; i < transactions+1; i++) {
        int value = read_account(accounts[i]);

        if(value + amounts[i] < 0) {
            struct timeval end;

            gettimeofday(&end, NULL);

            fprintf(f, "%d ISF %d TIME %d.%06d %d.%06d\n", id, accounts[i], start.tv_sec, start.tv_usec, end.tv_sec, end.tv_usec);

            //clear the file from cache
            //fflush(f);
            free(f);

            properB = 1;
        }
    }

    if(properB == 0) {
        for (i = 1; i < transactions + 1; i++) {
            int balance = read_account(accounts[i]);

            //This function returns the value of the specified account
            write_account(accounts[i], balance + amounts[i]);
        }

        struct timeval end;

        gettimeofday(&end, NULL);

        fprintf(f, "%d OK TIME %d.%06d %d.%06d\n", id, start.tv_sec, start.tv_usec, end.tv_sec, end.tv_usec);

    }

    for (i = 1; i < transactions + 1; i++) {
        pthread_mutex_unlock(&allocate[accounts[i]].lock);
    }
}

//to check balance
void balance(int requestid, int accid, struct timeval start) {

    //mutex lock
    pthread_mutex_lock(&allocate[accid].lock);

    int balance = read_account(accid);

    //mutex unlock
    pthread_mutex_unlock(&allocate[accid].lock);

    struct timeval end;

    gettimeofday(&end, NULL);

    fprintf(f, "%d BAL %d TIME %d.%06d %d.%06d\n", requestid, balance, start.tv_sec, start.tv_usec, end.tv_sec, end.tv_usec);

    //clear file from cache
    //fflush(f);
    free(f);

}

//handles requests we got from the list and handles the transactions along with the balance
void* handleMutexAndCommands(void *arg) {

  while(trigger||root != NULL) {

        pthread_mutex_lock(&list);

        struct request r;

        if(root != NULL){

            r= root->data;

            root= root ->next;

            pthread_mutex_unlock(&list);

            //now we handle the request that we got from the list
            printf("ID %d\n", r.rID);

            char *commands[1024];

            memcpy(&commands, &r.task,sizeof commands);

            if(strcmp("TRANS",commands[0]) == 0){
                transaction(r.rID,commands, r.times );
            }

            if(strcmp("CHECK",commands[0]) == 0){
                balance(r.rID,atoi(commands[1]), r.times);
            }

        }
        else{
            pthread_mutex_unlock(&list);
        }
  }
}


