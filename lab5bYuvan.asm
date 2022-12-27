# Lab 5b CS 10
# Program by Yuvan Sharma
# multiplies two 4x4 matrices and prints the result


# This version of lab 5 has the inner matrix multiply loop completely unrolled.
# It uses the same number of registers as the rolled version, since I reused the
# same registers. This program is much longer than lab5a since the same code is written
# four times instead of using a loop to iterate through it. Its conceptually
# simpler as it avoids iteration, and its execution time will also be faster since it
# avoids the loop's branch instruction and so total number of instructions is reduced.

.data


.align 2
prompt: .asciiz "Enter Row "
.align 2
prompt2: .asciiz " : "
newline: .asciiz "\n"
space: .asciiz " "
.align 2
prompt3: .asciiz "Row "
.align 2
M: .space 64 # 4x4 integer array #1
.align 2
N: .space 64 # 4x4 integer array #2
.align 2
result: .space 64 # 4x4 integer array to store multiplication result
.align 2
input: .space 8
.align 2
inputsize: .word 8
mask: .word 15 # 15 is the mask to convert char digits to int

.text

# get first matrix
li $t0, 0 # counter for loop
li $t1, 1
lw $t6, mask
la $t4, M #address counter for M(+4 each time)
jal getmatriceloop

la $a0, newline
li $v0, 4
syscall


# get second matrix
li $t0, 0 # counter for loop
li $t1, 1
lw $t6, mask
la $t4, N
jal getmatriceloop

la $a1, result
la $a2, M
la $a3, N
jal matrixmultiply

la $a0, newline
li $v0, 4
syscall

li $t0, 1
la $t1, result
jal printloop

j exit # exit the program

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
	li $t9, 4
	bne $t5, $t9, fillrow
	jr $ra
	
getmatriceloop:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	insideloop:
		jal getrow
		la $t3, input #address counter for input (+2 each time, since each char is a byte and we need to skip the spaces)
		li $t5, 0 # counter for fillrow loop
		jal fillrow
		addi $t0, $t0, 1
		addi $t1, $t1, 1
		li $t9, 4
		bne $t0, $t9, insideloop
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra


