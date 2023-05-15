.data
array1: .word 123, 111, 44, 101, 2, 1, 99
.globl main
main:

lui $s0, 0x00001001
ori $s0, 0x00000000

addi $s2, $0, 1

addi $s3, $0, 5

addi $s4, $0, 1

swaploop1:

lui $s0, 0x00001001
ori $s0, 0x00000000

beq $s4, $s0, exit

ori $s3, 5
add $s4, $0, $0

swaploop2:

beq $s3, $0, swaploop1

lw $t0, ($s0)

addi $s0, $s0, 4
subu $s3, $0, swaploop2

lw $t1, ($s0)

slt $t2, $t1, $t0

bne $t2, $0, swap

j swaploop2

swap:

sw $t0, ($s0)
subi $s0, $s0, 4

sw $t1, ($s0)
addi $s0, $s0, 4

addi $s4, $0, 1

j swaploop2

exit:

halt
