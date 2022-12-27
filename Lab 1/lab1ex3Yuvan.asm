#plays a 15 note song
#program by Yuvan Sharma

.data

pitches: .space 60#10 pitches represented by integers, each taking 4 bytes
durations: .space 60
instruments: .space 60
volumes: .space 60

.text

j values #jump to values, which stores notes in each array

#WHILE LOOP

while:
	beq $t0, 28, secondwhile
	li $v0, 31
	lw $a0, pitches($t0)
	lw $a1, durations($t0)
	lw $a2, instruments($t0)
	lw $a3, volumes($t0)
	syscall
	addi $t0, $t0, 4
	li $v0, 32
	li $a0, 300
	syscall
	j while
#secondwhile is faster than while
secondwhile:
	beq $t0, 60, exit
	li $v0, 31
	lw $a0, pitches($t0)
	lw $a1, durations($t0)
	lw $a2, instruments($t0)
	lw $a3, volumes($t0)
	syscall
	addi $t0, $t0, 4
	li $v0, 32
	li $a0, 250
	syscall
	j secondwhile
	
exit:
	li $v0, 10
	syscall

values:

li $t0, 0 #initialize $t0 to 0

#NOTE 1
addi $s0, $zero, 70
addi $s1, $zero, 700
addi $s2, $zero, 25
addi $s3, $zero, 120

sw $s0, pitches($t0)
sw $s1, durations($t0)
sw $s2, instruments($t0)
sw $s3, volumes($t0)

#NOTE 2
addi $t0, $t0, 4
addi $s0, $zero, 66
addi $s1, $zero, 500
addi $s2, $zero, 25
addi $s3, $zero, 120

sw $s0, pitches($t0)
sw $s1, durations($t0)
sw $s2, instruments($t0)
sw $s3, volumes($t0)

#NOTE 3
addi $t0, $t0, 4
addi $s0, $zero, 66
addi $s1, $zero, 400
addi $s2, $zero, 25
addi $s3, $zero, 120

sw $s0, pitches($t0)
sw $s1, durations($t0)
sw $s2, instruments($t0)
sw $s3, volumes($t0)

#NOTE 4
addi $t0, $t0, 4
addi $s0, $zero, 54
addi $s1, $zero, 1000
addi $s2, $zero, 80
addi $s3, $zero, 128

sw $s0, pitches($t0)
sw $s1, durations($t0)
sw $s2, instruments($t0)
sw $s3, volumes($t0)

#NOTE 5
addi $t0, $t0, 4
addi $s0, $zero, 75
addi $s1, $zero, 1000
addi $s2, $zero, 80
addi $s3, $zero, 120

sw $s0, pitches($t0)
sw $s1, durations($t0)
sw $s2, instruments($t0)
sw $s3, volumes($t0)

#NOTE 6
addi $t0, $t0, 4
addi $s0, $zero, 63
addi $s1, $zero, 1000
addi $s2, $zero, 98
addi $s3, $zero, 120


sw $s0, pitches($t0)
sw $s1, durations($t0)
sw $s2, instruments($t0)
sw $s3, volumes($t0)

#NOTE 7
addi $t0, $t0, 4
addi $s0, $zero, 70
addi $s1, $zero, 1000
addi $s2, $zero, 99
addi $s3, $zero, 120

sw $s0, pitches($t0)
sw $s1, durations($t0)
sw $s2, instruments($t0)
sw $s3, volumes($t0)

#NOTE 8
addi $t0, $t0, 4
addi $s0, $zero, 67
addi $s1, $zero, 1000
addi $s2, $zero, 37
addi $s3, $zero, 120


sw $s0, pitches($t0)
sw $s1, durations($t0)
sw $s2, instruments($t0)
sw $s3, volumes($t0)

#NOTE 9
addi $t0, $t0, 4
addi $s0, $zero, 63
addi $s1, $zero, 1000
addi $s2, $zero, 90
addi $s3, $zero, 128


sw $s0, pitches($t0)
sw $s1, durations($t0)
sw $s2, instruments($t0)
sw $s3, volumes($t0)

#NOTE 10
addi $t0, $t0, 4
addi $s0, $zero, 70
addi $s1, $zero, 400
addi $s2, $zero, 93
addi $s3, $zero, 120


sw $s0, pitches($t0)
sw $s1, durations($t0)
sw $s2, instruments($t0)
sw $s3, volumes($t0)

#NOTE 11
addi $t0, $t0, 4
addi $s0, $zero, 60 
addi $s1, $zero, 400
addi $s2, $zero, 98
addi $s3, $zero, 120


sw $s0, pitches($t0)
sw $s1, durations($t0)
sw $s2, instruments($t0)
sw $s3, volumes($t0)

#NOTE 12
addi $t0, $t0, 4
addi $s0, $zero, 56
addi $s1, $zero, 400
addi $s2, $zero, 105
addi $s3, $zero, 120


sw $s0, pitches($t0)
sw $s1, durations($t0)
sw $s2, instruments($t0)
sw $s3, volumes($t0)

#NOTE 13
addi $t0, $t0, 4
addi $s0, $zero, 65
addi $s1, $zero, 400
addi $s2, $zero, 118
addi $s3, $zero, 120


sw $s0, pitches($t0)
sw $s1, durations($t0)
sw $s2, instruments($t0)
sw $s3, volumes($t0)

#NOTE 14
addi $t0, $t0, 4
addi $s0, $zero, 55
addi $s1, $zero, 500
addi $s2, $zero, 7
addi $s3, $zero, 120


sw $s0, pitches($t0)
sw $s1, durations($t0)
sw $s2, instruments($t0)
sw $s3, volumes($t0)

#NOTE 15
addi $t0, $t0, 4
addi $s0, $zero, 55
addi $s1, $zero, 400
addi $s2, $zero, 90
addi $s3, $zero, 120


sw $s0, pitches($t0)
sw $s1, durations($t0)
sw $s2, instruments($t0)
sw $s3, volumes($t0)
li $t0, 0
j while #jump to while to play the song

