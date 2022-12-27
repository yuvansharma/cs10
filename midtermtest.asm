.data
N: .word 1,2,3,4
jj: .word 0

.text
la $t0, jj
la $t1, N
li $t2, 0
li $t3, 3
loop:
lw $t4, 0($t1)
lw $t5, 0($t0)
add $t6, $t5, $t4
sw $t6, 0($t0)
addi $t1, $t1,  4
addi $t2, $t2, 1
bne $t2, $t3, loop

move $a0, $t6
li $v0, 1
syscall
