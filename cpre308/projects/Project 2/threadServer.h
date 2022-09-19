int main(int argc, char * argv[]);
void transaction(int id,char* task[1024], struct timeval start);
void balance(int requestid, int accid, struct timeval start);
void* handleMutexAndCommands(void *arg);

struct node *root;
struct node *last;

struct account {
  pthread_mutex_t lock;
  int value;
};

struct request {
  char* task[1024];
  struct timeval times;
  int rID;
};

struct node {
  struct request data;
  struct node *next;
};

