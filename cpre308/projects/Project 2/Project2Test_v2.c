/** 
* CPR E 308: Introduction to Operating Systems 
* Project 2: Multi-Threaded Bank Server Test Script 
* Written by: Wenhao Chen and Ahmad Nazar 
* Latest update: 04/01/2020
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <limits.h>
#include <math.h>

// generate a random number between lower (inclusive) and upper (exclusive)
#define RAND(lower, upper) ( (rand() % (upper - lower)) + lower )

#define MAX(A, B) (A > B? A : B)
#define MIN(A, B) (A < B? A : B)

/* the amount of money for initial deposits */
#define AMOUNT_INITIAL_DEPOSIT 10000

/* the range of number of randomly generated transaction after initial deposit */
#define MIN_RANDOM_TRANS 300
#define MAX_RANDOM_TRANS 1000

/* the wait time in microseconds (usleep) between sending each requests.
This wait time is very short, but it allows the request ID from the bank
program to be printed out in the right place
*/
#define REQUEST_INTERVAL 2000

/* seed for the Random Number Generator */
#define RNG_SEED 5

/* Functions for the testing process */
void startTesting();
int doInitialDeposits(FILE*, int*, int); // step 1
void countDown(int, char*); // step 2 and 4
int* doRandomTrans(FILE*, int*, int); // step 3
void doFinalBalanceCheck(FILE*); // step 5
void endProgram(FILE*); // step 6
void analyzeOutputFile(int*, int*, int, int); // step 7

/* Helper functions */
void printUsage();
void printFormatError(int, char*);
int split(char*, char **);
void sort(int*, int);
int equals(int*, int, int*, int);

/* testing parameters */
char program_path[200], output_path[200];
int num_workers = 10;
int num_accounts = 1000;
int wait_time_initial = 20;
int wait_time_final = 30;
int secret_trans_count = 0;
	
int main(int argc, char** argv) {

	if (argc < 2) {
		printUsage();
		return 0;
	};

	/* Initialize testing parameters */
	strcpy(program_path, argv[1]);
	if (argc > 2)
		num_workers = atoi(argv[2]);
	if (argc > 3)
		num_accounts = atoi(argv[3]);
	if (argc > 4)
		wait_time_initial = atoi(argv[4]);
	if (argc > 5)
		wait_time_final = atoi(argv[5]);
	if (argc > 6)
		secret_trans_count =atoi(argv[6]);
	sprintf(output_path, "test_%d_%d.txt", num_workers, num_accounts);

	startTesting();
}

void startTesting() {
	int i, j;
	
	// delete the output file from previous tests
	remove(output_path); 
	
	// generate the parameters to run the test program
	char command[300];
	sprintf(command, "%s %d %d %s", program_path, num_workers, num_accounts, output_path);
	
	FILE *pipe = popen(command, "w");
	if (pipe == NULL) {
        printf("Error: popen(%s) failed.\n", command);
        return;
    }
	// set the pipe as autoflush
	setvbuf(pipe, NULL, _IONBF, 0);
	
	int expected_balances[num_accounts];
	
	// Step 1: make initial deposits
	int num_trans_initial = doInitialDeposits(pipe, expected_balances, 10);
	int num_trans_random = MAX(MIN_RANDOM_TRANS, num_accounts/num_workers * 3);
	    num_trans_random = MIN(MAX_RANDOM_TRANS, num_trans_random);
	if (secret_trans_count)
		num_trans_random = secret_trans_count;
	// Step 2: wait for [wait_time_initial] seconds
	printf("\nWaiting for the %d initial transactions to finish... %d random transactions coming up next\n", num_trans_initial, num_trans_random);
	countDown(wait_time_initial, "[wait_time_initial]");
	
	// Step 3: make num_trans_random amount of random transactions
	int *isf_req_ids = doRandomTrans(pipe, expected_balances, num_trans_random);
	
	// Step 4: wait for [wait_time_final] seconds
	printf("\nWaiting for the %d random transactions to finish... checking final account balances next\n", num_trans_random);
	countDown(wait_time_final, "[wait_time_final]");
	
	// Step 5: check final balances
	doFinalBalanceCheck(pipe);
	
	// Step 6: wait for the program to finish
	endProgram(pipe);
	
	// Step 7: parse the output file
	analyzeOutputFile(expected_balances, isf_req_ids, num_trans_initial, num_trans_random);
	
	free(isf_req_ids);
}

