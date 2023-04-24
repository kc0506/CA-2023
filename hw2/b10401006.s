.globl __start

.rodata
    division_by_zero: .string "division by zero"

.data
    Jumptable: .word _add, _sub, _mul, _div, _min, _pow, _fac

.text
__start:
    # Read first operand
    li a0, 5
    ecall
    mv s0, a0
    # Read operation
    li a0, 5
    ecall
    mv s1, a0
    # Read second operand
    li a0, 5
    ecall
    mv s2, a0
    
    la t1, Jumptable
    slli s1, s1, 2
    add t1, t1, s1
    lw t2, 0(t1)
    jalr x0, 0(t2)
    

###################################
#  TODO: Develop your calculator  #
#                                 #
###################################


_add:
    add s3, s0, s2
    jal x0 output

_sub:
    sub s3, s0, s2
    jal x0 output

_mul:
    mul s3, s0, s2
    jal x0 output    

_div:
    beq s2, zero, division_by_zero_except
    div s3, s0, s2
    jal x0, output    

_min:
    bgt s0, s2, L0 
    mv s3, s0
    jal zero, output

    L0:
        mv s3, s2
        jal zero, output

_pow:
    addi s3, zero, 1
    beq s2, zero, output
    li t1, 1
    L1:
        # s3 *= s0 if s2 is odd
        AND t2, s2, t1
        beq t2, zero, L2
        mul s3, s3, s0
         
        L2:
            srli s2, s2, 1
            mul s0, s0, s0
            bgt s2, zero, L1
    jal zero, output

_fac:
    li s3, 1
    li t0, 1

    L3: 
        beq s0, zero, output
        mul s3, s3, s0
        sub s0, s0, t0
        jal zero, L3

output:
    # Output the result
    li a0, 1
    mv a1, s3
    ecall
    jal x0 exit

exit:
    # Exit program(necessary)
    li a0, 10
    ecall

division_by_zero_except:
    li a0, 4
    la a1, division_by_zero
    ecall
    jal zero, exit
