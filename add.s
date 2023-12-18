add:

add $sp,$sp,-4
sw $s1, ($sp)

move $a0, $t0
move $a1, $t1
move $a2, $t2
move $a3, $t3

lw $t4, ($sp)
add $sp,$sp,4

li $t5, 0
li $t6, 0
li $t7, 0

loop:

bgt $t5, $t1, a
bgt $t6, $t3, a

add $t8, $t5, $t0
lw $t8, ($t8)

add $t9, $t6, $t2
lw $t9, ($t9)

blt $t8, $t9, less
bgt $t8, $t9, more

sw $t8, $t4
addi $t4, 1
addi $t5, 1
addi $t6, 1
addi $t7, 1

add $t8, $t5, $t0
lw $t8, ($t8)

add $t9, $t6, $t2
lw $t9, ($t9)

add $s0, $t8, $t9

sw $s0, $t4

addi $t4, 1
addi $t5, 1
addi $t6, 1
addi $t7, 1

j a

less:
sw $t8, $t4
addi $t5, 1
addi $t7, 1

add $t8, $t5, $t0
lw $t8, ($t8)

sw $t8, $t4
addi $t5, 1
addi $t7, 1

j a

more:
sw $t9, $t4
addi $t6, 1
addi $t7, 1

add $t9, $t6, $t2
lw $t9, ($t9)

sw $t9, $t4
addi $t6, 1
addi $t7, 1

a:
bgt $t5, $t1, b

sw $t8, $t4
addi $t5, 1
addi $t7, 1

add $t8, $t5, $t0
lw $t8, ($t8)

sw $t8, $t4
addi $t5, 1
addi $t7, 1


b:
bgt $t6, $t3, return

sw $t9, $t4
addi $t6, 1
addi $t7, 1

add $t9, $t6, $t2
lw $t9, ($t9)

sw $t9, $t4
addi $t6, 1
addi $t7, 1

return:
lw $s1, ($sp)
add $sp, $sp, 4

move $t7, $v0

jr $ra


