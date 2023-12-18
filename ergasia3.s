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
        .text
main:
    # Print options
    jal readOption

    sw $v0, op

    # Load op to $t0
    lw $t0, op

    li $v0, 10
    syscall

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
    la $a1, pinA
    jal readPin

    j go_to_main_loop
case_2:
    la $a1, pinB
    jal readPin

    j go_to_main_loop
case_3:
case_4:
case_5:
case_6:
    la $a1, SparseA
    lw $a2, mikosA
    jal printSparse

    j go_to_main_loop
case_7:
    la $a1, SparseB
    lw $a2, mikosB
    jal printSparse

    j go_to_main_loop
case_8:
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

    sub $a0, $t1, $t2   # i
    li $v0, 1
    syscall

    la $a0, print_elmnt # " :"
    li $v0, 4
    syscall

    lw $a0, 0($a1)      # pos[i]
    li $v0, 1
    syscall

    add $t2, $t2, 1  # counter++
    add $a1, $a1, 4  # -> nextInt 

    j readPin

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
