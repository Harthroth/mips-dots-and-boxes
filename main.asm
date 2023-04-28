.data
	horizontalLineArray: .space 56  # 56 bytes for a 8 * 7 array
	verticalLineArray: .space 54	# 54 bytes for an 9 * 6 array
	boxArray: .space 48             # 48 bytes for a 8 * 6 array
	score: .space 2                 # 2 bytes for the scores of both players

	whoIsFirst:	.asciiz "Who is going first (1 = Player | 2 = Computer)\n"
	invalidInput:	.asciiz "Invalid input, must be either input 1 or 2\n"

	initialText1:	.asciiz "Player "
	initialText2:	.asciiz " will be going first\n"
	ifP2:		.asciiz	" (Computer)"
	
	player1TurnPrompt1:	.asciiz "Input the X coordinate (1-9)\n"
	player1TurnPrompt2:	.asciiz "\nInput the Y coordinate (1-7)\n"
	player1TurnPrompt3:	.asciiz "\nInput the Cardinal Direction in upper case (N/S/E/W)\n"
	
	turnPlayerPrompt1:	.asciiz "\nIt is now Player "
	turnPlayerPrompt2:	.asciiz "'s "
	turnPlayerPrompt2a:	.asciiz "(Computer) "
	turnPlayerPrompt3:	.asciiz "turn\n"
	
	invalidPrompt:		.asciiz "Error in input, try again\n"
	invalidDirection:	.asciiz "Error in direction input (make sure to use upper case!), try again\n"
	
	boxes:			.asciiz "A box has been created, player goes again\n"
	
	gameOverString:		.asciiz "Game is over!"
	player1WonString:		.asciiz "Player 1 won the game! Congratulations!\n"
	player2WonString:		.asciiz "Player 2 (Computer) won the game! Better luck next time!\n"
	tiedGameString:		.asciiz "The game is a tie!\n"

	newLineCharacter: 	.byte '\n'
	nChar: 	.byte 'N'
	sChar:	.byte 'S'
	eChar: 	.byte 'E'
	wChar: 	.byte 'W'
	
	

	firstTurnPlayer:	.word 0
	currentTurnPlayer:	.word 0
	xCoord:			.word 0
	yCoord:			.word 0
	cardinalDirection:	.word 0

.globl main
.globl horizontalLineArray
.globl verticalLineArray
.globl boxArray
.globl score
.globl gameStart
.globl xCoord
.globl yCoord

##--------------------------------------------------------------------------------------------------------------------------
.text
main:
	jal turnPlayerDecider
	jal printBoard	
	jal printInitialAsciiz	# runs printInitialAsciiz method
	
	jal gameStart
	
gameOver:
	li $v0, 4
	la $a0, gameOverString
	syscall
	
	la $t0, score
	lbu $t1, 0($t0)	# player 1 score
	lbu $t2, 1($t0)	# player 2 score
	
	beq $t1, $t2, tiedGame
	bgt $t1, $t2, player1Won
	
	la $a0, player2WonString
	syscall
	j exitProgram
	
tiedGame:
	la $a0, tiedGameString
	syscall
	j exitProgram

player1Won:
	la $a0, player1WonString
	syscall
	j exitProgram
	
exitProgram:
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
	
	# adds a newLineCharacter to make I/O readable
	li $v0, 11
	lbu $a0, newLineCharacter		
	syscall					
	
	jr $ra
	
	
#--------------------------------------------------------------------------------------------------------------------------
# printBoard Function
printBoard:
	move $s1, $ra	# save return address into $s0
	# prints the board from printBoard.asm
	jal start
	jr $s1			# returns to main
	
	
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
	addiu $sp, $sp, -4	# allocate space in stack
	sw $ra, 0($sp)		# loads saved $ra to first word on stack
	
	jal checkGameOver	# check if game is over
	
	lw $ra, 0($sp)		# pop value off stack
	addiu $sp, $sp, 4	# deallocate space in stack
	
	beq $v0, 0, gameOver	# if v0 == 0, game is over
	j ContinueGame
	
checkGameOver:
	move $t0, $zero
	
gameOverCheckLoop:
	lbu $t1, boxArray($t0)
	beq $t1, 0, emptyBoxFound
	addi $t0, $t0, 1
	bne $t0, 48, gameOverCheckLoop
	# no empty box found
	move $v0, $zero
	jr $ra
	
emptyBoxFound:
	li $v0, 1
	jr $ra
	
ContinueGame:
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
	
	addi $v0, $v0, -1 # decrement user input to be 0-based indexing
	sw $v0, xCoord
	
	li $v0, 4
	la $a0, player1TurnPrompt2
	syscall
	
	li $v0, 5
	syscall
	
	addi $v0, $v0, -1 # decrement user input to be 0-based indexing
	sw $v0, yCoord

