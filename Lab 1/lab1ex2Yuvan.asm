 # Lab 1 Exercise 2
# Program by Yuvan Sharma

.text 
# asking user for name
li $v0, 4
la $a0, question1
syscall

# taking name input
li $v0, 8
la $a0, name
la $t1, namelength # store address of namelength to use in next line
lw $a1, 0($t1) # as mentioned in instructions, the correct format of lw has integer offset and two registers like this line.
syscall

# asking user for age
li $v0, 4
la $a0, question2
syscall

# taking age input
li $v0, 5
syscall 
move $t0, $v0

# printing hello
li $v0, 4
la $a0, hello
syscall

# printing name
li $v0, 4
la $a0, name
syscall


# printing first part of age statement
li $v0, 4
la $a0, agestatement1
syscall

# printing age
li $v0, 1
add $t1, $t0, 4
move $a0, $t1
syscall

# printing second part of age statement
li $v0, 4
la $a0, agestatement2
syscall


.data
question1: .asciiz "What is your name? "
question2: .asciiz "What is your age? "
hello: .asciiz  "Hello, "
agestatement1: .asciiz "You will be "
agestatement2: .asciiz " years old in four years"
.align 2 # to align to word boundary
name: .space 50
namelength: .word 50