matrixmultiply:
	addi $t0, $zero, 4 # $t0 holds the number of elements in each row
	addi $t1, $zero, 0 # counter for first loop
	L1:
		addi $t2, $zero, 0 # counter for second loop
		L2:
			addi $t3, $zero, 0 # counter for third loop
			sll  $t4, $t1, 2 # multiply first counter by 4 to "skip" that many rows
			add $t4, $t4, $t2 # add the second counter value to select the required element in the row
			sll $t4, $t4, 2 # multiply our index by 4 to transform it into a byte index, since one int = 4 bytes
			add $t4, $a1, $t4 # add the byte index to address of the result array, to tranform t4 into address of result[][] element
			lw $s0, 0($t4)
			
			# loop completely unrolled
			sll $t5, $t3, 2 # multiply counter for third loop by 4 to skip that many rows
			add $t5, $t5, $t2 # add second counter value to select the required element in the row
			sll $t5, $t5, 2 # multiply index by 4 to transform into byte index, since one int = 4 bytes
			add $t5, $a3, $t5 # add byte index to address of N array, to transform $t5 to address of N[][] element
			lw $s1, 0($t5)
				
			sll $t5, $t1, 2 # multiply counter of first loop by 4 to skip that many rows
			add $t5, $t5, $t3 # add third counter value to select the required element in the row
			sll $t5, $t5, 2 # multiply index by 4 to transform into byte index, since one int = 4 bytes
			add $t5, $a2, $t5 # add byte index to address of M array, to transform $t5 to address of M[][] element
			lw $s2, 0($t5)
				
			# s0 has result element, s1 has N element, s2 has M element
			mul $s1, $s2, $s1
			add $s0, $s0, $s1

			addi $t3, $t3, 1
				
			sll $t5, $t3, 2 # multiply counter for third loop by 4 to skip that many rows
			add $t5, $t5, $t2 # add second counter value to select the required element in the row
			sll $t5, $t5, 2 # multiply index by 4 to transform into byte index, since one int = 4 bytes
			add $t5, $a3, $t5 # add byte index to address of N array, to transform $t5 to address of N[][] element
			lw $s1, 0($t5)
				
			sll $t5, $t1, 2 # multiply counter of first loop by 4 to skip that many rows
			add $t5, $t5, $t3 # add second counter value to select the required element in the row
			sll $t5, $t5, 2 # multiply index by 4 to transform into byte index, since one int = 4 bytes
			add $t5, $a2, $t5 # add byte index to address of M array, to transform $t5 to address of M[][] element
			lw $s2, 0($t5)
				
			# s0 has result element, s1 has N element, s2 has M element
			mul $s1, $s1, $s2
			add $s0, $s0, $s1
								
			addi $t3, $t3, 1 # increment 3rd loop counter by 1

			sll $t5, $t3, 2 # multiply counter for third loop by 4 to skip that many rows
			add $t5, $t5, $t2 # add second counter value to select the required element in the row
			sll $t5, $t5, 2 # multiply index by 4 to transform into byte index, since one int = 4 bytes
			add $t5, $a3, $t5 # add byte index to address of N array, to transform $t5 to address of N[][] element
			lw $s1, 0($t5)
				
			sll $t5, $t1, 2 # multiply counter of first loop by 4 to skip that many rows
			add $t5, $t5, $t3 # add second counter value to select the required element in the row
			sll $t5, $t5, 2 # multiply index by 4 to transform into byte index, since one int = 4 bytes
			add $t5, $a2, $t5 # add byte index to address of M array, to transform $t5 to address of M[][] element
			lw $s2, 0($t5)
				
			# s0 has result element, s1 has N element, s2 has M element
			mul $s1, $s1, $s2
			add $s0, $s0, $s1
								
			addi $t3, $t3, 1 # increment 3rd loop counter by 1
				
			sll $t5, $t3, 2 # multiply counter for third loop by 4 to skip that many rows
			add $t5, $t5, $t2 # add second counter value to select the required element in the row
			sll $t5, $t5, 2 # multiply index by 4 to transform into byte index, since one int = 4 bytes
			add $t5, $a3, $t5 # add byte index to address of N array, to transform $t5 to address of N[][] element
			lw $s1, 0($t5)
				
			sll $t5, $t1, 2 # multiply counter of first loop by 4 to skip that many rows
			add $t5, $t5, $t3 # add second counter value to select the required element in the row
			sll $t5, $t5, 2 # multiply index by 4 to transform into byte index, since one int = 4 bytes
			add $t5, $a2, $t5 # add byte index to address of M array, to transform $t5 to address of M[][] element
			lw $s2, 0($t5)
				
			# s0 has result element, s1 has N element, s2 has M element
			mul $s1, $s1, $s2
			add $s0, $s0, $s1
				
			sw $s0, 0($t4) # otherwise store the computed value in the appropriate element
				
			addi $t2, $t2, 1
			bltu $t2, $t0, L2
				
		addi $t1, $t1, 1
		bltu $t1, $t0, L1
	jr $ra

printloop:
	la $a0, prompt3 # prompt3 = "Row "
	li $v0, 4
	syscall
	addi $a0, $t0, 0 # to print row number
	li $v0, 1
	syscall
	la $a0, prompt2 # prompt2 = ": "
	li $v0, 4
	syscall
	
	li $t2, 1 # counter for printloop2
	printloop2:
		li $v0, 1 # print element
		lw $a0, 0($t1)
		syscall
		
		li $v0, 4 # print space
		la $a0, space
		syscall
		
		addi $t2, $t2, 1
		addi $t1, $t1, 4
		li $t9, 5
		bne $t2, $t9, printloop2
	
	la $a0, newline # go to next line
	li $v0, 4
	syscall
	
	addi $t0, $t0, 1
	li $t9, 5
	bne $t0, $t9, printloop

jr $ra