int doInitialDeposits(FILE* pipe, int *expected_balances, int accounts_per_trans) {
	int i, j, num_request = 0;
	char request[300], part[25];
	for (i = 0; i < num_accounts; i += accounts_per_trans)
	{
		sprintf(request, "TRANS");
		for (j = i; j < i+accounts_per_trans && j < num_accounts; j++)
		{
			// deposit action for one account
			sprintf(part, " %d %d", j+1, AMOUNT_INITIAL_DEPOSIT); 
			// append deposit action to TRANS request
			strcat(request, part);
			// update expected balances
			expected_balances[j] = AMOUNT_INITIAL_DEPOSIT; 
		}
		// send the TRANS request
		printf("%s\n", request);
		fprintf(pipe, "%s\n", request);
		num_request++;
		usleep(REQUEST_INTERVAL);
	}
	return num_request;
}

int* doRandomTrans(FILE* pipe, int *balances, int num_trans) {
	int i, j;
	char request[300], part[25];
	// initialize RNG with seed
	srand(RNG_SEED);
	
	// 1% of the random TRANS should be ISF
	int num_isf = num_trans / 100;
	if (num_trans > 1 && num_isf == 0)
		num_isf = 1;
	
	// determine which TRANS requests should be ISF
	int *isf_req_ids = (int*) malloc(num_isf * sizeof(int));
	char *shouldISF = (char*) calloc(num_trans, sizeof(char));
	while (num_isf > 0) {
		i = RAND(0, num_trans);
		if (!shouldISF[i]) {
			shouldISF[i] = 1;
			num_isf--;
		}
	}
	
	// init an array of flags to indicate if an account
	// already exists in a TRANS request
	char *acc_included = (char*) calloc(num_accounts, sizeof(char));
	
	int k = 0;
	// generate TRANS requests
	for (i = 0; i < num_trans; i++) {
		
		// each TRANS contains 1 to 6 pairs of accounts
		// TRANS with always have 6 pairs
		int num_pairs = shouldISF[i]? 6 : RAND(1, 7);
		int acc_ids[num_pairs];
		
		if (shouldISF[i])
			isf_req_ids[k++] = i;
		
		sprintf(request, "TRANS");
		for (j = 0; j < num_pairs; j++) {
			// generate random account id
			int acc_id = RAND(0, num_accounts);
			// avoid duplicate accounts IDs in the same TRANS request
			if (acc_included[acc_id]) {
				j--;
				continue;
			}
			acc_included[acc_id] = 1;
			acc_ids[j] = acc_id;
			
			// random amount in the range of [-current_balance, current_balance]
			int amount = balances[acc_id] - 2*RAND(0, balances[acc_id]+1);
			// don't let the amount be 0
			if (amount == 0)
				amount += RAND(1, AMOUNT_INITIAL_DEPOSIT/2);
			// update the expected balances for non-ISF TRANS
			if (!shouldISF[i])
				balances[acc_id] += amount;
			else if (j == 2) // let the 3rd pair cause ISF in ISF TRANS
				amount -= 10*balances[acc_id];
			// when sending the request, use acc_id+1
			sprintf(part, " %d %d", acc_id+1, amount);
			strcat(request, part);
		}
		// send the TRANS request
		printf("%s\n", request);
		fprintf(pipe, "%s\n", request);
		usleep(REQUEST_INTERVAL);
		
		// reset the acc_included flags
		for (j = 0; j < num_pairs; j++)
			acc_included[acc_ids[j]] = 0;
	}
	
	free(shouldISF);
	free(acc_included);
	
	return isf_req_ids;
}

void doFinalBalanceCheck(FILE *pipe) {
	char request[20];
	int i;
	for (i = 0; i < num_accounts; i++)
	{
		sprintf(request, "CHECK %d", i+1);
		printf("%s\n", request);
		fprintf(pipe, "%s\n", request);
		usleep(REQUEST_INTERVAL);
	}
}

