.data
.text
.globl main
main:
    # Start Test
	repl.qb $1, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $2, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $3, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $4, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $5, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $6, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $7, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $8, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $9, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $10, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $11, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $12, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $13, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $14, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $15, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $16, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $17, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $18, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $19, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $20, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $21, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $22, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $23, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $24, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $25, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $26, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $27, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $28, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $29, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $30, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	repl.qb $31, 255 #check replicating all 1s for overflow or issues with all ones, rd should be 0xFFFFFFFF 
	# End Test

    # Exit program
	halt
    li $v0, 10
    syscall