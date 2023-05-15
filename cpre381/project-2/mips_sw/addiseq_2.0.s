#
# First part of the Lab 3 test program
#

# data section
.data

# code/instruction section
.text

branch:
addi $1, $0, 1
addi $2, $0, 2
addi $3, $0, -3
addi $4, $0, -4
addi $5, $0, 5
addi $6, $0, 6

bne $1, $1, branch
bne $1, $2, branchnotequal

addi $15, $1, 2

branchnotequal:
bne $3, $3, branch
bne $3, $4, branchnotequal2
addi $16, $1, 1

branchnotequal2:
beq $1, $2, branch
beq $1, $1, branchequal
addi $17, $1, 1

branchequal:
beq $3, $4, branch
beq $3, $3, branchequal2
addi $18, $1, 1

branchequal2:
addi $15, $1, 5
add $16, $5, $6

addi  $2,  $0,  10              # Place 10 in $v0 to signal a halt
syscall                         # halt lol

