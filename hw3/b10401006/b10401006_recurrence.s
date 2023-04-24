

.globl __start

.text
__start:

    addi sp, sp, -8
    sw s0, 0(sp)
    sw ra, 4(sp)
1
    # read n -> a0
    li a0, 5  # ecall for read int
    ecall
    mv a1, a0
    li t1, 1
    jal ra, func
    jal zero, exit

# caller: store in stack
#         jal ra, ...
# callee: load from stack
#         jalr zero, 0(ra)

func:
    # a1 := n
    # a0 := f(n)

    beq a1, zero, ret0
    beq a1, t1, ret1

    # store s0, a1, ra
    addi sp, sp, -12
    sw s0, 0(sp)
    sw a1, 4(sp)
    sw ra, 8(sp)


    # s0 := store current value
    li s0, 0
    
    # first compute f(n-1)
    addi a1, a1, -1
    jal ra, func  # after jump back, a0 == f(n-1)
    # s0 += 2 * f(n-1)
    add s0, s0, a0
    add s0, s0, a0

    # then compute f(n-2)
    addi a1, a1, -1
    jal ra, func
    add s0, s0, a0

    mv a0, s0
    lw s0, 0(sp)
    lw a1, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 12
    jalr zero, 0(ra)

    ret0:
        li a0, 0
        jalr zero, 0(ra)
        
    ret1:
        li a0, 1
        jalr zero, 0(ra)

exit:
    mv a1, a0  # parameter for print
    li a0, 1  # ecall for print int
    ecall

    lw s0, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

    li a0, 10
    ecall

