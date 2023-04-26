# Subroutine to count any new boxes created
# The subroutine needs turnNumber as an argument in $a0 to mark completed boxes
# It will return the number (0, 1, or 2) of newly created boxes by this player (turnNumber) in register $v0
	
.globl BoxCounter

.text
BoxCounter:
	move $t0, $zero	# set t0 to zero, row index
	move $t1, $zero # set t1 to zero, column index
	move $v0, $zero # set v0 to zero, will be return value (number of boxes completed)
	
rowLoop: 
	beq $t0, 5, outerLoopEnd	# while i < 5
columnLoop:
	beq $t1, 7, innerLoopEnd	# while i < 7
	
	# if horiArr[i*8 + j] == 1
	#	&& horiArr[(i+1)*8 + j] == 1
	#	&& vertArr[i*9 + j] == 1
	#	&& vertArr[i*9 + j + 1] == 1
	#	&& box[i*7 + j] == 0
	
	# t3 = 8*t0 + t1
	sll $t3, $t0, 3
	add $t3, $t3, $t1
	lbu $t4, horizontalLineArray($t3)	# top line must exist
	bne $t4, 1, Continue	# if horiArr[i*8 + j] != 1, branch
	
	# t3 = 8*(t0+1) + t1
	addi $t3, $t3, 8
	lbu $t4, horizontalLineArray($t3)	# bottom line must exist
	bne $t4, 1, Continue	# if horiArr[(i+1)*8 + j] != 1, branch
	
	# t3 = 9*t0 + j
	mul $t3, $t0, 9
	add $t3, $t3, $t1
	lbu $t4, verticalLineArray($t3)	# left line must exist
	bne $t4, 1, Continue	# if vertArr[i*9 + j] != 1, branch
	
	# t3 = 9*t0 + j + 1
	addi $t3, $t3, 1
	lbu $t4, verticalLineArray($t3)	# right line must exist
	bne $t4, 1, Continue	# if vertArr[i*9 + j + 1] != 1, branch
	
	# t3 = 7*t0 + j
	mul $t3, $t0, 7
	add $t3, $t3, $t1
	lbu $t4, boxArray($t3)	# box cannot already exist
	bne $t4, 0, Continue	# if box[i*7 + j] != 0, branch
	
	# store the turn number of the player who just completed a box in index t3 of boxArray
	# the turn number is passed in to the subroutine in register $a3
	sb $a0, boxArray($t3)
	addi $v0, $v0, 1 # increment return value v0 by 1 to indicate that player completed a box
	
	bne $v0, 2, Continue
	jr $ra	# if v0 is set to 2, maximum number of new boxes have been completed, no need to keep searching
	
Continue:
	addi $t1, $t1, 1	# increment j
	j columnLoop
	
innerLoopEnd:
	addi $t0, $t0, 1	# increment i
	move $t1, $zero	# reset j
	j rowLoop
	
outerLoopEnd:
	jr $ra	# return
