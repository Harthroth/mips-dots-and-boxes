
.globl computerTurn

.text
computerTurn:
# check for filled boxes
        move $t0, $zero	# set t0 to zero, row index
	move $t1, $zero # set t1 to zero, column index
	move $v0, $zero # set v0 to zero, will be return value (number of boxes completed)
	
rowLoop: 
	beq $t0, 6, outerLoopEnd	# while i < 6
columnLoop:
	beq $t1, 8, innerLoopEnd	# while i < 8

	# if horiArr[i*8 + j]
	#  + horiArr[(i+1)*8 + j]
	#  + vertArr[i*9 + j]
	#  + vertArr[i*9 + j + 1] == 3

	move $t6, $zero

	move $t3, $zero
	
	# t3 = 8*t0 + t1
	sll $t3, $t0, 3
	add $t3, $t3, $t1
	lbu $t4, horizontalLineArray($t3)	# top line must exist
	add $t6, $t6, $t4        # add horiArr(t3) to t6
	
	# t3 = 8*(t0+1) + t1
	addi $t3, $t3, 8
	lbu $t4, horizontalLineArray($t3)	# bottom line must exist
	add $t6, $t6, $t4	# add horiArr(t3) to t6
	
	# t3 = 9*t0 + j
	mul $t3, $t0, 9
	add $t3, $t3, $t1
	lbu $t4, verticalLineArray($t3)	# left line must exist
	add $t6, $t6, $t4	# add vertArr(t3) to t6
	
	# t3 = 9*t0 + j + 1
	addi $t3, $t3, 1
	lbu $t4, verticalLineArray($t3)	# right line must exist
	add $t6, $t6, $t4	# add vertArr(t3) to t6
	
	# store the turn number of the player who just completed a box in index t3 of boxArray
	# the turn number is passed in to the subroutine in register $a3
	
	bne $t6, 3, Continue		# if there are not 3 sides in the box, continue
	
	# find line which is not filled, fill the line
	# t3 = 8*t0 + t1
	sll $t3, $t0, 3
	add $t3, $t3, $t1
	lbu $t4, horizontalLineArray($t3)	# top line must exist
	bne $t4, 0, return	# if horiArr[i*8 + j] != 1, branch
	
	# t3 = 8*(t0+1) + t1
	addi $t3, $t3, 8
	lbu $t4, horizontalLineArray($t3)	# bottom line must exist
	bne $t4, 1, return	# if horiArr[(i+1)*8 + j] != 1, branch
	
	# t3 = 9*t0 + t1
	mul $t3, $t0, 9
	add $t3, $t3, $t1
	lbu $t4, verticalLineArray($t3)	# left line must exist
	bne $t4, 1, return	# if vertArr[i*9 + j] != 1, branch
	
	# t3 = 9*t0 + t1 + 1
	addi $t3, $t3, 1
	lbu $t4, verticalLineArray($t3)	# right line must exist
	bne $t4, 1, return	# if vertArr[i*9 + j + 1] != 1, branch
	
	return:
	

Continue:
	addi $t1, $t1, 1	# increment j
	j columnLoop
	
innerLoopEnd:
	addi $t0, $t0, 1	# increment i
	move $t1, $zero	# reset j
	j rowLoop

outerLoopEnd:
	j generateRandom


# generate a random value if there is no box to complete
generateRandom:	
# random number generator for 1st value
        li $a1, 9  #Here you set $a1 to the max bound.
   	li $v0, 42  #generates the random number.
    	syscall
    	
    	addi $a0, $a0, 1  #Here you add the lowest bound
   	li $v0, 1  #1 print integer
  	syscall
  	
  	addi $a0, $a0, -1 # decrement random number to be 0-based indexing
  	sw $a0, xCoord	# stores rng x-coord into xCoord
  	
  	# newLineChar
  	lbu $a0, newLineCharacter
  	li $v0, 11
  	syscall
  	
  	# random number generator for 2nd value
  	li $a1, 7  #Here you set $a1 to the max bound.
   	li $v0, 42  #generates the random number.
    	syscall
    	
    	add $a0, $a0, 1  #Here you add the lowest bound
   	li $v0, 1  #1 print integer
  	syscall
  	
  	addi $a0, $a0, -1 # decrement random number to be 0-based indexing
  	sw $a0, yCoord	# stores rng x-coord into xCoord
  	
  	# newlineChar
    	lbu $a0, newLineCharacter
  	li $v0, 11
  	syscall
  	
  	# random number generator for 3rd value (N/E/S/W)
  	li $a1, 3  #Here you set $a1 to the max bound.
   	li $v0, 42  #generates the random number.
    	syscall
    	
    	# depending on RNG, chooses N/E/S/W
    	move $s0, $a0
    	beq $s0, 0, N
    	beq $s0, 1, E
    	beq $s0, 2, S
    	beq $s0, 3, W
	
	j $ra	#return
	
	

