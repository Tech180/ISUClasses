.data
.text
.globl main
main:
    # Start Test
	repl.qb $1, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $2, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $3, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $4, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $5, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $6, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $7, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $8, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $9, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $10, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $11, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $12, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $13, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $14, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $15, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $16, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $17, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $18, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $19, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $20, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $21, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $22, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $23, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $24, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $25, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $26, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $27, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $28, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $29, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $30, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	repl.qb $31, 0 #check that you can write over the register and that you can duplicate the 0, rd should be 0x00000000
	# End Test

    # Exit 
	halt
    li $v0, 10
    syscall
