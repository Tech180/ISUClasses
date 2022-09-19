#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <pthread.h>
#include <unistd.h>

#include "Bank.c"
#include "Bank.h"

typedef struct account {
    pthread_mutex_t mutex;
    int amount;
} account;

typedef struct request {
    struct request * next;
    char* cmd;
    int request_id;
    struct timeval starttime;
} request;

typedef struct node {
    struct request * head, * tail;
    int num_jobs;
} node;

node* trans;
account* accounts;

int rID = 1;

//important temporary variable
int temp = 1;

void* handleRequest();
void push(char* cmd, int id);

int inputParams(char* input, char* args[]);

FILE* f;

pthread_mutex_t list;

struct request r();

void main(int argc, char** argv) {
    int i;

    //number of threads
    long t = strtol(argv[1], NULL, 0);
    //number of accounts
    long aa = strtol(argv[2], NULL, 0);

    char* f1 = argv[3];
    char* input = NULL; //input

    size_t length = 0;

    pthread_t thread[t];

    trans = (node*) malloc(sizeof(node));

    trans -> head = NULL;
    trans -> tail = NULL;
    trans -> num_jobs = 0;

    //initialize mutex
    pthread_mutex_init(&list, NULL);

    f = fopen(f1, "w");

    printf("%ld thread(s), %ld account(s), to %s\n", t, aa, f1);

    accounts = (account*) malloc(aa*sizeof(account));

    initialize_accounts(aa);

    // mutex for each account
    for(i = 0; i < aa; i++) {
        pthread_mutex_init(&(accounts[i].mutex), NULL);
        accounts[i].amount = 0;
    }

    //creates additional threads
    for(i = 0; i < t; i++) {
        pthread_create(&thread[i], NULL, handleRequest, NULL);
    }


    while(temp) {
        printf("> ");

        getline(&input, &length, stdin);

        strtok(input, "\n");

        if(strcmp(input, "END") == 0) {
            temp = 0;
            break;
        }

        //lock mutex
        pthread_mutex_lock(&list);

        push(input, rID);

        printf("< ID %d\n", rID);

        pthread_mutex_unlock(&list);

        rID++;
    }

    for(i = 0; i < t; i++) {
        pthread_join(thread[i], NULL);
    }

    //free all transactions
    //does this work?

    pthread_mutex_unlock(&list);

    free(trans);

    fclose(f);

    //doesn't finish... unsure why?
}

void* handleRequest() {

    //makes sure that either are checked so it can write transactions
    while(temp || trans -> head != NULL) {

        //mutex lock
        pthread_mutex_lock(&list);

        if(trans -> head != NULL) {

            request req = r();
            pthread_mutex_unlock(&list);

            char* seperate = strsep(&req.cmd, " ");
            char** args;

            int blank = inputParams(req.cmd, args);

            // handle request logic
            if(strcmp(seperate, "CHECK") == 0) {

                int balance;
                int accID = atoi(args[1]);

                struct timeval complete;

                account acc;

                acc = accounts[accID - 1];

                //mutex lock
                pthread_mutex_lock(&acc.mutex);

                //read balance
                balance = read_account(accID);

                //mutex unlock
                pthread_mutex_unlock(&acc.mutex);

                //complete cycle
                gettimeofday(&complete, NULL);

                //lock file
                flockfile(f);

                fprintf(f, "%ld.%06ld", complete.tv_sec, complete.tv_usec);

                //unlock file
                funlockfile(f);
            }

            else if(strcmp(seperate, "TRANS") == 0) {

                int half = blank / 2;

                int accIDs[half];
                int amounts[half];

                int ISF = 0;

                int i;
                //account
                int index = 0;
                //amount for transaction index
                int index2 = 0;

                // grab account # and amount separately
                for(i = 1; i <= blank; i++) {
                    if(i % 2 == 0) {
                        amounts[index2] = atoi(args[i]);

                        index2++;
                    } else {
                        accIDs[index] = atoi(args[i]);

                        index++;
                    }
                }

                // for negative balance!
                // forgot about this until last second
                for(i = 0; i < half; i++) {

                    int thisBalance = read_account(accIDs[i]);

                    if(thisBalance + amounts[i] < 0) {

                        ISF = 1;
                        break;
                    }
                }

                if(ISF) {
                    struct timeval complete;

                    //complete cycle
                    gettimeofday(&complete, NULL);

                    //lock file
                    flockfile(f);

                    fprintf(f, "%d ISF %d TIME %ld.%06ld %ld.%06ld\n", req.request_id, accIDs[i], req.starttime.tv_sec, req.starttime.tv_usec, complete.tv_sec, complete.tv_usec);

                    //unlock file
                    funlockfile(f);
                }

                else {
                    for(i = 0; i < half; i++) {

                        account acc = accounts[accIDs[i] - 1];

                        int thisBalance = read_account(accIDs[i]);

                        write_account(accIDs[i], (thisBalance + amounts[i]));
                    }

                    struct timeval complete;

                    gettimeofday(&complete, NULL);

                    //lock file
                    flockfile(f);

                    fprintf(f, "%d OK TIME %ld.%06ld %ld.%06ld\n", req.request_id, req.starttime.tv_sec, req.starttime.tv_usec, complete.tv_sec, complete.tv_usec);

                    //unlock file
                    funlockfile(f);
                }

                for(i = 0; i < half; i++) {
                    account acc;

                    acc = accounts[accIDs[i] - 1];

                    pthread_mutex_unlock(&acc.mutex); //unlock mutex(s)
                }
            }
            else { // else invalid input, do nothing
                pthread_mutex_unlock(&list);
            }
        }
    }
}

//to parse any input strings
int inputParams(char* input, char* args[]) {
    int i;
    int j;
    int blank = 0;

    for(i = 0; i < strlen(input); i++) {
        if(input[i] == ' ') {
            blank++;
        }
    }

    for(j = 0; j < 20; j++) {
        args[j] = strsep(&input, " ");
    }

    return blank;
}


void push(char* cmd, int id) {

    request* newReq = malloc(sizeof(request));

    newReq->cmd = malloc(1024*sizeof(char));

    strncpy(newReq->cmd, cmd, 1024);

    newReq->request_id = id;

    gettimeofday(&(newReq -> starttime), NULL);

    newReq -> next = NULL;

    if(trans -> num_jobs > 0) {
        trans -> tail -> next = newReq;
        trans -> num_jobs = trans -> num_jobs + 1;
    }
    else {
        trans -> head = newReq;
        trans -> tail = newReq;
    }
}

struct request r() {

    request* temp;
    request r1;

    if(trans -> num_jobs > 0) {

        r1.request_id = trans -> head -> request_id;

        r1.starttime = trans -> head -> starttime;

        r1.cmd = malloc(1024 * sizeof(char));

        strncpy(r1.cmd, trans -> head -> cmd, 1024);

        r1.next = NULL;

        temp = trans -> head;

        trans -> head = trans -> head -> next;

        //free pointer
        free(temp -> cmd);

        //free variable
        free(temp);

        if(!trans -> head) {
            trans -> tail = NULL;
        }

        trans -> num_jobs = trans -> num_jobs - 1;

    }

    else {
        r1.cmd = NULL;
    }

    return r1;
}
