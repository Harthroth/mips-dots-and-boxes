.data
	whoIsFirst:	.asciiz "Who is going first (1 = Player | 2 = Computer)\n"
	invalidInput:	.asciiz "Invalid input, must be either input 1 or 2\n"

	initialText1:	.asciiz "Player "
	initialText2:	.asciiz " will be going first"
	ifP2:		.asciiz	" (Computer)"

	newLineCharacter: .byte '\n'

	turn1Player:	.word 0


.globl main

.text
main:
	jal turnPlayerDecider
	j printBoard	# Unable to use jal because I have to use jal to call function from another class
			# plz look over code if it's how we're supposed to actually use multiple.asm files -Justin
	
postBoardPrint:
	jal printInitialAsciiz
	
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
	bne $v0, $zero, invalidInput		# if input is 0, then it's an invalidInput
				
	bne $t0, $zero, turnPlayerDeciderEnd	# input is 1 or 2 goes to turnPlayerDeciderEnd, which goes back to main
	
	li $v0, 4				# outputs invalidInput response
	la $a0, invalidInput
	syscall 
	
	j turnPlayerDecider			# loops back to turnPlayerDecider


turnPlayerDeciderEnd:
	sw $v0, turn1Player 			# stores input in turn1Player .word
	
	# spacing to make I/O readable
	lbu $a0, newLineCharacter		# \- Can't figure out why this won't output a newLineCharacter
	syscall					# / -Justin
	
	jr $ra
	
	
	
# printBoard Function
printBoard:
	# prints the board from printBoard.asm
	jal start
	
	# resetting counters for the registers
	move $t0, $zero
	move $t1, $zero

	j postBoardPrint
	
	

# initialAsciiz Function
printInitialAsciiz:	
	# outputs initialText1
	li $v0, 4
	la $a0, initialText1
	syscall
	
	# outputs who is turn 1 player
	li $v0, 1
	lw $a0, turn1Player
	syscall
	
	# if computer is first turn player, then jump to computerT1
	lw $t0, turn1Player
	li $t1, 2
	beq $a0, $t1, computerT1

printInitialAsciizEnd:
	li $v0, 4
	la $a0, initialText2
	syscall
	
	jr $ra

computerT1:
	# first turn player is Player2, so output ifP2
	li $v0, 4
	la $a0, ifP2
	syscall
		
	j printInitialAsciizEnd 		# jumps to printInitialAsciizEnd
	
