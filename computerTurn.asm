
.globl computerTurn

computerTurn:
# check for filled boxes

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

