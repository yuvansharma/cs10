# Lab 2 CS 10
# Program by Yuvan Sharma

.data
.align 2
prompt: .asciiz "Enter V: "
.align 2
prompt2: .asciiz "Enter VPrime: \n"
.align 2
prompt3: .asciiz "Check Result: "
.align 2
input: .space 16
.align 2
inputsize: .word 16
.align 2
V: .space 32
.align 2
VPrime: .space 32
.align 2
VCheck: .space 32

.text

#ask for V
li $v0, 4
la $a0, prompt
syscall

li $v0, 8
la $a0, input
la $t0, inputsize
lw $a1, 0($t0)
syscall


li $t2, 0 #t2 is the loop counter


la $t3, input #address counter for input (+2 each time, since each char is a byte and we need to skip the spaces)
la $t4, V #address counter for V(+4 each time)

loop:
 
	lbu $a0, ($t3)
	addi $a0, $a0, -48 #convert to ascii by subtraction

	sw $a0, ($t4)
	addi $t2, $t2, 1
	addi $t3, $t3, 2
	addi $t4, $t4, 4
	bne $t2, 8, loop

	
#ask for VPrime
li $v0, 4
la $a0, prompt2
syscall

li $t0, 0 # counter for loadVPrime loop
la $t1, VPrime #address counter for VPrime(+4 each time)
loadVPrime:
	
	li $v0, 5
	syscall
	sw $v0, ($t1)
	addi $t0, $t0, 1
	addi $t1, $t1, 4
	bne $t0, 8, loadVPrime

li $t0, 0 #counter for subtract loop
la $t1, V # address counter for V (+4 each time)
la $t2, VPrime #address counter for VPrime (+4 each time)
la $t3, VCheck #address counter for VCheck (+4 each time)

subtract:
	
	lw $t4, ($t1)
	lw $t5, ($t2)
	sub $t6, $t4, $t5
	sw $t6, ($t3)
	addi $t1, $t1, 4
	addi $t2, $t2, 4
	addi $t3, $t3, 4
	addi $t0, $t0, 1
	bne $t0, 8, subtract


#print the words "Check Result"
li $v0, 4
la $a0, prompt3
syscall


li $t0, 0 #counter for sumVCheck loop
la $t1, VCheck # address counter for VCheck (+4 each time)
li $a0, 0 # to check the sum

sumVCheck:

	lw $t2, ($t1)
	add $a0, $a0, $t2
	addi $t0, $t0, 1
	addi $t1, $t1, 4
	bne $t0, 8, sumVCheck



li $v0, 1
syscall


li $v0, 10
syscall #exit the program
