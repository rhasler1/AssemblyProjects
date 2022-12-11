


    .global main // makes main a function
    .text


toCode:
    push {lr}
    add r0,r0,#2
    cmp r0,#'a'
    blt toCodeDone
    cmp r0,#'z'
    bgt toCodeDone2
    pop {lr}
    bx lr

toCodeDone:
    push {lr}
    add r0,r0,#26
    pop {lr}
    bx lr

toCodeDone2:
    push {lr}
    sub r0,r0,#26
    pop {lr}
    bx lr

main:
    push {lr}
    ldr r4,=string

loop:
    ldrb r0,[r4]
    cmp r0,#0
    beq end_loop
    bl toCode
    bl putchar
    add r4,r4,#1
    b loop

end_loop:
    pop {lr}
    bx lr
    
skip:
    pop {lr}
    bx lr    

    .data
string:
    .asciz "your mom" /* create array of characters with these values */

address_of_string:
    .word 0
