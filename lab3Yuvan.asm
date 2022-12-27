# Lab 3 CS 10
# Program by Yuvan Sharma

.data
.align 2
prompt: .asciiz "Enter Row "
.align 2
prompt2: .asciiz " : "
newline: .asciiz "\n"
.align 2
prompt3: .asciiz "Sum: "
.align 2
M: .space 64 # 4x4 integer array
.align 2
input: .space 8
.align 2
inputsize: .word 8
mask: .word 15 # 15 is the mask to convert char digits to int


.text


li $t0, 0 # counter for loop
li $t1, 1
la $t4, M #address counter for M(+4 each time)
lw $t6, mask # store the number 15 in $t6 to use as a mask

loop:
	jal getrow
	la $t3, input #address counter for input (+2 each time, since each char is a byte and we need to skip the spaces)
	li $t5, 0 # counter for fillrow loop
	jal fillrow
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	bne $t0, 4, loop

li $t0, 0 # counter for sumloop
la $t1, M #  address counter for M (+4 each time)
li $t2, 0 # to store the sum

sumloop:
	lw $t3, ($t1)
	add $t2, $t2, $t3
	addi $t1, $t1, 4
	addi $t0, $t0, 1
	bne $t0, 16, sumloop

rem $t0, $t2, 2 # puts 0 in $t0 if sum is even, and 1 if sum is odd

li $v0, 4
la $a0, prompt3
syscall

beqz $t0, even # go to even if remainder is zero

li $a0, 1 #else print 1 for odd sum
li $v0, 1
syscall
j exit # exit the program


even:
	li $v0, 1
	li $a0, 0
	syscall
	j exit


exit:
	li $v0, 10
	syscall #exit the program

getrow:
	li $v0, 4
	la $a0, prompt
	syscall
	li $v0, 1
	la $a0, ($t1)
	syscall
	li $v0, 4
	la $a0, prompt2
	syscall
	li $v0, 8
	la $a0, input
	la $t2, inputsize
	lw $a1, 0($t2)
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	jr $ra

fillrow:
	lbu $a0, ($t3)
	and $a0, $a0, $t6 #convert to ascii by masking with 0000 1111 (decimal number 15) which is stored in $t6
	sw $a0, ($t4)
	addi $t5, $t5, 1
	addi $t3, $t3, 2
	addi $t4, $t4, 4
	bne $t5, 4, fillrow
	jr $ra





