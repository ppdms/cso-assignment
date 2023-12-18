        .data
pinA:   .space 40
pinB:   .space 40
SparseA:   .space 80
SparseB:   .space 80
SparseC:   .space 80
op:     .space 4
mikosA:     .word 0
mikosB:     .word 0
mikosC:     .word 0
options_print:    .asciiz "\n-----------------------------\n1. Read Array A\n2. Read Array B\n3. Create Sparse Array A\n4. Create Sparse Array B\n5. Create Sparse Array C = A + B\n6. Display Sparse Array A\n7. Display Sparse Array B\n8. Display Sparse Array C\n0. Exit\n-----------------------------\nChoice? "
pos_print:      .asciiz "Position "
posv2_print:    .asciiz "Position: "
val_print:      .asciiz " Value: "
print_elmnt:    .asciiz " :"   
new_line:       .asciiz "\n"
msg3: .asciiz "Creating Sparse Array A"
msg4: .asciiz "Creating Sparse Array B"
msg5: .asciiz "Creating Sparse Array C = A + B"
vals: .asciiz " values"
he:     .asciiz "Case 1"
hehe:     .asciiz "Case 2"



        .text
main:
    # Print options
    jal readOption

    sw $v0, op

    # Load op to $t0
    lw $t0, op

loop:
    # while((op>=1) && (op<=8))
    blt $t0, 1, end
    bgt $t0, 8, end

    # Case 1-8
    beq $t0, 1, case_1
    beq $t0, 2, case_2
    beq $t0, 3, case_3
    beq $t0, 4, case_4
    beq $t0, 5, case_5
    beq $t0, 6, case_6
    beq $t0, 7, case_7
    beq $t0, 8, case_8
case_1:
    li $t2, 0
    la $a1, pinA
    jal readPin

    j go_to_main_loop
case_2:
    li $t2, 0
    la $a1, pinB
    jal readPin

    j go_to_main_loop
case_3:
    la $a0, msg3
    li $v0, 4
    syscall

    la $a0, pinA
    la $a1, SparseA
    jal createSparse
    sw $v0, mikosA

    div $v0, $v0, 2
    move $v0, $a0
    li $v0, 1
    syscall

    la $a0, vals
    li $v0, 4
    syscall
    
case_4:
    la $a0, msg4
    li $v0, 4
    syscall

    la $a0, pinB
    la $a1, SparseB
    jal createSparse
    sw $v0, mikosB

    div $v0, $v0, 2
    move $v0, $a0
    li $v0, 1
    syscall

    la $a0, vals
    li $v0, 4
    syscall

case_5:
    la $a0, msg5
    li $v0, 4
    syscall

    la $a0, SparseA
    la $a1, mikosA
    la $a2, SparseB
    la $a3, mikosB

    add $sp,$sp,-4
    lw $t0, SparseC
    sw $t0, ($sp)

    jal sum
    sw $v0, mikosC

    div $v0, $v0, 2
    move $v0, $a0
    li $v0, 1
    syscall

    la $a0, vals
    li $v0, 4
    syscall

case_6:
    li $t2, 0
    la $a1, SparseA
    lw $a2, mikosA
    jal printSparse

    j go_to_main_loop
case_7:
    li $t2, 0
    la $a1, SparseB
    lw $a2, mikosB
    jal printSparse

    j go_to_main_loop
case_8:
    li $t2, 0
    la $a1, SparseC
    lw $a2, mikosC
    jal printSparse

    j go_to_main_loop


# **** Functions ****
readOption:
    la $a0, options_print
    li $v0, 4
    syscall

    # Read op
    li $v0, 5
    syscall

    j $ra

