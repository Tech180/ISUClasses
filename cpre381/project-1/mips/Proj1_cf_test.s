.globl main
main:

addi $t0, $0, 5

first:
beq $t0, $0, exit
j third

second:
subi $t0, $t0, 1
j fifth

third:
subi $t0, $t0, 1
j second

fourth:
subi $t0, $t0, 1
j sixth

fifth:
subi $t0, $t0, 1
j fourth

sixth:
subi $t0, $t0, 1
j first

exit:
halt
