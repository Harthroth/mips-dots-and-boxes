.text
	move $t0, $zero	# set t0 to zero to start indexing the arrays, t0 is row index
	move $t1, $zero # set t1 to zero, t1 is column index
	
horizontalPrintLoop:
	beq $t1, 7, horizLoopEnd	# if t1 = 7, past last column so move to next row 
	
	lbu $a0, dotSymbol	# print the dot symbol (+ sign)
	li $v0, 11
	syscall
	
	mul $t2, $t0, 7		# multiply t0 by 7 
	add $t2, $t2, $t1	# add t1 to t2 to get final index
	
	lbu $t3, horizontalLineArray($t2)	# load the state of current edge into register t3
	beq $t3, 0, printSpaces	# if line is 0, it does not exist, print spaces instead
	
	lbu $a0, dashSymbol	# line is not 0, so print 3 dashes
	syscall
	syscall
	syscall
	
	j continue1	# skip the else block
	
printSpaces: lbu $a0, spaceCharacter # else block: print 3 space characters since line does not exist
	syscall
	syscall
	syscall
	
continue1:
	
	addi $t1, $t1, 1	# increment column counter t1
	j horizontalPrintLoop	# repeat the loop for the rest of the row

horizLoopEnd: move $t1, $zero	# reset column counter
	
	lbu $a0, dotSymbol	# print the final dot symbol (+ sign)
	syscall

	lbu $a0, newLineCharacter	# print out a new line character
	syscall

verticalPrintLoop:
	beq $t1, 8, vertLoopEnd		# if t1 = 8, past last column so move to next row
	beq $t0, 5, vertLoopEnd		# if t0 = 5, just printed very bottom of game board, dont print vertical lines below it
	
	sll $t2, $t0, 3		# multiply t0 by 8
	add $t2, $t2, $t1	# add t1 to t2 to get final index
	
	lbu $t3, verticalLineArray($t2)	# load the state of current edge into register t3
	beq $t3, 0, printSpace	# if line is 0, it does not exist, so print a space instead
	
	lbu $a0, verticalLineSymbol	# if line is not 0, it exists, so print the vertical line symbol
	syscall
	j continue2	# skip the else block
	
printSpace: lbu $a0, spaceCharacter	# else block: print a space character in place of line
	syscall
	
continue2:
	lbu $a0, spaceCharacter # print 3 space characters to fill in empty cell
	syscall
	sll $t2, $t0, 3
	sub $t2, $t2, $t0  # multiply t0 by 7 by multiplying by 8 and subtracting 1
	add $t2, $t2, $t1  # add t1 to t2 to get final index
	lbu $t3, boxArray($t2)  # load the state of current box into register t3
	beq $t3, 0, Else   # check if box has been captured
	addi $a0, $t3, 48  # print out player that captured box
	syscall
	lbu $a0, spaceCharacter  # change back to space for last space
	j End
	Else: syscall
	End: syscall
	
	addi $t1, $t1, 1	# increment column loop counter
	j verticalPrintLoop	# loop for the rest of the row
	
vertLoopEnd: move $t1, $zero	# reset the column counter
	addi $t0, $t0, 1	# increment the row counter
	
	lbu $a0, newLineCharacter	# print a new line
	syscall
	bne $t0, 6, horizontalPrintLoop	# if row does not = 6, repeat the loop
	
	li $v0, 10	# exit program (temporary)
	syscall
	
.data
	horizontalLineArray: .space 42	# 42 bytes for a 7 * 6 array
	verticalLineArray: .space 40	# 40 bytes for an 8 * 5 array
	boxArray: .space 35             # 35 bytes for a 7 * 5 array
	
	dotSymbol: .byte '+'		# plus sign for representing dots
	dashSymbol: .byte '-'	# subtract symbol for horizontal lines
	verticalLineSymbol: .byte '|'	# vertical line symbol
	spaceCharacter: .byte ' '
	newLineCharacter: .byte '\n'
	
