# Subroutine to add new lines given an x and y coordinate as well as a direction
# a0 holds x, a1 holds y, a2 holds direction
# Subroutine does input validation and prints an error
# v0 contains return value which is 0 if line is printed successfully otherwise it holds 1
.globl lineAdding

.text
lineAdding:
	move $t0, $a0 # a0 holds X coordinate, move to t0
	move $t1, $a1 # a1 holds Y coordinate, move to t1
	move $t2, $a2 # a2 holds direction num (NESW / 0123)
	
	blt $t2, 2, postDirUpdate
	addi $t2, $t2, -2	# lower direction by 2
	
	beq $t2, 1, westDir	# branch if direction is west (now east)
	addi $t1, $t1, 1	# if south. increment y by one
	j postDirUpdate
westDir: addi $t0, $t0, -1	# if west, decrement x by one
	
postDirUpdate:

	# branch if x < 0 or x > 8 or y < 0 or y > 6
	blt $t0, 0, xTooSmallError
	bgt $t0, 8, xTooBigError
	blt $t1, 0, yTooSmallError
	bgt $t1, 6, yTooBigError
	
	beq $t2, 1, eastLineAdd
	
	beq $t1, 0, yTooSmallError # branch if y == 0, error
	
	# adding a north line
	# t3 is index = (y-1)*9 + x
	addi $t3, $t1, -1
	mul $t3, $t3, 9
	add $t3, $t3, $t0
	lbu $t4, verticalLineArray($t3)
	bne $t4, 0, lineExistsError	# if line exists, throw error
	li $t4, 1
	sb $t4, verticalLineArray($t3)
	
	# set v0 to 0 to indicate success and then return
	li $v0, 0
	jr $ra
	
	
eastLineAdd:
	beq $t0, 8, xTooBigError # if x == 8, error

	# adding an east line
	# t3 is index = y*8 + x
	sll $t3, $t1, 3
	add $t3, $t3, $t0
	lbu $t4, horizontalLineArray($t3)
	bne $t4, 0, lineExistsError	# if line exists, throw error
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
	
	#addiu $sp, $sp, -4	# allocate space in stack
	#sw $ra, 0($sp)		# loads saved $ra to first cell(?) of stack
	j gameStart
	
	
.data	
	xTooSmallString: .asciiz "\nInputted x value is too small!\n"
	xTooBigString: .asciiz "\nInputted x value is too big!\n"
	yTooSmallString: .asciiz "\nInputted y value is too small!\n"
	yTooBigString: .asciiz "\nInputted y value is too big!\n"
	lineExistsErrorString: .asciiz "\nLine already exists in that position!\n"
	