void analyzeOutputFile(int *expected_balances, int *expected_isf_req_ids, int num_trans_initial, int num_trans_random) {
	
	int i;
	int num_req_total = num_trans_initial + num_trans_random + num_accounts;
	int num_trans = num_trans_initial + num_trans_random;
	int lineNumber = 0;
	int num_isf_expected = num_trans_random / 100;
	if (num_trans_random > 1 && num_isf_expected == 0)
		num_isf_expected = 1;
	int num_isf_actual = 0;
	int actual_isf_req_ids[num_trans_random];
	int sum_actual_balance = 0;
	
	/* total wait time for TRANS and CHECK requests*/
	double total_time_trans = 0;
	double total_time_check = 0;
	/* start and end time for this test script */
	double time_start = LONG_MAX;
	double time_end = 0;
	/* start and end time for initial deposits */
	double time_initial_start = LONG_MAX; 
	double time_initial_end = 0;
	/* start and end time for random transactions */
	double time_random_start = LONG_MAX; 
	double time_random_end = 0;
	/* start and end time for final balance checks*/
	double time_final_start = LONG_MAX;
	double time_final_end = 0;
	
	char *req_answered = (char*) calloc(num_req_total, sizeof(char));
	char **parts = (char **) malloc(sizeof(char*)*100);
	char lineCopy[200];
	char *line = NULL;
	size_t len = 0;
	char format_OK = 1;
	
	
	printf("============== Test Summary =================\n");
	printf("\nBank program parameters: %d worker threads, %d bank accounts\n", num_workers, num_accounts);
	printf("Output file path: %s\n", output_path);
	printf("Total number of requests generated: %d (%d TRANS, %d CHECK)\n", num_req_total, num_trans, num_accounts);
	
	
	// For each line in output file:
	//   1. check num_parts: 5 for OK, 6 for BAL and ISF, anything else is bad
	//   2. check result_string: value
	//   3. check req_id: range, duplication
	//   4. check ISF_acc_id (if ISF): range
	//   5. record balance (if BAL)
	//   6. check time: end time should be greater than start time
	FILE *out = fopen(output_path, "r");
	if (out == NULL) {
		printf("\n[Error] Cannot open output file %s\n", output_path);
		return;
	}
	
	while ((getline(&line, &len, out)) != -1) {
		lineNumber++;
		line[strlen(line)-1] = '\0';
		strcpy(lineCopy, line);
		// split the line into parts
		int num_parts = split(line, parts);
		
		// check the number of parts
		//printf("num parts %d %s\n", num_parts, parts[1]);
		if (num_parts!=5 && num_parts!=6) {
			printFormatError(lineNumber, lineCopy);
			format_OK = 0;
			break;
		}
		int isBAL = strcasecmp(parts[1], "BAL")==0;
		int isOK = strcasecmp(parts[1], "OK")==0;
		int isISF = strcasecmp(parts[1], "ISF")==0;
		if (isOK && num_parts!=5 || isBAL && num_parts!=6 || isISF && num_parts!=6){
			printFormatError(lineNumber, lineCopy);
			format_OK = 0;
			break;
		}
		
		// check result string
		if (!isBAL && !isOK && !isISF) {
			printf("\n[ERROR] unrecognized keyword \"%s\" in Line %d: %s\n",
				parts[1], lineNumber, lineCopy);
			format_OK = 0;
			break;
		}
		
		// check req_id for value range and duplication
		int req_id = atoi(parts[0]);
		if (req_id < 1 || req_id > num_req_total) {
			printf("\n[ERROR] Bad request ID \"%s\" in Line %d: %s\n", parts[0], lineNumber, lineCopy);
			format_OK = 0;
			break;
		}
		if (req_answered[req_id-1]) {
			printf("\n[ERROR] Duplicate Request ID \"%d\" in Line %d: %s\n", req_id, lineNumber, lineCopy);
			format_OK = 0;
			break;
		}
		req_answered[req_id-1] = 1;
		
		// for ISF trans
		if (isISF) {
			int isf_acc_id = atoi(parts[2]);
			// check ISF account id for value range
			if (isf_acc_id < 1 || isf_acc_id > num_accounts) {
				printf("\n[ERROR] Bad ISF account number \"%s\" in Line %d: %s\n", parts[2], lineNumber, lineCopy);
				format_OK = 0;
				break;
			}
			actual_isf_req_ids[num_isf_actual++] = req_id;
		}
		// record balance (if BAL)
		if (isBAL) {
			int balance = atoi(parts[2]);
			if (balance < 0) {
				printf("\n[ERROR] Negative balance in Line %d: %s\n", lineNumber, lineCopy);
				format_OK = 0;
				break;
			}
			sum_actual_balance += balance;
		}
		// check time: end time should be greater than start time
		double start, end;
		sscanf(parts[num_parts-2], "%lf", &start);
		sscanf(parts[num_parts-1], "%lf", &end);
		if (end < start) {
			printf("\n[ERROR] Request end_time smaller than start_time in Line %d: %s\n", lineNumber, lineCopy);
			format_OK = 0;
				break;
		}
		double elapsed = end - start;
		
		if (req_id <= num_trans_initial) {
			time_initial_start = MIN(time_initial_start, start);
			time_initial_end = MAX(time_initial_end, end);
		}
		else if (req_id <= num_trans_initial+num_trans_random) {
			time_random_start = MIN(time_random_start, start);
			time_random_end = MAX(time_random_end, end);
		}
		else {
			time_final_start = MIN(time_final_start, start);
			time_final_end = MAX(time_final_end, end);
		}
		time_start = MIN(time_start, start);
		time_end = MAX(time_end, end);

		if (isBAL)
			total_time_check += elapsed;
		else
			total_time_trans += elapsed;
	}
	if (!format_OK) {
		free(parts);
		free(req_answered);
		return;
	}

	printf("Total number of results retrived: %d\n", lineNumber);
	// check if there are missing requests
	int missing_req_ids[num_req_total];
	int count_missing = 0;
	for (i=0; i<num_req_total; i++)
	if (!req_answered[i])
		missing_req_ids[count_missing++] = i;
	if (count_missing > 0) {
		printf("\n%d requests are missing", count_missing);
		if (count_missing < 20) {
			printf(". Missing req IDs:");
			for (i=0; i<count_missing; i++)
				printf(" %d", missing_req_ids[i]);
		}
		printf("\n");
		/*free(parts);
		free(req_answered);
		return;*/
	}
	
	// compare the expected and actual sum
	int sum_expected_balance = 0;
	for (i=0; i<num_accounts; i++)
		sum_expected_balance += expected_balances[i];
	printf("\n-- Final Balances --\n");
	printf("Expected sum of balances: %d\n", sum_expected_balance);
	printf("  Actual sum of balances: %d\n", sum_actual_balance);
	
	if (sum_expected_balance == sum_actual_balance)
		printf("Passed. Congratulations!\n");
	else if (num_workers == 1)
		printf("Failed. the two sums should have been the same since we are testing with a single worker thread\n");
	else
		printf("Note: The expected sum is calculated by assuming all the requests are processed in sequential order in a single thread. Since we are testing with %d threads, a small difference is acceptable\n", num_workers);
	
	// compare the expected and actual ISF request IDs
	printf("\n-- ISF transactions --\n");
	printf("Expected %2d ISF requests:", num_isf_expected);
	for (i=0; i<num_isf_expected; i++)
		expected_isf_req_ids[i] += num_trans_initial+1;
	for (i=0; i<num_isf_expected; i++)
		printf(" %d", expected_isf_req_ids[i]);
	printf("\n     Got %2d ISF requests:", num_isf_actual);
	sort(actual_isf_req_ids, num_isf_actual);
	for (i=0; i<num_isf_actual; i++)
		printf(" %d", actual_isf_req_ids[i]);
	printf("\n");
	
	if (equals(expected_isf_req_ids, num_isf_expected, actual_isf_req_ids, num_isf_actual))
		printf("Passed. Congratulations!\n");
	/*else if (num_workers == 1)
		printf("Failed. The ISF request IDs should be the same since we are testing with a single worker thread\n");*/
	else 
		printf("Note: It's acceptable to have more ISF requests than expected as long as all of the expected ISF requests are correctly recognized\n");
	
	// report run time
	double time_initial = time_initial_end - time_initial_start;
	double time_random = time_random_end - time_random_start;
	//double time_final_bal = time_final_end - time_final_start;
	printf("\n-- Script Run Time --\n");
	printf("Initial deposits (%d TRANS) took %.1f seconds to finish, script waited %d seconds.%s\n", num_trans_initial, time_initial, wait_time_initial, wait_time_initial+2>time_initial?"":". Might need a higher [wait_time_initial]");
	printf("Random transactions (%d TRANS) took %.1f seconds to finish, script waited %d seconds.%s\n", num_trans_random, time_random, wait_time_final, wait_time_final+2>time_random?"":". Might need a higher [wait_time_final]");
	//printf("Final balance checks(%d CHECK) took %.1f seconds to finish\n", num_accounts, time_final_bal);
	
	double avg_time_trans = total_time_trans / num_trans;
	double avg_time_check = total_time_check / num_accounts;
	printf("\n-- Request Wait Time --\n");
	printf("Total wait time for the %d TRANS requests: %.3f seconds, average %.3f seconds per request\n", num_trans, total_time_trans, avg_time_trans);
	printf("Total wait time for the %d CHECK requests: %.3f seconds, average %.3f seconds per request\n\n", num_accounts, total_time_check, avg_time_check);
	
	free(parts);
	free(req_answered);
}

