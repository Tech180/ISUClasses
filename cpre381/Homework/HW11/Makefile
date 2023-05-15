
SRCS := $(wildcard test*.c)
BINS = ${SRCS:.c=}
CFLAGS = "-std=c99" 
CPPFLAGS = 

all: $(BINS)

test% : test%.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $< -o $@

clean:
	rm -f $(BINS)