readPin:
    # $a1 holds int[] pin
    # $t1 holds the number 10 at the beginning (aka pin.length)
    # $t2 is a counter
    beq $t2, 10, go_back # if this doesnt work just go to a dif func that calls "j $ra"
    
    # Print
    la $a0, pos_print   # "Position "
    li $v0, 4
    syscall

    sub $a0, $t2, $zero   # i
    li $v0, 1
    syscall

    la $a0, print_elmnt # " :"
    li $v0, 4
    syscall

    lw $a0, 0($a1)      # pos[i]
    li $v0, 1
    syscall

    la $a0, new_line # "\n"
    li $v0, 4
    syscall

    add $t2, $t2, 1  # counter++
    add $a1, $a1, 4  # -> nextInt 

    j readPin

createSparse:
    move $a0, $t0
    move $a1, $t1

    li $t2, 0
    li $t3, 0

    li $t4, 10 # array length

    loop_createSparse:
    beq $t2, $t4, exit_createSparse

    add $t5, $t3, $t0
    lw $t5, ($t5)
    beqz $t5, continue

    sw $t2, ($t1)
    addi $t1, 1
    addi $t3, 1
    sw $t5, ($t1)
    addi $t1, 1
    addi $t3, 1

    continue:
    addi $t2, 1
    j createSparse

    exit_createSparse:
    move $t3, $v0
    j go_back


printSparse:
    # $a1 = int[] Sparse
    # $a2 = int mikos
    # $t2 = counter i (0 at the start)
    bge $t2, $a2, go_back

    # Print
    la $a0, posv2_print   # "Position: "
    li $v0, 4
    syscall

    la $a0, 0($a1)  # Sparse [i++]
    li $v0, 1
    syscall

    add $t2, $t2, 1
    add $a1, $a1, 4

    la $a0, val_print   # " Value: "
    li $v0, 4
    syscall

    la $a0, 0($a1)  # Sparse [i++]
    li $v0, 1
    syscall

    add $t2, $t2, 1
    add $a1, $a1, 4

    j printSparse

sum:

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

    while:

    bgt $t5, $t1, alpha
    bgt $t6, $t3, alpha

    add $t8, $t5, $t0
    lw $t8, ($t8)

    add $t9, $t6, $t2
    lw $t9, ($t9)

    blt $t8, $t9, less
    bgt $t8, $t9, more

    sw $t8, ($t4)
    addi $t4, 1
    addi $t5, 1
    addi $t6, 1
    addi $t7, 1

    add $t8, $t5, $t0
    lw $t8, ($t8)

    add $t9, $t6, $t2
    lw $t9, ($t9)

    add $s0, $t8, $t9

    sw $s0, ($t4)

    addi $t4, 1
    addi $t5, 1
    addi $t6, 1
    addi $t7, 1

    j while

    less:
    sw $t8, ($t4)
    addi $t5, 1
    addi $t7, 1

    add $t8, $t5, $t0
    lw $t8, ($t8)

    sw $t8, ($t4)
    addi $t5, 1
    addi $t7, 1

    j while

    more:
    sw $t9, ($t4)
    addi $t6, 1
    addi $t7, 1

    add $t9, $t6, $t2
    lw $t9, ($t9)

    sw $t9, ($t4)
    addi $t6, 1
    addi $t7, 1

    alpha:
    bgt $t5, $t1, beta

    sw $t8, ($t4)
    addi $t5, 1
    addi $t7, 1

    add $t8, $t5, $t0
    lw $t8, ($t8)

    sw $t8, ($t4)
    addi $t5, 1
    addi $t7, 1


    beta:
    bgt $t6, $t3, return

    sw $t9, ($t4)
    addi $t6, 1
    addi $t7, 1

    add $t9, $t6, $t2
    lw $t9, ($t9)

    sw $t9, ($t4)
    addi $t6, 1
    addi $t7, 1

    return:
    lw $s1, ($sp)
    add $sp, $sp, 4

    move $t7, $v0

    jr $ra



# **** Helpers ****
go_back:
    j $ra

go_to_main_loop:
    # Print options
    jal readOption

    sw $v0, op

    # Load op to $t0
    lw $t0, op

    j loop

# Finish
end:
    li $v0, 10
    syscall