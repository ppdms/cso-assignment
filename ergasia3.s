        .data
        .align 6
pinA:   .word 0, 0, 0, 2, 0, 0, 0, 0, 3, 0
pinB:   .word 0, 5, 0, 0, 0, 0, 7, 0, 0, 0
SparseA:   .space 40
SparseB:   .space 40
SparseC:   .space 80
op:     .space 4
mikosA:     .word 10
mikosB:     .word 10
mikosC:     .word 0
options_print:    .asciiz "\n-----------------------------\n1. Read Array A\n2. Read Array B\n3. Create Sparse Array A\n4. Create Sparse Array B\n5. Create Sparse Array C = A + B\n6. Display Sparse Array A\n7. Display Sparse Array B\n8. Display Sparse Array C\n0. Exit\n-----------------------------\nChoice? "
pos_print:      .asciiz "Position "
posv2_print:    .asciiz "Position: "
val_print:      .asciiz " Value: "
print_elmnt:    .asciiz " :"   
new_line:       .asciiz "\n"
msg3: .asciiz "Creating Sparse Array A\n"
msg4: .asciiz "Creating Sparse Array B\n"
msg5: .asciiz "Creating Sparse Array C = A + B\n"
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
    move $a0, $v0
    li $v0, 1
    syscall

    la $a0, vals
    li $v0, 4
    syscall

    j go_to_main_loop
    
case_4:
    la $a0, msg4
    li $v0, 4
    syscall

    la $a0, pinB
    la $a1, SparseB
    jal createSparse
    sw $v0, mikosB

    div $v0, $v0, 2
    move $a0, $v0
    li $v0, 1
    syscall

    la $a0, vals
    li $v0, 4
    syscall

    j go_to_main_loop

case_5:
    la $a0, msg5
    li $v0, 4
    syscall

    la $a0, SparseA
    lw $a1, mikosA
    la $a2, SparseB
    lw $a3, mikosB

    add $sp, $sp, -4
    la $t0, SparseC
    sw $t0, ($sp)

    jal addSparse
    sw $v0, mikosC

    div $v0, $v0, 2
    move $a0, $v0
    li $v0, 1
    syscall

    la $a0, vals
    li $v0, 4
    syscall

    j go_to_main_loop

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
    move $t0, $a0
    move $t1, $a1

    li $t2, 0
    li $t3, 0

    li $t4, 10 # array length

    loop_createSparse:
    beq $t2, $t4, exit_createSparse

    mul $t2, $t2, 4
    add $t5, $t2, $t0
    div $t2, $t2, 4
    lw $t5, ($t5)
    beqz $t5, continue

    sw $t2, ($t1)
    addi $t1, 4
    addi $t3, 1
    sw $t5, ($t1)
    addi $t1, 4
    addi $t3, 1

    continue:
    addi $t2, 1
    j loop_createSparse

    exit_createSparse:
    move $v0, $t3
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

addSparse:
    add $sp, $sp, -4
    sw $s0, ($sp)

    add $sp, $sp, -4
    sw $s1, ($sp)

    add $sp, $sp, -4
    sw $s2, ($sp)

    move $t0, $a0
    move $t1, $a1
    move $t2, $a2
    move $t3, $a3

    la $t4, ($sp)
    add $sp, $sp, 4

    li $t5, 0
    li $t6, 0
    li $t7, 0

    while:
    bgt $t5, $t1, alpha
    beq $t5, $t1, alpha
    bgt $t6, $t3, alpha
    beq $t6, $t3, alpha

    mul $t5, $t5, 4
    add $s0, $t5, $t0
    div $t5, $t5, 4
    lw $s0, ($s0)

    mul $t6, $t6, 4
    add $s1, $t6, $t2
    div $t6, $t6, 4
    lw $s1, ($s1)

    blt $s0, $s1, less
    bgt $s0, $s1, more

    sw $s0, ($t4)
    addi $t4, 4
    addi $t5, 1
    addi $t6, 4
    addi $t7, 1

    mul $t5, $t5, 4
    add $s0, $t5, $t0
    div $t5, $t5, 4
    lw $s0, ($s0)

    mul $t6, $t6, 4
    add $s1, $t6, $t2
    div $t6, $t6, 4
    lw $s1, ($s1)

    add $s0, $s0, $s1

    sw $s0, ($t4)

    addi $t4, 4
    addi $t5, 1
    addi $t6, 4
    addi $t7, 1

    j while

    less:
    sw $s0, ($t4)
    addi $t5, 1
    addi $t7, 1

    mul $t5, $t5, 4
    add $s0, $t5, $t0
    div $t5, $t5, 4
    lw $s0, ($s0)

    sw $s0, ($t4)
    addi $t5, 1
    addi $t7, 1

    j while

    more:
    sw $s1, ($t4)
    addi $t6, 1
    addi $t7, 1

    mul $t6, $t6, 4
    add $s1, $t6, $t2
    div $t6, $t6, 4
    lw $s1, ($s1)

    sw $s1, ($t4)
    addi $t6, 1
    addi $t7, 1

    j while

    alpha:
    bgt $t5, $t1, beta
    beq $t5, $t1, beta

    sw $s0, ($t4)
    addi $t5, 1
    addi $t7, 1

    mul $t5, $t5, 4
    add $s0, $t5, $t0
    div $t5, $t5, 4
    lw $s0, ($s0)

    sw $s0, ($t4)
    addi $t5, 1
    addi $t7, 1

    j alpha

    beta:
    bgt $t6, $t3, return
    beq $t6, $t3, return

    sw $s1, ($t4)
    addi $t6, 1
    addi $t7, 1

    mul $t6, $t6, 4
    add $s1, $t6, $t2
    div $t6, $t6, 4
    lw $s1, ($s1)

    sw $s1, ($t4)
    addi $t6, 1
    addi $t7, 1

    j beta

    return:
    lw $s2, ($sp)
    add $sp, $sp, 4
    lw $s1, ($sp)
    add $sp, $sp, 4
    lw $s0, ($sp)
    add $sp, $sp, 4

    move $v0, $t7

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