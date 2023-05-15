.globl main
main:

addi $t0, $0, 25  #t0 = 25
addi $t1, $0, 1   #t1 = 1
addiu $t0, $t0, 10 #t0 = 35
addu $t0, $t0, 1   #t0 = 36
add $t0, $t0, $t1 #t0 = 37

and $t1, $t0, $t1 #t1 = 0
andi $t1, $t0, 37 #t1 = 37
or $t2, $t1, $0 #t2 = t1
addi $t0, $0, 1 #t0 = 0
xor $t0, $t1, $t0 #t0 = 0
or $t0, $t1, $t0 # t0 = 1

j test2

test1:

j exit

test2:

addi $t1, $0, 1
addi $t0, $0, 1
beq $t1, $t0, test1

exit:

halt
