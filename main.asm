.data
	whoIsFirst:	.asciiz "Who is going first (1 = Player | 2 = Computer)\n"
	invalidInput:	.asciiz "Invalid input, must be either input 1 or 2\n"

	initialText1:	.asciiz "Player "
	initialText2:	.asciiz " will be going first\n"
	ifP2:		.asciiz	" (Computer)"
	
	player1TurnPrompt1:	.asciiz "Input the X coordinate (0-7)\n"
	player1TurnPrompt2:	.asciiz "\nInput the Y coordinate (0-5)\n"
	player1TurnPrompt3:	.asciiz "\nInput the Cardinal Direction (N/S/E/W)\n"
	
	invalidPrompt:		.asciiz "Error in input, try again\n"

	newLineCharacter: 	.byte '\n'

	firstTurnPlayer:	.word 0
	currentTurnPlayer:	.word 0
	xCoord:			.word 0
	yCoord:			.word 0
	cardinalDirection:	.word 80

.globl main

.text
main:
	jal turnPlayerDecider
	jal printBoard	
	jal printInitialAsciiz
	
	jal gameStart
	
	
	li $v0, 10
	syscall
	
	
	
	
	
	
	
	
	
	
#--------------------------------------------------------------------------------------------------------------------------
# TurnPlayerDecider Function
turnPlayerDecider:
	# Asking who is going first
	li $v0, 4
	la $a0, whoIsFirst
	syscall
	
	li $v0, 5				# reading input
	syscall
	
	slti $t0, $v0, 3 			# if input < 3 (aka, is 1 or 2), then $t0 is set to 1
	beq $v0, $zero, invalidInput		# if input is 0, then it's an invalidInput
				
	bne $t0, $zero, turnPlayerDeciderEnd	# input is 1 or 2 goes to turnPlayerDeciderEnd, which goes back to main
	
	li $v0, 4				# outputs invalidInput response
	la $a0, invalidInput
	syscall 
	
	j turnPlayerDecider			# loops back to turnPlayerDecider


turnPlayerDeciderEnd:
	sw $v0, firstTurnPlayer 			# stores input in firstTurnPlayer .word
	
	# adds a newLinenCharacter to make I/O readable
	li $v0, 11
	lbu $a0, newLineCharacter		
	syscall					
	
	jr $ra
	
	
#--------------------------------------------------------------------------------------------------------------------------
# printBoard Function
printBoard:
	addiu $sp, $sp, -4	# allocate space in stack
	sw $ra, 0($sp)		# loads saved $ra to first cell(?) of stack
		
	# prints the board from printBoard.asm
	jal start
	
	lw $ra, 0($sp)		# pop value off stack
	addiu $sp, $sp, 4	# deallocate space in stack
	
	jr $ra			# returns to main
	
	
#--------------------------------------------------------------------------------------------------------------------------
# initialAsciiz Function
printInitialAsciiz:	
	# outputs initialText1
	li $v0, 4
	la $a0, initialText1
	syscall
	
	# outputs who is turn 1 player
	li $v0, 1
	lw $a0, firstTurnPlayer
	syscall
	
	# if computer is first turn player, then jump to computerT1
	lw $t0, firstTurnPlayer
	li $t1, 2
	beq $a0, $t1, computerT1

printInitialAsciizEnd:
	# prints initialText2
	li $v0, 4
	la $a0, initialText2
	syscall
	
	# loads firstTurnPlayer and sets it to the currentTurnPlayer
	lw $t0, firstTurnPlayer		
	sw $t0, currentTurnPlayer
	
	jr $ra	# returns to main

computerT1:
	# first turn player is Player2, so output ifP2
	li $v0, 4
	la $a0, ifP2
	syscall
		
	j printInitialAsciizEnd 	# jumps to printInitialAsciizEnd
	
#--------------------------------------------------------------------------------------------------------------------------
# gameStart Function
gameStart:
	# depending on value of currentTurnPlayer, it will go to player1Turn or player2Turn
	lw $t0, currentTurnPlayer
	beq $t0, 1, player1Turn
	beq $t0, 2, player2Turn

player1Turn:
	# prints player1TurnPrompt and stores each input in respective variable
	li $v0, 4
	la $a0, player1TurnPrompt1
	syscall
	
	li $v0, 5
	syscall
	
	bge $v0, 8, invalid	#checks if input is greater than 7 (invalid input), and if so, goes to invalid
	blt $v0, 0, invalid	# checks if input is a negative (invalid input), and if so, goes to invalid
	sw $v0, xCoord
	
	
	li $v0, 4
	la $a0, player1TurnPrompt2
	syscall
	
	li $v0, 5
	syscall
	
	bge $v0, 6, invalid	#checks if input is greater than 7, and if so, goes to invalid
	blt $v0, 0, invalid	# checks if input is a negative (invalid input), and if so, goes to invalid
	sw $v0, yCoord
	
	li $v0, 4
	la $a0, player1TurnPrompt3
	syscall
	
	li $v0, 8	
	la $a0, cardinalDirection
	li $a1, 20			# allocate byte space for string
	move $t0, $a0
	sw $t0, cardinalDirection	# store string into cardinalDirection
	syscall
	
	jr $ra
	
	
	

player2Turn:







invalid:
	li $v0, 4
	la $a0, invalidPrompt
	syscall
	j player1Turn
	
