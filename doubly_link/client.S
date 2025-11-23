.section .rodata
ismsg1:
    .string "INSERT START"
iemsg1:
    .string "INSERT END"

.section .text

.globl main
.type main, @function
main:
    pushl %ebp
    movl %esp, %ebp
    subl $8, %esp

    movl $0, -4(%ebp)           # p_list = NULL
    movl $0, -8(%ebp)           # i = 0

    leal -4(%ebp), %ebx
    pushl %ebx
    call createList
    addl $4,%esp

mcnd1:
    cmpl $5, -8(%ebp)
    jge mforend1
    
    movl -8(%ebp), %ebx
    addl $1, %ebx
    pushl %ebx
    pushl -4(%ebp)
    call insertStart
    addl $8,%esp

    addl $1, -8(%ebp)
    jmp mcnd1
mforend1:

    pushl $ismsg1
    pushl -4(%ebp)
    call showList
    addl $8,%esp

    pushl $100
    pushl -4(%ebp)
    call insertEnd
    addl $8,%esp

    pushl $iemsg1
    pushl -4(%ebp)
    call showList
    addl $8,%esp


    leal -4(%ebp), %ebx
    pushl %ebx
    call destroyList
    addl $4,%esp


    movl $0,%ebx
    movl $1,%eax
    int $0x80
