# Lab 6 CS 10
# Program by Yuvan Sharma
# multiplies two 8x8 matrices and prints the result using cache blocking

# RESULTS:


# WITHOUT CACHE BLOCKING:

# Direct mapped cache, 4 blocks, block size of 8 words (TOTAL CACHE SIZE 128 BYTES) -> 49% hit rate
# 2 way assoc.  cache, 4 blocks, block size of 8 words (TOTAL CACHE SIZE 128 BYTES) -> 58% hit rate

# WITH CACHE BLOCKING:

# Direct mapped cache, 4 blocks, block size of 8 words (TOTAL CACHE SIZE 128 BYTES) -> 63% hit rate
# 2 way assoc.  cache, 4 blocks, block size of 8 words (TOTAL CACHE SIZE 128 BYTES) -> 64% hit rate

# Direct mapped cache, 8 blocks, block size of 8 words (TOTAL CACHE SIZE 256 BYTES) -> 74% hit rate
# 2 way assoc.  cache, 8 blocks, block size of 8 words (TOTAL CACHE SIZE 256 BYTES) -> 80% hit rate

# COMMENTS:

# the results above show how cache blocking has a big impact on the hit rate, with a 14% improvement
# for a direct mapped cache of size 128 bytes. Making the 128 byte cache 2 way associative after blocking
# did not improve the hit rate very much, but a 2 way associative cache performed much better than the direct
# mapped cache when the cache size was increased from 128 to 256 bytes.

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
M: .word 6,2,4,2,5,6,3,8,
	 8,4,4,6,5,6,9,1,
	 2,6,7,8,4,1,5,8,
	 2,1,2,9,3,5,2,5,
	 6,6,4,3,5,6,0,7,
	 7,3,2,2,6,4,6,7,
	 5,4,1,5,6,9,8,9,
	 3,0,8,0,3,5,5,6 # 8x8 integer matrix #1
.align 2
N: .word 4,5,0,2,1,6,3,8,
	 5,9,1,3,0,6,4,3,
	 2,6,7,8,4,7,5,1,
	 1,7,2,8,3,4,2,5,
	 6,9,4,2,5,6,6,2,
	 7,3,4,2,6,4,6,7,
	 5,7,1,5,6,3,3,4,
	 3,0,8,0,3,1,5,6 # 8x8 integer matrix #1
.align 2
result: .space 256 # 8x8 integer matrix to store multiplication result
mask: .word 15 # 15 is the mask to convert char digits to int

.text


li $t0, 1
la $t1, M
jal printloop

la $a0, newline
li $v0, 4
syscall

li $t0, 1
la $t1, N
jal printloop


la $a1, result
la $a2, M
la $a3, N


jal dgemm

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

dgemm:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	
	li $s3, 0 # sj
	li $s4, 0 # si
	li $s5, 0 # sk
	li $s6, 8 # 8 is the size of the matrix

	B1:
	li $s4, 0
		B2:
			li $s5, 0
			B3:
	
				# sj in $s3, si in $s4, sk in $s5, n = 8
				
				jal do_block
				
				addi $s5, $s5, 4
				bltu $s5, $s6, B3
			
			addi $s4, $s4, 4
			bltu $s4, $s6, B2
			
		

		addi $s3, $s3, 4 # 4 is the block size
		bltu $s3, $s6, B1
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra


do_block:
#	addi $t0, $zero, 8 # $t0 holds the number of elements in each row
	add $t1, $s3, $zero # counter for first loop $t1 = i
	addi $t6, $s3, 4 # 4 is the block size 
	addi $t7, $s4, 4
	addi $t8, $s5, 4
	
	L1:
		add $t2, $s4, $zero # counter for second loop
		L2:
			add $t3, $s5, $zero # counter for third loop
			sll  $t4, $t1, 3 # multiply first counter by 8 to "skip" that many rows
			add $t4, $t4, $t2 # add the second counter value to select the required element in the row
			sll $t4, $t4, 2 # multiply our index by 4 to transform it into a byte index, since one int = 4 bytes
			add $t4, $a1, $t4 # add the byte index to address of the result array, to tranform t4 into address of result[][] element
			lw $s0, 0($t4)
			
			L3:
				sll $t5, $t1, 3 # multiply counter for third loop by 8 to skip that many rows
				add $t5, $t5, $t3 # add first counter value to select the required element in the row
				sll $t5, $t5, 2 # multiply index by 4 to transform into byte index, since one int = 4 bytes
				add $t5, $a2, $t5 # add byte index to address of M array, to transform $t5 to address of M[][] element
				lw $s1, 0($t5)
				
				sll $t5, $t3, 3	# multiply counter of second loop by 8 to skip that many rows
				add $t5, $t5, $t2 # add third counter value to select the required element in the row
				sll $t5, $t5, 2 # multiply index by 4 to transform into byte index, since one int = 4 bytes
				add $t5, $a3, $t5 # add byte index to addres of N array, to transform $t5 to address of N[][] element
				lw $s2, 0($t5)
				
				# s0 has result element, s1 has M element, s2 has N element
				mul $s1, $s2, $s1
				add $s0, $s0, $s1
				
				addi $t3, $t3, 1 # increment 3rd loop counter by 1
				blt $t3, $t8, L3 # if 3rd loop counter < $t8, repeat addition
				sw $s0, 0($t4) # otherwise store the computed value in the appropriate element
				
			addi $t2, $t2, 1
			blt $t2, $t7, L2
				
		addi $t1, $t1, 1
		blt $t1, $t6, L1
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
	li $t9, 9
	printloop2:
		li $v0, 1 # print element
		lw $a0, 0($t1)
		syscall
		
		li $v0, 4 # print space
		la $a0, space
		syscall
		
		addi $t2, $t2, 1
		addi $t1, $t1, 4
		bne $t2, $t9, printloop2
	
	la $a0, newline # go to next line
	li $v0, 4
	syscall
	
	addi $t0, $t0, 1
	bne $t0, $t9, printloop # $t9 has 9

jr $ra




