.globl computerTurn

.text
computerTurn:
# check for filled boxes
        move $t0, $zero	# set t0 to zero, row index
	move $t1, $zero # set t1 to zero, column index
	move $v0, $zero # set v0 to zero, will be return value (number of boxes completed)
	
rowLoop: 
	beq $t0, 6, generateRandom	# while i < 6
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
	
	li $t6, 1	# if there are 3 sides in the box, set $t6 to 1 to fill later
	
	# fill all 4 lines, only adds 1 since 3 are filled already
	# t3 = 8*t0 + t1
	sll $t3, $t0, 3
	add $t3, $t3, $t1
	sb $t6, horizontalLineArray($t3)
		
	# t3 = 8*(t0+1) + t1
	addi $t3, $t3, 8
	sb $t6, horizontalLineArray($t3)	
	
	# t3 = 9*t0 + t1
	mul $t3, $t0, 9
	add $t3, $t3, $t1
	sb $t6, verticalLineArray($t3)
	
	# t3 = 9*t0 + t1 + 1
	addi $t3, $t3, 1
	sb $t6, verticalLineArray($t3)	
	
	jr $ra	#done, return to use box checker

Continue:
	addi $t1, $t1, 1	# increment j
	j columnLoop
	
innerLoopEnd:
	addi $t0, $t0, 1	# increment i
	move $t1, $zero		# reset j
	j rowLoop

# generate a random value if there is no box to complete
generateRandom:	
	# find number of non-filled sides
	move $t0, $zero
	move $t1, $zero
	horizontalLoop:
	beq $t0, 56, horizontalEnd
	lbu $t2, horizontalLineArray($t0)	#load side into t2
	
	# add 1-side to add 1 when side is 0
	addi $t1, $t1, 1
	sub $t1, $t1, $t2
	
	addi $t0, $t0, 1
	j horizontalLoop
	
	horizontalEnd:
	
	move $t0, $zero
	verticalLoop:
	beq $t0, 56, verticalEnd
	lbu $t2, verticalLineArray($t0)	#load side into t2
	
	# add 1-side to add 1 when side is 0
	addi $t1, $t1, 1
	sub $t1, $t1, $t2
	
	addi $t0, $t0, 1
	j verticalLoop
	
	verticalEnd:
	move $a1, $t1  #Here you set $a1 to the max bound.
   	li $v0, 42  #generates the random number.
    	syscall
    	
  	li $t0, -1
	move $t1, $a0	# move picked index into $t1
	horizontalFindLoop:
	addi $t0, $t0, 1
	beq $t0, 56, horizontalFindEnd
	lbu $t2, horizontalLineArray($t0)	#load side into t2
	
	# subtract 1-side to subtract 1 when side is 0
	addi $t1, $t1, -1
	add $t1, $t1, $t2
	
	bne $t1, 0, horizontalFindLoop		# loop if index not reached
	li $t2, 1
	sb $t2, horizontalLineArray($t0)	#set side to 1
	jr $ra 	# return
	
	horizontalFindEnd:
	
	li $t0, -1
	verticalFindLoop:	#don't need end condition, index must be here 
	addi $t0, $t0, 1
	lbu $t2, verticalLineArray($t0)	#load side into t2
	
	# subtract 1-side to subtract 1 when side is 0
	addi $t1, $t1, -1
	add $t1, $t1, $t2
	
	bne $t1, 0, verticalFindLoop	# loop if index not reached
	li $t2, 1
	sb $t2, verticalLineArray($t0)	#set side to 1
	jr $ra 	# return
	
  	
    	

	
	
