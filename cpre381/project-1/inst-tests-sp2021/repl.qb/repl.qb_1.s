.data
.text
.globl main
main:
    # Start Test
	repl.qb $1, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $2, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $3, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $4, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $5, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $6, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $7, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $8, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $9, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $10, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $11, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $12, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $13, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $14, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $15, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $16, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $17, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $18, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $19, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $20, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $21, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $22, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $23, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $24, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $25, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $26, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $27, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $28, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $29, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $30, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	repl.qb $31, 128 #check that it can replicate 1000 0000 without any errors from it being negative (overflow, carrys), rd should be 0x80808080
	# End Test

    # Exit 
	halt
    li $v0, 10
    syscall