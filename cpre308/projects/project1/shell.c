#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdbool.h>

#define MAX_LENGTH 1024

void shell_prompt();
int system1(char **args, bool status);
void builtIn(char *input, char **args);
bool parse(char *a, char *args[]);
char *reading(void);
char inParse(char* p);

int background = 0;
//int flag = 0;

//runs the main shell loop
int main(int argc, char* argv[]) {

    //char *woosh[] = { (char *) "PATH=/bin", 0};

    char *input = NULL;
    char *input1;

    //init_shell(argc, argv, input);

    if (argc == 3 && strcmp(argv[1], "-p") == 0){
        input1 = argv[2];
    }
    else if (argc == 1) {
        input1 = "308sh >";
    }
    else {
        printf("\nPlease '-p <prompt>' as arguments for a custom prompt");
        return 0;
    }

    pid_t process;

    //size of string
    size_t string = 0;

    char **args;
    int status;

    while(1) {

        //check for process (background);
        process = waitpid(-1, &status, WNOHANG);

        if(background) {
            if(WIFEXITED(status)) {
                printf("\nChild %d exited with %d", process, WEXITSTATUS(status));
                background = background - 1;
            }
        }

        //when starting up
        static int a = 1;
        if (a == 1) {
            shell_prompt(input1, a);
            a = a - 1;
        }

        //continuing printing line
        else {
            printf("\n%s> ", input1);
        }

        //reads input which transfers the size of string and get line to later builtIn
        //input = reading();
        getline(&input, &string, stdin);

        strtok(input, "\n");

        //Built-in Function and system functions within
        builtIn(input, args);
    }
    return 1;
}

void shell_prompt(char *input, int count) {


    static int a = 1;

    if(a == 1) {
        //During first start up
        //clear the screen
        const char* CLEAR_SCREEN_ANSI = "\e[1;1H\e[2J";
        write(STDOUT_FILENO, CLEAR_SCREEN_ANSI, 11);

        printf("\n%s> ", input);
    }
    else {
        printf("\n%s> ", input);
    }

}

//parse the current string
bool parse(char *p, char* args[]) {
    int i;
    switch(i) {
        case 0 ... 19:
            args[i] = strsep(&p, " ");

            if(args[i] == NULL) {
                break;
            }
            i++;
        default:
            printf("Infinite loop");
    }

    if(inParse(args[0]) == '&') {
        int string = strlen(args[0]);
        args[0][string - 1] = '\0';

        return true;
    }
    else {
        return false;
    }
}


//checks for last character in the string, later checks for if that string is an '&'
char inParse(char* p) {
    int i = 0;

    while(i){
        //checks length of string
        if(i < strlen(p)) {
            if(i == strlen(p) - 1) {
                return p[i];
                //break;
            }
        }
        i++;
    }

    return 0;
}

void builtIn(char *input, char **args) {


    //exit
    if(strcmp(input, "exit") == 0){
        exit(0);
    }

    //pid
    else if (strcmp(input, "pid") == 0) {
        printf("Process ID: %d \n", getpid());
    }

    //pid
    else if (strcmp(input, "ppid") == 0) {
        printf("Parent Process ID: %d \n", getppid());
    }
    else if (strcmp(input, "pwd") == 0) {
        printf("Working Directory: %s \n", getcwd(NULL, 0));
    }
    else if (strncmp(input, "cd", 2) == 0) {

        if(strlen(input) > 2) {
            char* line = strtok(input, " ");

            line = strtok(NULL, "\0");

            if(chdir(line)) {
                printf("New Directory: %s \n", getcwd(NULL, 0));
            }
            else{
                perror("Directory Incorrect \n");
            }
        }
        else {
            chdir(getenv("HOME"));
            printf("Directory: %s \n", getcwd(NULL, 0));
        }
    }
    else {
        char* newArgs[20]; //Max numbers
        bool newBackground = parse(input, args);

        if(newBackground) {
            system1(args, true);
        }
        else {
            system1(args, false);
        }
    }
}


int system1(char **args, bool status) {
//int system1(char **args) {
    pid_t pid;
    int execute;

    pid = fork();
    // Child

    //error
    if (pid == -1) {
        printf("\n Failed fork()");
        printf("PID: %d\n", pid);
    }


    else if(pid == 0) {
        printf("PPID: %d\n", getppid());
        if(execvp(args[0], args) == -1) {
            perror("Command could not finish, Not Valid!\n");
        }

        //exits process due to no children
        exit(0);
    }
    // Parent
    else {
        printf("\nChild PID: %d", pid);

    }

    //checks status and waits for children to finish
    if(!status) {
        while (!WIFEXITED(execute) && !WIFSIGNALED(execute)) {
                    waitpid(pid, &execute, WUNTRACED);
        }
    }
    else {
        status++;
    }

    return 1;

}
