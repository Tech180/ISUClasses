.data
.text
.globl main
main:
    # Start Tests for comparisons of positive and negative values
    addi $1, $0, -1         # Set $1 = -1
    addi $2, $0, 1         # Set $1 = 1
    slt $3, $1, $2          # Verify that -1<1 sets $3 to 1
    slt $3, $2, $1          # Verify that 1<-1 sets $3 to 0
    addi $1, $0, -345         # Set $1 = -345
    addi $2, $0, 87         # Set $1 = 87
    slt $3, $1, $2          # Verify that -345<87 sets $3 to 1
    slt $3, $2, $1          # Verify that 87<-345 sets $3 to 0
    addi $1, $0, 9384         # Set $1 = 9384
    addi $2, $0, -57         # Set $1 = -57
    slt $3, $1, $2          # Verify that 9384<-57 sets $3 to 0
    slt $3, $2, $1          # Verify that -57<9384 sets $3 to 1
    add $1, $0, $0          # Set clear $1
    lui $1, 0xefff      # Set $1 = 0xefff0000
    addiu $1, $1, 0xffff    # Set $1 to 0xefffffff aka the max positive value
    add $2, $0, $0          # Set clear $2
    lui $2, 0x8000      # Set $2 = 0x10000000 aka the minimum value available in 2's compliment
    slt $3, $1, $2          # Verify that 0xefffffff<0x10000000 sets $3 to 0
    slt $3, $2, $1          # Verify that 0x10000000<0xefffffff sets $3 to 0
    # End Test

    # Exit program
    halt
    li $v0, 10
    syscall
