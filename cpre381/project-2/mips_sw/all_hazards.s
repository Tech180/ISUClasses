#
# First part of the Lab 3 test program
#

# data section
.data
tmp:.word   1
val:.word   5

# code/instruction section
.text
lui    $1, 4097
addi   $9,  $0,  1
addi   $2,  $0,  2
addi   $3,  $0,  3
addi   $4,  $0,  4
addi   $5,  $0,  5
addiu  $6,  $0,  -6
addiu  $7,  $0,  -7
ori    $11, $1, 4
addiu  $8,  $0,  8
addiu  $9,  $0,  9
addiu  $4, $0,  2
add    $18, $1, $2
addu   $12, $1, $5

sub    $13, $5, $2
subu   $22, $3, $1

and    $14, $2, $3
andi   $15, $6, 5

sw     $17, 0($11)

lui    $16, 1015

addi   $4, $0, 4097

nor    $19, $9, $5

xor    $20, $10, $3
xori   $21, $9, 6

lw     $17, 0($11)

or     $22, $5, $7
ori    $23, $7, 3
ori    $31, $5, 4

slt    $24, $5, $19
slti   $25, $3, 7
sltiu  $26, $5, 8
sltu   $27, $3, $5

sll    $28, $5, 2
srl    $29, $4, 3
sra    $30, $3, 4
sllv   $31, $2, $1
srlv   $12, $7, $2
srav   $13, $9, $3

b:
addi   $1, $0, 1
addi   $2, $0, 2
addi   $3, $0, -3
addi   $4, $0, -4
bne    $1, $1, b
NOP
NOP
bne    $1, $2, branchnotequal
NOP
NOP

branchnotequal:
j jump
NOP
NOP
addi   $1, $0, 1

jump:
jal jumpandlink
NOP
NOP
j jump2
NOP
NOP

jumpandlink:
NOP
NOP
NOP
jr    $31
NOP
NOP

jump2:
addi  $2,  $0,  10              # Place 10 in $v0 to signal a halt
syscall                         # halt lol
