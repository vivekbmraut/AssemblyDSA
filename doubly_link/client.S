.section .rodata
ismsg1:
    .string "INSERT START"
iemsg1:
    .string "INSERT END"
iamsg1:
    .string "INSERT AFTER"
ibmsg1:
    .string "INSERT 200 BEFORE 1"
gsmsg1:
    .string "START DATA: %d\n"
gsmsg2:
    .string "AFTER GET_START NO CHANGE"
gemsg1:
    .string "END DATA: %d\n"
gemsg2:
    .string "AFTER GET_END NO CHANGE"

.section .text

.globl main
.type main, @function
main:
    pushl %ebp
    movl %esp, %ebp
    subl $12, %esp

    movl $0, -4(%ebp)           # p_list = NULL
    movl $0, -8(%ebp)           # i = 0
    movl $0, -12(%ebp)           # data = 0

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

    pushl $300
    pushl $1
    pushl -4(%ebp)
    call insertAfter
    addl $12,%esp

    pushl $iamsg1
    pushl -4(%ebp)
    call showList
    addl $8, %esp

    pushl $200
    pushl $1
    pushl -4(%ebp)
    call insertBefore
    addl $12,%esp

    pushl $ibmsg1
    pushl -4(%ebp)
    call showList
    addl $8, %esp

    leal -12(%ebp), %ebx
    pushl %ebx
    pushl -4(%ebp)
    call getStart
    addl $4,%esp

    pushl -12(%ebp)
    pushl $gsmsg1
    call printf
    addl $8,%esp

    pushl $gsmsg2
    pushl -4(%ebp)
    call showList
    addl $8, %esp

    leal -12(%ebp), %ebx
    pushl %ebx
    pushl -4(%ebp)
    call getEnd
    addl $4,%esp

    pushl -12(%ebp)
    pushl $gemsg1
    call printf
    addl $8,%esp

    pushl $gemsg2
    pushl -4(%ebp)
    call showList
    addl $8, %esp

    leal -4(%ebp), %ebx
    pushl %ebx
    call destroyList
    addl $4,%esp

    movl $0,%ebx
    movl $1,%eax
    int $0x80