void countDown(int seconds, char *paramName) {
	sleep(1);
	printf("Note: the wait time can be specified by the script input parameter %s\n", paramName);
	fflush(stdout);
	int i; 
	for (i = seconds; i > 0; i--)
	{
		printf("\r%d seconds remaining... ", i);
		fflush(stdout);
		sleep(1);
	}
	printf("\n\n");
}

void endProgram(FILE* pipe) {
	fprintf(pipe, "END\n");
	sleep(1);
	printf("Waiting for program to END...\n");
	pclose(pipe);
}

void printUsage() {
	printf("Usage: ./Project2Test [program_path] [num_workers] [num_accounts] [wait_time_initial] [wait_time_final]\n");
	printf("Parameter:\n");
	printf("  %-18s: %s\n", "program_path", "path to the bank server program");
	printf("  %-18s: %s\n", "num_workers", "optional paramter (default 10). Number of worker threads for the bank server");
	printf("  %-18s: %s\n", "num_accounts", "optional paramter (default 1000). Number of bank accounts for the bank server");
	printf("  %-18s: %s\n", "wait_time_initial", "optional parameter (default 15). Wait time (in seconds) after initial deposits. ");
	printf("  %-18s: %s\n", "wait_time_final", "optional parameter (default 20). Wait time (in seconds) before final balance checking");
	printf("\nThis script tests your bank server program in 7 steps:\n");
	printf("  Step 1: Deposit %d to each bank account\n", AMOUNT_INITIAL_DEPOSIT);
	printf("  Step 2: Wait for [wait_time_initial] seconds to let all the Step 1 transactions finish\n");
	printf("  Step 3: Make at least %d randomly generated TRANS requests. A small percentage of them might cause ISF.\n", MIN_RANDOM_TRANS);
	printf("  Step 4: Wait for [wait_time_final] seconds to let all the Step 3 transactions finish\n");
	printf("  Step 5: Check all the account balances\n");
	printf("  Step 6: Send the END command and wait for program to finish\n");
	printf("  Step 7: Analyze the results from the output file\n");
	printf("\nIt's important to set a long enough [wait_time_initial] and [wait_time_final] so the transactions in Step 1 (initial deposits) and Step 3 (random transactions) are all finished during their respective wait time.\n");
}

