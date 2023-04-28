# allows to be used in main.asm
.globl start

.text
#--------------------------------------------------------------------------------------------------------------------------
start:
	# print player 1 score
	li $v0, 4
	la $a0, player1
	syscall
	li $v0, 1
	la $t0, score
	lbu $a0, 0($t0)
	syscall
	
	# print player 2 score
	li $v0, 4
	la $a0, player2
	syscall
	li $v0, 1
	la $t0, score
	lbu $a0, 1($t0)
	syscall
	
	# print newline
	li $v0, 11
	li $a0, 10  
	syscall
	
	addi $t0, $zero, 1	# set t0 to 1 as index
printColumnNums:
	li $v0, 1
	move $a0, $t0	# print out the number of the column
	syscall
	
	li $v0, 11
	lbu $a0, spaceCharacter	# print 3 spaces
	syscall
	syscall
	syscall
	
	addi $t0, $t0, 1
	bne $t0, 10, printColumnNums	# loop for all columns
	
	lbu $a0, newLineCharacter	# print newline
	syscall
	
	move $t0, $zero	# set t0 to zero to start indexing the arrays, t0 is row index
	move $t1, $zero # set t1 to zero, t1 is column index

horizontalPrintLoop:
	beq $t1, 8, horizLoopEnd	# if t1 = 8, past last column so move to next row 
	
	lbu $a0, dotSymbol	# print the dot symbol (+ sign)
	li $v0, 11
	syscall
	
	sll $t2, $t0, 3		# multiply t0 by 8 
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

horizLoopEnd: move $t1, $zero	#   column counter
	
	lbu $a0, dotSymbol	# print the final dot symbol (+ sign)
	syscall
	
	lbu $a0, spaceCharacter
	syscall
	syscall
	li $v0, 1	# print 2 spaces and then row number
	addi $a0, $t0, 1	# set a0, to t0+1 to make it 1-based number, not 0-based
	syscall
	
	li $v0, 11
	lbu $a0, newLineCharacter	# print out a new line character
	syscall

verticalPrintLoop:
	beq $t1, 9, vertLoopEnd		# if t1 = 9, past last column so move to next row
	beq $t0, 6, vertLoopEnd		# if t0 = 6, just printed very bottom of game board, dont print vertical lines below it
	
	mul $t2, $t0, 9		# multiply t0 by 9
	add $t2, $t2, $t1	# add t1 to t2 to get final index
	
	lbu $t3, verticalLineArray($t2)	# load the state of current edge into register t3
	beq $t3, 0, printSpace	# if line is 0, it does not exist, so print a space instead
	
	lbu $a0, verticalLineSymbol	# if line is not 0, it exists, so print the vertical line symbol
	syscall
	j continue2	# skip the else block
	
printSpace: lbu $a0, spaceCharacter	# else block: print a space character in place of line
	syscall
	
continue2:
	beq $t1, 8, skipLastColumn	# if at last column, skip checking box array

	lbu $a0, spaceCharacter # print 3 space characters to fill in empty cell
	syscall
	sll $t2, $t0, 3 # multiply t0 by 8
	add $t2, $t2, $t1  # add t1 to t2 to get final index
	lbu $t3, boxArray($t2)  # load the state of current box into register t3
	beq $t3, 0, Else   # check if box has been captured
	li $v0, 1
	move $a0, $t3 # print out player that completed box
	syscall
	
	li $v0, 11
	lbu $a0, spaceCharacter  # change back to space for last space
	j End
	Else: syscall
	End: syscall

skipLastColumn:
	addi $t1, $t1, 1	# increment column loop counter
	j verticalPrintLoop	# loop for the rest of the row
	
vertLoopEnd: move $t1, $zero	# reset the column counter
	addi $t0, $t0, 1	# increment the row counter
	
	lbu $a0, newLineCharacter	# print a new line
	syscall
	bne $t0, 7, horizontalPrintLoop	# if row does not = 7, repeat the loop
	
	jr $ra
	
.data	
	dotSymbol: .byte '+'		# plus sign for representing dots
	dashSymbol: .byte '-'	# subtract symbol for horizontal lines
	verticalLineSymbol: .byte '|'	# vertical line symbol
	spaceCharacter: .byte ' '
	newLineCharacter: .byte '\n'
	player1: .asciiz "\nPlayer 1 score: "
	player2: .asciiz "\nPlayer 2 score: "