getDirection:	
	li $v0, 4
	la $a0, player1TurnPrompt3
	syscall
	
	# li $v0, 12
	# syscall
	
	li $v0, 8	# read string syscall
	la $a0, cardinalDirection	# address to read into is cardinalDirection
	li $a1, 4	# read at most 4 characters only
	syscall
	lbu $t0, 0($a0)
	
	# char to int
	lbu $t1, nChar
	lbu $t2, sChar
	lbu $t3, eChar
	lbu $t4, wChar
	beq $t0, $t1, setNChar
	beq $t0, $t2, setSChar
	beq $t0, $t3, setEChar
	beq $t0, $t4, setWChar
	
	li $v0, 4
	la $a0, invalidDirection
	syscall
	
	j getDirection
	
setNChar:
  	# set $t1 to 0, and stores it in cardinal Direction
	addi $t1, $zero, 0
  	sw $t1, cardinalDirection
	j player1TurnEnd
	
setEChar:
	# set $t1 to 1, and stores it in cardinal Direction
	addi $t1, $zero, 1
  	sw $t1, cardinalDirection
	j player1TurnEnd

setSChar:
	# set $t1 to 2, and stores it in cardinal Direction
	addi $t1, $zero, 2
  	sw $t1, cardinalDirection
	j player1TurnEnd

setWChar:
	# set $t1 to 3, and stores it in cardinal Direction
	addi $t1, $zero, 3
  	sw $t1, cardinalDirection
	j player1TurnEnd
	
	
player1TurnEnd:
	# lineAdding jal section
	addiu $sp, $sp, -4	# allocate space in stack
	sw $ra, 0($sp)		# loads saved $ra to first cell(?) of stack
	
	lw $a0, xCoord
	lw $a1, yCoord
	lw $a2, cardinalDirection
	lw $a3, currentTurnPlayer
	jal lineAdding
	beq $v0, 1, gameStart # if v0 is 1, line was not successfully added due to error so try again
	
	# BoxCounter jal section
	
	lw $a0, currentTurnPlayer
	jal BoxCounter
	
	move $s0, $v0	# save return value of boxCounter into s0
	
	la $t0, score	# update player 1 score
	lbu $t1, 0($t0)
	add $t1, $t1, $s0
	sb $t1, 0($t0)
	
	# printBoard jal section
	
	jal printBoard
	
	bge $s0, 1, newTurn	# if a box has been made, then skips turnPlayerPrompt
				# (which changes the turn order) and lets player take another turn
	
	# turnPlayerPrompt jal section
	lw $t0, currentTurnPlayer	# loads currentTurnPlayer
	addi $t0, $t0, 1
	sw $t0, currentTurnPlayer	# sets currentTurnPlayer to P2
	
	jal turnPlayerPrompt
	
	lw $ra, 0($sp)		# pop value off stack
	addiu $sp, $sp, 4	# deallocate space in stack

	j gameStart
	
newTurn: 
	li $v0, 4
	la $a0, boxes
	syscall
	j gameStart	
	

player2Turn:
	jal computerTurn
    	
player2TurnEnd:

	# BoxCounter jal section
	lw $a0, currentTurnPlayer
	jal BoxCounter
	move $s0, $v0
	
	la $t0, score	# update player 2 score
	lbu $t1, 1($t0)
	add $t1, $t1, $s0
	sb $t1, 1($t0)
	
	# printBoard jal section
	jal printBoard
	
	bge $s0, 1, newTurn	# if a box has been made, then skips turnPlayerPrompt
				# (which changes the turn order) and lets player take another turn
	
	# turnPlayerPrompt jal section
	lw $t0, currentTurnPlayer	# loads currentTurnPlayer
	addi $t0, $t0, -1	
	sw $t0, currentTurnPlayer	# sets currentTurnPlayer to P1
	
	jal turnPlayerPrompt

	j gameStart
  	
#--------------------------------------------------------------------------------------------------------------------------
# turnPlayerPrompt Method
turnPlayerPrompt:
	li $v0, 4
	la $a0, turnPlayerPrompt1
	syscall
	
	li $v0, 1
	lw $a0, currentTurnPlayer
	syscall
	
	li $v0, 4
	la $a0, turnPlayerPrompt2
	syscall
	
	# if it's P2 turn, then jump to p2Prompt
	li $t1, 2
	beq $a0, $t1, p2Prompt
	

turnPlayerPromptEnd:
	li $v0, 4
	la $a0, turnPlayerPrompt3
	syscall
	
	jr $ra	
	
p2Prompt:
	li $v0, 4
	la $a0, turnPlayerPrompt2a
	syscall
	
	j turnPlayerPromptEnd
