
/* Caesar cipher program that takes inputs from the command line. Program takes (2) inputs
 * (1) encryption key, (2) string to encrypt.  Argument count (argc) passed into R0. 
 * Pointer to argument array (argv) passed in R1 - R1 gives way to access user input
 * strings (arguments) from cmd line, ie: qemu-arm ./cypherCmdLine 5 "hello it is me"
 * - ./cypherCmdLine5 (first argument(argv[0]): R1 + 0), 5 (second argument(argv[1]): R1 + 4), 
 * "hello it is me" (third agument(argv[2]): R1 + 8).  Local variables are pushed on the
 * stack and fetched using reference register r7 <- push & pop in main. */

    .global main // makes main a function
    .text

/* func toCypher is passed string byte to code in r0, purpose of func is to
 * encode byte by cypher shift.*/
toCypher:
    push {lr} /* push link register */
    sub sp,sp,#12 /* move sp down by 8 */
    str r0,[r7,#-20] /* store string byte to R7 - 20  */
    ldr r1,[r7,#-4] /* load r1 with pointer to argument array */
    ldr r0,[r1,#4] /* this is loading cypher to r0 */
    bl atoi /* atoi takes string "5" and returns int 5 into r0 */
    str r0,[r7,#-16] /* store int of cypher shift to R7 - 16 */
    ldr r5,[r7,#-16] /* loads r5 with int of cypher shift */
    ldrb r0,[r7,#-20] /* loads r0 with string byte */
    add r0,r0,r5 /* shifts string by count from cypher shift */
    cmp r0,#'a' /* compare cypher (shifted string) to ascii value of a*/
    blt aLess /* if ascii value of cypher is less than 'a' branch to aLess */
    cmp r0,#'z' /* compare cypher (shifted string) to ascii value of z*/
    bgt zGreater  /* if ascii value of cypher is greater than 'z' branch to zGreater*/
    add sp,sp,#12 /* collapse this func's partition of stack*/
    pop {lr} /* pop link register */
    bx lr /* return */

/* it was assumed that cypher would be lowercase, function aLess is only branched
to if user input is less than ascii value 'a', <--- SPACE .  I want space's to not change
so function subtracts the encoding (r0 = r0 - r5). */
aLess:
    push {lr}
    sub r0,r0,r5 /* reverse encoding */
    pop {lr}
    bx lr

/* func zGreater wraps alphabet into a loop */
zGreater:
    push {lr}
    sub r0,r0,#26 /* loop to beginning of alphabet */
    pop {lr}
    bx lr

main:
    push {lr,r7} /* push link register */
    mov r7,sp /* saves R7 in place of beginning stack pointer position */
    sub sp,#8 /* move stack pointer down 8 */
    str r0,[r7,#-8] /* store argument count to position of R7 - 8 */
    str r1,[r7,#-4] /* store base address of string array to position of R7 - 4*/
    ldr r4,[r1,#8] /* this is loading pointer to string to code to r4 */

loop:
    ldrb r0,[r4] /* loads one byte at a time */
    cmp r0,#0 /* makes sure a byte was loaded*/
    beq end_loop /* if byte was not loaded branch to end loop */
    bl toCypher /* branch link toCode */
    bl putchar /* branch link to putchar , uses r0 for parameter */
    add r4,r4,#1 /* parse string one byte at a time */
    b loop /* branch to loop */

end_loop:
    mov sp,r7 /* close stack pointer */
    pop {lr,r7} /* pop the link register */
    bx lr /* return */
    
skip:
    pop {lr}
    bx lr    


    .data
string:
    .asciz /* create array of characters with these values */

address_of_string:
    .word 0
