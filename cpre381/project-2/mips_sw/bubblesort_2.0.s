.data
array1: .word 123, 111, 44, 101, 2, 1, 99
size:.word  40

.text
.globl main

main:
lui $at, 4097

lw $t3, size

addi $t1, $0, 0
addi $t2, $0, 0

ori $t0, $at, 0
NOP

j count
NOP
NOP

swap:
	sw $s0, 4($t4)		# swap
	sw $s1, 0($t4)
	j sort1_1
	NOP
	NOP

count:
	sort:
		add $t4, $t0, $t1
		NOP
		NOP
		NOP
		lw $s0, 0($t4)
		lw $s1, 4($t4)
		NOP
		NOP
		NOP
		slt $t5, $s1, $s0
		NOP
		NOP
		NOP
		bne $t5, $0, swap
		NOP
		NOP

		sort1_1:
		addi $t1, $t1, 4
		NOP
		NOP
		NOP
		addi $t6, $t1, 4
		sub $t7, $t3, $t2
		NOP
		NOP
		NOP
		slt $s2, $t6, $t7
		NOP
		NOP
		NOP
		bne $s2, $0, sort
		NOP
		NOP
	addi $t2, $t2, 4
	addi $t1, $0, 0
	NOP
	NOP
	slt $s3, $t2, $t3
	NOP
	NOP
	NOP
	bne $s3, $0, count
	NOP
	NOP


addi  $2,  $0,  10              # Place 10 in $v0 to signal a halt
syscall                         # halt lol
