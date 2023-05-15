#include<stdlib.h>
#include<stdio.h>
#include<time.h>

int main(int argc, char **argv) {

  // Array should be relatively large (i.e., larger than a cache)
  int N = 1<<atoi(argv[1]);      // Array size in log2(N) bytes
  int iter = 1<<atoi(argv[2]);   // Number of times to repeat the experiment to
                                 // increase reliability and measurability of time
                                 // in log2(iter) iterations
  int ws = 1<<atoi(argv[3]);     // Size information from test1.c
                                 // in log2(ws) bytes

  char *a;
  a = (char *)malloc(sizeof(char)*N);
  char *b;
  b = (char *)malloc(sizeof(char)*N);

  for (int i = 0; i < N; ++i) {
    a[i] = 0;
    b[i] = 0;
  }

  for (int j = 1; j < N/ws; j=j<<1) {

    // In between test values, evict all elements of a
    for (int i = 0; i < N; ++i) {
      b[i]++;
    }
  
    clock_t start = clock(); // START EXPERIMENT 
  
    // iter/j to keep access count even across j values
    int accesses = 0;
    for (int k = 0; k < iter/j; ++k) { 
      for (int i = 0; i < j; ++i) {
          accesses++;
          a[i*ws]++;
      }
    }
  
    clock_t end = clock(); // END EXPERIMENT
    clock_t total_cycles = (end - start);
    double total_time = ((double)total_cycles)/CLOCKS_PER_SEC;
    printf("Total time (s) for j=%d is %f with %d accesses\n", j, total_time,accesses);

  }

  return 0;
}
