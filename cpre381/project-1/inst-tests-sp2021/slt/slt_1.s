.data
.text
.globl main
main:
    # Start Tests for negative value comparisons
    addi $1, $0, -1         # Set $1 = -1
    slt $2, $0, $1          # Verify 0<-1 sets $2 to 0
    slt $2, $1, $0          # Verify -1<0 sets $2 to 1
    addi $1, $0, -247       # Set $1 = -247
    slt $2, $0, $1          # Verify 0<-247 sets $2 to 0
    slt $2, $1, $0          # Verify -247<0 sets $2 to 1
    add $1, $0, $0          # Set clear $1
    lui $1, 0x8000      # Set $1 = 0x10000000 aka the minimum value available in 2's compliment
    slt $2, $0, $1          # Verify that 0<0x10000000 sets $2 to 0
    slt $2, $1, $0          # Verify that 0x10000000<0 sets $2 to 1
    addi $1, $0, -10         # Set $1 = -10
    addi $2, $0, -100        # Set $2 = -100
    slt $3, $1, $2          # Verify that -10<-100 sets $3 to 0
    slt $3, $2, $1          # Verify that -100<-10 sets $3 to 1
    # End Test

    # Exit program
    halt
    li $v0, 10
    syscall
