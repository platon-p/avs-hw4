.data
n: .word 0
array: .space 40
arrend:
st_enter_size: .asciz "Enter array size: "
st_enter_element: .asciz "Enter element: "
st_result: .asciz "Result: "

st_overflow: .asciz "Overflow! Temporary result: "
st_overflow_count: .asciz ", count: "
st_bad_size: .asciz "Bad size! 1 <= size <= 10"

st_even_count: .asciz "\nEvens: "
st_odd_count: .asciz ", odds: "
.text
    li a7 4
    la a0 st_enter_size
    ecall
    li a7 5
    ecall
    
    li t0 1
    blt a0 t0 bad_size
    li t0 10
    bgt a0 t0 bad_size
    
    la t0 n
    sw a0,(t0)
    
    la t0 array
    mv t1 a0
    
    loop_in:
    li a7 4
    la a0 st_enter_element
    ecall
    li a7 5
    ecall
    sw a0, (t0)
    addi t0 t0 4
    addi t1 t1 -1
    bgtz t1 loop_in
    #endloop
    
    # sum:
    la t0 array
    la t1 n
    lw t1,(t1)
    li t2 0 # res
    
    loop_sum:
    lw t3 (t0)
    xor t4 t3 t2
    bltz t4 overflow_ok
    add t4 t2 t3
    xor t4 t4 t2
    bltz t4 overflow_err
    overflow_ok:
    add t2 t2 t3
    addi t0, t0, 4
    addi t1 t1 -1
    bgtz t1 loop_sum
    
    li a7 4
    la a0 st_result
    ecall
    li a7 1
    mv a0 t2
    ecall
    
    j calc_odd_even
bad_size:
    li a7 4
    la a0 st_bad_size
    ecall
    j end
overflow_err:
    li a7 4
    la a0 st_overflow
    ecall
    li a7 1
    mv a0 t2
    ecall
    
    li a7 4
    la a0 st_overflow_count
    ecall
    li a7 1
    la a0 n
    lw a0 (a0)
    sub a0 a0 t1
    ecall
calc_odd_even:
    la t0 array
    la t1 n
    lw t1,(t1)
    li t2 0 # even count
    
    loop_even:
    lw t3 (t0)
    andi t3 t3 1
    bnez t3 skip_even
    addi t2 t2 1
    skip_even:
    addi t0, t0, 4
    addi t1 t1 -1
    bgtz t1 loop_even
    
    li a7 4
    la a0 st_even_count
    ecall
    li a7 1
    mv a0 t2
    ecall
    li a7 4
    la a0 st_odd_count
    ecall
    li a7 1
    la a0 n
    lw a0 (a0)
    sub a0 a0 t2
    ecall
end:
    li a7 10
    ecall