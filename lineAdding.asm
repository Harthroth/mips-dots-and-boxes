# Subroutine to add new lines given an x and y coordinate as well as a direction
# a0 holds x, a1 holds y, a2 holds direction
# Subroutine does input validation and prints an error
# v0 contains return value which is 0 if line is printed successfully otherwise it holds 1

.text
	move $t0, $a0 # a0 holds X coordinate, move to t0
	move $t1, $a1 # a1 holds Y coordinate, move to t1
	move $t2, $a2 # a2 holds direction num (NESW / 0123)
	
	blt $t2, 2, postDirUpdate
	addi $t2, $t2, -2	# lower direction by 2
	
	beq $t2, 1, westDir	# branch if direction is west (now east)
	addi $t1, $t1, 1	# if south. increment y by one
	j postDirUpdate
westDir: addi $t0, $t0, 1	# if west, increment x by one
	
postDirUpdate:

	# branch if x < 0 or x > 7 or y < 0 or y > 5
	blt $t0, 1, xTooSmallError
	bgt $t0, 7, xTooBigError
	blt $t1, 1, yTooSmallError
	bgt $t1, 5, yTooBigError
	
	beq $t2, 1, eastLineAdd
	
	# adding a north line
	# t4 is index = (x-1)*8 + y
	addi $t3, $t0, -1
	sll $t3, $t3, 3
	add $t3, $t3, $t1
	lbu $t4, verticalLineArray($t3)
	beq $t4, 0, lineExistsError	# if line exists, throw error
	li $t4, 1
	sb $t4, verticalLineArray($t3)
	
	# set v0 to 0 to indicate success and then return
	li $v0, 0
	jr $ra
	
eastLineAdd:
	# adding an east line
	# t4 is index = x*8 + y + 1
	sll $t3, $t0, 3
	add $t3, $t3, $t1
	addi $t3, $t3, 1
	lbu $t4, horizontalLineArray($t3)
	beq $t4, 0, lineExistsError	# if line exists, throw error
	li $t4, 1
	sb $t4, horizontalLineArray($t3)
	
	# set v0 to 0 to indicate success and then return
	li $v0, 0
	jr $ra

xTooSmallError:
	la $a0, xTooSmallString
	j InputErrorPrint
	
xTooBigError:
	la $a0, xTooBigString
	j InputErrorPrint
	
yTooSmallError:
	la $a0, yTooSmallString
	j InputErrorPrint
	
yTooBigError:
	la $a0, yTooBigString
	j InputErrorPrint
	
lineExistsError:
	la $a0, lineExistsErrorString
	j InputErrorPrint
	
InputErrorPrint:
	li $v0, 4
	syscall
	li $v0, 1
	jr $ra
	
.data	
	xTooSmallString: .asciiz "Inputted x value is too small!\n"
	xTooBigString: .asciiz "Inputted x value is too big!\n"
	yTooSmallString: .asciiz "Inputted y value is too small!\n"
	yTooBigString: .asciiz "Inputted y value is too big!\n"
	lineExistsErrorString: .asciiz "Line already exists in that position!\n"
	