void printFormatError(int lineNumber, char *line) {
	printf("\n[ERROR] Bad output format in Line %d: %s\n", lineNumber, line);
	printf("\nThe output for 'CHECK' should look like: ");
	printf(" 414 BAL 21928 TIME 1585331595.107089 1585331595.121682\n");
	printf("The output for 'TRANS' should look like:\n");
	printf("\t278 OK TIME 1585331570.968401 1585331571.177592\n");
	printf("OR");
	printf("\t356 ISF 813 TIME 1585331583.072773 1585331585.066149\n");
}

int split(char *line, char **parts) {
	int len = strlen(line);
	if (len>0 && line[len-1]=='\n')
		line[len-1] = '\0';
	int count = 0;
	char *part;
	while ((part = strsep(&line, " "))!=NULL)
	{
		parts[count++] = part;
	}
	parts[count] = NULL;
	return count;
}

int comparator(const void *a, const void *b) {
	int* i1 = (int*)a;
	int* i2 = (int*)b;
	return *i1 - *i2;
}

void sort(int *arr, int len) {
	qsort(arr, len, sizeof(int), comparator);
}

int equals(int* arr1, int len1, int* arr2, int len2) {
	if (len1 != len2)
		return 0;
	int i;
	for (i=0; i<len1; i++)
		if (arr1[i] != arr2[i])
			return 0;
	return 1;
}