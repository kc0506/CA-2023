.globl	__start

.rodata
        msg: .asciiz "Empty!"
.text

push_front_list:             
        ### if(list == NULL)return; ###
        beqz    a0, LBB0_2

        ### save ra, s0 ###
        addi    sp, sp, -16
        sw      ra, 12(sp)                      
        sw      s0, 8(sp)                       
        sw      s1, 4(sp)

        mv      s0, a0  # &(head) -> s0
        mv      s1, a1  # value -> s1
       
        li      a0, 8
        call    sbrk  # a0 := &(new_node)

        sw      s1, 0(a0)  # new_node->value = value
        lw      a1, 0(s0)  # 
        sw      a1, 4(a0)

        ### list->head = new_node; ###
        sw      a0, 0(s0)  # sp[0] = a0
LBB0_2:
        ## exit handling ###
        lw      ra, 12(sp)                      
        lw      s0, 8(sp)                       
        lw      s1, 4(sp)                       
        addi    sp, sp, 16
        ret
        
print_list:
############################################
#  TODO:Print out the linked list          #
#                                          #
############################################     
        
	# current addr in a0
	# a0[0] := value
	# a0[4] := next

	addi sp, sp, -8
	sw s0, 0(sp)
	sw ra, 4(sp)
	mv s0, a0

	beqz s0, print_exit

	# first recur
	lw a0, 4(s0)
	call print_list

	# then print value
	lw a0, 0(s0)
	call print_int
    
	print_exit: 
		lw s0, 0(sp)
		lw ra, 4(sp)
		addi sp, sp, 8
		ret


__start:
        ### save ra、s0 ###                                   
        addi    sp, sp, -16
        sw      ra, 12(sp)                      
        sw      s0, 8(sp)            
        sw      zero, 0(sp)                                
        ### read the numbers of the linked list ###
        call    read_int
        ### if(nums == 0) output "Empty!" ###
        beqz    a0, LBB2_2
        ### if(nums <= 0) exit
        mv      s0, a0
        blez    a0, exit
LBB2_1:                                
        call    read_int
        
        ### set push_front_list argument ###
        mv      a1, a0  # new int -> a1
        mv      a0, sp  # &head -> a0
        call    push_front_list

        addi    s0, s0, -1
        bnez    s0, LBB2_1
        lw      a0, 0(sp)  # head -> a0
        j       LBB2_3
LBB2_2:
        call    print_str
        j       exit
LBB2_3:
        call    print_list
exit:   
        ### exit handling ###
        li      a0, 0
        lw      ra, 12(sp)                      
        lw      s0, 8(sp)                       
        addi    sp, sp, 16
	li a0,	10
	ecall

read_int:
	li	a0, 5
	ecall
	jr	ra

sbrk:
	mv	a1, a0
	li	a0, 9
	ecall
	jr	ra
 
print_int:
	mv 	a1, a0
	li	a0, 1
	ecall
	li	a0, 11
	li	a1, ' '
	ecall
	jr	ra

print_str:
        li      a0, 4
        la      a1, msg
        ecall
        jr      ra