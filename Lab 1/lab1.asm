#Lab 1 Program
li $v0,4 #load service number for string print in $v0
la $a0, prompt_string # load address of string to be printed into $a0
syscall
li $v0,5 # read an integer
syscall # read value goes into v0
move $t1,$v0 # save integer in temp 1 (t1)
li $v0,4 #load service number for string print in $v0
syscall
li $v0,5 # read an integer
syscall # read value goes into v0
move $t2,$v0 # save integer in temp 2 (t2)
add $t3,$t1,$t2 #$t3 <- contents of $t1 + contents of $t2
li $v0,4 #load service number for string print in $v0
la $a0, result_string # load address of string to be printed into $a0
syscall
li $v0,1 # print an integer
move $a0,$t3 # integer to print goes in a0
syscall
# the null-terminated string must be defined in data segment
.data
prompt_string: .asciiz "Enter a value: "
result_string: .asciiz "The sum is: "